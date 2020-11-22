# ironhackmidcourseproject
Repo for submitting the mid-course project creating a predict model for a classification question
# 1213bst Will You Choose Cash or Trade? 
1213bst is an online second-hand retailer who buys all of its product directly from consumers. <br> We offer consumers two payment options: <ul>
<li>We offer to pay you 1/3 of our retail price in cash</li>
<li>Or you can choose to get 1/2 of our price in trade credit</li>
</ul>
To learn more about the business, you can go to our website: <a>https://1213bst.com</a><br><br>
The trade credit option is a very important one to us as a business.  It reflects our desire to promote reuse, recycling, and a circular economy.  But it also promotes our growth by allowing us to obtain product for the future promise of other goods.  The more customers who choose trade, the more we can grow. <br><br>
Therefore, it is very important to us to see whether or not we can predict who is likely to choose trade and which factors influence a customer's decision whether or not to choose the trade credit when they sell us their items. <br>
My goal was to build a model that could realistically predict, with the highest probability possible, whether or not any given buy that was submitted would likely result in the selection of trade credit as the payment method. <br><br>
## The Documents<br>
The following documents are submitted as part of this project:<ul>
  <li><b>ERD - 1213bst Classification Analysis - Trade_ Yes or No.pdf</b>: This is an entity relationship diagram I created of the tables that were relevant for my inquiry.</li>
  <li><b>caitlin classification SQL.docx</b>: This was created by Sian for me to run psql queries on my database.</li>
  <li><b>sql-queries-made-by-Sian.sql</b>: These are the answer to the queries prepared for me by Sian.</li>
  <li><b>pandas-queries.sql</b>: These were the initial 3 psql queries written to import my data into Python. Due to my inability to connect properly to my Postgres database, I ran these queries in our Postgresql client and exported CSV files of the resulting tables to then import into Python. </li>
  <li><b>pandas-queries-4-5.sql</b>: These are two additional psql queries I ran for additional features I decided I wanted to have.</li>
  <li><b>superset-query1.csv</b>: Then I am attaching the 5 CSV files that I uploaded into my Jupyter Notebook in order to run my models.</li>
  <li><b>superset-query2.csv</b></li>
  <li><b>superset-query3.csv</b></li>
  <li><b>superset-query4.csv</b></li>
  <li><b>superset-query5.csv</b></li>
  <li><b>mid-course project csv files.ipynb</b>: This is my Jupyter Notebook where the meat of my work took place.  It also contains most thorough narrative of my process.</li>
  <li><b>mid-course project.twbx</b>: Here is my Tableau workbook containing a dashboard and some visualizations of my data.  Because Tableau Desktop 2020.03 does not have the correct drivers for Postgres 12.0, I was unable to work directly from our database and had to rely on the CSV files I created instead.  
