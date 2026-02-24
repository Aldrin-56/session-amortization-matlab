% sim_latency.m — Computation Latency Comparison
% Base Paper (Code-based HE per packet) vs Session Amortization Novelty (Tier 2)
% Platform: MATLAB R2018a+ | Intel Core i5 | 8GB RAM (same as base paper)
% Source: master_draft_COMPLETE.md Table 6, Table 7
%
% Run: sim_latency.m
% Output: sim_latency.png + console results

clear; clc; close all;

fprintf('=============================================================\n');
fprintf('  SIMULATION 1: Computation Latency Comparison\n');
fprintf('  Base Paper vs Session Amortization Novelty\n');
fprintf('=============================================================\n\n');

%% ===== PARAMETERS (exact values from master_draft_COMPLETE.md) =====

% --- Base Paper: LR-IoTA Authentication (Table 6) ---
delta_KG_auth = 0.288;    % ms — Key Generation
delta_SG_auth = 13.299;   % ms — Signature Generation (Bernstein reconstruction)
delta_V_auth  = 0.735;    % ms — Signature Verification
cost_LRIoTA   = delta_KG_auth + delta_SG_auth + delta_V_auth;  % 14.322 ms

% --- Base Paper: Code-Based HE per packet (Table 7) ---
delta_KG_kep  = 0.8549;   % ms — QC-LDPC Key Generation
                          % [GAP 3 FIX] Algorithm 5 runs ONCE per data-sharing session
                          % in the base paper (not per packet) — same as proposed Phase 1.2.
                          % Excluded from per-packet cost. If included: base = 8.2277 ms
                          % (conservative choice: 7.3728 ms used = weaker claim).
delta_enc_kep = 1.5298;   % ms — KEP Encryption + AES (per packet in base paper, Table 7)
delta_dec_kep = 5.8430;   % ms — SLDSPA + SHA + AES Decryption (per packet, Table 7)
cost_base_per_packet = delta_enc_kep + delta_dec_kep;  % 7.3728 ms/packet

% --- Session Amortization: Epoch Initiation (one-time per Epoch) ---
cost_epoch_init = cost_LRIoTA + (delta_KG_kep + delta_enc_kep + delta_dec_kep);
% = 14.322 + 8.2277 = 22.5497 ms

% --- Session Amortization: Tier 2 per-packet (HKDF + AES-256-GCM) ---
% [GAP 1 FIX] These values are BENCHMARK-ESTIMATED from Intel AES-NI published
% throughput tables (Intel AES-NI Performance Brief, 2012) for Intel Core i5.
% They are NOT directly MATLAB-measured. Actual platform measurement may vary
% +/- 0.02 ms, yielding a reduction range of 98.4%-99.0%.
% Cite: Intel AES-NI Performance Brief; NIST AEAD Hardware Benchmarks.
cost_HKDF       = 0.002;   % ms — HMAC-SHA256 key derivation (AES-NI benchmark estimate)
cost_AES_GCM    = 0.073;   % ms — AES-256-GCM enc + dec + TAG verify (AES-NI benchmark estimate)
cost_tier2_pp   = cost_HKDF + cost_AES_GCM;  % 0.075 ms/packet (benchmark-estimated)

%% ===== SIMULATION =====
N_range = 1:100;

% Total cost over N packets
total_base  = N_range .* cost_base_per_packet;
total_novel = cost_epoch_init + max(N_range - 1, 0) .* cost_tier2_pp;

% Break-even point
break_even_N = find(total_novel <= total_base, 1);

% Per-packet reduction (for sessions beyond the initial handshake)
reduction_pct = (cost_base_per_packet - cost_tier2_pp) / cost_base_per_packet * 100;

%% ===== CONSOLE OUTPUT =====
fprintf('--- Base Paper Costs ---\n');
fprintf('  LR-IoTA authentication:         %.3f ms\n', cost_LRIoTA);
fprintf('  Code-based HE per packet:       %.4f ms  (enc: %.4f + dec: %.4f)\n', ...
    cost_base_per_packet, delta_enc_kep, delta_dec_kep);

fprintf('\n--- Session Amortization Costs ---\n');
fprintf('  Epoch Initiation (one-time):    %.4f ms  (LR-IoTA: %.3f + QC-LDPC KEP: %.4f)\n', ...
    cost_epoch_init, cost_LRIoTA, delta_KG_kep + delta_enc_kep + delta_dec_kep);
fprintf('  Tier 2 per-packet:              %.4f ms  (HKDF: %.3f + AES-GCM: %.3f)\n', ...
    cost_tier2_pp, cost_HKDF, cost_AES_GCM);

fprintf('\n--- Key Results ---\n');
fprintf('  Per-packet Tier 2 latency reduction:  %.2f%%\n', reduction_pct);
fprintf('  [NOTE] This %% applies to Tier 2 per-packet cost only.\n');
fprintf('  [NOTE] Amortized average at N=50:  (%.2f + 49x%.3f)/50 = %.3f ms/packet\n', ...
    cost_epoch_init, cost_tier2_pp, (cost_epoch_init + 49*cost_tier2_pp)/50);
fprintf('  [NOTE] Amortized average at N=100: (%.2f + 99x%.3f)/100 = %.3f ms/packet\n', ...
    cost_epoch_init, cost_tier2_pp, (cost_epoch_init + 99*cost_tier2_pp)/100);
fprintf('  Break-even point:               N = %d packets\n', break_even_N);
fprintf('  [GAP 4] Break-even valid for N>>4 (N_max=2^20, T_max=86400s ensure this in IoT)\n');
fprintf('  At N=50:  Base = %.1f ms  |  Proposed = %.2f ms  |  Saving = %.1f ms\n', ...
    50*cost_base_per_packet, cost_epoch_init + 49*cost_tier2_pp, ...
    50*cost_base_per_packet - (cost_epoch_init + 49*cost_tier2_pp));
fprintf('  At N=100: Base = %.1f ms  |  Proposed = %.2f ms  |  Saving = %.1f ms\n', ...
    100*cost_base_per_packet, cost_epoch_init + 99*cost_tier2_pp, ...
    100*cost_base_per_packet - (cost_epoch_init + 99*cost_tier2_pp));

%% ===== PLOT =====
figure('Name', 'Latency Comparison', 'Position', [100 100 900 550]);

plot(N_range, total_base, 'r-o', 'LineWidth', 2, 'MarkerSize', 4, ...
    'DisplayName', 'Base Paper (Full QC-LDPC per packet)');
hold on;
plot(N_range, total_novel, 'b-s', 'LineWidth', 2, 'MarkerSize', 4, ...
    'DisplayName', sprintf('Proposed Novelty (Epoch handshake + Tier 2 AEAD)'));

if ~isempty(break_even_N)
    xline(break_even_N, '--k', 'LineWidth', 1.5, ...
        'Label', sprintf('Break-even\n(N=%d)', break_even_N), ...
        'LabelVerticalAlignment', 'middle', 'LabelHorizontalAlignment', 'right');
end

xlabel('Number of Data Packets in Epoch', 'FontSize', 12);
ylabel('Total Computation Time (ms)', 'FontSize', 12);
title({'Latency Comparison: Base Paper vs Session Amortization Novelty'; ...
    sprintf('%.1f%% reduction per Tier 2 packet | Break-even at N=%d', reduction_pct, break_even_N)}, ...
    'FontSize', 13);
legend('Location', 'northwest', 'FontSize', 11);
grid on;
hold off;

saveas(gcf, 'results/sim_latency.png');
fprintf('\nFigure saved: sim_latency.png\n');
fprintf('\n[SIMULATION 1 COMPLETE]\n');
