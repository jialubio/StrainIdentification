% This code checks if a wanted strain is in existing collection
% Both existing collection and full collection are saved as .xlsx

full_list = readtable('NBRP Ecoli Strain_All.csv');
existing_list = readtable('KeioStrains_Andrea.csv');
full_list.Properties.VariableNames{'ResourceNo_JWID_'} = 'ID';
full_list.Properties.VariableNames{'PubMedID_RRCReference_'} = 'Reference';
full_list.ID = erase(full_list.ID, '-KC Ê ');
full_list.ID = erase(full_list.ID, 'JW');
existing_list.JW_id = erase(existing_list.JW_id, 'JW');
%existing_list.JW_id = cell2mat(existing_list.JW_id);
full_list_index = find(~cellfun(@isempty,full_list.ID));
full_ID = full_list.ID(full_list_index);
full_CellSahpe = full_list.CellShape(full_list_index); 
unique_CellShape = unique(full_CellSahpe);
type_num = 0;
for i = 2: length(unique_CellShape),
    type{i} = find(ismember(full_CellSahpe,unique_CellShape(i)));
    type_num(i) = length(type{i});
    in_existing{i} = find(ismember(existing_list.JW_id, full_ID(type{i} )));
    in_stock_list{i} = existing_list.JW_id(in_existing{i});
    in_stock_plate{i} = existing_list.Plate(in_existing{i});
    in_stock_row{i} = existing_list.Row(in_existing{i});
    in_stock_col{i} = existing_list.Col(in_existing{i});
    l = length(in_existing{i});
    
end 
in_stock_table = table(unique_CellShape, in_stock_list',in_stock_plate',in_stock_row',in_stock_col');

