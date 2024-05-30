Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B00145A01;
	Thu, 30 May 2024 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717081755; cv=none; b=X1NM0irFa2CIy6f6KlS/FJw28x9+dWKRuwps36XT/Zjh0ds87PYyPUDoq8TzNngqK/gZ4UpMGULT0inZ610BjraQGL4Ae7CjMDci6K63wsSLRTQQyXI/LG3SWYKtXl4TEvg36VPV89RKnf5jUwpFaDYS17owvQCGHf7mvr/ojvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717081755; c=relaxed/simple;
	bh=I3znZk7Px2aLbm4BQbBDIODP0k06GM7AnNSbWvHr/Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uG+6i8Un9xHn3/TDEcqr51bbiQTy5eegkSkWI1/OgVECKTy2e3rKvudA1Jfa+sd/tYFYk2jWMo4AzW+5/u7OaBqlazpM5675/q1c2NHppjZ53puB6/Dq0cQT4xGvHXDqeO3vB70wIDiOy9mLI7m5v7VV37UuG2xkS9buEKEf2qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VqqLK61MNz1S7Mv;
	Thu, 30 May 2024 23:05:13 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A0C2A180069;
	Thu, 30 May 2024 23:09:02 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 30 May 2024 23:08:58 +0800
Message-ID: <f79783ff-5ab7-163e-d2d3-4af9872a38c6@huawei-partners.com>
Date: Thu, 30 May 2024 18:08:53 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 08/12] selftests/landlock: Add
 tcp_layers.ruleset_overlap to socket tests
Content-Language: ru
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-9-ivanov.mikhail1@huawei-partners.com>
 <ZlT2edk0lBcMPcjp@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZlT2edk0lBcMPcjp@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 dggpemm500020.china.huawei.com (7.185.36.49)



5/28/2024 12:09 AM, Günther Noack wrote:
> On Fri, May 24, 2024 at 05:30:11PM +0800, Mikhail Ivanov wrote:
>> * Add tcp_layers fixture for tests that check multiple layer
>>    configuration scenarios.
>>
>> * Add test that validates multiple layer behavior with overlapped
>>    restrictions.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>
>> Changes since v1:
>> * Replaces test_socket_create() with test_socket().
>> * Formats code with clang-format.
>> * Refactors commit message.
>> * Minor fixes.
>> ---
>>   .../testing/selftests/landlock/socket_test.c  | 109 ++++++++++++++++++
>>   1 file changed, 109 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/socket_test.c b/tools/testing/selftests/landlock/socket_test.c
>> index 751596c381fe..52edc1a8ac21 100644
>> --- a/tools/testing/selftests/landlock/socket_test.c
>> +++ b/tools/testing/selftests/landlock/socket_test.c
>> @@ -299,4 +299,113 @@ TEST_F(protocol, inval)
>>   				       &protocol, 0));
>>   }
>>   
>> +FIXTURE(tcp_layers)
>> +{
>> +	struct service_fixture srv0;
>> +};
>> +
>> +FIXTURE_VARIANT(tcp_layers)
>> +{
>> +	const size_t num_layers;
>> +};
>> +
>> +FIXTURE_SETUP(tcp_layers)
>> +{
>> +	const struct protocol_variant prot = {
>> +		.family = AF_INET,
>> +		.type = SOCK_STREAM,
>> +	};
>> +
>> +	disable_caps(_metadata);
>> +	self->srv0.protocol = prot;
>> +	setup_namespace(_metadata);
>> +};
>> +
>> +FIXTURE_TEARDOWN(tcp_layers)
>> +{
>> +}
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(tcp_layers, no_sandbox_with_ipv4) {
>> +	/* clang-format on */
>> +	.num_layers = 0,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(tcp_layers, one_sandbox_with_ipv4) {
>> +	/* clang-format on */
>> +	.num_layers = 1,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(tcp_layers, two_sandboxes_with_ipv4) {
>> +	/* clang-format on */
>> +	.num_layers = 2,
>> +};
>> +
>> +/* clang-format off */
>> +FIXTURE_VARIANT_ADD(tcp_layers, three_sandboxes_with_ipv4) {
>> +	/* clang-format on */
>> +	.num_layers = 3,
>> +};
>> +
>> +TEST_F(tcp_layers, ruleset_overlap)
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_socket = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +	};
>> +	const struct landlock_socket_attr tcp_create = {
>> +		.allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>> +		.family = self->srv0.protocol.family,
>> +		.type = self->srv0.protocol.type,
>> +	};
>> +
>> +	if (variant->num_layers >= 1) {
>> +		int ruleset_fd;
>> +
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Allows create. */
>> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +					       &tcp_create, 0));
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	if (variant->num_layers >= 2) {
>> +		int ruleset_fd;
>> +
>> +		/* Creates another ruleset layer with denied create. */
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	if (variant->num_layers >= 3) {
>> +		int ruleset_fd;
>> +
>> +		/* Creates another ruleset layer. */
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Try to allow create second time. */
>> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_SOCKET,
>> +					       &tcp_create, 0));
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	if (variant->num_layers < 2) {
>> +		ASSERT_EQ(0, test_socket(&self->srv0));
>> +	} else {
>> +		ASSERT_EQ(EACCES, test_socket(&self->srv0));
>> +	}
>> +}
> 
> Wouldn't this be simpler if you did multiple checks in one test, in a sequence?
> 
>    * Expect that socket() works
>    * Enforce ruleset 1 with a rule
>    * Expect that socket() works
>    * Enforce ruleset 2 without a rule
>    * Expect that socket() fails
>    * Enforce ruleset 3
>    * Expect that socket() still fails
> 
> Then it would test the same and you would not need the fixture.
> If you extracted these if bodies above into helper functions,
> I think it would also read reasonably well.

I adapted this test from net_test.c and wanted it to remain similar to
the original. But I agree that such simplification is rational, probably
it's worth a little inconsistency.

Perhaps this test should be made common, like the tests that were
discussed earlier [1].

[1] 
https://lore.kernel.org/all/f4b5e2b9-e960-fd08-fdf4-328bb475e2ef@huawei-partners.com/

> 
> —Günther
