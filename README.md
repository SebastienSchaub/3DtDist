# 3DtDist
To measure simply the 3D distance from a stack, especially measuring A-B distance over time

## Installation

  - Download  3DtDist.ijm. 
  - Under ImageJ : Plugins > Macros > Install... then clicking on [1] runs the macro.
  
## How to use

### For single frame stack
- Simply click on the "A" location in 3D. 
- Then click on "B" location in 3D.
- A and B coordinates are stored in the Result table. subesequent measures are added to the table

### For timelapse
- Select for the frames you want (not mandatory to select all timepoint) and click on "A" location in 3D.
- For last time point [Ctrl]+[Left Click] to select "A" location.
- Then the macro will select sequentially timepoints where "A" has been defined. You then click on "B" location. You can on purpose miss  timepoints changing manually the time slider.
- When last "B" location is selected, the macro write A and B coordinates and their distance wfor all timepoints where A and B are defined.


## References

- 3DtDist.ijm is currently inder submission in collaboration with S.Castagnetti Lab (LBDV -CNRS UMR7009) : https://lbdv.imev-mer.fr/accueil-fr/recherche/equipes/equipe-mitose-et-controle-du-fuseau/

- has been published in ..., ***Paper in submission, TO BE UPDATED***

- contact : **sebastien.schaub@imev-mer.fr**
