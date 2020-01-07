<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use Illuminate\Support\Facades\DB;

class InstanceController extends Controller
{
    public function SlobodneInstance(){
        $instance = DB::select('SELECT * from instanca where slobodno = 1');
        return $instance;
    }

    public function ZauzeteInstance(){
        $instance = DB::select('SELECT * from instanca where slobodno = 0');
        return $instance;
    }

    public function TraziInstancu($naziv){
        $trazi = '%'. $naziv . '%';
        $instance = DB::select("select resurs.naziv, instanca.slobodno from resurs inner join instanca on resurs.id_resurs = instanca.fk_resurs where resurs.naziv like '" + $trazi + "'");
        return $instance;

    }
}
