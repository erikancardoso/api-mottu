package com.mottu.patio.service;

import com.mottu.patio.dto.PatioCreateDTO;
import com.mottu.patio.dto.PatioDTO;
import com.mottu.patio.entity.Patio;
import com.mottu.patio.repository.PatioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class PatioService {

    private final PatioRepository patioRepository;

    public PatioService(PatioRepository patioRepository) {
        this.patioRepository = patioRepository;
    }

    public PatioDTO create(PatioCreateDTO dto) {
        Patio patio = new Patio();
        patio.setNome(dto.getNome());
        patio.setEndereco(dto.getEndereco());

        Patio saved = patioRepository.save(patio);
        return toDTO(saved);
    }

    public List<PatioDTO> findAll() {
        return patioRepository.findAll()
                .stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public PatioDTO findById(Long id) {
        Patio patio = patioRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pátio não encontrado"));
        return toDTO(patio);
    }

    public void delete(Long id) {
        Patio patio = patioRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Pátio não encontrado"));
        patioRepository.delete(patio);
    }

    private PatioDTO toDTO(Patio patio) {
        return new PatioDTO(patio.getId(), patio.getNome(), patio.getEndereco());
    }
    public PatioDTO atualizarPatio(Long id, PatioCreateDTO dto) {
        Patio patio = patioRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pátio não encontrado"));

        patio.setNome(dto.getNome());
        patio.setEndereco(dto.getEndereco());

        patioRepository.save(patio);

        return PatioDTO.fromEntity(patio);
    }
}
