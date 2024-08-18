# Strain Identification via Colony Morphology Using Machine Learning

Plating is a common biology experiment where cells are streaked onto an agar plate and incubated. Researchers then either examine the colony morphology to identify the bacterial species or count the composition of a microbial community based on morphology. These experiments are often time-consuming and laborious.

To automate this process, a machine learning algorithm was developed. Images of entire agar plates with multiple single colonies are used as input. The images are segmented to isolate individual colonies, which are then analyzed by a trained CNN that classifies the strain based on colony morphology. Finally, the colony counts are aggregated to compute the overall composition of the microbial community.

The ML model was trained on [*E.coli* K12 Keio strain](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1681482/) and/or [*Pseudomonas aeruginosa* PA14 mutant](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7615952/) colony images. 

