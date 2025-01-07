-- 연습 문제
-- 1. orders에서 order_date가 2015년 10월 건과 2015년 12월 건을 select로 각각 추출하고,
-- 두 결과 집합을 UNION ALL을 사용해 하나로 결합하세요(단, 최종 결과는 최신순으로 정렬)

(select * from orders where substr(order_date, 1, 7) = "2015-10")
union all 
(select * from orders where substr(order_date, 1, 7) = "2015-12")
order by order_date desc;
-- 2번 쿼리
(select * from orders where order_date >= "2015-10-01" and order_date < "2015-11-01")
union all 
(select * from orders
	where order_date >= "2015-12-01" and order_date < "2016-01-01")
	order by order_date desc;

-- SQL상에서의 문자열 비교 방식
-- 문자열을 왼쪽에서 오른쪽으로 한 문자씩 비교
-- ASCII / 유니코드 값을 기준으로 비교합니다.
-- 왼쪽부터 읽어오다가 다른 문자가 발견되는 순간에 그 값에 따라 크고 작음을 판별합니다.

-- "2015-10-01" vs "2015-11-01"의 경우
-- "2" == "2" / "0" == "0" / "1" == "1" / "5" == "5" / "-" == "-" / "1" == "1"까지 동일합니다.
-- 그 다음 순간에 "0" != "1"이 다른 시점에 들어갔을 때 크기 비교가 이루어집니다.

-- YYY-MM-DD 형식으로 지정돼있다면, 문자열 비교 결과와 실제 날짜 비교
 
-- 2. users에서 USA에 거주 중이면서 마케팅 수신에 동의(1)한 회원 정보와 France에 거주 중이면서
-- 마케팅 수신에 동의하지 않은(0) 회원 정보를 SELECT로 각각 추출하고, 두 결과 집합을 UNION  ALL을
-- 사용해 하나로 결합하라(단, 최종 결과는 id, phone, country, city, is_marketing_agree
-- 컬럼 추출하고, 거주 국가 기준으로 알파벳 역순으로 추출하세요.)

(select id, phone, country, city, is_marketing_agree 
	from users 
	where is_marketing_agree = 1 
	and country = "USA")
union all
(select id, phone, country, city, is_marketing_agree 
	from users 
	where is_marketing_agree = 1 
	and country = "France")
order by country desc;
	
-- 3. 이건 풀지마세요. 문제만 적어놓고 같이 풀겠습니다.
--		UNION을 활요하여 orderdetails와 product를 full outer join 조건으로 결합하여 출력
--		하세요. -> 굳이 이런 형식으로 시험 문제 및 실무에까지 이용하는 경우는 거의 없습니다.
(select * from orderdetails o left join products p on o.product_id = p.id)
union
(select * from orderdetails o right join products p on o.product_id = p.id)
;

-- 서브쿼리
-- SQL 쿼리 결과를 테이블처럼 사용하는, 쿼리 속의 쿼리
-- 서브 쿼리는  작성한 쿼리를 소괄호로 감싸서 사용하는데, 실제로 테이블은 아니지만
-- 테이블처럼 사용이 가능합니다.

-- product에서 name(제품명)과 price(정상가격)을 모두 불러오고, '평균 정상 가격을
-- 새로운 컬럼'으로 각 행마다 출력해보세요.

select name, price, (select AVG(price) from products) from products
-- SELECT AVG(price) FROM products;를 하는 경우 전체 price / 행의 개수로 나눈 데이터가
-- 단 하나이므로 SELECT name, price, AVG(price) FROM products; 로 작성하면
-- 1행짜리만 도출됨. 

-- products 테이블의 name / price를 불러오는 것은 기본적인 select절입니다.
-- 그런데 select 절에는 단일값을 반환하는  서브 쿼리가 올 수 있습니다.

-- 스칼라(Scalar) 서브 쿼리 : 쿼리의 결과가 단일 값을 반환하는 서브 쿼리

select name, price, 38.5455 as avgPrc from products;

-- 특정한 단일 결과값을 각 행에 적용을 하고 시ㅍ다면 이상과 같은 하드코딩이 가능합니다.
-- 하짐나 정확한 값을 얻기 위해서 사전에 쿼리문으로
-- SELECT AVG(price) FROM products; 가 요구된다는 점에서 효율적이지는 않고,
-- 실무 상황에서 실제로 전체 쿼리문을 실행시킨 이후에 확인해야 해서
-- 서브 쿼리를 작성하는 편이 퀀장됩니다.

-- 스칼라 서브 퀄리를 작성할 때 '단일 값'이 반환되도록 작성해야 한다는 점에 유의하세요.
-- 만약 2개 이상의 집계 값을 기존 테이블에 추가하여 출력하고 싶다면 스칼라 서브 쿼리를 따로
-- 나누어서 작성해야 합니다.

-- users에서 city별 화원 수를 카운트하고, 회원 수가 3명 이상인 도시 명과 회원 수를 출력해보자.
-- (단, 회원 수를 기준으로 내림차순)

select city, count(distinct id) from users group by city; -- > 도시 별로
														  -- id 개수를 계산했습니다.
-- 1번 쿼리
select city, count(distinct id)
	from users
	group by city 
	having count(distinct id) >= 3
	order by count(distinct id) desc;

-- 2번 쿼리
select *
	from
	(
		select city, count(distinct id) as cntUser
		from users u
		group by city
	) a
	where cntUser >= 3
	order by cntUser desc;
-- 1번 쿼리는 제가 서브쿼리 없이 작성한 예시
-- 2번 쿼리가 서브 쿼리 포함된 해설인데요 -> 해당 문제에서 눈여겨 볼 것은 굳이 따지자면
-- 여기서는 서브쿼리를 작성하는데 있어서 스칼라 서브 쿼리 형태로 작성하는 것이 중요하다.
-- 해당 문제에서는 검증 결과 서브 쿼리 자체가 필요하지는 않습니다.
-- a 이 부분도 비표준 SQL이라서 일단을 적어만 두겠습니다.		(2번 쿼리부터 지운걸로 침)

-- orders와 staff를 활용해 last_name 이 Kyle이나 Scott인 직원의 담당 주문을 출력하려면?
-- (단, 서브쿼리 형태를 활용하자)

select id
	from staff
	where last_name in ("Kyle", "Scott");						-- 조건절에 쓰일 경우에
														-- scalar 서브가 아니었다는 점에 주목

-- 이상의 코드는 staff 테이블에서 id 값이 3, 5를 도출해냈습니다.
-- 해당 결과를 가지고 orders 테이블에 적용하는 형태로 작성합니다.

select *
	from orders
	where staff_id in (
		select id
			from staff
			where last_name in ("Kyle", "Scott")
	)
	order by staff_id
	;


-- WHERE 절 내에서 필터링 조건 지정을 위해 중첩된 서브 쿼리를 작ㄱ성 가능
-- WHERE 에서 IN 연산자와 함께 서브 쿼리를 활용할 경우 :
--  컬럼 개수와 필터링 적용 대상 컬럼의 개수가 '일치'해야만 합니다.

-- 이상의 코드에서 서브쿼리의 결과 도출되는 컬럼의 숫자 = 1 (staff테이블의 id) / 행 = 2

select *
	from orders
	where (staff_id, user_id) in (		-- 필터링 대상 컬럼 개수 = 2
		select id, user_id				-- 서브쿼리 컬럼 개수 = 2
			from staff
			where last_name in ("Kyle", "Scott")
	)
	order by staff_id
	;

-- 결과값으로 직원 정보 테이블에 존재하는 id, user_id와 동일한 값이 orders 테이블의
-- staff_id, user_id 컬럼에 있을 경우 반환하여 출력합니다.
-- 이상의 쿼리문의 해석 -> 직원이 자기 쇼핑몰에서 주문란 이력이 반환된 것.\

-- products에서 discount_price가 가장 비싼 제품 정보를 출력하세요.
-- (단, products의 전체 컬럼이 다 출력되어야 합니다)

select max(discount_price) from products;

select *
	from products
	where discount_price in (
		select max(discount_price)
			from products
	);


-- orders에서 주문 월(order_date 컬럼 활용)이 2015년 7월인 주문 정보를,
-- 주문 상세 정보 테이블 orderdetails에서 quantity가 50 이상인 정보를 각각 서브쿼리로 작성하고,
-- INNER JOIN하여 출력해봅시다.

select *
	from orders
	where order_date >= "2015-07-01"
		and order_date < "2015-08-01";


-- 2)
select *
	from orderdetails
		where quantity >= 50;

-- 1)과 2)의 INNER JOIN 구문 -> from절에서 이루어집니다.

select *
	from (select *
			from orders
			where order_date >= "2015-07-01"
				and order_date < "2015-08-01") o -- 1)의 결과가 테이블이었기 때문에 별칭 o를
		inner join
		(select *
			from orderdetails
			where quantity >= 50) od
		on o.id = od.order_id
		;

-- 서브 쿼리를 작성하기 위한 반안 중에 하나는 서브 쿼리에 들어가게 될 쿼리문을 작성한 결과값을 확인.
-- 이후 해당 쿼리가 scalar냐 아니냐에 따라서 그 위치 역시 어느 정도 통제 가능
-- ex) scalar인 경우에는 select절에 들어가는 것처럼
-- 이상의 경우에는 결과값이 테이블 형태로 나왔기 때문에 이를 기준으로 INNER JOIN했습니다.

-- 서브 쿼리 정리하기
-- 쿼리 결과값을 메인 쿼리에서 값이나 조건으로 사용하고 싶을 때 사용

-- SELECT / FROM / WHERE 등 사용 위치에 따라 불리는 이름이 다르다.

-- 정리 1. SELECT 절에서의 사용
-- 형태
-- SELECT ..., ([서브쿼리]) AS [컬럼명]
-- ...이하 생략

-- SELECT에서는 '단일 집계 값'을 신규 컬럼으로 추가하기 위해 서브 쿼리를 사용.
-- 여러 개의 컬럼을 추가하고 싶을 때는 서브 쿼리를 여러개 작석하면 된다.

-- 정리 3. WHERE에서의 사용

-- 형태 :
-- ...
-- WHERE [컬럼명] [조건 연산자] ([서브 쿼리])
-- ...

-- WHERE에서 필터링을 위한 조건 값을 설정하는데 서브 쿼리 사용 가능.
-- 위의 예시에서는 IN 연산자를 사용했지만 다른 비교 연산자도 사용 가능.

-- 특징 : IN 연산자의 경우에 다중 컬럼 1비교를 할 때는 서브 쿼리에서 추출하는 컬럼의 개수와
-- WHERE에 작성하는 필터링 대상 컬럼 개수가 일치 해야 함. -> 이때 필터링 대상 컬럼이 2 개 이상이면
-- ()로 묶어서 작성해야 합니다.

-- 1. 데이터 그룹화하기(GROUP BY + 집계함수)
-- 2. 데이터 결과 집합


-- 1. users에서 created_at 컬럼 활용하여 연도별 가입 회원 수를 추출

select *
from users;


select substr(created_at, 1, 4), count(distinct id)
	from users
	where created_at is not null
	group by substr(created_at, 1, 4);

-- 2. users에서 country, city, is_auth 컬럼을 활용, 국가별, 도시별로 본인 인증한 회원 수를
-- 추출하라.

select country, city, SUM(is_auth)	-- is_auth가 1이면 본인 인증한거니까 is_auth들의 합이
									-- 본인인증한 회원 숫자가 10이라는 뜻이라서
	from users		
	group by country, city
	order by SUM(is_auth);



	


 

