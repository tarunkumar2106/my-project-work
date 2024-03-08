import database as db     

customer=input("""which class would you have to like travel 
               1. 1st
               2. 2nd
               3. 3rd
               """)
start_point=input("enter your boarding location:")
end_point=input("enter your destination:")
if start_point=="delhi"and "gurugram" and "kanpur":
    print("pay fee")
elif end_point=="chandigarh"and"goa"and"manasar":
    print("pay fee")
else:
    print("no route for this destination")

amount=eval(input("ticket fee:"))
amount_1st_class=800
amount_1st_classg=5000
amount_2nd_class=2500.43
amount_3rd_class=1500.43

if customer=="1"and amount_1st_class<=amount:
    returing_amount=amount-amount_1st_class
    db.plane.execute(f"insert into ticket_chart(class,amount) values('1st',{amount_1st_class})")
    print("kindly collect your cash",returing_amount)
    print("ticket confrimed")
elif customer=="1"and amount_1st_classg<=amount:
    returing_amountg=amount-amount_1st_classg
    db.plane.execute(f"insert into ticket_booking(class,amount) values('1st',{amount_1st_classg})")
    print("kindly collect your cash",returing_amountg)
    print("ticket confrimed")
elif customer=="2"and amount_2nd_class<=amount:
    returing_amount=amount-amount_2nd_class
    db.plane.execute(f"insert into ticket_booking(class,amount) values('2nd',{amount_2nd_class})")
    print("kindly collect your cash",returing_amount)
    print("ticket confrimed")
elif customer=="3"and amount_3rd_class<=amount:
    returing_amount=amount-amount_3rd_class
    db.plane.execute(f"insert into ticket_booking(class,amount) values('3rd',{amount_3rd_class})")
    print("kindly collect your cash",returing_amount)
    print("ticket confrimed")

else: 
    print("booking not confrim, kindly try again")
db.tkpk.commit()