package com.mottu.patio.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

@Schema(description = "Dados para criação de um novo pátio")
public class PatioCreateDTO {

    @Schema(description = "Nome do pátio", example = "Pátio Central", required = true)
    @NotBlank
    private String nome;

    @Schema(description = "Endereço do pátio", example = "Rua das Flores, 123 - Centro", required = true)
    @NotBlank
    private String endereco;

    // Getters e Setters
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }
}

