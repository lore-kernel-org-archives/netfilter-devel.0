Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E242528371;
	Thu, 26 Sep 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727358724; cv=none; b=rebV2UhFuhvBjmBGrJQVQPF1k0Wxbh38gpqUfD5j6ayNM2J5GqfI7n16fyJUg8+PUmidsFLE7zT82S96hk+rnhyKTNCCa+9GccB0SqxsDQLXgDabHOu9JmljmHUlwIrB4Gs+rS6BMrkZ9sK4YrXVXD36RhtSEICDYugzDo3zZkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727358724; c=relaxed/simple;
	bh=puHz9/n9hCHTUlSi5yXT8B2gJspt2CeQ+grOC7G6Ga4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XSwFBVsgsf3M65QUQSRe197fMcIOAeamB7CnW8ZPPSvlpDHjYLgeoBI2usulnLZSsokFmYjHXswI9u6VK0y+L/3J0+7TqiX3FhsdAQTdjuWlVc7/WwLQYbJhVUQRhxjH4UfUCufUNSWXb+s9kLcRD4iaeiLd2EZGL1zlKh7hLPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XDw3C2MQbz1T7cs;
	Thu, 26 Sep 2024 21:50:31 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id C1A9C140159;
	Thu, 26 Sep 2024 21:51:57 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 21:51:53 +0800
Message-ID: <9f7063bb-1926-0f52-9e97-2ba08f31990e@huawei-partners.com>
Date: Thu, 26 Sep 2024 16:51:49 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/9] selftests/landlock: Test listening restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, Matthieu Buffet
	<matthieu@buffet.re>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-5-ivanov.mikhail1@huawei-partners.com>
 <ZsSMe1Ce4OiysGRu@google.com>
 <22dcebae-dc5d-0bf1-c686-d2f444558106@huawei-partners.com>
 <20240925.aeJ2du2phi4i@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240925.aeJ2du2phi4i@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/25/2024 9:31 PM, Mickaël Salaün wrote:
> On Tue, Aug 20, 2024 at 09:46:56PM +0300, Mikhail Ivanov wrote:
>> 8/20/2024 3:31 PM, Günther Noack wrote:
>>> On Wed, Aug 14, 2024 at 11:01:46AM +0800, Mikhail Ivanov wrote:
>>>> Add a test for listening restriction. It's similar to protocol.bind and
>>>> protocol.connect tests.
>>>>
>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>> ---
>>>>    tools/testing/selftests/landlock/net_test.c | 44 +++++++++++++++++++++
>>>>    1 file changed, 44 insertions(+)
>>>>
>>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>>> index 8126f5c0160f..b6fe9bde205f 100644
>>>> --- a/tools/testing/selftests/landlock/net_test.c
>>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>>> @@ -689,6 +689,50 @@ TEST_F(protocol, connect)
>>>>    				    restricted, restricted);
>>>>    }
>>>> +TEST_F(protocol, listen)
>>>> +{
>>>> +	if (variant->sandbox == TCP_SANDBOX) {
>>>> +		const struct landlock_ruleset_attr ruleset_attr = {
>>>> +			.handled_access_net = ACCESS_ALL,
>>>> +		};
>>>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>>>> +			.allowed_access = ACCESS_ALL,
>>>> +			.port = self->srv0.port,
>>>> +		};
>>>> +		const struct landlock_net_port_attr tcp_denied_listen_p1 = {
>>>> +			.allowed_access = ACCESS_ALL &
>>>> +					  ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
>>>> +			.port = self->srv1.port,
>>>> +		};
>>>> +		int ruleset_fd;
>>>> +
>>>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>>> +						     sizeof(ruleset_attr), 0);
>>>
>>> Nit: The declaration and the assignment of ruleset_fd can be merged into one
>>> line and made const.  (Not a big deal, but it was done a bit more consistently
>>> in the rest of the code, I think.)
>>
>> Current variant is performed in every TEST_F() method. I assume that
>> this is required in order to not make a mess by combining the
>> ruleset_attr and several rule structures with the operation of creating
>> ruleset. WDYT?
> 
> Using variant->sandbox helps identify test scenarios.

Sorry, I'm not sure I understand if this advice can be applied to the
discussed nit.

> 
>>
>>>
>>>> +		ASSERT_LE(0, ruleset_fd);
>>>> +
>>>> +		/* Allows all actions for the first port. */
>>>> +		ASSERT_EQ(0,
>>>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>> +					    &tcp_not_restricted_p0, 0));
>>>> +
>>>> +		/* Allows all actions despite listen. */
>>>> +		ASSERT_EQ(0,
>>>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>> +					    &tcp_denied_listen_p1, 0));
>>>> +
>>>> +		enforce_ruleset(_metadata, ruleset_fd);
>>>> +		EXPECT_EQ(0, close(ruleset_fd));
>>>> +	}
>>>
>>> This entire "if (variant->sandbox == TCP_SANDBOX)" conditional does the exact
>>> same thing as the one from patch 5/9.  Should that (or parts of it) get
>>> extracted into a suitable helper?
>>
>> I don't think replacing
>> 	if (variant->sandbox == TCP_SANDBOX)
>> with
>> 	if (is_tcp_sandbox(variant))
>> will change anything, this condition is already quite simple. If
>> you think that such helper is more convenient, I can add it.
> 
> The variant->sandbox check is OK, but the following code block should
> not be duplicated because it makes more code to review and we may wonder
> if it does the same thing.  Intead we can have something like this:
> 
> if (variant->sandbox == TCP_SANDBOX)
> 	restrict_tcp_listen(_metadata, self);

Good suggestion, thank you! Probably it would be more simple to make a
single restrict_tcp() helper and pass appropriate access right to it:

if (variant->sandbox == TCP_SANDBOX)
	restrict_tcp(_metadata, self,
		LANDLOCK_ACCESS_NET_{LISTEN|BIND|CONNECT}_TCP);

> 
>>
>>>
>>>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>>>> +
>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>>>> +				    false);
>>>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
>>>> +				    restricted);
>>>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>>>> +				    restricted, restricted);
>>>
>>> If we start having logic and conditionals in the test implementation (in this
>>> case, in test_restricted_test_fixture()), this might be a sign that that test
>>> implementation should maybe be split apart?  Once the test is as complicated as
>>> the code under test, it does not simplify our confidence in the code much any
>>> more?
>>>
>>> (It is often considered bad practice to put conditionals in tests, e.g. in
>>> https://testing.googleblog.com/2014/07/testing-on-toilet-dont-put-logic-in.html)
>>>
>>> Do you think we have a way to simplify that?
>>
>> I agree.. using 3 external booleans to control behavior of the
>> test is really messy. I believe the best we can do to avoid this is to
>> split "test_restricted_net_fixture()" into few independent tests. For
>> example we can turn this call:
>>
>> 	test_restricted_net_fixture(_metadata, &self->srv0, false,
>> 		false, false);
>>
>> into multiple smaller tests:
>>
>> 	/* Tries to bind with invalid and minimal addrlen. */
>> 	EXPECT_EQ(0, TEST_BIND(&self->srv0));
>>
>> 	/* Tries to connect with invalid and minimal addrlen. */
>> 	EXPECT_EQ(0, TEST_CONNECT(&self->srv0));
>>
>> 	/* Tries to listen. */
>> 	EXPECT_EQ(0, TEST_LISTEN(&self->srv0));
>>
>> 	/* Connection tests. */
>> 	EXPECT_EQ(0, TEST_CLIENT_SERVER(&self->srv0));
> 
> These standalone bind/connect/listen/client_server looks good.
> 
>>
>> Each test is wrapped in a macro that implicitly passes _metadata argument.
> 
> I'd prefer to not use macros to pass argument because it makes it more
> difficult to understand what is going on. Just create a
> test_*(_metadata, ...) helper.

Ok, agreed

> 
>>
>> This case in which every access is allowed can be wrapped in a macro:
>>
>> 	TEST_UNRESTRICTED_NET_FIXTURE(&self->srv0);
> 
> Let's try to avoid macros as much as possible.

Ok, using such macros in tests might be really confusing.

> 
>>
>> Such approach has following cons though:
>> * A lot of duplicated code. These small helpers should be added to every
>>    test that uses "test_restricted_net_fixture()". Currently there
>>    are 16 calls of this helper.
> 
> We can start by calling these test_listen()-like helpers in
> test_bind_and_connect().  We should be careful to not change too much
> the existing test code to be able to run them against older kernels
> without too much changes.

Yeah, ofc we can do this if you think we need a smoother refactoring
process. We can discuss initial changes in dedicated topic [1].

[1] https://github.com/landlock-lsm/linux/issues/34

> 
>>
>> * There is wouldn't be a single entity that is used to test a network
>>    under different sandbox scenarios. If we split the helper each test
>>    should care about (1) sandboxing, (2) running all required tests. For
>>    example TEST_LISTEN() and TEST_CLIENT_SERVER() could not be called if
>>    bind is restricted.
> 
> Yes, this might be an issue, but for this specific case we may write a
> dedicated test if it helps.

Agreed

> 
>>
>> For example protocol.bind test would have following lines after
>> "test_restricted_net_fixture()" is removed:
>>
>> 	TEST_UNRESTRICTED_NET_FIXTURE(&self->srv0);
>>
>> 	if (is_restricted(&variant->prot, variant->sandbox)) {
>> 		EXPECT_EQ(-EACCES, TEST_BIND(&self->srv1));
>> 		EXPECT_EQ(0, TEST_CONNECT(&self->srv1));
>>
>> 		EXPECT_EQ(-EACCES, TEST_BIND(&self->srv2));
>> 		EXPECT_EQ(-EACCES, TEST_CONNECT(&self->srv2));
>> 	} else {
>> 		TEST_UNRESTRICTED_NET_FIXTURE(&self->srv1);
>> 		TEST_UNRESTRICTED_NET_FIXTURE(&self->srv2);
>> 	}
>>
>> I suggest leaving "test_restricted_net_fixture()" and refactor this
>> booleans (in the way you suggested) in order not to lose simplicity in
>> the testing:
>>
>> 	bool restricted = is_restricted(&variant->prot,
>> 		variant->sandbox);
>>
>> 	test_restricted_net_fixture(_metadata, &self->srv0,
>> 		(struct expected_net_enforcement){
>> 		.deny_bind = false,
>> 		.deny_connect = false,
>> 		.deny_listen = false
>> 	});
>> 	test_restricted_net_fixture(_metadata, &self->srv1,
>> 		(struct expected_net_enforcement){
>> 		.deny_bind = false,
>> 		.deny_connect = restricted,
>> 		.deny_listen = false
>> 	});
>> 	test_restricted_net_fixture(_metadata, &self->srv2,
>> 		(struct expected_net_enforcement){
>> 		.deny_bind = restricted,
>> 		.deny_connect = restricted,
>> 		.deny_listen = restricted
>> 	});
>>
>> But it's really not obvious design issue and splitting helper can really
>> be a better solution. WDYT?
>>
>>>
>>>
>>> Readability remark: I am not that strongly invested in this idea, but in the
>>> call to test_restricted_net_fixture(), it is difficult to understand "false,
>>> false, false", without jumping around in the file.  Should we try to make this
>>> more explicit?
>>>
>>> I wonder whether we should just pass a struct, so that everything at least has a
>>> name?
>>>
>>>     test_restricted_net_fixture((struct expected_net_enforcement){
>>>       .deny_bind = false,
>>>       .deny_connect = false,
>>>       .deny_listen = false,
>>>     });
>>>
>>> Then it would be clearer which boolean is which,
>>> and you could use the fact that unspecified struct fields are zero-initialized?
>>>
>>> (Alternatively, you could also spell out error codes here, instead of booleans.)
>>
>> Agreed, this is a best option for refactoring.
>>
>> I've also tried adding access_mask field to the service_fixture struct
>> with all accesses allowed by default. In a test, then you just need to
>> remove the necessary accesses after sandboxing:
>>
>> 	if (is_restricted(&variant->prot, variant->sandbox))
>> 		clear_access(&self->srv2,
>> 			     LANDLOCK_ACCESS_NET_BIND_TCP |
>> 				     LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>
>> 	test_restricted_net_fixture(_metadata, &self->srv2);
>>
>> But this solution is too implicit for the helper. Passing struct would
>> be better.
> 
> What about passing the variant to these tests and creating more
> fine-grained is_restricted_*() helpers?

Do you mean making is_restricted_{bind|connect|listen}()? We can't
identify which access rights are restricted for the port if we pass only
`variant` to test_bind_and_connect().

> 
>>
>>>
>>>> +}
>>>> +
>>>>    TEST_F(protocol, bind_unspec)
>>>>    {
>>>>    	const struct landlock_ruleset_attr ruleset_attr = {
>>>> -- 
>>>> 2.34.1
>>>>
>>>
>>> —Günther
>>
