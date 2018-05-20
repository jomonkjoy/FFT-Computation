// OFDM Single carrier to multiple sub-carrier spectral efficeincy & reduce delay-spread/ ISI
// 1MHz -> [100 sub carriers of 10KHz]
// OFDMA rxUE and SCFDMA txUE
// OFDM 64QAM Modulation -> IFFT(freq2time) -> CyclePrefix[GuardPeriod]
// 20MHz LTE spectrum Fmax = 9MHz
// Nquist sampling rate >= 18M samples per sec
// 20MHz LTE (3.8MHz * 8 = 30.7MHz sampling frequency)
// FFT Size = 2048 samples per symbol in OFDMA
// Removal of CyclePrrfix -> FFT(time2freq) -> OFDM 64QAM DeModulation
module ofdm_modulation #(
) (
);

endmodule
