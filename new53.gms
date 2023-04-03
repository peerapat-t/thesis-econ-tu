******************** setup ********************
sets
i household
/
household_1*household_10
/;

variable 
obj objective fn value;

equation
objective;
* dummy for solver
objective.. obj =e= 1;

option nlp = CONOPT4;
option decimals = 4;
option iterLim = 1000000;



******************** 1. find expenditure share/no tax case ********************

*********** paramerter ***********
parameter
* number of household
N1 number of household
WEIGHT1(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y1(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/

G1(i) demand for goods G
/
$ondelim
$include household_gas.csv
$offdelim
/
S1(i) demand for goods S
/
$ondelim
$include household_size.csv
$offdelim
/
V1(i) demand for goods V
/
$ondelim
$include household_age.csv
$offdelim
/
X1(i) demand for goods X
/
$ondelim
$include household_other_goods.csv
$offdelim
/
$offdigit

CAR_PRICE1(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

* price/tax
P_G1 price for goods G /35.77/
P_S1 price for goods S /6.36/
P_V1 price for goods V /1/
P_X1 price for goods X /1/

T_G1 tax for goods G /0/
T_S1 tax for goods S /0/
T_V1 tax for goods V /0/
T_X1 tax for goods X /0/
T_E1 pigouvian tax /0/
* others
T1 expenditure multiplier
;

* number of household
N1 = sum(i,WEIGHT1(i));
* expenditure multiplier
T1 = 0;

********** variable **********
variable
* income/demand/preference
K1(i) demand for goods K
* G1(i) demand for goods G
* income/demand/preference
a1(i) expenditure share for goods K
b1(i) expenditure share for goods S
c1(i) expenditure share for goods V
d1(i) expenditure share for goods X
TOTAL_K1 total unit of K
TOTAL_G1 total unit of G
TOTAL_S1 total unit of S
TOTAL_V1 total unit of V
TOTAL_X1 total unit of X
CAR_AGE1(i) car age
* price/tax
P_K1(i) price for goods K
T_K1(i) tax for goods K
* kilometer
KPL1(i) kilometer per lite
* emission
EPK1(i) emission per kilometer
EMISSION1(i) emission per household
TOTAL_EMISSION1 total emission
MU1 effect from 1 unit of emission
* utility
U1(i) indirect utility
W1 social welfare
* age
CAR_AGE1(i) car age
* government revenue
GOV_REVENUE1(i) government revenue
;


*********** lower bound ***********
* income/demand/preference
a1.lo(i) = 1e-6;
b1.lo(i) = 1e-6;
c1.lo(i) = 1e-6;
d1.lo(i) = 1e-6;
* price/tax
P_K1.lo(i) = 1e-6;
* kilometer
KPL1.lo(i) = 1e-6;
* emission
EPK1.lo(i) = 1e-6;
* utility
U1.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
a1.l(i) = 0.3;
b1.l(i) = 0.1;
c1.l(i) = 0.1;
d1.l(i) = 0.1;
* price/tax
P_K1.l(i) = 1;
T_K1.l(i) = 0;
* kilometer
KPL1.l(i) = 1;
* emission
EPK1.l(i) = 1;
* utility
U1.l(i) = 1;
W1.l = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION1(i)
G_DEMAND_EQUATION1(i)
S_DEMAND_EQUATION1(i)
V_DEMAND_EQUATION1(i)
X_DEMAND_EQUATION1(i)
TOTAL_K_EQUATION1
TOTAL_G_EQUATION1
TOTAL_S_EQUATION1
TOTAL_V_EQUATION1
TOTAL_X_EQUATION1

* price/tax
PRICE_K_EQUATION1(i)
TAX_K_EQUATION1(i)
* kilometer
KPL_EQUATION1(i)
* emission
EPK_EQUATION1(i)
EMISSION_EQUATION1(i)
TOTAL_EMISSION_EQUATION1
MU_FUNCTION1
* utility function
INDIRECT_UTILITY_EQUATION1(i)
SOCIAL_WELFARE_EQUATION1
* others
SHARE_CONDITION_EQUATION1(i)
GBC_EQUATION1
* age
CAR_AGE_EQUATION1(i)
* government revenue
GOV_REVENUE_EQUATION1(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION1(i).. (a1(i)*(Y1(i)-(T_E1*EPK1(i)*K1(i))))/(P_K1(i)+T_K1(i)) =e= K1(i);
G_DEMAND_EQUATION1(i).. K1(i)/KPL1(i) =e= G1(i);
S_DEMAND_EQUATION1(i).. (b1(i)*(Y1(i)-(T_E1*EPK1(i)*K1(i))))/(P_S1+T_S1) =e= S1(i);
V_DEMAND_EQUATION1(i).. (c1(i)*(Y1(i)-(T_E1*EPK1(i)*K1(i))))/(P_V1+T_V1) =e= V1(i);
X_DEMAND_EQUATION1(i).. (d1(i)*(Y1(i)-(T_E1*EPK1(i)*K1(i))))/(P_X1+T_X1) =e= X1(i);
TOTAL_K_EQUATION1.. TOTAL_K1 =e= sum(i,K1(i));
TOTAL_G_EQUATION1.. TOTAL_G1 =e= sum(i,G1(i));
TOTAL_S_EQUATION1.. TOTAL_S1 =e= sum(i,S1(i));
TOTAL_V_EQUATION1.. TOTAL_V1 =e= sum(i,V1(i));
TOTAL_X_EQUATION1.. TOTAL_X1 =e= sum(i,X1(i));

* price/tax
PRICE_K_EQUATION1(i).. (P_G1)/KPL1(i) =e= P_K1(i);
TAX_K_EQUATION1(i).. (T_G1)/KPL1(i) =e= T_K1(i);

* kilometer
KPL_EQUATION1(i).. 22.257238057 +
(-0.012389854*S1(i)) +
(0.000001828*S1(i)*S1(i)) +
(0.000870924*V1(i)) + 
(-0.000000001*V1(i)*V1(i)) + 
(-0.000000183*S1(i)*V1(i)) =e= KPL1(i);

* emission
EPK_EQUATION1(i).. 146.19866042 +
(-0.02232186*S1(i)) +
(0.00002766*S1(i)*S1(i)) +
(-0.00349283*V1(i)) + 
(0.00000001*V1(i)*V1(i)) + 
(0.00000024*S1(i)*V1(i)) =e= EPK1(i);

EMISSION_EQUATION1(i).. WEIGHT1(i)*EPK1(i)*K1(i) =e= EMISSION1(i);
TOTAL_EMISSION_EQUATION1.. TOTAL_EMISSION1 =e= sum(i,EMISSION1(i));

MU_FUNCTION1.. 0.001925/N1 =e= MU1;

* indirect utility function
INDIRECT_UTILITY_EQUATION1(i).. WEIGHT1(i)*
((((K1(i)**a1(i))*(S1(i)**b1(i))*(V1(i)**c1(i))*(X1(i)**d1(i)))/1)-(MU1*TOTAL_EMISSION1))
+(T1*(T_E1*EMISSION1(i))) =e= U1(i);
* social welfare
SOCIAL_WELFARE_EQUATION1.. sum(i,U1(i)) =e= W1;


* others
SHARE_CONDITION_EQUATION1(i).. a1(i)+b1(i)+c1(i)+d1(i) =e= 1;
GBC_EQUATION1.. sum(i,K1(i)*T_K1(i)) + sum(i,S1(i)*T_S1) + sum(i,V1(i)*T_V1) + sum(i,X1(i)*T_X1)
+ sum(i,EMISSION1(i)*T_E1) =g= 0;

* age
CAR_AGE_EQUATION1(i).. CAR_AGE1(i) =e= log((V1(i)*(12/0.2))/CAR_PRICE1(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION1(i).. GOV_REVENUE1(i) =e= K1(i)*T_K1(i)+ S1(i)*T_S1 + V1(i)*T_V1+ X1(i)*T_X1 + EMISSION1(i)*T_E1;


*********** setup model ***********
model CASE_1_NO_TAX_CASE
/
* income/demand/preference
K_DEMAND_EQUATION1,
G_DEMAND_EQUATION1,
S_DEMAND_EQUATION1,
V_DEMAND_EQUATION1,
X_DEMAND_EQUATION1,
TOTAL_K_EQUATION1,
TOTAL_G_EQUATION1,
TOTAL_S_EQUATION1,
TOTAL_V_EQUATION1,
TOTAL_X_EQUATION1,
* price/tax
PRICE_K_EQUATION1,
TAX_K_EQUATION1,
* kilometer
KPL_EQUATION1,
* emission
EPK_EQUATION1,
EMISSION_EQUATION1,
TOTAL_EMISSION_EQUATION1,
MU_FUNCTION1,
* utility function
INDIRECT_UTILITY_EQUATION1,
SOCIAL_WELFARE_EQUATION1,
* others
SHARE_CONDITION_EQUATION1,
GBC_EQUATION1,
objective,
* age
CAR_AGE_EQUATION1,
* government revenue
GOV_REVENUE_EQUATION1
/;

solve CASE_1_NO_TAX_CASE using nlp maximizing obj;


display
a1.l, b1.l, c1.l, d1.l
K1.l, G1, S1, V1, X1
CAR_AGE1.l,
KPL1.l, EPK1.l,
EMISSION1.l, U1.l,
Y1, CAR_PRICE1,
GOV_REVENUE1.l
;




******************** 2. pigouvian tax case ********************

*********** paramerter ***********
parameter
* number of household
N2 number of household
WEIGHT2(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y2(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE2(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a2(i) expenditure share for goods K
b2(i) expenditure share for goods S
c2(i) expenditure share for goods V
d2(i) expenditure share for goods X
* price/tax
P_G2 price for goods G /35.77/
P_S2 price for goods S /6.36/
P_V2 price for goods V /1/
P_X2 price for goods X /1/

T_G2 tax for goods K /0/
T_S2 tax for goods S /0/
T_V2 tax for goods V /0/
T_X2 tax for goods X /0/
T_E2 pigouvian tax /0.001925/
* others
T2 expenditure multiplier
;

* number of household
N2 = sum(i,WEIGHT2(i));
* expenditure multiplier
T2 = 0;
* income/demand/preference
a2(i) = a1.l(i);
b2(i) = b1.l(i);
c2(i) = c1.l(i);
d2(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K2(i) demand for goods K
G2(i) demand for goods G
S2(i) demand for goods S
V2(i) demand for goods V
X2(i) demand for goods X
TOTAL_K2 total unit of K
TOTAL_G2 total unit of G
TOTAL_S2 total unit of S
TOTAL_V2 total unit of V
TOTAL_X2 total unit of X
* price/tax
P_K2(i) price for goods K
T_K2(i) tax for goods K
* kilometer
KPL2(i) kilometer per lite
* emission
EPK2(i) emission per kilometer
EMISSION2(i) emission per household
TOTAL_EMISSION2 total emission
MU2 effect from 1 unit of emission
* utility
U2(i) indirect utility
W2 social welfare
* age
CAR_AGE2(i) car age
* government revenue
GOV_REVENUE2(i) government revenue
;


*********** lower bound ***********
* income/demand/preference
K2.lo(i) = 1e-6;
S2.lo(i) = 1e-6;
V2.lo(i) = 1e-6;
X2.lo(i) = 1e-6;
* price/tax
P_K2.lo(i) = 1e-6;
* kilometer
KPL2.lo(i) = 1e-6;
* emission
EPK2.lo(i) = 1e-6;
* utility
U2.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K2.l(i) = 1;
S2.l(i) = 1;
V2.l(i) = 1;
X2.l(i) = 1;
* price/tax
P_K2.l(i) = 1;
T_K2.l(i) = 0;
* kilometer
KPL2.l(i) = 10;
* emission
EPK2.l(i) = 150;
* utility
U2.l(i) = 1;
W2.l = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION2(i)
G_DEMAND_EQUATION2(i)
S_DEMAND_EQUATION2(i)
V_DEMAND_EQUATION2(i)
X_DEMAND_EQUATION2(i)
TOTAL_K_EQUATION2
TOTAL_G_EQUATION2
TOTAL_S_EQUATION2
TOTAL_V_EQUATION2
TOTAL_X_EQUATION2
* price/tax
PRICE_K_EQUATION2(i)
TAX_K_EQUATION2(i)
* kilometer
KPL_EQUATION2(i)
* emission
EPK_EQUATION2(i)
EMISSION_EQUATION2(i)
TOTAL_EMISSION_EQUATION2
MU_FUNCTION2
* utility function
INDIRECT_UTILITY_EQUATION2(i)
SOCIAL_WELFARE_EQUATION2
* others
SHARE_CONDITION_EQUATION2(i)
GBC_EQUATION2
* age
CAR_AGE_EQUATION2(i)
* government revenue
GOV_REVENUE_EQUATION2(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION2(i).. (a2(i)*(Y2(i)-(T_E2*EPK2(i)*K2(i))))/(P_K2(i)+T_K2(i)) =e= K2(i);
G_DEMAND_EQUATION2(i).. K2(i)/KPL2(i) =e= G2(i);
S_DEMAND_EQUATION2(i).. (b2(i)*(Y2(i)-(T_E2*EPK2(i)*K2(i))))/(P_S2+T_S2) =e= S2(i);
V_DEMAND_EQUATION2(i).. (c2(i)*(Y2(i)-(T_E2*EPK2(i)*K2(i))))/(P_V2+T_V2) =e= V2(i);
X_DEMAND_EQUATION2(i).. (d2(i)*(Y2(i)-(T_E2*EPK2(i)*K2(i))))/(P_X2+T_X2) =e= X2(i);
TOTAL_K_EQUATION2.. TOTAL_K2 =e= sum(i,K2(i));
TOTAL_G_EQUATION2.. TOTAL_G2 =e= sum(i,G2(i));
TOTAL_S_EQUATION2.. TOTAL_S2 =e= sum(i,S2(i));
TOTAL_V_EQUATION2.. TOTAL_V2 =e= sum(i,V2(i));
TOTAL_X_EQUATION2.. TOTAL_X2 =e= sum(i,X2(i));

* price/tax
PRICE_K_EQUATION2(i).. (P_G2)/KPL2(i) =e= P_K2(i);
TAX_K_EQUATION2(i).. (T_G2)/KPL2(i) =e= T_K2(i);

* kilometer
KPL_EQUATION2(i).. 22.257238057 +
(-0.012389854*S2(i)) +
(0.000001828*S2(i)*S2(i)) +
(0.000870924*V2(i)) + 
(-0.000000001*V2(i)*V2(i)) + 
(-0.000000183*S2(i)*V2(i)) =e= KPL2(i);

* emission
EPK_EQUATION2(i).. 146.19866042 +
(-0.02232186*S2(i)) +
(0.00002766*S2(i)*S2(i)) +
(-0.00349283*V2(i)) + 
(0.00000001*V2(i)*V2(i)) + 
(0.00000024*S2(i)*V2(i)) =e= EPK2(i);

EMISSION_EQUATION2(i).. WEIGHT2(i)*EPK2(i)*K2(i) =e= EMISSION2(i);

TOTAL_EMISSION_EQUATION2.. TOTAL_EMISSION2 =e= sum(i,EMISSION2(i));
MU_FUNCTION2.. 0.001925/N2 =e= MU2;

* indirect utility function
INDIRECT_UTILITY_EQUATION2(i).. WEIGHT2(i)*
((((K2(i)**a2(i))*(S2(i)**b2(i))*(V2(i)**c2(i))*(X2(i)**d2(i)))/1)-(MU2*TOTAL_EMISSION2))
+(T2*(T_E2*EMISSION2(i))) =e= U2(i);
* social welfare
SOCIAL_WELFARE_EQUATION2.. sum(i,U2(i)) =e= W2;

* others
SHARE_CONDITION_EQUATION2(i).. a2(i)+b2(i)+c2(i)+d2(i) =e= 1;
GBC_EQUATION2.. sum(i,K2(i)*T_K2(i)) + sum(i,S2(i)*T_S2) + sum(i,V2(i)*T_V2) + sum(i,X2(i)*T_X2)
+ sum(i,EMISSION2(i)*T_E2) =g= 0;

* age
CAR_AGE_EQUATION2(i).. CAR_AGE2(i) =e= log((V2(i)*(12/0.2))/CAR_PRICE2(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION2(i).. GOV_REVENUE2(i) =e= K2(i)*T_K2(i)+ S2(i)*T_S2 + V2(i)*T_V2+ X2(i)*T_X2 + EMISSION2(i)*T_E2;


*********** setup model ***********
model CASE_2_PIGOUVIAN_TAX_CASE
/
* income/demand/preference
K_DEMAND_EQUATION2,
G_DEMAND_EQUATION2,
S_DEMAND_EQUATION2,
V_DEMAND_EQUATION2,
X_DEMAND_EQUATION2,
TOTAL_K_EQUATION2,
TOTAL_G_EQUATION2,
TOTAL_S_EQUATION2,
TOTAL_V_EQUATION2,
TOTAL_X_EQUATION2,
* price/tax
PRICE_K_EQUATION2,
TAX_K_EQUATION2,
* kilometer
KPL_EQUATION2,
* emission
EPK_EQUATION2,
EMISSION_EQUATION2,
TOTAL_EMISSION_EQUATION2,
MU_FUNCTION2,
* utility function
INDIRECT_UTILITY_EQUATION2,
SOCIAL_WELFARE_EQUATION2,
* others
SHARE_CONDITION_EQUATION2,
objective,
* age
CAR_AGE_EQUATION2,
* government revenue
GOV_REVENUE_EQUATION2
/;

solve CASE_2_PIGOUVIAN_TAX_CASE using nlp maximizing obj;

display
a2, b2, c2, d2,
K2.l, G2.l, S2.l, V2.l, X2.l,
CAR_AGE2.l,
KPL2.l, EPK2.l,
EMISSION2.l, U2.l,
Y2, CAR_PRICE2,
GOV_REVENUE2.l
;



******************** 3. pigouvian tax case reinvest ********************

*********** paramerter ***********
parameter
* number of household
N3 number of household
WEIGHT3(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y3(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE3(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a3(i) expenditure share for goods K
b3(i) expenditure share for goods S
c3(i) expenditure share for goods V
d3(i) expenditure share for goods X
* price/tax
P_G3 price for goods G /35.77/
P_S3 price for goods S /6.36/
P_V3 price for goods V /1/
P_X3 price for goods X /1/

T_G3 tax for goods K /0/
T_S3 tax for goods S /0/
T_V3 tax for goods V /0/
T_X3 tax for goods X /0/
T_E3 pigouvian tax /0.001925/
* others
T3 expenditure multiplier
;

* number of household
N3 = sum(i,WEIGHT3(i));
* expenditure multiplier
T3 = 1;
* income/demand/preference
a3(i) = a1.l(i);
b3(i) = b1.l(i);
c3(i) = c1.l(i);
d3(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K3(i) demand for goods K
G3(i) demand for goods G
S3(i) demand for goods S
V3(i) demand for goods V
X3(i) demand for goods X
TOTAL_K3 total unit of K
TOTAL_G3 total unit of G
TOTAL_S3 total unit of S
TOTAL_V3 total unit of V
TOTAL_X3 total unit of X
* price/tax
P_K3(i) price for goods K
T_K3(i) tax for goods K
* kilometer
KPL3(i) kilometer per lite
* emission
EPK3(i) emission per kilometer
EMISSION3(i) emission per household
TOTAL_EMISSION3 total emission
MU3 effect from 1 unit of emission
* utility
U3(i) indirect utility
W3 social welfare
* age
CAR_AGE3(i) car age
* government revenue
GOV_REVENUE3(i) government revenue
;



*********** lower bound ***********
* income/demand/preference
K3.lo(i) = 1e-6;
S3.lo(i) = 1e-6;
V3.lo(i) = 1e-6;
X3.lo(i) = 1e-6;
* price/tax
P_K3.lo(i) = 1e-6;
* kilometer
KPL3.lo(i) = 1e-6;
* emission
EPK3.lo(i) = 1e-6;
* utility
U3.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K3.l(i) = 1;
S3.l(i) = 1;
V3.l(i) = 1;
X3.l(i) = 1;
* price/tax
P_K3.l(i) = 1;
T_K3.l(i) = 0;
* kilometer
KPL3.l(i) = 10;
* emission
EPK3.l(i) = 150;
* utility
U3.l(i) = 1;
W3.l = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION3(i)
G_DEMAND_EQUATION3(i)
S_DEMAND_EQUATION3(i)
V_DEMAND_EQUATION3(i)
X_DEMAND_EQUATION3(i)
TOTAL_K_EQUATION3
TOTAL_G_EQUATION3
TOTAL_S_EQUATION3
TOTAL_V_EQUATION3
TOTAL_X_EQUATION3
* price/tax
PRICE_K_EQUATION3(i)
TAX_K_EQUATION3(i)
* kilometer
KPL_EQUATION3(i)
* emission
EPK_EQUATION3(i)
EMISSION_EQUATION3(i)
TOTAL_EMISSION_EQUATION3
MU_FUNCTION3
* utility function
INDIRECT_UTILITY_EQUATION3(i)
SOCIAL_WELFARE_EQUATION3
* others
SHARE_CONDITION_EQUATION3(i)
GBC_EQUATION3
* age
CAR_AGE_EQUATION3(i)
* government revenue
GOV_REVENUE_EQUATION3(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION3(i).. (a3(i)*(Y3(i)-(T_E3*EPK3(i)*K3(i))))/(P_K3(i)+T_K3(i)) =e= K3(i);
G_DEMAND_EQUATION3(i).. K3(i)/KPL3(i) =e= G3(i);
S_DEMAND_EQUATION3(i).. (b3(i)*(Y3(i)-(T_E3*EPK3(i)*K3(i))))/(P_S3+T_S3) =e= S3(i);
V_DEMAND_EQUATION3(i).. (c3(i)*(Y3(i)-(T_E3*EPK3(i)*K3(i))))/(P_V3+T_V3) =e= V3(i);
X_DEMAND_EQUATION3(i).. (d3(i)*(Y3(i)-(T_E3*EPK3(i)*K3(i))))/(P_X3+T_X3) =e= X3(i);
TOTAL_K_EQUATION3.. TOTAL_K3 =e= sum(i,K3(i));
TOTAL_G_EQUATION3.. TOTAL_G3 =e= sum(i,G3(i));
TOTAL_S_EQUATION3.. TOTAL_S3 =e= sum(i,S3(i));
TOTAL_V_EQUATION3.. TOTAL_V3 =e= sum(i,V3(i));
TOTAL_X_EQUATION3.. TOTAL_X3 =e= sum(i,X3(i));

* price/tax
PRICE_K_EQUATION3(i).. (P_G3)/KPL3(i) =e= P_K3(i);
TAX_K_EQUATION3(i).. (T_G3)/KPL3(i) =e= T_K3(i);

* kilometer
KPL_EQUATION3(i).. 22.257238057 +
(-0.012389854*S3(i)) +
(0.000001828*S3(i)*S3(i)) +
(0.000870924*V3(i)) + 
(-0.000000001*V3(i)*V3(i)) + 
(-0.000000183*S3(i)*V3(i)) =e= KPL3(i);

* emission
EPK_EQUATION3(i).. 146.19866042 +
(-0.02232186*S3(i)) +
(0.00002766*S3(i)*S3(i)) +
(-0.00349283*V3(i)) + 
(0.00000001*V3(i)*V3(i)) + 
(0.00000024*S3(i)*V3(i)) =e= EPK3(i);

EMISSION_EQUATION3(i).. WEIGHT3(i)*EPK3(i)*K3(i) =e= EMISSION3(i);

TOTAL_EMISSION_EQUATION3.. TOTAL_EMISSION3 =e= sum(i,EMISSION3(i));
MU_FUNCTION3.. 0.001925/N3 =e= MU3;

* indirect utility function
INDIRECT_UTILITY_EQUATION3(i).. WEIGHT3(i)*
((((K3(i)**a3(i))*(S3(i)**b3(i))*(V3(i)**c3(i))*(X3(i)**d3(i)))/1)-(MU3*TOTAL_EMISSION3))
+(T3*(T_E3*EMISSION3(i))) =e= U3(i);
* social welfare
SOCIAL_WELFARE_EQUATION3.. sum(i,U3(i)) =e= W3;


* others
SHARE_CONDITION_EQUATION3(i).. a3(i)+b3(i)+c3(i)+d3(i) =e= 1;
GBC_EQUATION3.. sum(i,K3(i)*T_K3(i)) + sum(i,S3(i)*T_S3) + sum(i,V3(i)*T_V3) + sum(i,X3(i)*T_X3)
+ sum(i,EMISSION3(i)*T_E3) =g= 0;

* age
CAR_AGE_EQUATION3(i).. CAR_AGE3(i) =e= log((V3(i)*(12/0.2))/CAR_PRICE3(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION3(i).. GOV_REVENUE3(i) =e= K3(i)*T_K3(i)+ S3(i)*T_S3 + V3(i)*T_V3+ X3(i)*T_X3 + EMISSION3(i)*T_E3;


*********** setup model ***********
model CASE_3_PIGOUVIAN_TAX_CASE_REINVEST
/
* income/demand/preference
K_DEMAND_EQUATION3,
G_DEMAND_EQUATION3,
S_DEMAND_EQUATION3,
V_DEMAND_EQUATION3,
X_DEMAND_EQUATION3,
TOTAL_K_EQUATION3,
TOTAL_G_EQUATION3,
TOTAL_S_EQUATION3,
TOTAL_V_EQUATION3,
TOTAL_X_EQUATION3,
* price/tax
PRICE_K_EQUATION3,
TAX_K_EQUATION3,
* kilometer
KPL_EQUATION3,
* emission
EPK_EQUATION3,
EMISSION_EQUATION3,
TOTAL_EMISSION_EQUATION3,
MU_FUNCTION3,
* utility function
INDIRECT_UTILITY_EQUATION3,
SOCIAL_WELFARE_EQUATION3,
* others
SHARE_CONDITION_EQUATION3,
objective,
* age
CAR_AGE_EQUATION3,
* government revenue
GOV_REVENUE_EQUATION3
/;

solve CASE_3_PIGOUVIAN_TAX_CASE_REINVEST using nlp maximizing obj;

display
a3, b3, c3, d3,
K3.l, G3.l, S3.l, V3.l, X3.l,
CAR_AGE3.l,
KPL3.l, EPK3.l,
EMISSION3.l, U3.l,
Y3, CAR_PRICE3
GOV_REVENUE3.l
;



******************** 4. G tax case ********************

*********** paramerter ***********
parameter
* number of household
N4 number of household
WEIGHT4(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y4(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE4(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a4(i) expenditure share for goods K
b4(i) expenditure share for goods S
c4(i) expenditure share for goods V
d4(i) expenditure share for goods X

* price/tax
P_G4 price for goods G /35.77/
P_S4 price for goods S /6.36/
P_V4 price for goods V /1/
P_X4 price for goods X /1/
* T_G4 tax for goods K /0/
T_S4 tax for goods S /0/
T_V4 tax for goods V /0/
T_X4 tax for goods X /0/
T_E4 pigouvian tax /0/
* others
T4 expenditure multiplier
;

* number of household
N4 = sum(i,WEIGHT4(i));
* expenditure multiplier
T4 = 0;

* income/demand/preference
a4(i) = a1.l(i);
b4(i) = b1.l(i);
c4(i) = c1.l(i);
d4(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K4(i) demand for goods K
G4(i) demand for goods G
S4(i) demand for goods S
V4(i) demand for goods V
X4(i) demand for goods X
TOTAL_K4 total unit of K
TOTAL_G4 total unit of G
TOTAL_S4 total unit of S
TOTAL_V4 total unit of V
TOTAL_X4 total unit of X
* price/tax
P_K4(i) price for goods K
T_K4(i) tax for goods K
T_G4 tax for goods G
* kilometer
KPL4(i) kilometer per lite
* emission
EPK4(i) emission per kilometer
EMISSION4(i) emission per household
TOTAL_EMISSION4 total emission
MU4 effect from 1 unit of emission
* utility
U4(i) indirect utility
W4 social welfare
* age
CAR_AGE4(i) car age
* government revenue
GOV_REVENUE4(i) government revenue
;


*********** lower bound ***********
* income/demand/preference
K4.lo(i) = 1e-6;
S4.lo(i) = 1e-6;
V4.lo(i) = 1e-6;
X4.lo(i) = 1e-6;
* price/tax
T_G4.lo = -35.77;
* kilometer
KPL4.lo(i) = 1e-6;
* emission
EPK4.lo(i) = 1e-6;
* utility
U4.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K4.l(i) = 1;
S4.l(i) = 1;
V4.l(i) = 1;
X4.l(i) = 1;
* price/tax
P_K4.l(i) = 1;
T_K4.l(i) = 1;
T_G4.lo = -50;
* kilometer
KPL4.l(i) = 6;
* emission
EPK4.l(i) = 50;
* utility
U4.l(i) = 1;
W4.l = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION4(i)
G_DEMAND_EQUATION4(i)
S_DEMAND_EQUATION4(i)
V_DEMAND_EQUATION4(i)
X_DEMAND_EQUATION4(i)
TOTAL_K_EQUATION4
TOTAL_G_EQUATION4
TOTAL_S_EQUATION4
TOTAL_V_EQUATION4
TOTAL_X_EQUATION4
* price/tax
PRICE_K_EQUATION4(i)
TAX_K_EQUATION4(i)
* kilometer
KPL_EQUATION4(i)
* emission
EPK_EQUATION4(i)
EMISSION_EQUATION4(i)
TOTAL_EMISSION_EQUATION4
MU_EQUATION4
* utility function
INDIRECT_UTILITY_EQUATION4(i)
SOCIAL_WELFARE_EQUATION4
* others
SHARE_CONDITION_EQUATION4(i)
GBC_EQUATION4
* age
CAR_AGE_EQUATION4(i)
* government revenue
GOV_REVENUE_EQUATION4(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION4(i).. (a4(i)*(Y4(i)-(T_E4*EPK4(i)*K4(i))))/(P_K4(i)+T_K4(i)) =e= K4(i);
G_DEMAND_EQUATION4(i).. K4(i)/KPL4(i) =e= G4(i);
S_DEMAND_EQUATION4(i).. (b4(i)*(Y4(i)-(T_E4*EPK4(i)*K4(i))))/(P_S4+T_S4) =e= S4(i);
V_DEMAND_EQUATION4(i).. (c4(i)*(Y4(i)-(T_E4*EPK4(i)*K4(i))))/(P_V4+T_V4) =e= V4(i);
X_DEMAND_EQUATION4(i).. (d4(i)*(Y4(i)-(T_E4*EPK4(i)*K4(i))))/(P_X4+T_X4) =e= X4(i);
TOTAL_K_EQUATION4.. TOTAL_K4 =e= sum(i,K4(i));
TOTAL_G_EQUATION4.. TOTAL_G4 =e= sum(i,G4(i));
TOTAL_S_EQUATION4.. TOTAL_S4 =e= sum(i,S4(i));
TOTAL_V_EQUATION4.. TOTAL_V4 =e= sum(i,V4(i));
TOTAL_X_EQUATION4.. TOTAL_X4 =e= sum(i,X4(i));

* price/tax
PRICE_K_EQUATION4(i).. (P_G4)/KPL4(i) =e= P_K4(i);
TAX_K_EQUATION4(i).. (T_G4)/KPL4(i) =e= T_K4(i);

* kilometer
KPL_EQUATION4(i).. 22.257238057 +
(-0.012389854*S4(i)) +
(0.000001828*S4(i)*S4(i)) +
(0.000870924*V4(i)) + 
(-0.000000001*V4(i)*V4(i)) + 
(-0.000000183*S4(i)*V4(i)) =e= KPL4(i);

* emission
EPK_EQUATION4(i).. 146.19866042 +
(-0.02232186*S4(i)) +
(0.00002766*S4(i)*S4(i)) +
(-0.00349283*V4(i)) + 
(0.00000001*V4(i)*V4(i)) + 
(0.00000024*S4(i)*V4(i)) =e= EPK4(i);

EMISSION_EQUATION4(i).. WEIGHT4(i)*EPK4(i)*K4(i) =e= EMISSION4(i);
TOTAL_EMISSION_EQUATION4.. sum(i,EMISSION4(i)) =e= TOTAL_EMISSION4;
MU_EQUATION4.. 0.001925/N4 =e= MU4;


* indirect utility function
INDIRECT_UTILITY_EQUATION4(i).. WEIGHT4(i)*
((((K4(i)**a4(i))*(S4(i)**b4(i))*(V4(i)**c4(i))*(X4(i)**d4(i)))/1)-(MU4*TOTAL_EMISSION4))
+(T4*(T_E4*EMISSION4(i))) =e= U4(i);
* social welfare
SOCIAL_WELFARE_EQUATION4.. sum(i,U4(i)) =e= W4;

* others
SHARE_CONDITION_EQUATION4(i).. a4(i)+b4(i)+c4(i)+d4(i) =e= 1;
GBC_EQUATION4.. sum(i,K4(i)*T_K4(i)) + sum(i,S4(i)*T_S4) + sum(i,V4(i)*T_V4) + sum(i,X4(i)*T_X4)
+ sum(i,EMISSION4(i)*T_E4) =g= 0;

* age
CAR_AGE_EQUATION4(i).. CAR_AGE4(i) =e= log((V4(i)*(12/0.2))/CAR_PRICE4(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION4(i).. GOV_REVENUE4(i) =e= K4(i)*T_K4(i)+ S4(i)*T_S4 + V4(i)*T_V4+ X4(i)*T_X4 + EMISSION4(i)*T_E4;


*********** setup model ***********
model CASE_4_G_TAX
/
* income/demand/preference
K_DEMAND_EQUATION4,
G_DEMAND_EQUATION4,
S_DEMAND_EQUATION4,
V_DEMAND_EQUATION4,
X_DEMAND_EQUATION4,
TOTAL_K_EQUATION4,
TOTAL_G_EQUATION4,
TOTAL_S_EQUATION4,
TOTAL_V_EQUATION4,
TOTAL_X_EQUATION4,
* price/tax
PRICE_K_EQUATION4,
TAX_K_EQUATION4,
* kilometer
KPL_EQUATION4,
* emission
EPK_EQUATION4,
EMISSION_EQUATION4,
TOTAL_EMISSION_EQUATION4,
MU_EQUATION4,
* utility function
INDIRECT_UTILITY_EQUATION4,
SOCIAL_WELFARE_EQUATION4,
* others
SHARE_CONDITION_EQUATION4,
GBC_EQUATION4,
* age
CAR_AGE_EQUATION4,
* government revenue
GOV_REVENUE_EQUATION4
/;

solve CASE_4_G_TAX using nlp maximizing W4;


display
a4, b4, c4, d4,
K4.l, G4.l, S4.l, V4.l, X4.l,
CAR_AGE4.l,
KPL4.l, EPK4.l,
EMISSION4.l, U4.l,
Y4, CAR_PRICE4
GOV_REVENUE4.l
;


******************** 5. S tax ********************

*********** paramerter ***********
parameter
* number of household
N5 number of household
WEIGHT5(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y5(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE5(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a5(i) expenditure share for goods K
b5(i) expenditure share for goods S
c5(i) expenditure share for goods V
d5(i) expenditure share for goods X
* price/tax
P_G5 price for goods G /35.77/
P_S5 price for goods S /6.36/
P_V5 price for goods V /1/
P_X5 price for goods X /1/
T_G5 tax for goods K /0/
* T_S5 tax for goods S /0/
T_V5 tax for goods V /0/
T_X5 tax for goods X /0/
T_E5 pigouvian tax /0/
* others
T5 expenditure multiplier
;

* number of household
N5 = sum(i,WEIGHT5(i));
* expenditure multiplier
T5 = 0;
* income/demand/preference
a5(i) = a1.l(i);
b5(i) = b1.l(i);
c5(i) = c1.l(i);
d5(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K5(i) demand for goods K
G5(i) demand for goods G
S5(i) demand for goods S
V5(i) demand for goods V
X5(i) demand for goods X
TOTAL_K5 total unit of K
TOTAL_G5 total unit of G
TOTAL_S5 total unit of S
TOTAL_V5 total unit of V
TOTAL_X5 total unit of X

* price/tax
P_K5(i) price for goods K
T_K5(i) tax for goods K
* T_G5 tax for goods G
T_S5 tax for goods S
* kilometer
KPL5(i) kilometer per lite
* emission
EPK5(i) emission per kilometer
EMISSION5(i) emission per household
TOTAL_EMISSION5 total emission
MU5 effect from 1 unit of emission
* utility
U5(i) indirect utility
W5 social welfare
* age
CAR_AGE5(i) car age
* government revenue
GOV_REVENUE5(i) government revenue
;


*********** lower bound ***********
* income/demand/preference
K5.lo(i) = 1e-6;
S5.lo(i) = 1e-6;
V5.lo(i) = 1e-6;
X5.lo(i) = 1e-6;
* price/tax
* T_G5.lo = -35.77;
T_S5.lo = -6.36;
* kilometer
KPL5.lo(i) = 1e-6;
* emission
EPK5.lo(i) = 1e-6;
* utility
U5.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K5.l(i) = 1;
S5.l(i) = 1;
V5.l(i) = 1;
X5.l(i) = 1;
* price/tax
P_K5.l(i) = 1;
T_K5.l(i) = 1;
* T_G5.lo = 1;
T_S5.lo = -50;
* kilometer
KPL5.l(i) = 1;
* emission
EPK5.l(i) = 1;
* utility
U5.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION5(i)
G_DEMAND_EQUATION5(i)
S_DEMAND_EQUATION5(i)
V_DEMAND_EQUATION5(i)
X_DEMAND_EQUATION5(i)
TOTAL_K_EQUATION5
TOTAL_G_EQUATION5
TOTAL_S_EQUATION5
TOTAL_V_EQUATION5
TOTAL_X_EQUATION5
* price/tax
PRICE_K_EQUATION5(i)
TAX_K_EQUATION5(i)
* kilometer
KPL_EQUATION5(i)
* emission
EPK_EQUATION5(i)
EMISSION_EQUATION5(i)
TOTAL_EMISSION_EQUATION5
MU_EQUATION5
* utility function
INDIRECT_UTILITY_EQUATION5(i)
SOCIAL_WELFARE_EQUATION5
* others
SHARE_CONDITION_EQUATION5(i)
GBC_EQUATION5
* age
CAR_AGE_EQUATION5(i)
* government revenue
GOV_REVENUE_EQUATION5(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION5(i).. (a5(i)*(Y5(i)-(T_E5*EPK5(i)*K5(i))))/(P_K5(i)+T_K5(i)) =e= K5(i);
G_DEMAND_EQUATION5(i).. K5(i)/KPL5(i) =e= G5(i);
S_DEMAND_EQUATION5(i).. (b5(i)*(Y5(i)-(T_E5*EPK5(i)*K5(i))))/(P_S5+T_S5) =e= S5(i);
V_DEMAND_EQUATION5(i).. (c5(i)*(Y5(i)-(T_E5*EPK5(i)*K5(i))))/(P_V5+T_V5) =e= V5(i);
X_DEMAND_EQUATION5(i).. (d5(i)*(Y5(i)-(T_E5*EPK5(i)*K5(i))))/(P_X5+T_X5) =e= X5(i);
TOTAL_K_EQUATION5.. TOTAL_K5 =e= sum(i,K5(i));
TOTAL_G_EQUATION5.. TOTAL_G5 =e= sum(i,G5(i));
TOTAL_S_EQUATION5.. TOTAL_S5 =e= sum(i,S5(i));
TOTAL_V_EQUATION5.. TOTAL_V5 =e= sum(i,V5(i));
TOTAL_X_EQUATION5.. TOTAL_X5 =e= sum(i,X5(i));

* price/tax
PRICE_K_EQUATION5(i).. (P_G5)/KPL5(i) =e= P_K5(i);
TAX_K_EQUATION5(i).. (T_G5)/KPL5(i) =e= T_K5(i);

* kilometer
KPL_EQUATION5(i).. 22.257238057 +
(-0.012389854*S5(i)) +
(0.000001828*S5(i)*S5(i)) +
(0.000870924*V5(i)) + 
(-0.000000001*V5(i)*V5(i)) + 
(-0.000000183*S5(i)*V5(i)) =e= KPL5(i);

* emission
EPK_EQUATION5(i).. 146.19866042 +
(-0.02232186*S5(i)) +
(0.00002766*S5(i)*S5(i)) +
(-0.00349283*V5(i)) + 
(0.00000001*V5(i)*V5(i)) + 
(0.00000024*S5(i)*V5(i)) =e= EPK5(i);

EMISSION_EQUATION5(i).. WEIGHT5(i)*EPK5(i)*K5(i) =e= EMISSION5(i);
TOTAL_EMISSION_EQUATION5.. sum(i,EMISSION5(i)) =e= TOTAL_EMISSION5;
MU_EQUATION5.. 0.001925/N5 =e= MU5;

* indirect utility function
INDIRECT_UTILITY_EQUATION5(i).. WEIGHT5(i)*
((((K5(i)**a5(i))*(S5(i)**b5(i))*(V5(i)**c5(i))*(X5(i)**d5(i)))/1)-(MU5*TOTAL_EMISSION5))
+(T5*(T_E5*EMISSION5(i))) =e= U5(i);
* social welfare
SOCIAL_WELFARE_EQUATION5.. sum(i,U5(i)) =e= W5;

* others
SHARE_CONDITION_EQUATION5(i).. a5(i)+b5(i)+c5(i)+d5(i) =e= 1;
GBC_EQUATION5.. sum(i,K5(i)*T_K5(i)) + sum(i,S5(i)*T_S5) + sum(i,V5(i)*T_V5) + sum(i,X5(i)*T_X5)
+ sum(i,EMISSION5(i)*T_E5) =g= 0;

* age
CAR_AGE_EQUATION5(i).. CAR_AGE5(i) =e= log((V5(i)*(12/0.2))/CAR_PRICE5(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION5(i).. GOV_REVENUE5(i) =e= K5(i)*T_K5(i)+ S5(i)*T_S5 + V5(i)*T_V5+ X5(i)*T_X5 + EMISSION5(i)*T_E5;



*********** setup model ***********
model CASE_5_S_TAX
/
* income/demand/preference
K_DEMAND_EQUATION5,
G_DEMAND_EQUATION5,
S_DEMAND_EQUATION5,
V_DEMAND_EQUATION5,
X_DEMAND_EQUATION5,
TOTAL_K_EQUATION5,
TOTAL_G_EQUATION5,
TOTAL_S_EQUATION5,
TOTAL_V_EQUATION5,
TOTAL_X_EQUATION5,
* price/tax
PRICE_K_EQUATION5,
TAX_K_EQUATION5,
* kilometer
KPL_EQUATION5,
* emission
EPK_EQUATION5,
EMISSION_EQUATION5,
TOTAL_EMISSION_EQUATION5,
MU_EQUATION5,
* utility function
INDIRECT_UTILITY_EQUATION5,
SOCIAL_WELFARE_EQUATION5,
* others
SHARE_CONDITION_EQUATION5,
GBC_EQUATION5,
* age
CAR_AGE_EQUATION5,
* government revenue
GOV_REVENUE_EQUATION5
/;


solve CASE_5_S_TAX using nlp maximizing W5;

display
a5, b5, c5, d5,
K5.l, G5.l, S5.l, V5.l, X5.l,
CAR_AGE5.l,
KPL5.l, EPK5.l,
EMISSION5.l, U5.l,
Y5, CAR_PRICE5
GOV_REVENUE5.l
;


******************** 6. V tax ********************

*********** paramerter ***********
parameter
* number of household
N6 number of household
WEIGHT6(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y6(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE6(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a6(i) expenditure share for goods K
b6(i) expenditure share for goods S
c6(i) expenditure share for goods V
d6(i) expenditure share for goods X

* price/tax
P_G6 price for goods G /35.77/
P_S6 price for goods S /6.36/
P_V6 price for goods V /1/
P_X6 price for goods X /1/
T_G6 tax for goods K /0/
T_S6 tax for goods S /0/
* T_V6 tax for goods V /0/
T_X6 tax for goods X /0/
T_E6 pigouvian tax /0/
* others
T6 expenditure multiplier
;

* number of household
N6 = sum(i,WEIGHT6(i));
* expenditure multiplier
T6 = 0;
* income/demand/preference
a6(i) = a1.l(i);
b6(i) = b1.l(i);
c6(i) = c1.l(i);
d6(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K6(i) demand for goods K
G6(i) demand for goods G
S6(i) demand for goods S
V6(i) demand for goods V
X6(i) demand for goods X
TOTAL_K6 total unit of K
TOTAL_G6 total unit of G
TOTAL_S6 total unit of S
TOTAL_V6 total unit of V
TOTAL_X6 total unit of X

* price/tax
P_K6(i) price for goods K
T_K6(i) tax for goods K
* T_G6 tax for goods G
* T_S6 tax for goods S
T_V6 tax for goods V
* kilometer
KPL6(i) kilometer per lite
* emission
EPK6(i) emission per kilometer
EMISSION6(i) emission per household
TOTAL_EMISSION6 total emission
MU6 effect from 1 unit of emission
* utility
U6(i) indirect utility
W6 social welfare
* age
CAR_AGE6(i) car age
* government revenue
GOV_REVENUE6(i) government revenue
;

*********** lower bound ***********
* income/demand/preference
K6.lo(i) = 1e-6;
S6.lo(i) = 1e-6;
V6.lo(i) = 1e-6;
X6.lo(i) = 1e-6;
* price/tax
* T_G6.lo = -36.77;
* T_S6.lo = -6.36;
T_V6.lo = -1;
* kilometer
KPL6.lo(i) = 1e-6;
* emission
EPK6.lo(i) = 1e-6;
* utility
U6.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K6.l(i) = 1;
S6.l(i) = 1;
V6.l(i) = 1;
X6.l(i) = 1;
* price/tax
P_K6.l(i) = 1;
T_K6.l(i) = 1;
* T_G6.lo = 1;
* T_S6.lo = 1;
T_V6.lo = -50;
* kilometer
KPL6.l(i) = 1;
* emission
EPK6.l(i) = 1;
* utility
U6.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION6(i)
G_DEMAND_EQUATION6(i)
S_DEMAND_EQUATION6(i)
V_DEMAND_EQUATION6(i)
X_DEMAND_EQUATION6(i)
TOTAL_K_EQUATION6
TOTAL_G_EQUATION6
TOTAL_S_EQUATION6
TOTAL_V_EQUATION6
TOTAL_X_EQUATION6
* price/tax
PRICE_K_EQUATION6(i)
TAX_K_EQUATION6(i)
* kilometer
KPL_EQUATION6(i)
* emission
EPK_EQUATION6(i)
EMISSION_EQUATION6(i)
TOTAL_EMISSION_EQUATION6
MU_EQUATION6
* utility function
INDIRECT_UTILITY_EQUATION6(i)
SOCIAL_WELFARE_EQUATION6
* others
SHARE_CONDITION_EQUATION6(i)
GBC_EQUATION6
* age
CAR_AGE_EQUATION6(i)
* government revenue
GOV_REVENUE_EQUATION6(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION6(i).. (a6(i)*(Y6(i)-(T_E6*EPK6(i)*K6(i))))/(P_K6(i)+T_K6(i)) =e= K6(i);
G_DEMAND_EQUATION6(i).. K6(i)/KPL6(i) =e= G6(i);
S_DEMAND_EQUATION6(i).. (b6(i)*(Y6(i)-(T_E6*EPK6(i)*K6(i))))/(P_S6+T_S6) =e= S6(i);
V_DEMAND_EQUATION6(i).. (c6(i)*(Y6(i)-(T_E6*EPK6(i)*K6(i))))/(P_V6+T_V6) =e= V6(i);
X_DEMAND_EQUATION6(i).. (d6(i)*(Y6(i)-(T_E6*EPK6(i)*K6(i))))/(P_X6+T_X6) =e= X6(i);
TOTAL_K_EQUATION6.. TOTAL_K6 =e= sum(i,K6(i));
TOTAL_G_EQUATION6.. TOTAL_G6 =e= sum(i,G6(i));
TOTAL_S_EQUATION6.. TOTAL_S6 =e= sum(i,S6(i));
TOTAL_V_EQUATION6.. TOTAL_V6 =e= sum(i,V6(i));
TOTAL_X_EQUATION6.. TOTAL_X6 =e= sum(i,X6(i));

* price/tax
PRICE_K_EQUATION6(i).. (P_G6)/KPL6(i) =e= P_K6(i);
TAX_K_EQUATION6(i).. (T_G6)/KPL6(i) =e= T_K6(i);

* kilometer
KPL_EQUATION6(i).. 22.257238057 +
(-0.012389854*S6(i)) +
(0.000001828*S6(i)*S6(i)) +
(0.000870924*V6(i)) + 
(-0.000000001*V6(i)*V6(i)) + 
(-0.000000183*S6(i)*V6(i)) =e= KPL6(i);

* emission
EPK_EQUATION6(i).. 146.19866042 +
(-0.02232186*S6(i)) +
(0.00002766*S6(i)*S6(i)) +
(-0.00349283*V6(i)) + 
(0.00000001*V6(i)*V6(i)) + 
(0.00000024*S6(i)*V6(i)) =e= EPK6(i);

EMISSION_EQUATION6(i).. WEIGHT6(i)*EPK6(i)*K6(i) =e= EMISSION6(i);
TOTAL_EMISSION_EQUATION6.. sum(i,EMISSION6(i)) =e= TOTAL_EMISSION6;
MU_EQUATION6.. 0.001925/N6 =e= MU6;

* indirect utility function
INDIRECT_UTILITY_EQUATION6(i).. WEIGHT6(i)*
((((K6(i)**a6(i))*(S6(i)**b6(i))*(V6(i)**c6(i))*(X6(i)**d6(i)))/1)-(MU6*TOTAL_EMISSION6))
+(T6*(T_E6*EMISSION6(i))) =e= U6(i);
* social welfare
SOCIAL_WELFARE_EQUATION6.. sum(i,U6(i)) =e= W6;

* others
SHARE_CONDITION_EQUATION6(i).. a6(i)+b6(i)+c6(i)+d6(i) =e= 1;
GBC_EQUATION6.. sum(i,K6(i)*T_K6(i)) + sum(i,S6(i)*T_S6) + sum(i,V6(i)*T_V6) + sum(i,X6(i)*T_X6)
+ sum(i,EMISSION6(i)*T_E6) =g= 0;

* age
CAR_AGE_EQUATION6(i).. CAR_AGE6(i) =e= log((V6(i)*(12/0.2))/CAR_PRICE6(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION6(i).. GOV_REVENUE6(i) =e= K6(i)*T_K6(i)+ S6(i)*T_S6 + V6(i)*T_V6+ X6(i)*T_X6 + EMISSION6(i)*T_E6;


*********** setup model ***********
model CASE_6_S_TAX
/
* income/demand/preference
K_DEMAND_EQUATION6,
G_DEMAND_EQUATION6,
S_DEMAND_EQUATION6,
V_DEMAND_EQUATION6,
X_DEMAND_EQUATION6,
TOTAL_K_EQUATION6,
TOTAL_G_EQUATION6,
TOTAL_S_EQUATION6,
TOTAL_V_EQUATION6,
TOTAL_X_EQUATION6,
* price/tax
PRICE_K_EQUATION6,
TAX_K_EQUATION6,
* kilometer
KPL_EQUATION6,
* emission
EPK_EQUATION6,
EMISSION_EQUATION6,
TOTAL_EMISSION_EQUATION6,
MU_EQUATION6,
* utility function
INDIRECT_UTILITY_EQUATION6,
SOCIAL_WELFARE_EQUATION6,
* others
SHARE_CONDITION_EQUATION6,
GBC_EQUATION6,
* age
CAR_AGE_EQUATION6,
* government revenue
GOV_REVENUE_EQUATION6
/;

solve CASE_6_S_TAX using nlp maximizing W6;

display
a6, b6, c6, d6,
K6.l, G6.l, S6.l, V6.l, X6.l,
CAR_AGE6.l,
KPL6.l, EPK6.l,
EMISSION6.l, U6.l,
Y6, CAR_PRICE6
GOV_REVENUE6.l
;


******************** 7. G/S tax ********************

*********** paramerter ***********
parameter
* number of household
N7 number of household
WEIGHT7(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y7(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE7(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a7(i) expenditure share for goods K
b7(i) expenditure share for goods S
c7(i) expenditure share for goods V
d7(i) expenditure share for goods X
* price/tax
P_G7 price for goods G /35.77/
P_S7 price for goods S /6.36/
P_V7 price for goods V /1/
P_X7 price for goods X /1/
* T_G7 tax for goods K /0/
* T_S7 tax for goods S /0/
T_V7 tax for goods V /0/
T_X7 tax for goods X /0/
T_E7 pigouvian tax /0/
* others
T7 expenditure multiplier
* others
T7 expenditure multiplier
;

* number of household
N7 = sum(i,WEIGHT7(i));
* expenditure multiplier
T7 = 0;
* income/demand/preference
a7(i) = a1.l(i);
b7(i) = b1.l(i);
c7(i) = c1.l(i);
d7(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K7(i) demand for goods K
G7(i) demand for goods G
S7(i) demand for goods S
V7(i) demand for goods V
X7(i) demand for goods X
TOTAL_K7 total unit of K
TOTAL_G7 total unit of G
TOTAL_S7 total unit of S
TOTAL_V7 total unit of V
TOTAL_X7 total unit of X
* price/tax
P_K7(i) price for goods K
T_K7(i) tax for goods K
T_G7 tax for goods G
T_S7 tax for goods S
* T_V7 tax for goods V
* kilometer
KPL7(i) kilometer per lite
* emission
EPK7(i) emission per kilometer
EMISSION7(i) emission per household
TOTAL_EMISSION7 total emission
MU7 effect from 1 unit of emission
* utility
U7(i) indirect utility
W7 social welfare
* age
CAR_AGE7(i) car age
* government revenue
GOV_REVENUE7(i) government revenue
;

*********** lower bound ***********
* income/demand/preference
K7.lo(i) = 1e-6;
S7.lo(i) = 1e-6;
V7.lo(i) = 1e-6;
X7.lo(i) = 1e-6;
* price/tax
T_G7.lo = -35.77;
T_S7.lo = -6.36;
* T_V7.lo = -1;
* kilometer
KPL7.lo(i) = 1e-6;
* emission
EPK7.lo(i) = 1e-6;
* utility
U7.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K7.l(i) = 1;
S7.l(i) = 1;
V7.l(i) = 1;
X7.l(i) = 1;
* price/tax
P_K7.l(i) = 1;
T_K7.l(i) = 1;
T_G7.lo = -50;
T_S7.lo = -50;
* T_V7.lo = 1;
* kilometer
KPL7.l(i) = 1;
* emission
EPK7.l(i) = 1;
* utility
U7.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION7(i)
G_DEMAND_EQUATION7(i)
S_DEMAND_EQUATION7(i)
V_DEMAND_EQUATION7(i)
X_DEMAND_EQUATION7(i)
TOTAL_K_EQUATION7
TOTAL_G_EQUATION7
TOTAL_S_EQUATION7
TOTAL_V_EQUATION7
TOTAL_X_EQUATION7
* price/tax
PRICE_K_EQUATION7(i)
TAX_K_EQUATION7(i)
* kilometer
KPL_EQUATION7(i)
* emission
EPK_EQUATION7(i)
EMISSION_EQUATION7(i)
TOTAL_EMISSION_EQUATION7
MU_EQUATION7
* utility function
INDIRECT_UTILITY_EQUATION7(i)
SOCIAL_WELFARE_EQUATION7
* others
SHARE_CONDITION_EQUATION7(i)
GBC_EQUATION7
* age
CAR_AGE_EQUATION7(i)
* government revenue
GOV_REVENUE_EQUATION7(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION7(i).. (a7(i)*(Y7(i)-(T_E7*EPK7(i)*K7(i))))/(P_K7(i)+T_K7(i)) =e= K7(i);
G_DEMAND_EQUATION7(i).. K7(i)/KPL7(i) =e= G7(i);
S_DEMAND_EQUATION7(i).. (b7(i)*(Y7(i)-(T_E7*EPK7(i)*K7(i))))/(P_S7+T_S7) =e= S7(i);
V_DEMAND_EQUATION7(i).. (c7(i)*(Y7(i)-(T_E7*EPK7(i)*K7(i))))/(P_V7+T_V7) =e= V7(i);
X_DEMAND_EQUATION7(i).. (d7(i)*(Y7(i)-(T_E7*EPK7(i)*K7(i))))/(P_X7+T_X7) =e= X7(i);
TOTAL_K_EQUATION7.. TOTAL_K7 =e= sum(i,K7(i));
TOTAL_G_EQUATION7.. TOTAL_G7 =e= sum(i,G7(i));
TOTAL_S_EQUATION7.. TOTAL_S7 =e= sum(i,S7(i));
TOTAL_V_EQUATION7.. TOTAL_V7 =e= sum(i,V7(i));
TOTAL_X_EQUATION7.. TOTAL_X7 =e= sum(i,X7(i));

* price/tax
PRICE_K_EQUATION7(i).. (P_G7)/KPL7(i) =e= P_K7(i);
TAX_K_EQUATION7(i).. (T_G7)/KPL7(i) =e= T_K7(i);

* kilometer
KPL_EQUATION7(i).. 22.257238057 +
(-0.012389854*S7(i)) +
(0.000001828*S7(i)*S7(i)) +
(0.000870924*V7(i)) + 
(-0.000000001*V7(i)*V7(i)) + 
(-0.000000183*S7(i)*V7(i)) =e= KPL7(i);

* emission
EPK_EQUATION7(i).. 146.19866042 +
(-0.02232186*S7(i)) +
(0.00002766*S7(i)*S7(i)) +
(-0.00349283*V7(i)) + 
(0.00000001*V7(i)*V7(i)) + 
(0.00000024*S7(i)*V7(i)) =e= EPK7(i);


EMISSION_EQUATION7(i).. WEIGHT7(i)*EPK7(i)*K7(i) =e= EMISSION7(i);
TOTAL_EMISSION_EQUATION7.. sum(i,EMISSION7(i)) =e= TOTAL_EMISSION7;
MU_EQUATION7.. 0.001925/N7 =e= MU7;

* utility function
INDIRECT_UTILITY_EQUATION7(i).. WEIGHT7(i)*
((((K7(i)**a7(i))*(S7(i)**b7(i))*(V7(i)**c7(i))*(X7(i)**d7(i)))/1)-(MU7*TOTAL_EMISSION7)) =e= U7(i);
SOCIAL_WELFARE_EQUATION7.. sum(i,U7(i)) =e= W7;

* others
SHARE_CONDITION_EQUATION7(i).. a7(i)+b7(i)+c7(i)+d7(i) =e= 1;
GBC_EQUATION7.. sum(i,K7(i)*T_K7(i)) + sum(i,S7(i)*T_S7) + sum(i,V7(i)*T_V7) + sum(i,X7(i)*T_X7)
+ sum(i,EMISSION7(i)*T_E7) =g= 0;

* age
CAR_AGE_EQUATION7(i).. CAR_AGE7(i) =e= log((V7(i)*(12/0.2))/CAR_PRICE7(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION7(i).. GOV_REVENUE7(i) =e= K7(i)*T_K7(i)+ S7(i)*T_S7 + V7(i)*T_V7+ X7(i)*T_X7 + EMISSION7(i)*T_E7;



*********** setup model ***********
model CASE_7_G_S_TAX
/
* income/demand/preference
K_DEMAND_EQUATION7,
G_DEMAND_EQUATION7,
S_DEMAND_EQUATION7,
V_DEMAND_EQUATION7,
X_DEMAND_EQUATION7,
TOTAL_K_EQUATION7,
TOTAL_G_EQUATION7,
TOTAL_S_EQUATION7,
TOTAL_V_EQUATION7,
TOTAL_X_EQUATION7,
* price/tax
PRICE_K_EQUATION7,
TAX_K_EQUATION7,
* kilometer
KPL_EQUATION7,
* emission
EPK_EQUATION7,
EMISSION_EQUATION7,
TOTAL_EMISSION_EQUATION7,
MU_EQUATION7,
* utility function
INDIRECT_UTILITY_EQUATION7,
SOCIAL_WELFARE_EQUATION7,
* others
SHARE_CONDITION_EQUATION7,
GBC_EQUATION7,
* age
CAR_AGE_EQUATION7,
* government revenue
GOV_REVENUE_EQUATION7
/;


solve CASE_7_G_S_TAX using nlp maximizing W7;

display
a7, b7, c7, d7,
K7.l, G7.l, S7.l, V7.l, X7.l,
CAR_AGE7.l,
KPL7.l, EPK7.l,
EMISSION7.l, U7.l,
Y7, CAR_PRICE7
GOV_REVENUE7.l
;




******************** 8. G/S tax ********************

*********** paramerter ***********
parameter
* number of household
N8 number of household
WEIGHT8(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y8(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE8(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a8(i) expenditure share for goods K
b8(i) expenditure share for goods S
c8(i) expenditure share for goods V
d8(i) expenditure share for goods X
* price/tax
P_G8 price for goods G /35.77/
P_S8 price for goods S /6.36/
P_V8 price for goods V /1/
P_X8 price for goods X /1/
* T_G8 tax for goods K /0/
T_S8 tax for goods S /0/
* T_V8 tax for goods V /0/
T_X8 tax for goods X /0/
T_E8 pigouvian tax /0/
* others
T8 expenditure multiplier
;

* number of household
N8 = sum(i,WEIGHT8(i));
* expenditure multiplier
T8 = 0;
* income/demand/preference
a8(i) = a1.l(i);
b8(i) = b1.l(i);
c8(i) = c1.l(i);
d8(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K8(i) demand for goods K
G8(i) demand for goods G
S8(i) demand for goods S
V8(i) demand for goods V
X8(i) demand for goods X
TOTAL_K8 total unit of K
TOTAL_G8 total unit of G
TOTAL_S8 total unit of S
TOTAL_V8 total unit of V
TOTAL_X8 total unit of X

* price/tax
P_K8(i) price for goods K
T_K8(i) tax for goods K
T_G8 tax for goods G
* T_S8 tax for goods S
T_V8 tax for goods V
* kilometer
KPL8(i) kilometer per lite
* emission
EPK8(i) emission per kilometer
EMISSION8(i) emission per household
TOTAL_EMISSION8 total emission
MU8 effect from 1 unit of emission
* utility
U8(i) indirect utility
W8 social welfare
* age
CAR_AGE8(i) car age
* government revenue
GOV_REVENUE8(i) government revenue
;

*********** lower bound ***********
* income/demand/preference
K8.lo(i) = 1e-6;
S8.lo(i) = 1e-6;
V8.lo(i) = 1e-6;
X8.lo(i) = 1e-6;
* price/tax
T_G8.lo = -35.77;
* T_S8.lo = -6.36;
T_V8.lo = -1;
* kilometer
KPL8.lo(i) = 1e-6;
* emission
EPK8.lo(i) = 1e-6;
* utility
U8.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K8.l(i) = 1;
S8.l(i) = 1;
V8.l(i) = 1;
X8.l(i) = 1;
* price/tax
P_K8.l(i) = 1;
T_K8.l(i) = 1;
T_G8.lo = -50;
* T_S8.lo = 1;
T_V8.lo = -50;
* kilometer
KPL8.l(i) = 1;
* emission
EPK8.l(i) = 1;
* utility
U8.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION8(i)
G_DEMAND_EQUATION8(i)
S_DEMAND_EQUATION8(i)
V_DEMAND_EQUATION8(i)
X_DEMAND_EQUATION8(i)
TOTAL_K_EQUATION8
TOTAL_G_EQUATION8
TOTAL_S_EQUATION8
TOTAL_V_EQUATION8
TOTAL_X_EQUATION8

* price/tax
PRICE_K_EQUATION8(i)
TAX_K_EQUATION8(i)
* kilometer
KPL_EQUATION8(i)
* emission
EPK_EQUATION8(i)
EMISSION_EQUATION8(i)
TOTAL_EMISSION_EQUATION8
MU_EQUATION8
* utility function
INDIRECT_UTILITY_EQUATION8(i)
SOCIAL_WELFARE_EQUATION8
* others
SHARE_CONDITION_EQUATION8(i)
GBC_EQUATION8
* age
CAR_AGE_EQUATION8(i)
* government revenue
GOV_REVENUE_EQUATION8(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION8(i).. (a8(i)*(Y8(i)-(T_E8*EPK8(i)*K8(i))))/(P_K8(i)+T_K8(i)) =e= K8(i);
G_DEMAND_EQUATION8(i).. K8(i)/KPL8(i) =e= G8(i);
S_DEMAND_EQUATION8(i).. (b8(i)*(Y8(i)-(T_E8*EPK8(i)*K8(i))))/(P_S8+T_S8) =e= S8(i);
V_DEMAND_EQUATION8(i).. (c8(i)*(Y8(i)-(T_E8*EPK8(i)*K8(i))))/(P_V8+T_V8) =e= V8(i);
X_DEMAND_EQUATION8(i).. (d8(i)*(Y8(i)-(T_E8*EPK8(i)*K8(i))))/(P_X8+T_X8) =e= X8(i);
TOTAL_K_EQUATION8.. TOTAL_K8 =e= sum(i,K8(i));
TOTAL_G_EQUATION8.. TOTAL_G8 =e= sum(i,G8(i));
TOTAL_S_EQUATION8.. TOTAL_S8 =e= sum(i,S8(i));
TOTAL_V_EQUATION8.. TOTAL_V8 =e= sum(i,V8(i));
TOTAL_X_EQUATION8.. TOTAL_X8 =e= sum(i,X8(i));

* price/tax
PRICE_K_EQUATION8(i).. (P_G8)/KPL8(i) =e= P_K8(i);
TAX_K_EQUATION8(i).. (T_G8)/KPL8(i) =e= T_K8(i);

* kilometer
KPL_EQUATION8(i).. 22.257238057 +
(-0.012389854*S8(i)) +
(0.000001828*S8(i)*S8(i)) +
(0.000870924*V8(i)) + 
(-0.000000001*V8(i)*V8(i)) + 
(-0.000000183*S8(i)*V8(i)) =e= KPL8(i);

* emission
EPK_EQUATION8(i).. 146.19866042 +
(-0.02232186*S8(i)) +
(0.00002766*S8(i)*S8(i)) +
(-0.00349283*V8(i)) + 
(0.00000001*V8(i)*V8(i)) + 
(0.00000024*S8(i)*V8(i)) =e= EPK8(i);

EMISSION_EQUATION8(i).. WEIGHT8(i)*EPK8(i)*K8(i) =e= EMISSION8(i);
TOTAL_EMISSION_EQUATION8.. sum(i,EMISSION8(i)) =e= TOTAL_EMISSION8;
MU_EQUATION8.. 0.001925/N8 =e= MU8;

* indirect utility function
INDIRECT_UTILITY_EQUATION8(i).. WEIGHT8(i)*
((((K8(i)**a8(i))*(S8(i)**b8(i))*(V8(i)**c8(i))*(X8(i)**d8(i)))/1)-(MU8*TOTAL_EMISSION8))
+(T8*(T_E8*EMISSION8(i))) =e= U8(i);
* social welfare
SOCIAL_WELFARE_EQUATION8.. sum(i,U8(i)) =e= W8;

* others
SHARE_CONDITION_EQUATION8(i).. a8(i)+b8(i)+c8(i)+d8(i) =e= 1;
GBC_EQUATION8.. sum(i,K8(i)*T_K8(i)) + sum(i,S8(i)*T_S8) + sum(i,V8(i)*T_V8) + sum(i,X8(i)*T_X8)
+ sum(i,EMISSION8(i)*T_E8) =g= 0;

* age
CAR_AGE_EQUATION8(i).. CAR_AGE8(i) =e= log((V8(i)*(12/0.2))/CAR_PRICE8(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION8(i).. GOV_REVENUE8(i) =e= K8(i)*T_K8(i)+ S8(i)*T_S8 + V8(i)*T_V8+ X8(i)*T_X8 + EMISSION8(i)*T_E8;



*********** setup model ***********
model CASE_8_G_V_TAX
/
* income/demand/preference
K_DEMAND_EQUATION8,
G_DEMAND_EQUATION8,
S_DEMAND_EQUATION8,
V_DEMAND_EQUATION8,
X_DEMAND_EQUATION8,
TOTAL_K_EQUATION8,
TOTAL_G_EQUATION8,
TOTAL_S_EQUATION8,
TOTAL_V_EQUATION8,
TOTAL_X_EQUATION8,
* price/tax
PRICE_K_EQUATION8,
TAX_K_EQUATION8,
* kilometer
KPL_EQUATION8,
* emission
EPK_EQUATION8,
EMISSION_EQUATION8,
TOTAL_EMISSION_EQUATION8,
MU_EQUATION8,
* utility function
INDIRECT_UTILITY_EQUATION8,
SOCIAL_WELFARE_EQUATION8,
* others
SHARE_CONDITION_EQUATION8,
GBC_EQUATION8,
* age
CAR_AGE_EQUATION8,
* government revenue
GOV_REVENUE_EQUATION8
/;


solve CASE_8_G_V_TAX using nlp maximizing W8;

display
a8, b8, c8, d8,
K8.l, G8.l, S8.l, V8.l, X8.l,
CAR_AGE8.l,
KPL8.l, EPK8.l,
EMISSION8.l, U8.l,
Y8, CAR_PRICE8
GOV_REVENUE8.l
;



******************** 9. S/V tax ********************

*********** paramerter ***********
parameter
* number of household
N9 number of household
WEIGHT9(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y9(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE9(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a9(i) expenditure share for goods K
b9(i) expenditure share for goods S
c9(i) expenditure share for goods V
d9(i) expenditure share for goods X
* price/tax
P_G9 price for goods G /35.77/
P_S9 price for goods S /6.36/
P_V9 price for goods V /1/
P_X9 price for goods X /1/
T_G9 tax for goods K /0/
* T_S9 tax for goods S /0/
* T_V9 tax for goods V /0/
T_X9 tax for goods X /0/
T_E9 pigouvian tax /0/
* others
T9 expenditure multiplier
;

* number of household
N9 = sum(i,WEIGHT9(i));
* expenditure multiplier
T9 = 0;
* income/demand/preference
a9(i) = a1.l(i);
b9(i) = b1.l(i);
c9(i) = c1.l(i);
d9(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K9(i) demand for goods K
G9(i) demand for goods G
S9(i) demand for goods S
V9(i) demand for goods V
X9(i) demand for goods X
TOTAL_K9 total unit of K
TOTAL_G9 total unit of G
TOTAL_S9 total unit of S
TOTAL_V9 total unit of V
TOTAL_X9 total unit of X

* price/tax
P_K9(i) price for goods K
T_K9(i) tax for goods K
* T_G9 tax for goods G
T_S9 tax for goods S
T_V9 tax for goods V
* kilometer
KPL9(i) kilometer per lite
* emission
EPK9(i) emission per kilometer
EMISSION9(i) emission per household
TOTAL_EMISSION9 total emission
MU9 effect from 1 unit of emission
* utility
U9(i) indirect utility
W9 social welfare
* age
CAR_AGE9(i) car age
* government revenue
GOV_REVENUE9(i) government revenue
;

*********** lower bound ***********
* income/demand/preference
K9.lo(i) = 1e-6;
S9.lo(i) = 1e-6;
V9.lo(i) = 1e-6;
X9.lo(i) = 1e-6;
* price/tax
* T_G9.lo = -35.77;
T_S9.lo = -6.36;
T_V9.lo = -1;
* kilometer
KPL9.lo(i) = 1e-6;
* emission
EPK9.lo(i) = 1e-6;
* utility
U9.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K9.l(i) = 1;
S9.l(i) = 1;
V9.l(i) = 1;
X9.l(i) = 1;
* price/tax
P_K9.l(i) = 1;
T_K9.l(i) = 1;
* T_G9.lo = 1;
T_S9.lo = -50;
T_V9.lo = -50;
* kilometer
KPL9.l(i) = 1;
* emission
EPK9.l(i) = 1;
* utility
U9.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION9(i)
G_DEMAND_EQUATION9(i)
S_DEMAND_EQUATION9(i)
V_DEMAND_EQUATION9(i)
X_DEMAND_EQUATION9(i)
TOTAL_K_EQUATION9
TOTAL_G_EQUATION9
TOTAL_S_EQUATION9
TOTAL_V_EQUATION9
TOTAL_X_EQUATION9

* price/tax
PRICE_K_EQUATION9(i)
TAX_K_EQUATION9(i)
* kilometer
KPL_EQUATION9(i)
* emission
EPK_EQUATION9(i)
EMISSION_EQUATION9(i)
TOTAL_EMISSION_EQUATION9
MU_EQUATION9
* utility function
INDIRECT_UTILITY_EQUATION9(i)
SOCIAL_WELFARE_EQUATION9
* others
SHARE_CONDITION_EQUATION9(i)
GBC_EQUATION9
* age
CAR_AGE_EQUATION9(i)
* government revenue
GOV_REVENUE_EQUATION9(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION9(i).. (a9(i)*(Y9(i)-(T_E9*EPK9(i)*K9(i))))/(P_K9(i)+T_K9(i)) =e= K9(i);
G_DEMAND_EQUATION9(i).. K9(i)/KPL9(i) =e= G9(i);
S_DEMAND_EQUATION9(i).. (b9(i)*(Y9(i)-(T_E9*EPK9(i)*K9(i))))/(P_S9+T_S9) =e= S9(i);
V_DEMAND_EQUATION9(i).. (c9(i)*(Y9(i)-(T_E9*EPK9(i)*K9(i))))/(P_V9+T_V9) =e= V9(i);
X_DEMAND_EQUATION9(i).. (d9(i)*(Y9(i)-(T_E9*EPK9(i)*K9(i))))/(P_X9+T_X9) =e= X9(i);

TOTAL_K_EQUATION9.. TOTAL_K9 =e= sum(i,K9(i));
TOTAL_G_EQUATION9.. TOTAL_G9 =e= sum(i,G9(i));
TOTAL_S_EQUATION9.. TOTAL_S9 =e= sum(i,S9(i));
TOTAL_V_EQUATION9.. TOTAL_V9 =e= sum(i,V9(i));
TOTAL_X_EQUATION9.. TOTAL_X9 =e= sum(i,X9(i));

* price/tax
PRICE_K_EQUATION9(i).. (P_G9)/KPL9(i) =e= P_K9(i);
TAX_K_EQUATION9(i).. (T_G9)/KPL9(i) =e= T_K9(i);

* kilometer
KPL_EQUATION9(i).. 22.257238057 +
(-0.012389854*S9(i)) +
(0.000001828*S9(i)*S9(i)) +
(0.000870924*V9(i)) + 
(-0.000000001*V9(i)*V9(i)) + 
(-0.000000183*S9(i)*V9(i)) =e= KPL9(i);

* emission
EPK_EQUATION9(i).. 146.19866042 +
(-0.02232186*S9(i)) +
(0.00002766*S9(i)*S9(i)) +
(-0.00349283*V9(i)) + 
(0.00000001*V9(i)*V9(i)) + 
(0.00000024*S9(i)*V9(i)) =e= EPK9(i);

EMISSION_EQUATION9(i).. WEIGHT9(i)*EPK9(i)*K9(i) =e= EMISSION9(i);
TOTAL_EMISSION_EQUATION9.. sum(i,EMISSION9(i)) =e= TOTAL_EMISSION9;
MU_EQUATION9.. 0.001925/N9 =e= MU9;

* indirect utility function
INDIRECT_UTILITY_EQUATION9(i).. WEIGHT9(i)*
((((K9(i)**a9(i))*(S9(i)**b9(i))*(V9(i)**c9(i))*(X9(i)**d9(i)))/1)-(MU9*TOTAL_EMISSION9))
+(T9*(T_E9*EMISSION9(i))) =e= U9(i);
* social welfare
SOCIAL_WELFARE_EQUATION9.. sum(i,U9(i)) =e= W9;

* others
SHARE_CONDITION_EQUATION9(i).. a9(i)+b9(i)+c9(i)+d9(i) =e= 1;
GBC_EQUATION9.. sum(i,K9(i)*T_K9(i)) + sum(i,S9(i)*T_S9) + sum(i,V9(i)*T_V9) + sum(i,X9(i)*T_X9)
+ sum(i,EMISSION9(i)*T_E9) =g= 0;

* age
CAR_AGE_EQUATION9(i).. CAR_AGE9(i) =e= log((V9(i)*(12/0.2))/CAR_PRICE9(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION9(i).. GOV_REVENUE9(i) =e= K9(i)*T_K9(i)+ S9(i)*T_S9 + V9(i)*T_V9+ X9(i)*T_X9 + EMISSION9(i)*T_E9;



*********** setup model ***********
model CASE_9_S_V_TAX
/
* income/demand/preference
K_DEMAND_EQUATION9,
G_DEMAND_EQUATION9,
S_DEMAND_EQUATION9,
V_DEMAND_EQUATION9,
X_DEMAND_EQUATION9,
TOTAL_K_EQUATION9,
TOTAL_G_EQUATION9,
TOTAL_S_EQUATION9,
TOTAL_V_EQUATION9,
TOTAL_X_EQUATION9,

* price/tax
PRICE_K_EQUATION9,
TAX_K_EQUATION9,
* kilometer
KPL_EQUATION9,
* emission
EPK_EQUATION9,
EMISSION_EQUATION9,
TOTAL_EMISSION_EQUATION9,
MU_EQUATION9,
* utility function
INDIRECT_UTILITY_EQUATION9,
SOCIAL_WELFARE_EQUATION9,
* others
SHARE_CONDITION_EQUATION9,
GBC_EQUATION9,
* age
CAR_AGE_EQUATION9,
* government revenue
GOV_REVENUE_EQUATION9
/;

solve CASE_9_S_V_TAX using nlp maximizing W9;

display
a9, b9, c9, d9,
K9.l, G9.l, S9.l, V9.l, X9.l,
CAR_AGE9.l,
KPL9.l, EPK9.l,
EMISSION9.l, U9.l,
Y9, CAR_PRICE9
GOV_REVENUE9.l
;


******************** 10. G/S/V tax ********************

*********** paramerter ***********
parameter
* number of household
N10 number of household
WEIGHT10(i) weight of household
/
$ondelim
$include household_weight.csv
$offdelim
/
* income/demand/preference
Y10(i) income for each household
/
$ondelim
$include household_income.csv
$offdelim
/
CAR_PRICE10(i) private car price 
/
$ondelim
$include household_private_vehicle_cost_monthly.csv
$offdelim
/
$offdigit

a10(i) expenditure share for goods K
b10(i) expenditure share for goods S
c10(i) expenditure share for goods V
d10(i) expenditure share for goods X
* price/tax
P_G10 price for goods G /35.77/
P_S10 price for goods S /6.36/
P_V10 price for goods V /1/
P_X10 price for goods X /1/
* T_G10 tax for goods K /0/
* T_S10 tax for goods S /0/
* T_V10 tax for goods V /0/
T_X10 tax for goods X /0/
T_E10 pigouvian tax /0/
* others
T10 expenditure multiplier
;

* number of household
N10 = sum(i,WEIGHT10(i));
* expenditure multiplier
T10 = 0;
* income/demand/preference
a10(i) = a1.l(i);
b10(i) = b1.l(i);
c10(i) = c1.l(i);
d10(i) = d1.l(i);


********** variable **********
variable
* income/demand/preference
K10(i) demand for goods K
G10(i) demand for goods G
S10(i) demand for goods S
V10(i) demand for goods V
X10(i) demand for goods X
TOTAL_K10 total unit of K
TOTAL_G10 total unit of G
TOTAL_S10 total unit of S
TOTAL_V10 total unit of V
TOTAL_X10 total unit of X
* price/tax
P_K10(i) price for goods K
T_K10(i) tax for goods K
T_G10 tax for goods G
T_S10 tax for goods S
T_V10 tax for goods V
* kilometer
KPL10(i) kilometer per lite
* emission
EPK10(i) emission per kilometer
EMISSION10(i) emission per household
TOTAL_EMISSION10 total emission
MU10 effect from 1 unit of emission
* utility
U10(i) indirect utility
W10 social welfare
* age
CAR_AGE10(i) car age
* government revenue
GOV_REVENUE10(i) government revenue
;

*********** lower bound ***********
* income/demand/preference
K10.lo(i) = 1e-6;
S10.lo(i) = 1e-6;
V10.lo(i) = 1e-6;
X10.lo(i) = 1e-6;
* price/tax
T_G10.lo = -35.77;
T_S10.lo = -6.36;
T_V10.lo = -1;
* kilometer
KPL10.lo(i) = 1e-6;
* emission
EPK10.lo(i) = 1e-6;
* utility
U10.lo(i) = 1e-6;


*********** initial value ***********
* income/demand/preference
K10.l(i) = 1;
S10.l(i) = 1;
V10.l(i) = 1;
X10.l(i) = 1;
* price/tax
P_K10.l(i) = 1;
T_K10.l(i) = 1;
T_G10.lo = -50;
T_S10.lo = -50;
T_V10.lo = -50;
* kilometer
KPL10.l(i) = 1;
* emission
EPK10.l(i) = 1;
* utility
U10.l(i) = 1;


*********** equation ***********
equation
* income/demand/preference
K_DEMAND_EQUATION10(i)
G_DEMAND_EQUATION10(i)
S_DEMAND_EQUATION10(i)
V_DEMAND_EQUATION10(i)
X_DEMAND_EQUATION10(i)
TOTAL_K_EQUATION10
TOTAL_G_EQUATION10
TOTAL_S_EQUATION10
TOTAL_V_EQUATION10
TOTAL_X_EQUATION10
* price/tax
PRICE_K_EQUATION10(i)
TAX_K_EQUATION10(i)
* kilometer
KPL_EQUATION10(i)
* emission
EPK_EQUATION10(i)
EMISSION_EQUATION10(i)
TOTAL_EMISSION_EQUATION10
MU_EQUATION10
* utility function
INDIRECT_UTILITY_EQUATION10(i)
SOCIAL_WELFARE_EQUATION10
* others
SHARE_CONDITION_EQUATION10(i)
GBC_EQUATION10
* age
CAR_AGE_EQUATION10(i)
* government revenue
GOV_REVENUE_EQUATION10(i)
;


*********** define equation ***********
* income/demand/preference
K_DEMAND_EQUATION10(i).. (a10(i)*(Y10(i)-(T_E10*EPK10(i)*K10(i))))/(P_K10(i)+T_K10(i)) =e= K10(i);
G_DEMAND_EQUATION10(i).. K10(i)/KPL10(i) =e= G10(i);
S_DEMAND_EQUATION10(i).. (b10(i)*(Y10(i)-(T_E10*EPK10(i)*K10(i))))/(P_S10+T_S10) =e= S10(i);
V_DEMAND_EQUATION10(i).. (c10(i)*(Y10(i)-(T_E10*EPK10(i)*K10(i))))/(P_V10+T_V10) =e= V10(i);
X_DEMAND_EQUATION10(i).. (d10(i)*(Y10(i)-(T_E10*EPK10(i)*K10(i))))/(P_X10+T_X10) =e= X10(i);

TOTAL_K_EQUATION10.. TOTAL_K10 =e= sum(i,K10(i));
TOTAL_G_EQUATION10.. TOTAL_G10 =e= sum(i,G10(i));
TOTAL_S_EQUATION10.. TOTAL_S10 =e= sum(i,S10(i));
TOTAL_V_EQUATION10.. TOTAL_V10 =e= sum(i,V10(i));
TOTAL_X_EQUATION10.. TOTAL_X10 =e= sum(i,X10(i));

* price/tax
PRICE_K_EQUATION10(i).. (P_G10)/KPL10(i) =e= P_K10(i);
TAX_K_EQUATION10(i).. (T_G10)/KPL10(i) =e= T_K10(i);


* kilometer
KPL_EQUATION10(i).. 22.257238057 +
(-0.012389854*S10(i)) +
(0.000001828*S10(i)*S10(i)) +
(0.000870924*V10(i)) + 
(-0.000000001*V10(i)*V10(i)) + 
(-0.000000183*S10(i)*V10(i)) =e= KPL10(i);

* emission
EPK_EQUATION10(i).. 146.19866042 +
(-0.02232186*S10(i)) +
(0.00002766*S10(i)*S10(i)) +
(-0.00349283*V10(i)) + 
(0.00000001*V10(i)*V10(i)) + 
(0.00000024*S10(i)*V10(i)) =e= EPK10(i);

EMISSION_EQUATION10(i).. EPK10(i)*K10(i) =e= EMISSION10(i);
TOTAL_EMISSION_EQUATION10.. sum(i,EMISSION10(i)) =e= TOTAL_EMISSION10;
MU_EQUATION10.. 0.001925/N10 =e= MU10;

* indirect utility function
INDIRECT_UTILITY_EQUATION10(i).. WEIGHT10(i)*
((((K10(i)**a10(i))*(S10(i)**b10(i))*(V10(i)**c10(i))*(X10(i)**d10(i)))/1)-(MU10*TOTAL_EMISSION10))
+(T10*(T_E10*EMISSION10(i))) =e= U10(i);
* social welfare
SOCIAL_WELFARE_EQUATION10.. sum(i,U10(i)) =e= W10;

* others
SHARE_CONDITION_EQUATION10(i).. a10(i)+b10(i)+c10(i)+d10(i) =e= 1;
GBC_EQUATION10.. sum(i,K10(i)*T_K10(i)) + sum(i,S10(i)*T_S10) + sum(i,V10(i)*T_V10) + sum(i,X10(i)*T_X10)
+ sum(i,EMISSION10(i)*T_E10) =g= 0;

* age
CAR_AGE_EQUATION10(i).. CAR_AGE10(i) =e= log((V10(i)*(12/0.2))/CAR_PRICE10(i))/log(0.8);

* government revenue
GOV_REVENUE_EQUATION10(i).. GOV_REVENUE10(i) =e= K10(i)*T_K10(i)+ S10(i)*T_S10 + V10(i)*T_V10+ X10(i)*T_X10 + EMISSION10(i)*T_E10;

*********** setup model ***********
model CASE_10_G_S_V_TAX
/
* income/demand/preference
K_DEMAND_EQUATION10,
G_DEMAND_EQUATION10,
S_DEMAND_EQUATION10,
V_DEMAND_EQUATION10,
X_DEMAND_EQUATION10,
TOTAL_K_EQUATION10,
TOTAL_G_EQUATION10,
TOTAL_S_EQUATION10,
TOTAL_V_EQUATION10,
TOTAL_X_EQUATION10,

* price/tax
PRICE_K_EQUATION10,
TAX_K_EQUATION10,
* kilometer
KPL_EQUATION10,
* emission
EPK_EQUATION10,
EMISSION_EQUATION10,
TOTAL_EMISSION_EQUATION10,
MU_EQUATION10,
* utility function
INDIRECT_UTILITY_EQUATION10,
SOCIAL_WELFARE_EQUATION10,
* others
SHARE_CONDITION_EQUATION10,
GBC_EQUATION10,
* age
CAR_AGE_EQUATION10,
* government revenue
GOV_REVENUE_EQUATION10
/;

solve CASE_10_G_S_V_TAX using nlp maximizing W10;

display
K10.l, G10.l, S10.l, V10.l, X10.l,
a10, b10, c10, d10,
CAR_AGE10.l,
KPL10.l, EPK10.l,
EMISSION10.l, U10.l,
Y10, CAR_PRICE10
GOV_REVENUE10.l
;


display

"FINAL RESULT",


"1. NO TAX",
T_G1, T_S1, T_V1, T_E1,
TOTAL_EMISSION1.l, W1.l

"2. PIGOUVIAN TAX",
T_G2, T_S2, T_V2, T_E2,
TOTAL_EMISSION2.l, W2.l

"3. PIGOUVIAN TAX REINVEST",
T_G3, T_S3, T_V3, T_E3,
TOTAL_EMISSION3.l, W3.l

"4. G TAX",
T_G4.l, T_S4, T_V4, T_E4,
TOTAL_EMISSION4.l, W4.l

"5. S TAX",
T_G5, T_S5.l, T_V5, T_E5,
TOTAL_EMISSION5.l, W5.l

"6. V TAX",
T_G6, T_S6, T_V6.l, T_E6,
TOTAL_EMISSION6.l, W6.l

"7. G/S TAX",
T_G7.l, T_S7.l, T_V7, T_E7,
TOTAL_EMISSION7.l, W7.l

"8. G/V TAX",
T_G8.l, T_S8, T_V8.l, T_E8,
TOTAL_EMISSION8.l, W8.l

"9. S/V TAX",
T_G9, T_S9.l, T_V9.l, T_E9,
TOTAL_EMISSION9.l, W9.l

"10. G/S/V TAX",
T_G10.l, T_S10.l, T_V10.l, T_E10,
TOTAL_EMISSION10.l, W10.l


display
CAR_AGE1.l,
CAR_AGE2.l,
CAR_AGE3.l,
CAR_AGE4.l,
CAR_AGE5.l,
CAR_AGE6.l,
CAR_AGE7.l,
CAR_AGE8.l,
CAR_AGE9.l,
CAR_AGE10.l



$ontext
$offtext