DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL,
    password VARCHAR(60) NOT NULL,
    privilege_level INTEGER NOT NULL DEFAULT 3,
    CONSTRAINT unq_username UNIQUE (username),
    CONSTRAINT unq_email UNIQUE (email)
);

INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('admin', 'Admin', 'Admin', 'admin@admin.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 1);
INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('majamod', 'Maja', 'Mod', 'maja@mod.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 2);
INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('andrzejmod', 'Andrzej', 'Mod', 'andrzej@mod.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 2);

INSERT INTO public.users (username, first_name, last_name, email, password) 
VALUES ('jacex', 'Jacek', 'Mostek', 'jacek@mostek.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK');
INSERT INTO public.users (username, first_name, last_name, email, password) 
VALUES ('izaaa', 'Izabela', 'Trebeusz', 'iza@trebeusz.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK');
INSERT INTO public.users (username, first_name, last_name, email, password) 
VALUES ('aniagotuje', 'Anna', 'Wrońska', 'ania@gotuje.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK');


DROP TABLE IF EXISTS recipes;
CREATE TABLE recipes (
    recipe_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipe_name VARCHAR(100) NOT NULL,
    recipe_description VARCHAR(800) DEFAULT NULL,
    instruction TEXT NOT NULL,
    tips VARCHAR(400) DEFAULT NULL,
    portions VARCHAR(10),
    author_id BIGINT NOT NULL,
    date_added DATE NOT NULL DEFAULT CURRENT_DATE,
    active BOOLEAN NOT NULL DEFAULT true,
    views INT NOT NULL DEFAULT 0,
    difficulty INT NOT NULL,
    CONSTRAINT fk_recipe_author
        FOREIGN KEY (author_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Pad thai z tofu i warzywami', 'Przepis można wykonać z gotowej pasty Pad Thai (potrzebujemy na tę ilość składników 140 g pasty) lub też samemu zrobić sos ze składników podanych pod przepisem.', 'Makaron ryżowy włożyć do garnka, zalać gorącą i odstawić na 15 - 20 minut do namoczenia.\r\nPrzygotować warzywa: czerwoną cebulę obrać i pokroić na półplasterki. Marchewkę obrać i pokroić na cienkie plasterki. Paprykę i cukinię pokroić na podłużne kawałki.\r\nRozgrzać wok lub dużą i głęboką patelnię, wlać łyżkę oleju i dodać pokrojone w kosteczkę tofu. Obsmażyć na złoty kolor, przez około 4 minuty, odłożyć na talerz.\r\nWlać kolejną łyżkę oleju i wrzucić warzywa. Smażyć je przez ok. 4 minuty, co chwilę mieszając łopatką, doprawić solą.\r\nDo miseczki wbić jajka i roztrzepać je widelcem. Przesunąć warzywa na brzeg woka, w wolne miejsce wlać ostatnią łyżkę oleju i wlać jajka. Smażyć jak omlet bez mieszania przez ok. 1 - 2 minuty, następnie przełożyć go na warzywa.\r\nDodać sos Pad Thai, odłożone tofu, ostry sos sriracha i wymieszać.\r\nWyłowić makaron z wody i przełożyć go do woka. Całość smażyć co chwilę mieszając, do czasu aż makaron będzie ugotowany. Jeśli makaron nie jest wystarczająco miękki, można podczas smażenia podlewać go wodą, w której moczył się makaron.\r\nNa koniec wymieszać makaron z odsączonymi kiełkami, posiekanymi orzechami i szczypiorkiem i chwilę razem podsmażyć.', 'domowy sos Pad Thai: 6 łyżek sosu rybnego, 2 łyżki soku z limonki, 3 łyżki cukru, 4 łyżki wody, 2 łyżeczki pasty tamaryndowej (lub więcej w zależności od intensywności pasty)', '3 - 4', 6, '2024-11-12', true, 199, 8);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Gulasz z grzybami', 'Gulasz z grzybami leśnymi — najlepszy z borowikami, ewentualnie podgrzybkami. Można użyć świeżych lub mrożonych grzybów.', 'Mięso pokroić w kostkę ok. 1,5 cm. Boczek pokroić w małą kosteczkę. Cebulę obrać i pokroić w kosteczkę. Marchewkę obrać i pokroić na plasterki.\r\nW szerokim garnku rozgrzać 1 łyżkę oleju roślinnego, dodać boczek i smażyć go przez około 3 minuty.\r\nDodać cebulę oraz marchewkę i co chwilę mieszając podsmażać wszystko przez około 3 minuty.\r\nW międzyczasie na dużej patelni, na łyżce oleju, obsmażać mięso, doprawić je solą oraz pieprzem. Po obsmażeniu przenieść do garnka z warzywami. Wlać wino (jeśli go używamy) i chwilę odparować.\r\nDodać słodką i ostrą paprykę oraz obrany i przepołowiony czosnek, wymieszać. Wlać gorący bulion, zagotować, doprawić pieprzem i w razie potrzeby solą. Przykryć i gotować na małym ogniu ok. 1 i 1/2 godziny, do miękkości mięsa.\r\nGrzyby oczyścić, pokroić na platerki i podsmażyć na 1 łyżce masła. Przełożyć do gulaszu i zagotować.\r\nNa patelni roztopić 1 łyżkę masła, dodać mąkę i chwilę podsmażyć mieszając. Dodać kilka łyżek wywaru z gulaszu, wymieszać, a następnie przełożyć do garnka. Dokładnie wymieszać i zagotować. Posypać natką pietruszki.', NULL, '6', 6, '2024-10-31', true, 75, 7);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Ciasto twarogowe z jabłkami', 'Ciasto z jabłkami, z dodatkiem twarogu i aromatem cytryny. Nie dodaje się do niego masła, tylko twaróg oraz niewielką ilość oleju roślinnego.', 'Jajka i twaróg wyjąć wcześniej z lodówki i ogrzać w temp. pokojowej. Twaróg wyłożyć na talerz i rozgnieść praską.\r\nJabłka pokroić na ćwiartki, obrać ze skórki, usunąć gniazda nasienne, pokroić na plasterki. Włożyć do miski, wymieszać z sokiem z cytryny i startą skórką (tylko zewnętrzna, żółta część).\r\nPiekarnik nagrzać do 200 stopni C. Formę o średnicy 23 cm wyłożyć papierem do pieczenia, zapiąć obręcz, wypuszczając papier na zewnątrz.\r\nJajka wbić do miski, dodać cukier i ubijać na jasną i puszystą masę, przez około 5 - 7 minut, pod koniec dodać cukier wanilinowy.\r\nDo ubitych jajek dodać twaróg oraz olej roślinny i zmiksować (przez około pół minuty) na mniejszych obrotach miksera.\r\nMąkę pszenną wymieszać z mąką ziemniaczaną oraz proszkiem do pieczenia, następnie dodać do ubitej masy i zmiksować na małych obrotach miksera, tylko do połączenia się składników w jednolite ciasto.\r\nDo masy dodać około 2/3 ilości jabłek i wymieszać łyżką. Wyłożyć do formy, wyrównać powierzchnię, ułożyć wkoło resztę jabłek delikatnie wciskając je w ciasto.\r\nWstawić do nagrzanego piekarnika i piec przez ok. 45 minut (do suchego patyczka). Po upieczeniu posypać cukrem pudrem.', NULL, '0', 6, '2024-10-11', false, 13, 6);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Zupa z piczonej dyni, gruszki i pietruszki', NULL, 'Piekarnik nagrzać do 200 stopni C. Dynię obrać, usunąć pestki, pokroić w kostkę. Gruszkę pokroić na ćwiartki, wykroić gniazda nasienne. Pietruszkę obrać i pokroić w kostkę. Cebulę obrać i pokroić na półplasterki. Czosnek obrać i przekroić na pół.\r\nWszystkie warzywa włożyć do żaroodpornej formy, dodać pokrojoną papryczkę chili bez pestek, doprawić solą, pieprzem, rozmarynem i papryką słodką. Skropić oliwą i wstawić do nagrzanego piekarnika. Piec bez przykrycia przez około 35 minut.\r\nUpieczone warzywa zmiksować w blenderze z dodatkiem gorącego bulionu, następnie dodać mleczko kokosowe i ponownie zmiksować.\r\nPodawać z grzankami i pestkami dyni. Pestki dyni lekko podprażyć na suchej patelni. Pieczywo na grzanki (np. ciabatta, bagietka) pokroić w kostkę, skropić oliwą i lekko zrumienić na patelni.', NULL, '4', 6, '2024-10-19', true, 47, 6);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Grecka zapiekanka z fasoli', NULL, 'Suchą fasolę np. Piękny Jaś (w ilości ok. 1 szklanki) należy najpierw moczyć przez noc w dużej ilości wody, następnie zmienić wodę na nową, dodać pół łyżeczki soli i ugotować fasolę do miękkości przez koło 1,5 godziny.\r\nPiekarnik nagrzać do 180 stopni C.\r\nMarchewkę i cebulę obrać, następnie pokroić w kosteczkę. Podsmażyć na oliwie na dużej patelni, przez ok. 3 - 4 minuty.\r\nDodać przeciśnięty przez praskę czosnek oraz posiekaną papryczkę chili bez pestek.\r\nDodać fasolę wraz z zalewą oraz bulion i zagotować. Jeśli mamy więcej zalewy z gotowanej fasoli to można ją użyć zamiast bulionu.\r\nDodać pomidory z puszki (zmiksowane), doprawić solą oraz pieprzem, dodać oregano, słodką paprykę oraz cynamon. Wymieszać i zagotować.\r\nWyłożyć do żaroodpornej formy (ok. 20 x 30 cm), nakryć szczelnie folią aluminiową i wstawić do nagrzanego piekarnika.\r\nPiec przez 1 godzinę, następnie zdjąć folię i piec przez kolejne 1/2 godziny. Posypać natką pietruszki.', 'Danie można dodatkowo zapiec z fetą, lub też podawać je z pokruszoną fetą (jak na zdjęciu).', '4', 6, '2024-11-15', true, 100, 6);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Babekjnfkjenkj', NULL, 'Jajka i twaróg wyjąć wcześniej z lodówki i ogrzać w temp. pokojowej. Twaróg wyłożyć na talerz i rozgnieść praską do ziemniaków lub zmiksować w melakserze.\r\nPiekarnik nagrzać do 180 stopni C. Formę na muffiny wyłożyć 12 papilotkami.\r\nJajka ubić z cukrem na jasną i puszystą masę, przez około 7 minut. Dodać twaróg i zmiksować na mniejszych obrotach miksera. Wlać olej roślinny i ponownie zmiksować na mniejszych obrotach miksera.\r\nDodać sok i skórkę z cytryny oraz mąkę zmieszaną z proszkiem do pieczenia. Zmiksować tylko do połączenia się składników w jednolite ciasto.\r\nMasę wyłożyć do foremek, wcisnąć maliny (jeśli ich używamy) a wierzch posypać cukrem trzcinowym (po szczypcie na 1 babeczkę).\r\nWstawić do nagrzanego piekarnika i piec przez ok. 25 minut (do suchego patyczka).', 'Można dodać więcej owoców do babeczek.', '12', 6, '2024-09-20', true, 82, 5);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Wołowina w sosie grzybowym', NULL, 'Wołowinę pokroić na plasterki, następnie rozbić tłuczkiem. W szerokim i dużym garnku zagotować bulion.\r\nMięso doprawić solą. Na dużej patelni, na oleju, obsmażać je partiami, po minucie z każdej strony. Po obsmażeniu wkładać mięso do bulionu.\r\nPrzykryć garnek z mięsem i gotować przez około 1,5 godziny, aż mięso będzie kruche.\r\nGrzyby oczyścić i pokroić na plasterki. Cebulę pokroić w kosteczkę. Czosnek przecisnąć przez praskę.\r\nNa patelnię włożyć 1 łyżkę masła oraz cebulę, podsmażyć ją co chwilę mieszając. Dodać czosnek a następnie grzyby. Doprawić solą oraz pieprzem i smażyć co chwilę mieszając przez około 5 minut.\r\nWlać śmietankę, wymieszać i gotować przez minutę, następnie odstawić z ognia.\r\nGdy mięso będzie już ugotowane, dodać do niego grzyby z sosem, wymieszać i zagotować.\r\nZagęścić mąką: najpierw na suchej patelni podprażyć mąkę, następnie dodać łyżkę masła i wymieszać. Wlewać po trochu sosu mieszając drewnianą łyżką. Gęstą zasmażkę dodać do garnka, wymieszać i zagotować.\r\nNa koniec posypać natką pietruszki.', NULL, '4 - 6', 6, '2024-10-25', true, 154, 6);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Pastka - dip z białej fasoli', 'Hummus z białej fasoli.', 'Fasolę wyłożyć na sitko i zostawić do odsączenia.\r\nDo pojeminika rozdrabniacza - mini melaksera, włożyć odsączoną fasolę, dodać obrany czosnek, oliwę, tahini, sok z cytryny, kmin rzymski oraz sól i pieprz.\r\nWszystko zmiksować na pastę, wyłożyć do miseczki, skropić oliwą, posypać natką pietruszki i granatem lub płatkami chili.\r\nPodawać jako dip lub pasta kanapkowa.', 'jj', '2', 6, '2024-11-11', false, 4, 2);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Krewetki po Toskańsku', 'Krewetki w kremowym sosie ze szpinakiem i suszonymi pomidorami. Prosty i pyszny obiad z jednej patelni! Krewetki świetnie smakują z makaronem, ale również z ryżem.', 'Krewetki rozmrozić, obrać z pancerzy, usunąć ogonki i oczyścić. Opłukać a następnie osuszyć.\r\nDoprawić solą, pieprzem, suszonym oregano oraz drobno startym czosnkiem.\r\nSuszone pomidory drobniej posiekać. Ser zetrzeć na najdrobniejszych oczkach tarki.\r\nNa dużą patelnię włożyć masło. Gdy patelnia i tłuszcz będą gorące, włożyć krewetki i na większym ogniu krótko obsmażyć z dwóch stron, po około minucie.\r\nDodać suszone pomidory i wymieszać. Teraz dodać szpinak i znów wymieszać, podgrzewać przez chwilę aż szpinak zwiędnie.\r\nWlać śmietankę i zagotować. Dodać tarty ser i gotować jeszcze przez minutę. Sprawdzić doprawienie solą i pieprzem. Podawać z makaronem lub ryżem.', NULL, '2', 6, '2024-10-12', true, 13, 7);
INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Babeczki twarogowe z jabłkami', NULL, 'Jajka i twaróg wyjąć wcześniej z lodówki i ogrzać w temp. pokojowej. Twaróg wyłożyć na talerz i rozgnieść praską.\r\nJabłka obrać, pokroić na ósemki, usunąć gniazda nasienne, następnie pokroić na plasterki.\r\nPiekarnik nagrzać do 200 stopni C. Formę na muffiny wyłoży papilotkami.\r\nJajka ubijać z cukrem na jasną i puszystą masę, przez około 5 - 7 minut. Dodać wanilię, skórkę z cytryny, twaróg oraz olej roślinny i zmiksować na mniejszych obrotach miksera, do połączenia się składników.\r\nDodać mąkę oraz proszek do pieczenia i ponownie zmiksować na małych obrotach miksera, tylko do połączenia się składników w jednolite ciasto.\r\nDo masy dodać około 2/3 ilości jabłek i wymieszać łyżką. Wyłożyć do foremek starając się wyłożyć jak najwięcej ciasta z górką. Na wierzch dać resztę jabłek delikatnie wciskając je w ciasto.\r\nWstawić do nagrzanego piekarnika i piec przez ok. 25 minut (do suchego patyczka). Po upieczeniu można posypać cukrem pudrem i/lub cynamonem.', 'do wypieków używamy jabłek twardych, kwaśnych, odmiany np. szara reneta, golden delicious.', '12-15', 6, '2024-10-18', false, 42, 6);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Ziemniaczki pieczone z camembertem', NULL, 'Piekarnik nagrzać do 200 stopni C. Przygotować dużą formę żaroodporną oraz mniejszą foremkę do zapiekania na ser.\r\nZiemniaczki umyć, włożyć do miski, doprawić solą, pieprzem oraz ziołami. Dodać przepołowiony 1 ząbek czosnku oraz 1 łyżkę oliwy. Wymieszać a następnie wyłożyć jedną warstwą do formy.\r\nSer (skórkę) ponacinać nożem w kratkę, włożyć do mniejszej foremki, wlać wino, następnie dodać przeciśnięty przez praskę 1 ząbek czosnku, doprawić solą, pieprzem i ziołami. Polać 1 łyżką oliwy.\r\nZrobić miejsce w środku pomiędzy ziemniakami i wstawić w nie foremkę z serem.\r\nNaczynie z ziemniaczkami wstawić do nagrzanego piekarnika i piec przez 40 - 45 minut.\r\nPrzemieszać ser i maczać w nim upieczone ziemniaki.', NULL, NULL, 6, '2024-11-09', true, 34, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Chlebek marchewkowy', 'Cynamonowy chlebek / ciasto marchewkowe pieczone w podłużnej foremce. Z dodatkiem kremowego serka i orzechów włoskich.', 'Jajka ocieplić w temperaturze pokojowej. Marchewkę obrać i zetrzeć na tarce o małych oczkach. Jabłko obrać i również zetrzeć tak samo jak marchewkę.\r\nPiekarnik nagrzać do 180 stopni C. Formę podłużną o długości 28 - 30 cm wyłożyć papierem do pieczenia.\r\nJajka ubić z cukrem na puszustą masę. Wciąż ubijając dolewać ciągłym, cieniutkim strumieniem olej.\r\nW drugiej misce wymieszać mąkę z proszkiem do pieczenia, sodą, cynamonem, imbirem oraz solą.\r\nPrzesypać do ubitej masy i zmiksować na małych obrotach miksera, tylko do połączenia się składników.\r\nDodać marchewkę z jabłkiem i wymieszać łyżką na jednolite ciasto. Wyłożyć do foremki i wstawić do piekarnika na około 50 minut do suchego patyczka.\r\nSerek ubijać razem z cukrem pudrem oraz ekstraktem z wanilii przez ok. 2 minuty, następnie rozsmarować po ostudzonym cieście. Posypać posiekanymi orzechami.', '', NULL, 6, '2024-11-21', true, 0, 3);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Pistacjowe brownie', 'Brownie z dodatkiem kremu z pistacji oraz pistacji prażonych', 'Jajka ogrzać w temp. pokojowej lub najlepiej w misce z ciepłą wodą.\r\nPiekarnik nagrzać do 160 stopni C. Przygotować małą formę do pieczenia o wymiarach 24 x 24 cm i wyłożyć ją papierem do pieczenia.\r\nMasło pokroić i włożyć do rondelka, dodać połamaną na kosteczki czekoladę i na minimalnym ogniu roztopić, co chwilę mieszając. Nie podgrzewać za mocno masy, odstawić z ognia.\r\nW oddzielnej misce rozmiksować lub wymieszać rózgą jajka z drobnym cukrem (cukier powinien całkowicie się rozpuścić).\r\nDodać masę czekoladową oraz sól i wymieszać rózgą na gładką masę.\r\nDodać mąkę i ponownie wymieszać. Wyłożyć do przygotowanej blaszki.\r\nŁyżeczką wyłożyć miejscami krem pistacjowy. Posypać pistacjami. Cienkim patyczkiem lub wykałaczką zrobić 2 lub 3 ósemki w masie tworząc wzorki z pasty pistacjowej.\r\nWstawić do piekarnika i piec przez 35 minut, aż ciasto się podniesie, a na wierzchu zrobi się skorupka.', NULL, '20', 6, '2024-11-03', true, 12, 7);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Curry z tofu', 'Jednogarnkowe curry z dodatkiem tofu i warzyw: papryki, cebuli i szpinaku', 'Do woka lub szerokiego rondla wlać olej i dodać pokrojoną w kostkę cebulę oraz paprykę. Smażyć co chwilę mieszając przez około 4 minuty, doprawić solą oraz pieprzem.\r\nDodać przeciśnięty przez praskę czosnek oraz obray i starty na drobnej tarce imbir. Smażyć przez ok. 1 - 2 minuty. Na koniec dodać przyprawę curry, kurkumę i kumin.\r\nWlać mleko kokosowe oraz passatę, wymieszać i zagotować.\r\nDodać pokrojone w kosteczkę tofu i gotować przez około 4 - 5 minut.\r\nNa koniec wymieszać ze szpinakiem. Doprawić sokiem z limonki, podawać z ryżem i posypać świeżą kolendrą.', 'Z tego przepisu można zrobić klasyczne curry z tofu, bez dodatku papryki i szpinaku.', '4', 6, '2024-11-01', true, 92, 5);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Makaron z krewetkami i ajvarem', 'Pyszny makaron z krewetkami i ajvarem (bałkańską pastą z papryki), w sosie ze śmietanką, czosnkiem i natką pietruszki.', 'Krewetki rozmrozić, oczyścić jeśli jest konieczność, oderwać ogonki, opłukać i osuszyć. Doprawić świeżo zmielonym pieprzem, słodką papryką, chili oraz drobno startym czosnkiem. Wymieszać z oliwą.\r\nMakaron ugotować w osolonej wodzie zgodnie z instrukcją na opakowaniu.\r\nRozgrzać dużą patelnię, roztopić masło i dodać krewetki, smażyć przez ok. 1 minutę co chwilę mieszając, w międzyczasie doprawić solą.\r\nDodać ajvar, wymieszać i smażyć przez kilkanaście sekund. Wlać śmietankę i zagotować. Wymieszać z natką pietruszki.\r\nDodać makaron, wymieszać i wszystko razem podgrzać. Podawać z tartym parmezanem.', 'Ajvar można bez problemu kupić gotowy, lub też zrobić własny z tego przepisu.\r\nW wersji bardziej light można pominąć śmietankę i dodać w to miejsce kilka łyżek wody z gotowanego makaronu.', '2', 6, '2024-11-12', false, 13, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Fasola zapiekana z warzywami', NULL, 'Fasolę suchą należy namoczyć przez noc w zimnej wodzie, następnie odcedzić wodę, wlać nową (kilka cm powyżej poziomu fasoli), posolić i gotować do miękkości przez ok. 1,5 - 2 godziny. Do zapiekanki używamy ok. 1 - 1,5 szklanki odcedzonej fasoli.\r\nPiekarnik nagrzać do 200 stopni C. Przygotować większą formę do zapiekania ok. 20 x 30 cm.\r\nBatata obrać i pokroić w kostkę. Cukinię przyciąć na końcach i pokroić w kostkę. Paprykę oczyścić z nasion i pokroić w kostkę. Cebulę pokroić na półplasterki. Pomidorki pokroić na połówki.\r\nWarzywa doprawić solą, pieprzem, oregano i papryką słodką. Polać oliwą i przemieszać. Wyłożyć do formy, wstawić do piekarnika i piec bez przykrycia przez ok. 30 minut. Następnie wyłożyć odcedzoną fasolę, posypać parmezanem i zapiekać jeszcze przez ok. 10 minut.\r\nWyjąć z piekarnika, posypać posiekaną papryczką chili i posiekaną bazylią.', NULL, '2 - 4', 6, '2024-11-09', true, 48, 6);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Zapiekanka ziemniaczana z boczkiem', 'Do zapiekanych ziemniaków można użyć świeżo ugotowanych ziemniaków lub już wcześniej ugotowanych (np. z poprzedniego dnia).\r\nZamiast boczku można użyć podsmażonej kiełbasy, chorizo czy szynki parmeńskiej. W wersji wegetariańskiej - suszonych pomidorów.\r\nJeśli wierzch za bardzo się rumieni, można nakryć kawałkiem folii aluminiowej.\r\nZapiekankę można podawać jako dodatek do obiadu, lub jako samodzielne danie np. z kefirem, sałatą ze śmietaną, mizerią.', 'Ziemniaki obrać i ugotować w osolonej wodzie. Odcedzić i pokroić na plasterki, doprawić solą i pieprzem.\r\nPiekarnik nagrzać do 180 stopni C.\r\nBoczek pokroić w kostkę, a cebulę w kostkę lub w piórka. Boczek i cebulę włożyć na patelnię z łyżką oleju roślinnego i co chwilę mieszając, smażyć przez około 3 minuty.\r\nDo miski wbić jajko, dodać śmiętankę oraz starty ser. Doprawić solą oraz pieprzem oraz dodać przyprawy (po 1 - 2 szczypty każdej). Wymieszać.\r\nPołowę ziemniaków wyłożyć w żaroodpornej formie. Na wierzch wyłożyć połowę mieszanki śmietanki z serem, a następnie połowę boczku z cebulą.\r\nTeraz ułożyć takie same warstwy: ziemniaków, śmietanki z serem oraz boczku z cebulą.\r\nWstawić do piekarnika i piec przez ok. 30 minut.\r\nPosypać natką pietruszki i szczypiorkiem.', NULL, '4', 6, '2024-11-12', true, 17, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Uszka z mięsem', NULL, 'Ciasto\r\nMąkę wsypać do miski, dodać sól. Do gorącej wody włożyć masło i roztopić lub wlać olej. Stopniowo wlewać do mąki, mieszając wszystko łyżką.\r\nPołączyć składniki i wyłożyć je na podsypaną mąką stolnicę. Zagniatać ciasto przez około 5 minut aż będzie gładkie i miękkie.\r\nCiasto zabezpieczyć przed wyschnięciem i odłożyć na ok. 30 minut.\r\nFarsz\r\nMięso z rosołu lub bulionu mięsnego (wołowego) obrać od kości, usunąć skórę oraz ścięgna. Dokładnie ostudzić, odparować (można ugotować dzień wcześniej). Zważyć potrzebą ilość mięsa. Warzywa obrać w razie potrzeby.\r\nCebulę pokroić w krążki i zeszklić na oleju roślinnym lub maśle.\r\nMięso, warzywa z wywaru, zeszkloną cebulę oraz grzyby suszone ugotowane w wywarze (jeśli je mamy) zmielić w maszynce do mięsa o dużych oczkach lub rozdrobnić w malekserze. Można też bardzo dokładnie posiekać na desce.\r\nFarsz wyrobić dłonią, doprawić go solą oraz pieprzem. Niektórzy praktykują dodatkowe przesmażenie farszu na maśle.\r\nLepienie uszek\r\nCiasto podzielić na 3 części i kolejno rozwałkowywać, resztę trzymać pod przykryciem. Ciasto rozwałkować na cienki placek (około 2 mm), podsypując stolnicę i wałek mąką.\r\nMałą szklaneczką o średnicy 4,5 cm wycinać kółka, na środek nakładać po 1/3 łyżeczki farszu. Placek złożyć na pół z nadzieniem w środku. Zlepić brzegi, następnie połączyć dwa końce tworząc jakby pierścionek - najlepiej zawinąć sobie pierożka wkoło wskazującego palca i zlepić końce. Najgrubszy środek \"pierścionka\" lekko odchylić.\r\nGotowe uszka układać na stolnicy lub blacie oprószonych mąką.\r\nZagotować osoloną wodę, wkładać partiami uszka, gotować na umiarkowanym ogniu przez około 1-2 minuty (w zależności od grubości ciasta). Wyławiać łyżką cedzakową i układać na talerzach lub tacy zachowując odstępy.\r\nPo dokładnym osuszeniu można układać w pojemniczkach, pudełkach plastikowych i trzymać w lodówce do 3 - 4 dni. Można też zamrozić na dłużej.', NULL, '6', 6, '2024-11-07', true, 94, 6);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Barszcz czerwony', 'Klasyczny przepis na barszcz czerwony, ugotowany z surowych buraków, na bulionie mięsnym, doprawiany zakwasem z buraków - sokiem z kiszonych buraków. Zakwas można zrobić własny (przepis) lub kupić gotowy dobrej jakości.\r\nCzysty barszcz można podać z uszkami, krokietami lub pasztecikami z farszem z ugotowanego mięsa. Można też podawać z ziemniakami z okrasą.', 'Mięso umyć, zalać 2,5 litra zimnej wody, doprowadzić do wrzenia, zmniejszyć ogień, zszumować. Gotować na wolnym ogniu przez około 1 godzinę.\r\nDodać obrane warzywa, opłukane suszone grzyby, sól, pieprz, liście laurowe, ziele angielskie. Gotować przez około 1/2 godziny do miękkości mięsa i warzyw.\r\nGdy mięso i warzywa będą już miękkie, wyjąć je z wywaru. Dodać natomiast buraki - obrane i pokrojone na cienkie talarki lub starte na dużych oczkach tarki. Gotować przez około 15 minut na małym ogniu, do miękkości, następnie całość przecedzić do czystego garnka.\r\nDo barszczu dodać przeciśnięty przez praskę czosnek oraz majeranek.\r\nTeraz najważniejsze - doprawić barszcz. Dodadać zakwas z buraków, ale stopniowo, bo każdy zakwas ma inną moc. Dodać sok z cytryny i cukier oraz w razie potrzeby sól, zmielony pieprz.\r\nPodgrzać prawie do zagotowania, ale już nie zagotowywać.', 'Barszcz można też zrobić na domowym rosole. Dodać do niego buraki jak w przepisie powyżej, czyli pominąć etap gotowania wywaru mięsnego. Będziemy wówczas potrzebować około 2 litry rosołu.\r\nJeśli nie chcemy pozbywać się ugotowanych buraków, można zrobić surówkę lub buraczki zasmażane.', '6', 6, '2024-11-06', false, 2, 5);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Stek z kalafiora', 'Steki z kalafiora pieczone w piekarniku w przyprawach, z oliwą i odrobiną miodu.\r\n\r\nRazem z kalafiorem pieczemy też pomidorki koktajlowe (lub zwykłe pomidory świeże lub z puszki). Po upieczeniu stają się idealnym dodatkiem - \"sosem\" do steku z kalafiora.', 'Piekarnik nagrzać do 190 stopni C.\r\nKalafiora umyć i pokroić na 4 grubsze plastry. Pomidorki pokroić na połówki. Marchewkę obrać i pokroić na plasterki.\r\nDelikatnie natłuścić żaroodporne naczynie i ułożyć steki z kalafiora. Dodać pomidorki oraz marchewkę.\r\nWszystko doprawić solą, pieprzem oraz przyprawami, następnie skropić oliwą oraz miodem.\r\nWstawić do nagrzanego piekarnika i piec przez około 40 minut.\r\nPosiekać szczypiorek z natką pietruszki, wymieszać z oliwą, doprawić solą oraz pieprzem. Taką mieszanką polać kalafiora po upieczeniu.\r\nNa kalafiora można też położyć małe kleksy majonezu.', NULL, '2', 6, '2024-11-15', false, 88, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Pieczony kalafior z ajvarem', 'Pieczone różyczki kalafiora w marynacie z ajwaru i przypraw', 'Piekarnik nagrzać do 190 stopni C.\r\nGłówkę kalafiora umyć i rozdzielić na różyczki. Włożyć do miski, doprawić solą, pieprzem oraz przyprawami.\r\nDodać oliwę oraz ajvar i wymieszać. Wyłożyć jedną warstwą do żaroodpornej formy, dodać przekrojone na połówki pomidorki koktajlowe i pokrojoną na plasterki obraną marchewkę. Skropić dodatkową oliwą.\r\nWstawić do nagrzanego piekarnika i piec przez ok. 35 - 40 minut.\r\nPo upieczeniu posypać natką pietruszki i dodatkowo szczypiorkiem - dla chętnych.', 'Propozycja podania: majonez / jogurt naturalny', '3', 6, '2024-11-15', true, 53, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Makaron z pieczonym kalafiorem', NULL, 'Piekarnik nagrzać do 190 stopni C. Kalafiora umyć i podzielić na małe różyczki. Włożyć do miski, doprawić solą oraz pieprzem.\r\nDodać przeciśnięty przez praskę czosnek, oregano, paprykę słodką i wędzoną oraz płatki chili. Wlać oliwę, dodać ajvar i całość wymieszać.\r\nKalafiora wyłożyć do naczynia żaroodpornego i piec do miękkości przez około 30 minut.\r\nZagotować wodę w dużym garnku, posolić, wrzucić makaron. Gotować al dente, zgodnie z czasem podanym na opakowaniu.\r\nMakaron odcedzić, włożyć z powrotem do garnka, dodać upieczonego kalafiora i wymieszać.\r\nPołączyć z połową startego sera i połową rukoli. Wyłożyć do talerzy, posypać resztą rukoli i sera. Można skropić dodatkową oliwą.', NULL, '3', 6, '2024-11-15', true, 72, 3);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Tiramisu', 'Prawdziwy, oryginalny i najlepszy przepis! Tiramisu to włoski deser, który składa się z warstw podłużnych biszkoptów (specjalnych włoskich biszkoptów Savoiardi) nasączonych mocną kawą oraz migdałowym likierem amaretto, przełożonych kremem z serka mascarpone, jajek i cukru. Całość posypana jest kakao i podawana po schłodzeniu. Warstwy biszkoptów można posypać dodatkowo startą gorzką czekoladą.\r\n\r\nDeser można podawać w pucharkach, ale najczęściej robi się je w jednej prostokątnej formie i nakłada na talerzyki porcje w kształcie \"kostki\" lub prostokąta. Tiramisu z języka włoskiego oznacza ocknąć się, przebudzić.', 'Jajka włożyć do zlewu i przelać gorącą wodą. Zaparzyć kawę, dodać likier i całość ostudzić. Oddzielić żółtka od białek.\r\nWszystkie 4 żółtka ubić z cukrem pudrem na puszysty i jasny krem (ok. 7 minut) - najlepiej początkowo ubijać na parze (w metalowej misce zawieszonej na garnku z parującą wodą), a gdy żółtka będą już ciepłe, odstawić z pary i dalej ubijać.\r\nNastępnie dodawać porcjami (po 3 łyżki) mascarpone, ale już w krótszych odstępach czasu, cały czas ubijając, aż krem będzie gęsty i jednolity.\r\nW oddzielnej misce ubić białka na idealnie sztywną pianę z dodatkiem małej szczypty soli. Połączyć je z kremem z żółtek i mascarpone delikatnie mieszając łyżką.\r\nPołowę biszkoptów na moment zanurzać w kawie i układać w prostokątnym naczyniu np. żaroodpornym lub szklanym (ok. 20 x 22 cm) lub w pojedynczych naczynkach. Posypać cienką warstwą kakao.\r\nWyłożyć połowę kremu i przykryć kolejną warstwą nasączonych biszkoptów. Znów oprószyć kakao. Posmarować resztą kremu, posypać kakao i wstawić do lodówki na minimum 3 godziny lub na całą noc.', NULL, '7', 6, '2024-11-07', true, 519, 8);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Zupa dyniowa', NULL, 'Dynię pokroić na kawałki, łyżką usynąć nasiona ze środka, obrać ze skórki. Miąższ pokroić w kostkę.\r\nW większym garnku na oliwie zeszklić pokrojoną w kostkę cebulę, dodać obrany i pokrojony czosnek i chwilę razem podsmażać.\r\nZiemniaki obrać i pokroić w kostkę. Razem z dynią dodać do garnka, smażyć co chwilę mieszając przez około 2 minuty.\r\nDoprawić solą i świeżo zmielonym pieprzem. Dodać przyprawę curry, słodką paprykę oraz masło. Wszystko wymieszać.\r\nWlać gorący bulion, przykryć i zagotować. Gotować przez ok. 10 minut.\r\nDodać mleko i zmiksować na krem np. w blenderze kielichowym.\r\nPodawać z przyrumienionymi pestkami dyni.', 'Zamiast mleka można użyć 80 ml śmietanki 30%.', '6', 6, '2024-11-12', false, 3, 3);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Bułeczki cynamonowe - Cynamonki', 'Pyszne bułeczki drożdżowe (drożdżówki) z cynamonem', 'Przy pracy z ciastem drożdżowym bardzo ważna jest temperatura składników. Mleko powinno być letnie, czyli lekko ciepłe (temp. 37 - 40 st C), jajka i drożdże wyjęte wcześniej z lodówki i ogrzane w temperaturze pokojowej. Masło należy również wyjąć wcześniej z lodówki, pokroić w kosteczkę i zostawić aby całkowicie zmiękło (konsystencja masła - możliwa do rozsmarowania po cieście, ale nie płynna).\r\nJeśli używamy świeżych drożdży należy przygotować z nich rozczyn: drożdże pokruszyć i umieścić w kubku, dodać łyżeczkę cukru i rozetrzeć łyżeczką aż drożdże się rozpuszczą. Następnie dodać łyżkę mąki oraz 50 ml lekko ciepłego mleka, wymieszać i odstawić do wyrośnięcia na 10 minut.\r\nMąkę wsypać do misy miksera lub dużej miski. Jeśli używamy drożdży instant należy dodać je bezpośrednio do mąki i wymieszać. Jeśli używamy świeżych drożdży - należy wlać do mąki przygotowany, wyrośnięty rozczyn.\r\nNastępnie do mąki dodać lekko ciepłe mleko, jajka, żółtka, roztopione i przestudzone masło, cukier oraz sól.\r\nWyrabiać (ręcznie lub miskerem planetarnym) przez ok. 10 minut aż ciasto będzie gładkie i sprężyste. Przykryć folią i odstawić na ok. 1 godzinę do wyrośnięcia.\r\nPo tym czasie wyłożyć ciasto na stolnicę lub blat i wygniatać przez chwilę pozbywając się pęcherzy powietrza. Ciasto podzielić na 2 części i każdą rozwałkować na placek o wymiarach 30 x 30 cm.\r\nPlacki z ciasta kolejno smarować miękkim masłem i posypać mieszanką cynamonu, cukru wanilinowego, drobnego cukru i startej skórki.\r\nZawinąć ciasto w roladki i każdą z nich pokroić w poprzek na 10 plasterków o grubości ok. 2 cm. Wszystkie 20 sztuk ułożyć na dużej prostokątnej blaszce wyłożonej papierem do pieczenia. Odstawić na ok. 15 - 20 minut do wyrośnięcia.\r\nPiekarnik nagrzać do 180 stopni C. Wierzch bułeczek delikatnie posmarować roztrzepanym (i nie zimnym) jajkiem i piec na złoty kolor przez ok. 20 minut.\r\nPo ostudzeniu polać lukrem: podgrzać sok z cytryny, dodać cukier puder i wymieszać.', '', '20', 6, '2024-10-30', false, 422, 4);
-- INSERT INTO recipes (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty) VALUES ('Lasagne bolognese', 'Lazania to klasyczne włoskie danie, które składa się z warstw makaronu, bogatego sosu mięsno-pomidorowego, kremowego beszamelu i sera, najczęściej mozzarelli lub parmezanu. Każda warstwa tworzy harmonijną kompozycję smaków, a danie pieczone w piekarniku nabiera złocistej, apetycznej skórki. Lazania jest uwielbiana za swoje sycące, aromatyczne wnętrze i stanowi doskonałą propozycję na rodzinny obiad lub spotkanie w gronie przyjaciół.', 'Sos boloński\r\nNa oliwie, w dużym garnku, zeszklić drobno posiekaną cebulę, dodać posiekany w drobną kosteczkę seler naciowy oraz startą marchewkę (warzywa można też rozdrobnić w malakserze).\r\nObsmażyć, następnie przesunąć na bok i w wolne miejsce włożyć pokrojony w drobną kosteczkę boczek. Zrumienić i wymieszać z warzywami.\r\nPrzesunąć wszystko na bok garnka i partiami wkładać mięso: włożyć 1/3 część mięsa i obsmażyć mieszając co chwilę, aż zmieni kolor z czerwonego na brązowy. Następnie wymieszać z warzywami i boczkiem, przesunąć na bok, powtórzyć z resztą mięsa.\r\nWlać wino i gotować na średnim ogniu przez 3 minuty, dodać gorący bulion wymieszany z koncentratem pomidorowym, zagotować, dodać passatę pomidorową.\r\nDoprawić solą i pieprzem. Przykryć i gotować na małym ogniu 2 godziny (można dłużej). Od czasu do czasu zamieszać.\r\nSos beszame​lowy\r\nW średnim garnku dobrze rozgrzać masło, dodać mąkę i smażyć przez około 2 minuty ciągle mieszając. Stopniowo wlewać mleko cały czas energicznie mieszając aż sos będzie gładki.\r\nGotować na wolnym ogniu przez kilka minut. Odstawić z ognia, doprawić solą i gałką muszkatołową.\r\nPieczenie\r\nPiekarnik nagrzać do 175 stopni C (grzanie góra-dół bez termoobiegu). Przygotować żaroodporną formę o wymiarach około 19 x 27 cm. Wysmarować ją masłem, wlać i rozprowadzić ok. 100 ml sosu beszamelowego, ułożyć pierwszą warstwę płatów lasagne (mogą nieznacznie na siebie nachodzić).\r\nNa płatach lasagne rozprowadzić warstwę sosu bolońskiego, następnie polać sosem beszamelowym i posypać parmezanem. Powtórzyć jeszcze 4-krotnie.\r\nTak złożoną lasagne włożyć do piekarnika i piec 45 minut (w połowie czasu pieczenia przykryć folią aluminiową). Po wyjęciu z piekarnika odczekać 5 minut przed porcjowaniem.', 'Przed porcjowaniem zostaw danie do ostnignięcia.', '8', 6, '2024-11-06', true, 745, 6);


DROP TABLE IF EXISTS recipe_ratings;
CREATE TABLE recipe_ratings  (
  recipe_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  rating INT NOT NULL,
  CONSTRAINT pk_ratings UNIQUE (recipe_id, user_id),
  CONSTRAINT fk_rating_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(recipe_id)
    ON DELETE CASCADE,
CONSTRAINT fk_rating_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (1, 2, 4);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (1, 1, 5);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (2, 4, 2);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (2, 3, 2);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (2, 1, 3);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (2, 2, 1);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (3, 2, 4);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (3, 1, 5);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (4, 2, 4);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (4, 4, 1);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (4, 1, 1);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (4, 3, 1);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (5, 4, 1);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (5, 2, 4);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (5, 3, 2);
INSERT INTO recipe_ratings (recipe_id, user_id, rating) VALUES (5, 1, 4);


DROP TABLE IF EXISTS ingredients;
CREATE TABLE ingredients (
  ingredient_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  recipe_id BIGINT NOT NULL,
  ingredient_name varchar(120) NOT NULL,
  CONSTRAINT fk_ingredient_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(recipe_id)
    ON DELETE CASCADE
);

INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '10 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '100 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '2 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, '2 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (1, 'śmietanka 30 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '10 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '100 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '2 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, '2 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (2, 'śmietanka 30 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '10 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '100 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '2 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, '2 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (3, 'śmietanka 30 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '10 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '100 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '2 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, '2 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (4, 'śmietanka 30 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '50 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '500 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '8 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '6 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '8 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, '6 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (5, 'śmietanka 70 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '50 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '500 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '8 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '6 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '8 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, '6 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (6, 'śmietanka 70 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '50 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '500 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '8 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '6 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '8 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, '6 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (7, 'śmietanka 70 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '50 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '500 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '8 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '6 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '8 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, '6 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (8, 'śmietanka 70 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '90 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '900 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '10 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, '10 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (9, 'śmietanka 30 (opcjonalnie)');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '90 kg ziemniaków');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '900 ml wody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '4 jajka');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '10 zielone arbuzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, 'szczypta soli i pieprzy');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '4 czerwone papryki');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, '10 lyzki miody');
INSERT INTO ingredients (recipe_id, ingredient_name) VALUES (10, 'śmietanka 30 (opcjonalnie)');


DROP TABLE IF EXISTS tags;
CREATE TABLE tags (
  tag_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tag_name VARCHAR(40),
  CONSTRAINT unq_tag_name UNIQUE(tag_name)
);

INSERT INTO tags (tag_name) VALUES ('babeczki');
INSERT INTO tags (tag_name) VALUES ('bez pieczenia');
INSERT INTO tags (tag_name) VALUES ('bezglutenowe');
INSERT INTO tags (tag_name) VALUES ('boczek');
INSERT INTO tags (tag_name) VALUES ('curry');
INSERT INTO tags (tag_name) VALUES ('cynamon');
INSERT INTO tags (tag_name) VALUES ('czekolada');
INSERT INTO tags (tag_name) VALUES ('danie tradycyjne');
INSERT INTO tags (tag_name) VALUES ('drożdżówki');
INSERT INTO tags (tag_name) VALUES ('dynia');
INSERT INTO tags (tag_name) VALUES ('fit');
INSERT INTO tags (tag_name) VALUES ('grzyby');
INSERT INTO tags (tag_name) VALUES ('jabłka');
INSERT INTO tags (tag_name) VALUES ('jednogarnkowe');
INSERT INTO tags (tag_name) VALUES ('krewetki');
INSERT INTO tags (tag_name) VALUES ('kuchnia azjatycka');
INSERT INTO tags (tag_name) VALUES ('kuchnia grecka');
INSERT INTO tags (tag_name) VALUES ('kuchnia polska');
INSERT INTO tags (tag_name) VALUES ('kuchnia włoska');
INSERT INTO tags (tag_name) VALUES ('lukier');
INSERT INTO tags (tag_name) VALUES ('makaron');
INSERT INTO tags (tag_name) VALUES ('mięso mielone');
INSERT INTO tags (tag_name) VALUES ('świąteczne');
INSERT INTO tags (tag_name) VALUES ('szybki obiad');
INSERT INTO tags (tag_name) VALUES ('wegańskie');
INSERT INTO tags (tag_name) VALUES ('wegetariańskie');
INSERT INTO tags (tag_name) VALUES ('wołowina');
INSERT INTO tags (tag_name) VALUES ('zapiekanka');
INSERT INTO tags (tag_name) VALUES ('zupa krem');


DROP TABLE IF EXISTS tags_recipes;
CREATE TABLE tags_recipes (
  tag_id BIGINT NOT NULL,
  recipe_id BIGINT NOT NULL,
  CONSTRAINT pk_tags_recipes UNIQUE(tag_id, recipe_id),
  CONSTRAINT fk_tag
    FOREIGN KEY (tag_id)
    REFERENCES tags(tag_id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_tag_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(recipe_id)
    ON DELETE CASCADE
);

INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (1, 1);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (2, 1);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (3, 1);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (4, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (5, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (6, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (7, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (8, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (9, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (10, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (11, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (15, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (23, 2);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (1, 4);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (12, 4);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (2, 5);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (10, 5);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (7, 6);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (9, 6);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (10, 6);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (7, 7);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (9, 7);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (10, 7);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (13, 8);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (14, 8);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (15, 8);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (16, 8);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (13, 9);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (14, 9);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (16, 9);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (17, 10);
INSERT INTO tags_recipes (tag_id, recipe_id) VALUES (18, 10);


DROP TABLE IF EXISTS favourite_recipes;
CREATE TABLE favourite_recipes (
  recipe_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  CONSTRAINT pk_favourite_recipes UNIQUE (recipe_id, user_id),
  CONSTRAINT fk_favorite_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(recipe_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_favorite_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (1, 2);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (2, 2);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (9, 2);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (4, 5);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (3, 5);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (1, 5);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (2, 5);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (2, 4);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (10, 4);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (1, 3);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (5, 3);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (7, 3);
INSERT INTO favourite_recipes (recipe_id, user_id) VALUES (9, 3);


DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  category_name VARCHAR(60),
  CONSTRAINT unq_category_name UNIQUE (category_name)
);

INSERT INTO categories (category_name) VALUES ('danie główne');
INSERT INTO categories (category_name) VALUES ('deser');
INSERT INTO categories (category_name) VALUES ('kolacja');
INSERT INTO categories (category_name) VALUES ('lunch');
INSERT INTO categories (category_name) VALUES ('napój');
INSERT INTO categories (category_name) VALUES ('podwieczorek');
INSERT INTO categories (category_name) VALUES ('przekąska');
INSERT INTO categories (category_name) VALUES ('sałatka');
INSERT INTO categories (category_name) VALUES ('śniadanie');
INSERT INTO categories (category_name) VALUES ('surówka');
INSERT INTO categories (category_name) VALUES ('wypieki');
INSERT INTO categories (category_name) VALUES ('zupy');


DROP TABLE IF EXISTS categories_recipes;
CREATE TABLE categories_recipes (
  recipe_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  CONSTRAINT pk_categories_recipes UNIQUE (recipe_id, category_id),
  CONSTRAINT fk_categories_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_categories_recipe
    FOREIGN KEY (recipe_id)
    REFERENCES recipes(recipe_id)
    ON DELETE CASCADE
);

INSERT INTO categories_recipes (recipe_id, category_id) VALUES (1, 1);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (5, 1);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (7, 1);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (9, 1);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (10, 1);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (1, 2);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (6, 2);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (2, 4);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (4, 4);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (2, 5);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (3, 6);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (8, 6);
INSERT INTO categories_recipes (recipe_id, category_id) VALUES (2, 10);
