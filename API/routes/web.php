<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
 */

Route::get('/', function () {
    return view('welcome');
});

Route::get('/ShowUsers', 'DBController@ShowUsers');
//Instance//
Route::get('/SlobodneInstance', 'InstanceController@SlobodneInstance');
Route::get('/ZauzeteInstance', 'InstanceController@ZauzeteInstance');
Route::get('/TraziInstancu/{naziv}', 'InstanceController@TraziInstancu');
//Resursi//
Route::get('/VrsteResursa', 'ResursiController@VrsteResursa');
Route::get('/TraziPoVrsti/{id}', 'ResursiController@TraziPoVrsti');
Route::get('/DodajResurs/{naziv}/{kolicina}/{slika}/{posudba}/{tip}', 'ResursiController@DodajResurs');
Route::get('/TraziPoVrsti2/{id}', 'ResursiController@TraziPoVrsti2');
Route::get('/MojiResursi/{id}', 'ResursiController@MojiResursi');
Route::get('/SviResursi','ResursiController@SviResursi');
//Log//
Route::get('/DodajLog/{id_kor}/{id_ins}/{id_vrsta}/{feedback?}', 'LogController@DodajLog');
Route::get('/IspisLog/{id_kor?}', 'LogController@IspisLog');
Route::get('/IspisObavijesti', 'LogController@IspisObavijesti');
Route::get('/IspisNeprocitanih', 'LogController@IspisNeprocitanih');
Route::get('/ProcitajObavijest/{id}','LogController@ProcitajObavijest');
//Korisnik//
Route::post('/Prijava', 'KorisnikController@Prijava');
Route::get('/SviKorisnici', 'KorisnikController@SviKorisnici');
Route::post('/DodajKorisnika', 'KorisnikController@DodajKorisnika');
Route::get('/SvePoslovnice', 'KorisnikController@SvePoslovnice');
//Posudbe//
Route::get('/MojePosudbe/{id}', 'PosudbaController@MojePosudbe');
Route::get('/MojePosudbe2/{id}','PosudbaController@MojePosudbe2');
Route::post('/Posudi', 'PosudbaController@Posudi');
Route::post('/Vrati','PosudbaController@Vrati');
