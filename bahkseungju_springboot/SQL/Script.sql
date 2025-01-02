select * from users;

select *
	from users
	where country not like "S%"
	;

-- IS : A IS B -> A는 B다라는 뜻이기 때문에
-- A 커럼의 값이 B 이다 일 때 특히 null 일 때 '=' 대신 사용합니다.
-- 예제 : users에서 created.at 컬럼의 값이 null인 결과 출력
select *
	from users
	where created_at is null;

select *
	from users
	where created_at is not null;	-- 참고
	
-- 연습 문제
	-- 1. users에서 contry가 Mexico인 회원 정보 추출.
		-- 단 created_at, phone, city, country 컬럼만 추출할 것
	select create_at, phone, city, country
		from users
		where country = "Mexico";
	-- 2. products에서 id가 20 이하이고 price는 30 이상인 제품 정보 출력
		-- 단 기존 컬럼 전부 출력하고, 정상 가격에서 얼마나 할인 되었는지를
		-- (price - discount_price)
		-- discount_amount라는 컬럼명으로 추출할 것.
select *,				-- '전부 다'의 기준은 기존 컬럼 
	(price - discount_price) as "discount_amount"	-- 새로운 컬럼
	from products
	where id <= 20 and price >= 30
	
	-- 3. users에서 country가 korea, Canada, Belgium도 아닌 회원의
		-- 정보를 모두 추출할 것.
		-- 단, OR 연산자를 사용하지 않고 출력할 것.
	select *
		from users
		where country not in ("Korea", "Canada", "Belgium")
		;
	
	select *
		from users
		where country != "Korea" and country != "Canada" and country 
		;
	
	
	-- 4. products에서 name이 N으로 시작하는 제품 정보를 전부 출력할 것.
		-- 단, id, name, price컬럼만 출력할 것
	select id, name, price
		from products
		where name like "N%"
		;
	-- 5. orders에서 order_data가 2015-07-01부터 2015-101-31까지가
		-- 아닌 부분만 출력할 것
	

-- ORDER BY
-- 현재까지 WHERE을 이용해서 특정한 조건에 합치하는 데이터들을 조회하는 SQL문에 대해서
-- 학습했습니다.
	
-- 이상의 경우 저장된 순서대로 정렬된 결과만 볼 수 있습니다 -> id라는 PK값에 따라

-- 이번에는 가져온 데이터를 원하는 순서대로 정렬하는 방법에 관한 것입니다.
	
-- 예제 : users에서 id를 기준으로 오름차순 정렬 후 출ㄹ력
	select *
		from users
		order by id asc;	-- asc : Ascending의 축약어로 '오름차순'
		
-- 예제 : user에서 id를 기준으로 내림차순 정렬 후 출력
		select *
			from users
			order by id desc;		-- desc : Decending의 축약어로 '내림차순'

-- 이상에서 볼 수 있듯이 ORDER BY는 컬럼을 기준으로 행 데이터를 ASC 혹은 DESC로
-- 정렬할 때 사용 : 숫자의 경우는 쉽게 알 수 있지만, 문자의 경우는
-- 아스키 코드(ASCII Code)를 기준으로 합니다.
			
select *
	from users
	order by city desc 
	;


select *
	from users
	order by created_at asc 
	;

select *
	from users
	order by 1 asc
	;

-- oder by의 특징 : 컬럼명 대신에 컬럼 순서를 기준으로 하여 정렬이 가능.
	-- 컬럼명을 몰라도 정렬할 수 있다는 장점이 있지만 주의할 필요가 있음

-- 예제 : users에서 username, phone, city, country, id 컬럼을 순서대로 추력
-- 하는데, 첫 번째 컬럼 기준으로 오름차순 정렬 해보세요
select username, phone, city, country, id
	from users
	order by 1 asc 
	;
-- 아까와 같이 ORDER BY 1 ASC로 했지만 정렬이 id가 아닌 username을 기준으로
-- ASCII Code가 적용되어 정렬 방식이 달라졌음을 확인 가능.
-- 즉, ORDER BY는 데이터 추출이 끝난 후를 기점으로 적용이 된다는 점을 명심해야 합니다.

-- 예제 : USERS에서 CITY, ID 컬럼만 출력하는데, city 기준 내림 차순
--	 id 기준 오름차순으로 정렬
select city, id
	from users
	order by city desc, id asc
	;

-- 컬럼별로 다양하게 오름차순 혹은 내림차순 적용이 가능

-- ORDER BY 정리
-- 1. 데이터를 가져올 때 지정된 컬럼을 기준으로 정렬함.
-- 2. 형식 : ORDER BY '컬럼명' ASC/DESC
-- 3. 2개 이;상의 정렬 기준을 쉼표(,)를 기준으로 합쳐서 지정 가능
	-- 이상의 경우 먼저 지정된 칼럼이 우선하여 정렬됨.
-- 4. 2 개 이상의 정렬 기준을 지정할 때 각각 지정 가능.
	-- 이상의 경우 각 컬럼 당 명시적으로 ASC 혹은 DESC를 지정 해줘야 함.
	-- 하지만 지정하지 않을 경우 default로 ASC 적용

-- 연습 문제
-- 1. products에서 price가 비싼 제품부터 순서대로 모든 컬럼 출력
select *
	from products
	order by price desc
	;
-- 2. orders에서 order_date 기준 최신순으로 모든 컬럼 출력
select *
	from orders
	order by order_date desc 
	;
-- 3. orderdetails에서 product_id를 기준 네림차순, 같은 제품 아이디 내에서는
-- quantity 기준 오름차순으로 모든 컬럼 출력
select *
	from orderdetails
	order by product_id desc, quantity
	;

-- 야태까지 배운 것을 기준으로 실무에서는 어떤 방식으로 데이터 추출해서 사용하는지 예시
-- 실무에서는 select, where, order by를 사용해 다양한 데이터를 추출하는데,

-- 1. 배달 서비스 예시
	-- 1) 2023-08-01에 주문한 내역 중 쿠폰 할인이 적용된 내역 추출
select *
	from 주문정보
	where 주문일자 = '2023-08-01'
		and 쿠폰할인금액 > 0
	;
	-- 2) 마포구에서 1인분 배달이 가능한 음식점 추출