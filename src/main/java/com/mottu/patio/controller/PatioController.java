package com.mottu.patio.controller;

import com.mottu.patio.dto.PatioCreateDTO;
import com.mottu.patio.dto.PatioDTO;
import com.mottu.patio.service.PatioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api/patios")
@Tag(name = "Pátios", description = "Operações de CRUD para gerenciamento de pátios logísticos")
public class PatioController {

    private final PatioService patioService;

    public PatioController(PatioService patioService) {
        this.patioService = patioService;
    }

    @PostMapping
    @Operation(summary = "Criar novo pátio")
    public ResponseEntity<PatioDTO> create(@RequestBody @Valid PatioCreateDTO dto) {
        PatioDTO created = patioService.create(dto);
        return ResponseEntity.created(URI.create("/api/patios/" + created.getId())).body(created);
    }

    @GetMapping
    @Operation(summary = "Listar pátios")
    public ResponseEntity<List<PatioDTO>> findAll() {
        return ResponseEntity.ok(patioService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar pátio por ID")
    public ResponseEntity<PatioDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(patioService.findById(id));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Atualizar pátio")
    public ResponseEntity<PatioDTO> update(@PathVariable Long id, @RequestBody @Valid PatioCreateDTO dto) {
        return ResponseEntity.ok(patioService.atualizarPatio(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Excluir pátio")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        patioService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
