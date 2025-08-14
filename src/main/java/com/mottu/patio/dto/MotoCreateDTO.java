package com.mottu.patio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Schema(description = "Dados para criação de uma nova moto")
public class MotoCreateDTO {

    @Schema(description = "Placa da moto", example = "ABC-1234", required = true)
    @NotBlank
    private String placa;

    @Schema(description = "Status da moto", example = "DISPONIVEL", allowableValues = {"DISPONIVEL", "EM_MANUTENCAO", "ALUGADA"}, required = true)
    @NotBlank
    private String status;

    @Schema(description = "ID do pátio onde a moto será registrada", example = "1", required = true)
    @NotNull
    private Long patioId;

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

    public Long getPatioId() {
        return patioId;
    }

    public void setPatioId(Long patioId) {
        this.patioId = patioId;
    }
}
