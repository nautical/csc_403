
// c - d

// c => Id ( Int )
// d => Id ( Int )

rule substI(I:Id, SUBST) => {SUBST [ I ]}:>Int
rule substI(I1 - I2, SUBST) => substI(I1, SUBST) -Int substI(I2, SUBST)

