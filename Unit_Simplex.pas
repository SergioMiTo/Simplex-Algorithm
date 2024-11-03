unit Unit_Simplex;

interface
uses SysUtils, Math;

type
    toutput =   record
     values : array [1..2] of extended;
     report : string;
    end;

     vector = array of extended;    // n elements

    datarow= array  of extended;   //  nvpp elements

    tdata =    array of datarow;    { the data   mnp   elements}

function simplex (data  : tdata; maxIter {max number of iterations}, m { number of parameter to fit}, nvpp{total number of vars per data point}:integer; alfa, beta, gamma, vstep, maxError:extended)  : toutput;



implementation





function simplex (data  : tdata; maxIter: integer ; m, nvpp  :integer; alfa, beta, gamma, vstep, maxError:extended) :  toutput;
type

    index = 0..255;

const  root2= 1.414214;

var

    n :integer; // vertex m+1
{    alfa  :extended;  //reflection coeficient
    beta  :extended;  //contraction coeficient
    gamma :extended;  //expansion coeficient
}
    numerador,denominador:double;

    done : boolean; //convergence
    i,j :index;
    h,l :array of index;  // number high low paramters
    niter : integer;   //number of iterations
    next,    // new vertex to be texted
    center,  // center of the hyperplaned described by all vertexes of the simplex exluiding the worst
    mean, error,
    maxerr,       // maximum error acepted
    p,q,          // to compute first simplex
    step  : vector;   //  n elements
    simp  : array of vector; //the simplex   n    elements


    input: array of  vector;  // datos de entrada

    log : string;

// función para ajustar
function    f(parameters: vector; d:datarow) : real;
  begin
  result:= parameters[0]* d[0]/(d[0]+parameters[1]);
  end;


// computes the sum of the square of the residuals
procedure sum_of_residuals(var x :vector);
  var  i :integer;
       r:extended;
  begin
  x[n-1]:= 0.0;
  for I := 0 to High(data) do
    begin
      r:= sqr (f(x, data[i])- data[i,nvpp-1]) ;
      x[n-1] := x[n-1]  + r;
    end;

  end;

procedure first;
  var i,j :index;
  begin

    log := sLineBreak + 'Starting Simplex' + sLineBreak;
    for j := 0 to n-1 do
      begin

        log := log + 'Simp [' + inttostr(j) + '] ';
         for i := 0 to n-1 do
          begin
            log := log + '  '+ FloatToStr(simp[j,i]);
          end;
          log := log +  sLineBreak;
      end;

  end;

procedure new_vertex;   // next in place of the worst vertex
  var i:index;
  begin
    for i := 0 to n-1 do
      begin
       simp[h[high(h)],i]:= next [i];
      end;
  end;

procedure order; // gives high/low in each parameter
var i,j: index;
begin
  for j := 0 to n-1 do         // all dimensions
      begin
         for i := 0 to n-1 do  // of all vertexes
          begin              // find best and worst
            if simp[i,j] < simp[l[j],j]
              then l[j] := i;
            if simp[i,j] > simp[h[j],j]
              then h[j] := i;

          end;
      end;
end;

procedure enter_data;
begin

simp[0,0] := 0.2;
simp[0,1] := 0.3;

step[0] := vstep;
step[1] := vstep;

maxerr[0]:= maxError;
maxerr[1]:= maxError;
maxerr[2]:= maxError;

end;

procedure report;
var s:string;
    i,j :integer;
    y,dy: extended;
    sigma,estimated_error:extended;
begin
s:='' ;
s :=  sLineBreak+'Program exited after '+  inttostr(niter) +' iterations.' +sLineBreak ;

s := s +sLineBreak+'The final simplex is  : '+ sLineBreak ;

for j := 0 to n-1 do
  begin

    s := s + 'Simp [' + inttostr(j) + '] ';
     for i := 0 to n-1 do
      begin
        s := s + '  '+ FloatToStr(simp[j,i]);
      end;
      s := s +  sLineBreak;
  end;

  s := s +sLineBreak+'The mean is  : ' ;

  for i := 0 to n-1 do
      begin
        s := s + '  '+ FloatToStr(mean[i]);
      end;
      s := s +  sLineBreak;

    s := s +sLineBreak+'The estimated fractional error is  : ' ;

  for i := 0 to n-1 do
      begin
        s := s + '  '+ FloatToStr(error[i]);
      end;
      s := s +  sLineBreak;




     sigma := 0.0;
     for i := 0 to (length(data)-1) do
     begin
      y := f(mean, data[i]) ;
      dy := data[i,1]- y ;
      sigma := sigma + sqrt(y);
     end;
     sigma := sigma/  length(data);
     s := s +sLineBreak+'The estandar deviation is  : ' + FloatToStr(sigma)  +  sLineBreak ;
     estimated_error := sigma / sqrt((length(data)+1)-m ) ;
     s := s +sLineBreak+'The estimated error of the function is  : ' +FloatToStr(estimated_error)  +  sLineBreak;
log:= log + s ;
end;

begin


  n := m+1;
 Setlength (step, n);
 Setlength (simp, n, n);
 Setlength (p, n);
 Setlength (q, n);
 setlength (h,n);
 setlength (l,n);
 setlength (mean,n);
 setlength (next,n);
 setlength (center,n);
 setlength (error,n);
 setlength (maxerr,n);

{Alfa:= 1.0;
Beta:= 0.5;
Gamma:= 2.0; }

 enter_data;
 sum_of_residuals(simp[0]); //first vertex

 for i  := 0 to m-1 do         // compute offset of the vertexes
     begin
     p[i] := step[i] * (sqrt(n)+m-1)/(m * root2);
     q[i]  := step[i] * (sqrt(n)-1)  /(m * root2);
     end;

 for i := 1 to n-1 do        // all the vertex of the starting simplex
     begin
        for j := 0 to m-1 do
        begin
          simp[i,j] := simp[0,j] + q [j];
        end;
        simp[i,i-1]  :=  simp[0,i-1] + p[i-1];
        sum_of_residuals(simp[i])
     end;

 for i := 0 to n-1 do       // preset
     begin
       l[i] :=1;
       h[i] :=1;
     end;


   order;
   first;

   niter := 0;           // no iterations yet

   repeat
   done := true;
   niter:= niter +1;
   for i := 0 to n-1 do center[i] := 0.0;

   for i := 0 to n-1 do     //compute centroid
    begin
      if i <> h[n-1]        // excluding the worst
        then for j := 0 to m-1 do
               center[j] := center[j] + simp[i,j];
    end;


    for i := 0 to n-1 do    // first attempt to reflect
      begin
        center[i]:= center[i] /m;
        next[i] := (1.0+alfa)*center[i]-alfa*simp[h[n-1],i] ;
        // Next vertex is the specular reflection of the worst

      end;

     sum_of_residuals(next);

     if next[n-1] <= simp[l[n-1],n-1]
      then                         // better than the best?
        begin
          new_vertex;            //accepted !
          for i := 0 to m-1 do     // and expanded
            next[i] := gamma *simp[h[n-1],i]  +(1.0-gamma)*center[i];
          sum_of_residuals(next);  // still better?
          if next[n-1] <= simp[l[n-1],n-1]  then  new_vertex; // expansion accepted
        end
      else          // if not better than the best
       begin
             if next[n-1]<= simp[h[n-1],n-1]
                then
                  new_vertex // better than worst
                else    // worst than the worst
                  begin  //then: contract
                     for i := 0 to m-1 do     // and expanded
                      next[i] := beta *simp[h[n-1],i]  +(1.0-beta)*center[i];
                     sum_of_residuals(next);  // still better?
                     if next[n-1]<= simp[h[n-1],n-1]
                      then
                         new_vertex // contraction acepted
                      else
                         begin
                           for i := 0 to n-1 do
                             begin
                               for j := 0 to m-1 do
                                 simp[i,j] := (simp[i,j]+simp[l[n-1],j]) * beta;
                               sum_of_residuals(simp[i]);
                             end;
                         end;


                  end;

       end;
       order;
       for j := 0 to n-1 do // check for convergence
       begin
         error[j]   :=   (simp[h[j],j]-simp[l[j],j]) / simp[h[j],j];
         if done  then
         if error[j]> maxerr[j]
          then
               done := false;

       end;




   until (done or (niter= maxiter));



   for i := 0 to n-1 do
         begin
           mean[i] := 0.0;
           for j:= 0 to n-1 do
             mean[i] := mean[i]  + simp[j,i];
           mean[i] := mean[i] /n
         end;

   report;
  result.report := sLineBreak + 'Simplex Algorithm results:'+  sLineBreak + log + sLineBreak ;
result.values[1]:= mean[0] ;
result.values[2]:= mean[1] ;
end;

end.
