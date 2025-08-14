package com.mottu.patio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Dados para atualização de uma moto")
public class MotoUpdateDTO {

    @Schema(description = "Nova placa da moto", example = "XYZ-9876", required = true)
    @NotBlank
    private String placa;

    @Schema(description = "Novo status da moto", example = "EM_MANUTENCAO", allowableValues = {"DISPONIVEL", "EM_MANUTENCAO", "ALUGADA"}, required = true)
    @NotBlank
    private String status;

    // Getters e Setters
    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

