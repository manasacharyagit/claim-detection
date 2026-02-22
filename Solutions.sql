create database claimdata;
use claimdata;
select * from details;

#So let's solve some problems here 

# 1. Which insurance companies are the slowest or have the most "No Response" cases?

select client, count(status) as cases_not_responded from details group by client, status
having status = "No response";

# 2.  Which specific "Status Codes" are causing the highest Balance (uncollected money) across the whole hospital?

select `Status Code`, sum(`Balance Amount`) from details
group by `Status Code` order by sum(`Balance Amount`) desc;

# 3. Which Team Allocation (Coding, Billing, or Payment) is sitting on the highest number of "Claim Errors"?

select `Assigned To`, count(`Status Code`) from details
group by `Assigned To`, `Status Code` having `Status Code` = "Claim Error" order by count(`Status Code`);

# 4 Find all claims where Aging Days is greater than 365. Many insurance companies won't pay after one year.

select * from details where `aging days` >=365;

# 5 Which insurance companies are actually paying? Group by Primary Insurance and calculate the average Paid Amount vs. the average Claim Amount.

select Client, `Primary/Secondary`, avg(`Billed Amount` - `Balance Amount`) as avg_paid_amount, avg(`Billed Amount`) as avg_claim_ammount from details
group by Client, `Primary/Secondary` having `Primary/Secondary` = "Primary" order by avg_paid_amount;

# 6 Where is the most money being held up? List the top 10 Visit IDs with a Status of 'Denied', sorted by the highest Balance.

select `VisitID#`, Status, sum(`Billed Amount`) as claimed_amount from details where Status = "Denied"
group by `VisitID#` order by `VisitID#` limit 10;

# 7 Which department is the slowest?

select `Assigned To`, avg(`Aging Days`) from details
group by `Assigned To` order by avg(`Aging Days`)  desc;

# 8 Why are we losing money? Count the occurrences of each Status Code to see the most frequent reason for non-payment.

select `Status Code`, count(`Status Code`) as occurance from details
group by `Status Code` order by count(`Status Code`) desc;

# 9 What is the most common "next step" being taken? Find the top 3 most used Action Code values to see how the team is responding to these old claims.

select `Action Code` as `Top 3 actions` from details group by `Action Code`  order by `Action Code` desc limit 3;

# 10 Which claims were underpaid? Find claims where the Status is 'Paid' but the Paid Amount is less than the Claim Amount.

select client, `VisitID#`, `Patient Name` from details where Status = "Paid" and `Billed Amount`-`Balance Amount` < `Billed Amount`;

# 11 Which medical facility (Client) has the highest outstanding debt? Group by Client and sum the total Balance to see who owes the most.

select client, round(sum(`Balance Amount`),2) as `Balance Amount` from details
group by client order by `Balance Amount` desc;

