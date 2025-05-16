package com.example.restaurentapp.modules.common;

import java.io.Serializable;
import java.util.UUID;

/**
 * BaseEntity providing common ID property and serializability
 */
public abstract class BaseEntity implements Serializable {

    private String id;

    public BaseEntity() {
        this.id = UUID.randomUUID().toString();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
