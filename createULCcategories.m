function categories = createULCcategories()

categories = table(); c = 0;

c = c+1;
categories.type{c} = 'D-CON';
categories.name{c} = 'Consumables';

c = c+1;
categories.type{c} = 'D-TRA';
categories.name{c} = 'Travel & Sub';

c = c+1;
categories.type{c}  = 'D-EQU';
categories.name{c}  = 'Procured Equipment';

c = c+1;
categories.type{c}  = 'D-MAT';
categories.name{c}  = 'Materials /Res Exps';

c = c+1;
categories.type{c}  = 'D-EXP';
categories.name{c}  = 'Experiment Costs';

c = c+1;
categories.type{c}  = 'D-OTH';
categories.name{c}  = 'Other Costs';

c = c+1;
categories.type{c}  = 'D-ANI';
categories.name{c}  = 'Animal Costs';

c = c+1;
categories.type{c}  = 'D-FAC';
categories.name{c}  = 'Research Facilities';

c = c+1;
categories.type{c}  = 'D-SER';
categories.name{c}  = 'Services';

c = c+1;
categories.type{c}  = 'D-COY';
categories.name{c}  = 'Contingency';

c = c+1;
categories.type{c}  = 'S-ACA';
categories.name{c}  = 'Academic Salaries';

c = c+1;
categories.type{c}  = 'S-CAC';
categories.name{c}  = 'Clinical Academic Salaries';

c = c+1;
categories.type{c}  = 'S-ASS';
categories.name{c}  = 'Admin Support Staff';

c = c+1;
categories.type{c}  = 'S-CLE';
categories.name{c}  = 'Clerical Salaries';

c = c+1;
categories.type{c}  = 'S-TEC';
categories.name{c}  = 'Technical Salaries';

c = c+1;
categories.type{c}  = 'X-IND';
categories.name{c}  = 'Indirect Contribution';

c = c+1;
categories.type{c}  = 'X-HEF';
categories.name{c}  = 'Exceptional Items';

c = c+1;
categories.type{c}  = 'X-COL';
categories.name{c}  = 'Collaboration Costs';

c = c+1;
categories.type{c}  = 'D-FEE';
categories.name{c}  = 'Tuition Fees';

c = c+1;
categories.type{c}  = 'D-STU';
categories.name{c}  = 'Studentship';

c = c+1;
categories.type{c}  = '100';
categories.name{c}  = 'UCL';

c = c+1;
categories.type{c}  = '22';
categories.name{c}  = 'UCL';

% c = c+1;
% categories.type{c}  = '';
% categories.name{c}  = '';

save('UCL_categories.mat','categories')
