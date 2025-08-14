package com.mottu.patio.dto;

import com.mottu.patio.entity.Patio;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Dados de um pátio")
public class PatioDTO {

    @Schema(description = "ID único do pátio", example = "1")
    private Long id;
    
    @Schema(description = "Nome do pátio", example = "Pátio Central")
    private String nome;
    
    @Schema(description = "Endereço do pátio", example = "Rua das Flores, 123 - Centro")
    private String endereco;

    public PatioDTO(Long id, String nome, String endereco) {
        this.id = id;
        this.nome = nome;
        this.endereco = endereco;
    }
    public static PatioDTO fromEntity(Patio patio) {
        return new PatioDTO(patio.getId(), patio.getNome(), patio.getEndereco());
    }


    public Long getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public String getEndereco() {
        return endereco;
    }
}
