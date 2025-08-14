package com.mottu.patio.controller;

import com.mottu.patio.dto.MotoCreateDTO;
import com.mottu.patio.dto.MotoDTO;
import com.mottu.patio.dto.MotoUpdateDTO;
import com.mottu.patio.service.MotoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
@RequestMapping("/api/motos")
@Tag(name = "Motos", description = "Operações de CRUD para gerenciamento de motos nos pátios")
public class MotoController {

    private final MotoService motoService;

    public MotoController(MotoService motoService) {
        this.motoService = motoService;
    }

    @PostMapping
    @Operation(summary = "Registrar nova moto")
    public ResponseEntity<MotoDTO> create(@RequestBody @Valid MotoCreateDTO dto) {
        MotoDTO created = motoService.create(dto);
        return ResponseEntity.created(URI.create("/api/motos/" + created.getId())).body(created);
    }

    @GetMapping
    @Operation(summary = "Listar motos")
    public ResponseEntity<Page<MotoDTO>> findAll(
            @RequestParam(required = false) String status,
            Pageable pageable) {
        return ResponseEntity.ok(motoService.findAll(status, pageable));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Buscar moto por ID")
    public ResponseEntity<MotoDTO> findById(@PathVariable Long id) {
        return ResponseEntity.ok(motoService.findById(id));
    }
//    @GetMapping
//    public Page<MotoDTO> listar(@RequestParam(required = false) String status, Pageable pageable) {
//        return motoService.listarMotos(status, pageable);
//    }

    @PutMapping("/{id}")
    @Operation(summary = "Atualizar moto")
    public ResponseEntity<MotoDTO> update(@PathVariable Long id, @RequestBody @Valid MotoUpdateDTO dto) {
        return ResponseEntity.ok(motoService.update(id, dto));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Excluir moto")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        motoService.delete(id);
        return ResponseEntity.noContent().build();
    }

}
