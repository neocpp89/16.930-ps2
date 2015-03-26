function [] = createCircleTable(plist, sizelist, filename)
f = fopen(filename, 'w');

for i=1:numel(plist) 
    for j=1:numel(sizelist)
        [area1(i,j), area2(i,j), perimeter(i,j)] = areacircle(sizelist(j), plist(i));
    end
end

% Table for areas by volume integral
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', area1(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:area1}\n\\end{table}\n\n');

% Table for areas by divergence and surface integral
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', area2(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:area2}\n\\end{table}\n\n');

% Table for perimeters
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', perimeter(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:perimeter}\n\\end{table}\n\n');

% Table for areas by volume integral (diff)
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', pi-area1(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:diffarea1}\n\\end{table}\n\n');

% Table for areas by divergence and surface integral (diff)
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', pi-area2(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:diffarea2}\n\\end{table}\n\n');

% Table for perimeters (diff)
fprintf(f, '\\begin{table}\n\\begin{tabular}{c');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %g ', 2*pi-perimeter(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:perimeter}\n\\end{table}\n\n');
end
