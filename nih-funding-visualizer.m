clear; clc;

addpath(genpath('./utils/'));

type_visualize = 'amount'; % 'topic' or 'organization' or 'state' or 'amount'
T_freq = 10;
num_bin = 50;

file_info = './data/NIH_informatics.xls';
[~, ~, raw] = xlsread(file_info);
data = raw(4:end-2, 6:10);

title = data(:, 1);
organization = data(:, 3);
state = data(:, 4);
amount = data(:, 5);

switch type_visualize

case 'topic'

    num_project = length(title);

    list_keyword = {};

    for id_project = 1:num_project

    	title_cur = title{id_project};
    	keyword_cur_ngrams_1 = lower(ngrams(title_cur, 1));
    	keyword_cur_ngrams_2 = lower(ngrams(title_cur, 2));

    	list_keyword = [list_keyword, keyword_cur_ngrams_1, keyword_cur_ngrams_2];

    	disp(['Processing Project ', num2str(id_project), '...']);

    end

    table_keyword = tabulate(list_keyword);
    dict_keyword = table_keyword(:, 1);
    freq_keyword = cell2mat(table_keyword(:, 2));

    indices_keyword = find(freq_keyword >= T_freq);
    keyword_shortlist = dict_keyword(indices_keyword);
    freq_shortlist = freq_keyword(indices_keyword);

case 'organization'

    list_organization = organization;
    table_organization = tabulate(list_organization);
    dict_organization = table_organization(:, 1);
    freq_organization = cell2mat(table_organization(:, 2));

    [~, indices_organization] = sort(freq_organization, 'descend');
    organization_sorted = dict_organization(indices_organization);
    freq_organization = freq_organization(indices_organization);

case 'state'

	list_state = state;
	list_state(find(cell2mat(cellfun(@(x)any(isnan(x)), list_state, 'UniformOutput', false)))) = {'NaN'};
    table_state = tabulate(list_state);
    dict_state = table_state(:, 1);
    freq_state = cell2mat(table_state(:, 2));

    [~, indices_state] = sort(freq_state, 'descend');
    state_sorted = dict_state(indices_state);
    freq_state = freq_state(indices_state);

case 'amount'

    amount = cell2mat(amount);
    
    figure(1);
    hist(amount, num_bin);
    xlim([1e5, 1e8]);
    set(gca, 'XScale', 'log');
    xlabel('Funding Amount');
    ylabel('Number of Projects');

    indices_project = [1:1:length(amount)]; 
    amount_sorted = sort(amount, 'descend');
    percentage_cumsum = cumsum(amount_sorted) ./ sum(amount_sorted);

	figure(2);
	[hAx, hLine1, hLine2] = plotyy(indices_project, amount_sorted, indices_project, percentage_cumsum, 'stem', 'plot');   
    xlabel('Project ID');
    ylabel(hAx(1), 'Funding Amount'); 
    ylabel(hAx(2), 'Funding Amount Percentage');
    grid on;

end
