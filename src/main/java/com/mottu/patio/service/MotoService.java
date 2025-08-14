package com.mottu.patio.service;

import com.mottu.patio.dto.MotoCreateDTO;
import com.mottu.patio.dto.MotoDTO;
import com.mottu.patio.dto.MotoUpdateDTO;
import com.mottu.patio.entity.Moto;
import com.mottu.patio.entity.Patio;
import com.mottu.patio.repository.MotoRepository;
import com.mottu.patio.repository.PatioRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MotoService {

    private final MotoRepository motoRepository;
    private final PatioRepository patioRepository;

    // Injeção de dependência via construtor
    public MotoService(MotoRepository motoRepository, PatioRepository patioRepository) {
        this.motoRepository = motoRepository;
        this.patioRepository = patioRepository;
    }

    public MotoDTO create(MotoCreateDTO dto) {
        Patio patio = patioRepository.findById(dto.getPatioId())
                .orElseThrow(() -> new EntityNotFoundException("Pátio não encontrado"));

        Moto moto = new Moto();
        moto.setPlaca(dto.getPlaca());
        moto.setStatus(dto.getStatus());
        moto.setPatio(patio);

        Moto saved = motoRepository.save(moto);
        return toDTO(saved);
    }

    @Cacheable("motos")
    public Page<MotoDTO> findAll(String status, Pageable pageable) {
        if (status == null || status.isBlank()) {
            return motoRepository.findAll(pageable).map(this::toDTO);
        }
        return motoRepository.findByStatusContainingIgnoreCase(status, pageable).map(this::toDTO);
    }

    public MotoDTO findById(Long id) {
        Moto moto = motoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Moto não encontrada"));
        return toDTO(moto);
    }
    //retorna uma lista vazia temporariamente 17/05/2025
    @Cacheable("motos")
    public List<MotoDTO> listarMotos() {
            return List.of(); // retorno de uma lista imutável vazia
    }

    public MotoDTO update(Long id, MotoUpdateDTO dto) {
        Moto moto = motoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Moto não encontrada"));

        moto.setPlaca(dto.getPlaca());
        moto.setStatus(dto.getStatus());

        Moto updated = motoRepository.save(moto);
        return toDTO(updated);
    }

    public void delete(Long id) {
        Moto moto = motoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Moto não encontrada"));

        motoRepository.delete(moto);
    }

    private MotoDTO toDTO(Moto moto) {
        return new MotoDTO(moto.getId(), moto.getPlaca(), moto.getStatus(), moto.getPatio().getId());
    }
}
