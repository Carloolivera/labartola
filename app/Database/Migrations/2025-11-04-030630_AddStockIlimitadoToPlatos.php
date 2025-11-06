<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class AddStockIlimitadoToPlatos extends Migration
{
    public function up()
    {
        $this->forge->addColumn('platos', [
            'stock_ilimitado' => [
                'type' => 'TINYINT',
                'constraint' => 1,
                'default' => 1,
                'null' => false
            ]
        ]);
    }

    public function down()
    {
        $this->forge->dropColumn('platos', 'stock_ilimitado');
    }
}