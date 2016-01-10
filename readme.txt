užduotis https://gist.github.com/raimondasv/4dce3ec02ff1e1568361

Programa paleidžiama "rake run input.txt"
testai paleidžiami "rake test"

Input.txt - duomenų failas, kaip nurodyta užduotyje.
prices.txt - kainoraščio failas.
readme.txt - dabar skaitote, dokumentacija.
test_input.txt - testams skirtas inputas.
main.rb - modulio paleidimo failas.
namu_darbai.rb - užduoties modulis.
rakefile - rake tasku failas, ledžiantis modulio paleidą nurodytą užduotyje.
tc_namu_darbai.tb - aprašyti testai. Prie testų nerašiau komentarų, nes testo pavadinimas atitinka testuojamo metodo pavadinimą.


Dariau su Ruby kalba,
prieš tai nebuvau su ja susipažinęs, neskaitant nepilno Rails for Zombies tutorialo.

Užduotyje buvo prašomap arašyti 1 modulį atliekantį pateitką užduotį.

 modulis parašytas, sintaksė tikrinta su Rubocop, pagrindiniai išliekabtys errorai yra
 perdidelis modulio kodo eilučių kiekis, apie 50% daugiau nei turėtų būti, errorai su vieno/poros metodų sudėtingumu
 (perdidelis ifų ir priskyrimų kiekis)

 Prie kiekvienos funkcijos yra komentarai ką ji atlieka.

 main.rb faile yra metodo paleidimas.

 free_ship_rls kintamasis yra 2D masyvas, galima į jį tiesiai pridėti daugiau taisyklių.
 Lengvai galima pakeisti jog būtų galima nurodyti ar pilnai nemokama prekė ar tarkim kas penkto M dydžio LP tiekėjo
 kaina būtų sumažinama 50prc o ne pilnų 100.

 buvau parašęs ir errorus, kai inputo failas tuščias, kai paduodami paramsai tušti, bet teko atsisakyti jų nes ir tiap labai
 viršijamas eilučių skaičius.

Testai padaryti su esamu unit tetsš libu, su unit testavimu esu nelabai susipažinęs, nes buvussiam/esamam darbe kodas nera
OOP.

Jei daryčiau užduotį per naują, daryčiausi testus ir kodą rašyčiau kartu, nes dabar buvo pirma kodas tada testai,
kas iškėlė nemažai problemų.

Testai kaip suprantu turi nemažą problemą, tai kad jie yra order dependant, manau aukščiau paminėta logika išspręstų šitą bėdą,
nes būtų rašomi izoliuoti metodai nepriklausomai nuo sekos.


