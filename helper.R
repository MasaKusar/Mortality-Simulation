# dolocitev stevila zapletov, starosti in OR smrti za vsakega bolnika v poskusu
zapleti <- function(stevilobolnikov, povpst, sdstarost, pulmo, kardio, CNS, krg){
  mortality <- {}
  stevilozapletov <- {}
  starosti <- {}
  ORs <- {}
  for (i in 1:stevilobolnikov) {
    zapleti <- 0
    # dolocitev starosti bolnika
    starost <- rnorm(1, povpst, sdstarost)
    # dolocitev OR pojava zapleta in smrti glede na starost bolnika
    if (starost <= 40) {
      faktor <- runif(1, 0.5, 0.7)
      faktors <- runif(1, 0.4, 0.6)
    }
    else if (starost <= 60) {
      faktor <- runif(1, 0.85, 0.95)
      faktors <- runif(1, 0.7, 0.9)
    }
    else if (starost <= 80) {
      faktor <- 1
      faktors <- 1
    }
    else {
      faktor <- runif(1, 1.05, 1.1)
      faktors <- runif(1, 1.1, 1.2)
    }
    # verjetnost posameznih skupin zapletov
    pulmo <- min(pulmo*faktor, 1)
    kardio <- min(kardio*faktor, 1)
    CVS <- min(CNS*faktor, 1)
    krg <- min(krg*faktor, 1)
    vrste <- c(pulmo, kardio, CVS, krg)
    # doda bolniku posamezne zaplete, ce se zgodijo
    for (tip in vrste) {
      if (rbinom(1, 1, tip) == 1) {
        zapleti <- zapleti + 1
      } 
      # umrljivost glede na stevilo zapletov pri bolnikih ~70
      s <- c(0.02, 0.1, 0.15, 0.2, 0.5)
      z <- c(0.10, 0.25, 0.3, 0.4, 0.9)
      i <- pmin(zapleti+1, 5)   # indeksi kategorije zapletov, omejeni navzgor (poglejte ?pmin)
      ocena <- runif(1,s[i],z[i])
    }  
    # doda bolnikove podatke v zbirko
    mortality <- c(mortality, ocena)
    stevilozapletov <- c(stevilozapletov, zapleti)
    starosti <- c(starosti, starost)
    ORs <- c(ORs, faktors)
    
  }
  # urejanje serije bolnikov v matricno obliko za nadaljnjo obravnavo
  mortality <-as.matrix(mortality)
  stevilozapletov <-as.matrix(stevilozapletov)
  starosti <- as.matrix(starosti)
  ORs <-as.matrix(ORs)
  rezultat <- cbind(stevilozapletov, starosti, ORs, mortality)
  colnames(rezultat) <- c("Stevilo zapletov", "Starost", "OR smrti", "ocena umrljivosti")
  return(rezultat)
}


# simulacija umrljivosti bolnikov
simulacija <- function(steviloposkusov, stevilobolnikov, povpst, sdstarost, pulmo, kardio, CNS, krg) {
  smrtnost <- {}
  # simulacija posameznega poskusa/serije bolnikov
  for (i in 1:steviloposkusov) {  
    umrli <- 0
    bolniki <- zapleti(stevilobolnikov, povpst, sdstarost, pulmo, kardio, CNS, krg)
    for (j in 1:stevilobolnikov) {# izracun stevila umrlih v posamezni seriji bolnikov
      # verjetnost smrti je produkt verjetnosti smrti zaradi stevila zapletov ter verjetnosti zaradi bolnikove starosti
      verjetnost <- bolniki[j, 4]*bolniki[j, 3]
      smrt <- rbinom(1, 1, min(verjetnost, 1))
      umrli <- umrli + smrt 
    }
    mort <- umrli/stevilobolnikov
    smrtnost <- c(smrtnost, mort)
  }
  return (smrtnost)
}