Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D81719478;
	Thu,  1 Aug 2024 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722527291; cv=none; b=Nr/vZWiTH9983Ip7+X5jXfdy2O+8nf8b+YMl6hOFs5gWoxdrAszRiPwNpJ3QI5HopghbVbXew864yIZuqSOuEX023qft+zvwOfEAbKM7ARIgL02dmXr5JxOXs3gBlo1o6/+DJNlew48jtlWn10VJDH8mnFF0oqISxc/YcKg4tmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722527291; c=relaxed/simple;
	bh=3b3teYOeMnKN/5gEkex+1dr1uybGX1tQ7lYOcPUoa4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ap3WwKas3hvR6F/w0I6sq38u6fkE7HWrFWyYXMVjBMGHnKHlyhsuJmHDjGhE9ZXbUI1bGatlkIMRJKyhS4H1fsJjx625WUhb0tGo+gswWyxrf/35pr74YN9VFz6sCp788iVgXmUDMv3QeZ2Kai/qt7WEUIXtRKKfy4KhF+uofds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WZYGX1zszzfZ2f;
	Thu,  1 Aug 2024 23:46:12 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 5BED11402CD;
	Thu,  1 Aug 2024 23:48:03 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 1 Aug 2024 23:47:59 +0800
Message-ID: <af585335-9844-c9c1-5320-7751e0f3a97c@huawei-partners.com>
Date: Thu, 1 Aug 2024 18:47:55 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 5/9] selftests/landlock: Test listen on connected
 socket
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
References: <20240728002602.3198398-1-ivanov.mikhail1@huawei-partners.com>
 <20240728002602.3198398-6-ivanov.mikhail1@huawei-partners.com>
 <20240801.Ee3Cai7eeD1g@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240801.Ee3Cai7eeD1g@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/1/2024 5:46 PM, Mickaël Salaün wrote:
> On Sun, Jul 28, 2024 at 08:25:58AM +0800, Mikhail Ivanov wrote:
>> Test checks that listen(2) doesn't wrongfully return -EACCES instead
>> of -EINVAL when trying to listen for an incorrect socket state.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> 
> Good to have this test!
> 
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 65 +++++++++++++++++++++
>>   1 file changed, 65 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index b6fe9bde205f..a8385f1373f6 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -1644,6 +1644,71 @@ TEST_F(ipv4_tcp, with_fs)
>>   	EXPECT_EQ(-EACCES, bind_variant(bind_fd, &self->srv1));
>>   }
>>   
>> +TEST_F(ipv4_tcp, listen_on_connected)
> 
> We should use the "protocol" fixture and its variants instead to test
> with different protocols and also without sandboxing (which is crutial).
> 
> I guess espintcp_listen should use "protocol" too.
> 
> ipv4_tcp is to run tests that only make sense on an IPv4 socket, but
> when we test EINVAL, we should make sure Landlock doesn't introduce
> inconsistencies for other/unsupported protocols.

Makes sense, let's use "protocol".

> 
>> +{
>> +	const struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_net = ACCESS_ALL,
>> +	};
>> +	const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>> +		.allowed_access = ACCESS_ALL,
>> +		.port = self->srv0.port,
>> +	};
>> +	const struct landlock_net_port_attr tcp_denied_listen_p1 = {
>> +		.allowed_access = ACCESS_ALL & ~LANDLOCK_ACCESS_NET_LISTEN_TCP,
>> +		.port = self->srv1.port,
>> +	};
>> +	int ruleset_fd;
>> +	int bind_fd, status;
>> +	pid_t child;
>> +
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Allows all actions for the first port. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +				       &tcp_not_restricted_p0, 0));
>> +
>> +	/* Deny listen for the second port. */
> 
> nit: Denies listening

will be fixed

> 
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> +				       &tcp_denied_listen_p1, 0));
>> +
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	EXPECT_EQ(0, close(ruleset_fd));
>> +
>> +	/* Init listening socket. */
> 
> nit: Initializes

will be fixed

> 
>> +	bind_fd = socket_variant(&self->srv0);
>> +	ASSERT_LE(0, bind_fd);
>> +	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>> +
>> +	child = fork();
>> +	ASSERT_LE(0, child);
>> +	if (child == 0) {
>> +		int connect_fd;
>> +
>> +		/* Closes listening socket for the child. */
>> +		EXPECT_EQ(0, close(bind_fd));
>> +
>> +		connect_fd = socket_variant(&self->srv1);
>> +		ASSERT_LE(0, connect_fd);
>> +		EXPECT_EQ(0, connect_variant(connect_fd, &self->srv0));
>> +
>> +		/* Tries to listen on connected socket. */
>> +		EXPECT_EQ(-EINVAL, listen_variant(connect_fd, backlog));
>> +
>> +		EXPECT_EQ(0, close(connect_fd));
>> +		_exit(_metadata->exit_code);
>> +		return;
>> +	}
>> +
>> +	EXPECT_EQ(child, waitpid(child, &status, 0));
>> +	EXPECT_EQ(1, WIFEXITED(status));
>> +	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +
>> +	EXPECT_EQ(0, close(bind_fd));
>> +}
>> +
>>   FIXTURE(port_specific)
>>   {
>>   	struct service_fixture srv0;
>> -- 
>> 2.34.1
>>
>>
