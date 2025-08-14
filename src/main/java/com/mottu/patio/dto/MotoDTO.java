package com.mottu.patio.dto;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Dados de uma moto")
public class MotoDTO {
    @Schema(description = "ID único da moto", example = "1")
    private Long id;
    
    @Schema(description = "Placa da moto", example = "ABC-1234")
    private String placa;
    
    @Schema(description = "Status atual da moto", example = "DISPONIVEL")
    private String status;
    
    @Schema(description = "ID do pátio onde a moto está localizada", example = "1")
    private Long patioId;

    // classe construtora
    public MotoDTO(Long id, String placa, String status, Long patioId) {
        this.id = id;
        this.placa = placa;
        this.status = status;
        this.patioId = patioId;
    }

    // Getters
    public Long getId() {
        return id;
    }

    public String getPlaca() {
        return placa;
    }

    public String getStatus() {
        return status;
    }

    public Long getPatioId() {
        return patioId;
    }
}
