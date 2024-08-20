Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A22A1CAB8;
	Tue, 20 Aug 2024 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724179632; cv=none; b=ZbnCN6Ga6C+XKSFRkaWkVwU6TToRS2QqJkNzELp4WEYLKYR6niu9ZaA5ULmNA4EpAvpsswpr4sPxhCQeylFxkdotBsQ4yzuuIV1S6Q8SFX3OTbu6udjS6vEIyH5Xish42jp7qpMhT17iIkU68xtQxql8XA1lO6XoJvchNkT1Zvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724179632; c=relaxed/simple;
	bh=MI+6+AbYWVXAmOCQRTxhN1stH6g3sRSpWQLKOnWqCXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F/7xrYfWLQeQ6cX/GDsTUOJIH11aCytOyKn+4YwIluwtUsrvSW8uDFfgN09nPtf94v6NUfJPOgJQP5wyto6nMmSGdBq/Y+4FKaigh3j3wCOvCumPDPwsQDVMkOlKzd2WIeDxEupbMvWYYqVXi+RcMreHZPXCVFwRVJEsed6soJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WpJNQ6MF8z1S8DL;
	Wed, 21 Aug 2024 02:47:02 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id E56991A0188;
	Wed, 21 Aug 2024 02:47:04 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 21 Aug 2024 02:47:00 +0800
Message-ID: <22dcebae-dc5d-0bf1-c686-d2f444558106@huawei-partners.com>
Date: Tue, 20 Aug 2024 21:46:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/9] selftests/landlock: Test listening restriction
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-5-ivanov.mikhail1@huawei-partners.com>
 <ZsSMe1Ce4OiysGRu@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZsSMe1Ce4OiysGRu@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 3:31 PM, Günther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:46AM +0800, Mikhail Ivanov wrote:
>> Add a test for listening restriction. It's similar to protocol.bind and
>> protocol.connect tests.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 44 +++++++++++++++++++++
>>   1 file changed, 44 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index 8126f5c0160f..b6fe9bde205f 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -689,6 +689,50 @@ TEST_F(protocol, connect)
>>   				    restricted, restricted);
>>   }
>>   
>> +TEST_F(protocol, listen)
>> +{
>> +	if (variant->sandbox == TCP_SANDBOX) {
>> +		const struct landlock_ruleset_attr ruleset_attr = {
>> +			.handled_access_net = ACCESS_ALL,
>> +		};
>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>> +			.allowed_access = ACCESS_ALL,
>> +			.port = self->srv0.port,
>> +		};
>> +		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
>> +			.allowed_access = ACCESS_ALL &
>> +					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
>> +			.port = self->srv1.port,
>> +		};
>> +		int ruleset_fd;
>> +
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
> 
> Nit: The declaration and the assignment of ruleset_fd can be merged into one
> line and made const.  (Not a big deal, but it was done a bit more consistently
> in the rest of the code, I think.)

Current variant is performed in every TEST_F() method. I assume that
this is required in order to not make a mess by combining the
ruleset_attr and several rule structures with the operation of creating
ruleset. WDYT?

> 
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Allows all actions for the first port. */
>> +		ASSERT_EQ(0,
>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +					    &tcp_not_restricted_p0, 0));
>> +
>> +		/* Allows all actions despite listen. */
>> +		ASSERT_EQ(0,
>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +					    &tcp_denied_listen_p1, 0));
>> +
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
> 
> This entire "if (variant->sandbox == TCP_SANDBOX)" conditional does the exact
> same thing as the one from patch 5/9.  Should that (or parts of it) get
> extracted into a suitable helper?

I don't think replacing
	if (variant->sandbox == TCP_SANDBOX)
with
	if (is_tcp_sandbox(variant))
will change anything, this condition is already quite simple. If
you think that such helper is more convenient, I can add it.

> 
>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>> +
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>> +				    false);
>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
>> +				    restricted);
>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>> +				    restricted, restricted);
> 
> If we start having logic and conditionals in the test implementation (in this
> case, in test_restricted_test_fixture()), this might be a sign that that test
> implementation should maybe be split apart?  Once the test is as complicated as
> the code under test, it does not simplify our confidence in the code much any
> more?
> 
> (It is often considered bad practice to put conditionals in tests, e.g. in
> https://testing.googleblog.com/2014/07/testing-on-toilet-dont-put-logic-in.html)
> 
> Do you think we have a way to simplify that?

I agree.. using 3 external booleans to control behavior of the
test is really messy. I believe the best we can do to avoid this is to
split "test_restricted_net_fixture()" into few independent tests. For
example we can turn this call:

	test_restricted_net_fixture(_metadata, &self->srv0, false,
		false, false);

into multiple smaller tests:

	/* Tries to bind with invalid and minimal addrlen. */
	EXPECT_EQ(0, TEST_BIND(&self->srv0));

	/* Tries to connect with invalid and minimal addrlen. */
	EXPECT_EQ(0, TEST_CONNECT(&self->srv0));

	/* Tries to listen. */
	EXPECT_EQ(0, TEST_LISTEN(&self->srv0));

	/* Connection tests. */
	EXPECT_EQ(0, TEST_CLIENT_SERVER(&self->srv0));

Each test is wrapped in a macro that implicitly passes _metadata argument.

This case in which every access is allowed can be wrapped in a macro:

	TEST_UNRESTRICTED_NET_FIXTURE(&self->srv0);

Such approach has following cons though:
* A lot of duplicated code. These small helpers should be added to every
   test that uses "test_restricted_net_fixture()". Currently there
   are 16 calls of this helper.

* There is wouldn't be a single entity that is used to test a network
   under different sandbox scenarios. If we split the helper each test
   should care about (1) sandboxing, (2) running all required tests. For
   example TEST_LISTEN() and TEST_CLIENT_SERVER() could not be called if
   bind is restricted.

For example protocol.bind test would have following lines after
"test_restricted_net_fixture()" is removed:

	TEST_UNRESTRICTED_NET_FIXTURE(&self->srv0);

	if (is_restricted(&variant->prot, variant->sandbox)) {
		EXPECT_EQ(-EACCES, TEST_BIND(&self->srv1));
		EXPECT_EQ(0, TEST_CONNECT(&self->srv1));

		EXPECT_EQ(-EACCES, TEST_BIND(&self->srv2));
		EXPECT_EQ(-EACCES, TEST_CONNECT(&self->srv2));
	} else {
		TEST_UNRESTRICTED_NET_FIXTURE(&self->srv1);
		TEST_UNRESTRICTED_NET_FIXTURE(&self->srv2);
	}

I suggest leaving "test_restricted_net_fixture()" and refactor this
booleans (in the way you suggested) in order not to lose simplicity in
the testing:

	bool restricted = is_restricted(&variant->prot,
		variant->sandbox);

	test_restricted_net_fixture(_metadata, &self->srv0,
		(struct expected_net_enforcement){
		.deny_bind = false,
		.deny_connect = false,
		.deny_listen = false
	});
	test_restricted_net_fixture(_metadata, &self->srv1,
		(struct expected_net_enforcement){
		.deny_bind = false,
		.deny_connect = restricted,
		.deny_listen = false
	});
	test_restricted_net_fixture(_metadata, &self->srv2,
		(struct expected_net_enforcement){
		.deny_bind = restricted,
		.deny_connect = restricted,
		.deny_listen = restricted
	});

But it's really not obvious design issue and splitting helper can really
be a better solution. WDYT?

> 
> 
> Readability remark: I am not that strongly invested in this idea, but in the
> call to test_restricted_net_fixture(), it is difficult to understand "false,
> false, false", without jumping around in the file.  Should we try to make this
> more explicit?
> 
> I wonder whether we should just pass a struct, so that everything at least has a
> name?
> 
>    test_restricted_net_fixture((struct expected_net_enforcement){
>      .deny_bind = false,
>      .deny_connect = false,
>      .deny_listen = false,
>    });
> 
> Then it would be clearer which boolean is which,
> and you could use the fact that unspecified struct fields are zero-initialized?
> 
> (Alternatively, you could also spell out error codes here, instead of booleans.)

Agreed, this is a best option for refactoring.

I've also tried adding access_mask field to the service_fixture struct
with all accesses allowed by default. In a test, then you just need to
remove the necessary accesses after sandboxing:

	if (is_restricted(&variant->prot, variant->sandbox))
		clear_access(&self->srv2,
			     LANDLOCK_ACCESS_NET_BIND_TCP |
				     LANDLOCK_ACCESS_NET_CONNECT_TCP);

	test_restricted_net_fixture(_metadata, &self->srv2);

But this solution is too implicit for the helper. Passing struct would
be better.

> 
>> +}
>> +
>>   TEST_F(protocol, bind_unspec)
>>   {
>>   	const struct landlock_ruleset_attr ruleset_attr = {
>> -- 
>> 2.34.1
>>
> 
> —Günther
