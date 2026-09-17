# DD1351 övning 2 — rättade Prologfiler

Filerna kommer från `github.com/dicander/prolog` och hör till bildspelet
`DD1351_ovning2_prolog.pdf`. Alla svar i bildspelet är körda mot exakt dessa filer
i SWI-Prolog 9. Kör testerna med

    swipl -q -g run_tests -t halt test_ovn2.pl

## Ändringar jämfört med repot (2026-09-17)

| Fil | Ändring |
|---|---|
| `scheduling.pl` | **Bugg rättad.** `student_requirements/2` och `student_mandatory_types/3` skrev `session/7` direkt inne i `setof` med anonyma variabler för dag, start och slut. Anonyma variabler är fria för `setof`, så svaren grupperades per tidpunkt och snittet behöll första gruppen: `student_requirements(s_marcus, R)` gav `[da101-exam]` i stället för `[da101-exam, da101-lab1, ma201-exam, pr301-demo]`. Målen ligger nu i egna predikat (`mandatory_type/2`, `requirement/2`). Verifierade svar längst ner i filen. |
| `filurien.pl` | `pairwise_score/2` räknade varje par två gånger (`select` + `member`); nu `A @< B`, så parlamentets index är 21, inte 42. Villkoret `Score > 0` påverkades inte. Kommentaren med exempelsvar var fel (`[p1,p4,p5,p6]` har 123 mandat, inte 117) och är ersatt med verifierade svar. `smallest_stable/3` tillagd. Typografiska citattecken i kommentarer ersatta med raka, så att filen laddar utan varningar även i icke-UTF-8-lokaler. |
| `bintree.pl` | Snitten borttagna (de var gröna: funktorerna utesluter varandra). `sum/2` och `height/2` tillagda som alias med uppgiftsbladets namn. Kommentar om nod- kontra kanträkning av höjd. |
| `perm.pl` | `permute/2` (via `select/3`, uppgiftsbladets namn) tillagd bredvid repots `permutation/2`. |
| `ovn2.pl` | `removelast2/2` (via `append/3`) tillagd. |
| alla | `:- encoding(utf8).` först i varje fil; radslut LF i stället för CRLF. |
| `test_ovn2.pl` | ny: plunit-tester för uppgift 3–7. |
