Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CC414F120;
	Mon, 13 May 2024 12:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715602734; cv=none; b=Q7ACV6/lKusf7e+E20+i6qclb9nys0oSLLpxQBkuSgO3sgQpjD4mPjFx/IqCmMUA3GCNiGB+zE9ATihZjUW6Ql5sMgodysTLR+39shVVQUf0gOh66UkeiGtgAOqQoJfzOjUtzJGRoOFYxgqgwwFX8xza/wNrcUXsu7SR1shQHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715602734; c=relaxed/simple;
	bh=SrdN7bp3GCGn0BQxbzXtwzf6R0uqeQKv+xbDU3kLob0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mosoKBAFPb3EqwNBWIxuSF1GmcK4oC08a/eApEYvftdS+WEQf70C1Al0V3kaY9OofAzteZgPW+qbu99iB4UsOUs+we9x6GIyX1xOzl08yIhhiN0TOsNF9jARPaLLm2go0A/XtD/PbjSWTRZnTyn2CJWwCKjqXWtlP/RC53Zu794=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VdJMy25NyzkXWr;
	Mon, 13 May 2024 20:15:10 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id EE432180060;
	Mon, 13 May 2024 20:18:41 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 20:18:37 +0800
Message-ID: <2a278e4b-89c4-4fc5-173e-b62978299b28@huawei-partners.com>
Date: Mon, 13 May 2024 15:18:32 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/landlock: Create 'listen_zero',
 'deny_listen_zero' tests
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>,
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
References: <20240408094747.1761850-1-ivanov.mikhail1@huawei-partners.com>
 <20240408094747.1761850-3-ivanov.mikhail1@huawei-partners.com>
 <20240430.ohruCa7giToo@digikod.net>
From: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240430.ohruCa7giToo@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 dggpemm500020.china.huawei.com (7.185.36.49)



4/30/2024 4:36 PM, Mickaël Salaün wrote:
> The subject should be something like:
> "selftests/landlock: Test listening on socket without binding"

thanks, will be fixed.

> 
> On Mon, Apr 08, 2024 at 05:47:47PM +0800, Ivanov Mikhail wrote:
>> Suggested code test scenarios where listen(2) call without explicit
>> bind(2) is allowed and forbidden.
>>
>> Signed-off-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
>> Reviewed-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 89 +++++++++++++++++++++
>>   1 file changed, 89 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index 936cfc879f1d..6d6b5aef387f 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -1714,6 +1714,95 @@ TEST_F(port_specific, bind_connect_zero)
>>   	EXPECT_EQ(0, close(bind_fd));
>>   }
>>   
>> +TEST_F(port_specific, listen_zero)
>> +{
>> +	int listen_fd, connect_fd;
>> +	uint16_t port;
>> +
>> +	/* Adds a rule layer with bind actions. */
>> +	if (variant->sandbox == TCP_SANDBOX) {
>> +		const struct landlock_ruleset_attr ruleset_attr = {
>> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +		};
>> +		const struct landlock_net_port_attr tcp_bind_zero = {
>> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +			.port = 0,
>> +		};
>> +		int ruleset_fd;
>> +
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Checks zero port value on bind action. */
>> +		EXPECT_EQ(0,
>> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +					    &tcp_bind_zero, 0));
>> +
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	listen_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, listen_fd);
>> +
>> +	connect_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, listen_fd);
>> +	/*
>> +	 * Allow listen(2) to select a random port for the socket,
>> +	 * since bind(2) wasn't called.
>> +	 */
>> +	EXPECT_EQ(0, listen(listen_fd, backlog));
>> +
>> +	/* Sets binded (by listen(2)) port for both protocol families. */
>> +	port = get_binded_port(listen_fd, &variant->prot);
>> +	EXPECT_NE(0, port);
>> +	set_port(&self->srv0, port);
>> +
>> +	/* Connects on the binded port. */
>> +	EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
>> +
>> +	EXPECT_EQ(0, close(listen_fd));
>> +	EXPECT_EQ(0, close(connect_fd));
>> +}
>> +
>> +TEST_F(port_specific, deny_listen_zero)
>> +{
>> +	int listen_fd, ret;
>> +
>> +	/* Adds a rule layer with bind actions. */
>> +	if (variant->sandbox == TCP_SANDBOX) {
>> +		const struct landlock_ruleset_attr ruleset_attr = {
>> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +		};
>> +		int ruleset_fd;
>> +
>> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +						     sizeof(ruleset_attr), 0);
>> +		ASSERT_LE(0, ruleset_fd);
>> +
>> +		/* Forbid binding to any port. */
>> +		enforce_ruleset(_metadata, ruleset_fd);
>> +		EXPECT_EQ(0, close(ruleset_fd));
>> +	}
>> +
>> +	listen_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, listen_fd);
>> +	/*
> 
> nit: Extra space

will be fixed

> 
>> +	 * Check that listen(2) call is prohibited without first calling bind(2).
> 
> This should fit in 80 columns.

will be fixed

> 
>> +	 */
>> +	ret = listen(listen_fd, backlog);
>> +	if (is_restricted(&variant->prot, variant->sandbox)) {
>> +		/* Denied by Landlock. */
>> +		EXPECT_NE(0, ret);
>> +		EXPECT_EQ(EACCES, errno);
>> +	} else {
>> +		EXPECT_EQ(0, ret);
>> +	}
>> +
>> +	EXPECT_EQ(0, close(listen_fd));
>> +}
> 
> These tests look good!
> 
>> +
>>   TEST_F(port_specific, bind_connect_1023)
>>   {
>>   	int bind_fd, connect_fd, ret;
>> -- 
>> 2.34.1
>>
>>
