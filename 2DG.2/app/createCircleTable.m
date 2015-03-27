function [] = createCircleTable(plist, sizelist, filename)
f = fopen(filename, 'w');

for i=1:numel(plist) 
    for j=1:numel(sizelist)
        [area1(i,j), area2(i,j), perimeter(i,j)] = areacircle(sizelist(j), plist(i));
    end
end

% Table for areas by volume integral
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the results for the volume integral over the circular mesh.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', area1(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:area1}\n\\end{table}\n\n');

% Table for areas by divergence and surface integral
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the results for the surface integral of a divergence over the circular mesh.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', area2(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:area2}\n\\end{table}\n\n');

% Table for perimeters
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the results for the surface integral for the boundary over the circular mesh; again, something seems off with the cubic case.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', perimeter(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:perimeter}\n\\end{table}\n\n');

% Table for areas by volume integral (diff)
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the difference of the actual result ($\\pi$) and the volume integral over the circular mesh.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', pi-area1(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:diffarea1}\n\\end{table}\n\n');

% Table for areas by divergence and surface integral (diff)
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the difference of the actual result ($\\pi$) and the surface integral of a divergence over the circular mesh.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', pi-area2(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:diffarea2}\n\\end{table}\n\n');

% Table for perimeters (diff)
fprintf(f, '\\begin{table}\n');
fprintf(f, '\\caption{Here we show the difference of the actual result ($2\\pi$) and the surface integral of the boundary over the circular mesh.}\n');
fprintf(f, '\\centering\\begin{tabular}{c |');
for j=1:numel(sizelist)
    fprintf(f, ' c');
end
fprintf(f, '}\n\nOrder ');
for j=1:numel(sizelist)
    fprintf(f, '& size = %g ', sizelist(j));
end
fprintf(f, '\\\\\n');
for i=1:numel(plist) 
    fprintf(f, 'p = %d ', plist(i));
    for j=1:numel(sizelist)
        fprintf(f, '& %10.10g ', 2*pi-perimeter(i, j));
    end
    fprintf(f, '\\\\\n');
end
fprintf(f, '\\end{tabular}\n');
fprintf(f, '\\label{tbl:diffperimeter}\n\\end{table}\n\n');
end
