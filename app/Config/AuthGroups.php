<?php

declare(strict_types=1);

namespace Config;

use CodeIgniter\Shield\Config\AuthGroups as ShieldAuthGroups;

class AuthGroups extends ShieldAuthGroups
{
    /**
     * --------------------------------------------------------------------
     * Default Group
     * --------------------------------------------------------------------
     * The grupo que se asigna automáticamente a nuevos usuarios registrados.
     */
    public string $defaultGroup = 'cliente';

    /**
     * --------------------------------------------------------------------
     * Groups
     * --------------------------------------------------------------------
     */
    public array $groups = [
        'admin' => [
            'title'       => 'Admin',
            'description' => 'Administrador con acceso completo al sistema.',
        ],
        'vendedor' => [
            'title'       => 'Vendedor',
            'description' => 'Vendedor del negocio con acceso a pedidos y stock.',
        ],
        'cliente' => [
            'title'       => 'Cliente',
            'description' => 'Cliente registrado del negocio.',
        ],
    ];

    /**
     * --------------------------------------------------------------------
     * Permissions
     * --------------------------------------------------------------------
     */
    public array $permissions = [
        'admin.access'    => 'Can access the sites admin area',
        'admin.settings'  => 'Can access the main site settings',
        'users.manage'    => 'Can manage users',
        'platos.create'   => 'Can create platos',
        'platos.edit'     => 'Can edit platos',
        'platos.delete'   => 'Can delete platos',
        'vendedor.access' => 'Can access vendedor area',
        'pedidos.view'    => 'Can view pedidos',
        'pedidos.manage'  => 'Can manage pedidos',
        'stock.manage'    => 'Can manage stock',
        'cliente.access'  => 'Can access cliente area',
    ];

    /**
     * --------------------------------------------------------------------
     * Permissions Matrix
     * --------------------------------------------------------------------
     */
    public array $matrix = [
        'admin' => [
            'admin.access',
            'admin.settings',
            'users.manage',
            'platos.create',
            'platos.edit',
            'platos.delete',
            'vendedor.access',
            'pedidos.view',
            'pedidos.manage',
            'stock.manage',
            'cliente.access',
        ],
        'vendedor' => [
            'vendedor.access',
            'pedidos.view',
            'pedidos.manage',
            'stock.manage',
            'platos.create',
            'platos.edit',
            'platos.delete',
        ],

        'cliente' => [
            'cliente.access',
        ],
    ];
}