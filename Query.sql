-- câu 1:  Lấy danh sách các yêu cầu dịch vụ với chi phí lớn hơn 4000000
SELECT Request_ID, Service_Type, Service_Charges
FROM SERVICE_REQUEST
WHERE Service_Charges > 4000000
-- câu 2:  Tìm hợp đồng có trạng thái là 'Completed'
SELECT Contract_ID, Contract_Date, Total_Value
FROM CONTRACT WHERE Status = 'Completed';
-- Câu 3 : Hiển thị ngày vào làm của nhân viên theo dạng ngày tháng năm 
SELECT Employee_ID,
       CONVERT(VARCHAR, Hired_Date, 105) AS Hired_Date_Formatted
FROM EMPLOYEE;
-- Câu 4 : Hiển thị trạng thái hợp đồng và tình trang thanh toán
SELECT Contract_ID, Total_Value, Status,
    CASE
        WHEN Status = 'Pending' AND Total_Value < 10000 THEN 'Not Paid'
        WHEN Status = 'Pending' AND Total_Value >= 10000 THEN 'Partially Paid'
        WHEN Status = 'Completed' THEN 'Fully Paid'
    END AS Payment_Status
FROM CONTRACT;
-- Câu 5 : Đếm số lượng khách hàng theo loại dịch vụ yêu cầu
SELECT Service_Type, COUNT(Customer_ID) AS NumberOfCustomers 
FROM SERVICE_REQUEST 
GROUP BY Service_Type;
-- Câu 6: Tính tổng giá trị hợp đồng của từng khách hàng, hiển thị từ cao xuống thấp
SELECT C.Customer_Name, SUM(CON.Total_Value) AS Total_Contract_Value
FROM CONTRACT CON
JOIN SERVICE_REQUEST SR ON CON.Request_ID = SR.Request_ID
JOIN CUSTOMER C ON SR.Customer_ID = C.Customer_ID
GROUP BY C.Customer_Name
ORDER BY Total_Contract_Value DESC
-- Câu 7: Hiển thị thông tin kiểm tra hàng hóa cùng với tên nhân viên thực hiện
SELECT GI.Inspection_ID, GI.Inspection_Type, GI.Schedule_Date, E.Employee_Name AS Inspector
FROM GOODS_INSPECTION GI
JOIN EMPLOYEE E ON GI.Employee_ID = E.Employee_ID;
-- câu 8 : Liệt kê các hợp đồng với giá trị trên trung bình
SELECT Contract_ID, Total_Value
FROM CONTRACT
WHERE Total_Value > (SELECT AVG(Total_Value) FROM CONTRACT);
-- câu 9 : Xem chi tiết hàng hóa trong từng khai báo của khách hàng
SELECT CD.Declaration_ID, GD.Detail_ID, G.Goods_Name, GD.Quantity, GD.Total_Value
FROM CUSTOMER_DECLARATION CD
JOIN GOODS_DETAIL GD ON CD.Declaration_ID = GD.Declaration_ID
JOIN GOODS G ON GD.Goods_ID = G.Goods_ID;
-- câu 10: Tính tổng số lượng và tổng giá trị hàng hóa theo từng loại kiểm tra
SELECT GI.Inspection_Type, SUM(GD.Quantity) AS Total_Quantity, SUM(GD.Total_Value) AS Total_Value
FROM GOODS_INSPECTION GI
JOIN CUSTOMER_DECLARATION CD ON GI.Declaration_ID = CD.Declaration_ID
JOIN GOODS_DETAIL GD ON CD.Declaration_ID = GD.Declaration_ID
GROUP BY GI.Inspection_Type;


