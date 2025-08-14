package com.mottu.patio.repository;

import com.mottu.patio.entity.Moto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MotoRepository extends JpaRepository<Moto, Long> {
    Page<Moto> findByStatusContainingIgnoreCase(String status, Pageable pageable);
}
