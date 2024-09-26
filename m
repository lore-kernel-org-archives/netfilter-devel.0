Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615614F9DD;
	Thu, 26 Sep 2024 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727352013; cv=none; b=Db46GrMus0C7i8wj6vbGOkHJD7ixPNoVzAGjYtEok10YKiyAOWU1bWrz7H9g3x4T2EEwZYIlBg+QVvMs0pdaTyjoaIHKAJjPpf0BEB9JnywsApKheJ5WnayvKyxXYkD+aqau5YJS9koilDMwLuKMRm/lMIjtlr2D5A+A+mllgyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727352013; c=relaxed/simple;
	bh=HmmzYioF8i0QQOyBlXV2xcFR07IE8YZBvIVOV3TdJOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=StPetsT//pV+za/Q5kUxqtIA0wO+RDc6i+xTiU7X4qr9d9/MYBpaDn33G2/ut2/VpOu3Ogr7Od0Qo7TJ7dIr0+DXkzxRmE0WKni18rDrZT6J06GXG+UIiAjS2S5sIGe1CrZKr6FqhH0A5jmQg2GzlBGi96JKdjUvD7NvUNs0VqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XDsZ64GcGz1T7vC;
	Thu, 26 Sep 2024 19:58:38 +0800 (CST)
Received: from kwepemj200016.china.huawei.com (unknown [7.202.194.28])
	by mail.maildlp.com (Postfix) with ESMTPS id E730D18005F;
	Thu, 26 Sep 2024 20:00:04 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 kwepemj200016.china.huawei.com (7.202.194.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 20:00:00 +0800
Message-ID: <3235bd40-093d-ca2a-2de8-cd96e6247f86@huawei-partners.com>
Date: Thu, 26 Sep 2024 14:59:56 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/9] selftests/landlock: Support
 LANDLOCK_ACCESS_NET_LISTEN_TCP
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
CC: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	<willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>, Matthieu Buffet
	<matthieu@buffet.re>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-4-ivanov.mikhail1@huawei-partners.com>
 <ZsO-pIGsTl6T5AL1@google.com> <ZsSW0H4FR3ElOPAy@google.com>
 <be3f4eea-3203-8af1-2e7f-e80fde30c45f@huawei-partners.com>
 <20240925.ugemahnie3Ie@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20240925.ugemahnie3Ie@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 kwepemj200016.china.huawei.com (7.202.194.28)

On 9/25/2024 9:31 PM, Mickaël Salaün wrote:
> On Tue, Aug 20, 2024 at 09:27:10PM +0300, Mikhail Ivanov wrote:
>> 8/20/2024 4:14 PM, Günther Noack wrote:
>>> On Mon, Aug 19, 2024 at 11:52:36PM +0200, Günther Noack wrote:
>>>> On Wed, Aug 14, 2024 at 11:01:45AM +0800, Mikhail Ivanov wrote:
>>>>> * Add listen_variant() to simplify listen(2) return code checking.
>>>>> * Rename test_bind_and_connect() to test_restricted_net_fixture().
>>>>> * Extend current net rules with LANDLOCK_ACCESS_NET_LISTEN_TCP access.
>>>>> * Rename test port_specific.bind_connect_1023 to
>>>>>     port_specific.port_1023.
>>>>> * Check little endian port restriction for listen in
>>>>>     ipv4_tcp.port_endianness.
>>>>> * Some local renames and comment changes.
>>>>>
>>>>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>>>>> ---
>>>>>    tools/testing/selftests/landlock/net_test.c | 198 +++++++++++---------
>>>>>    1 file changed, 107 insertions(+), 91 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>>>> index f21cfbbc3638..8126f5c0160f 100644
>>>>> --- a/tools/testing/selftests/landlock/net_test.c
>>>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>>>> @@ -2,7 +2,7 @@
>>>>>    /*
>>>>>     * Landlock tests - Network
>>>>>     *
>>>>> - * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
>>>>> + * Copyright © 2022-2024 Huawei Tech. Co., Ltd.
>>>>>     * Copyright © 2023 Microsoft Corporation
>>>>>     */
>>>>> @@ -22,6 +22,17 @@
>>>>>    #include "common.h"
>>>>> +/* clang-format off */
>>>>> +
>>>>> +#define ACCESS_LAST LANDLOCK_ACCESS_NET_LISTEN_TCP
>>>>> +
>>>>> +#define ACCESS_ALL ( \
>>>>> +	LANDLOCK_ACCESS_NET_BIND_TCP | \
>>>>> +	LANDLOCK_ACCESS_NET_CONNECT_TCP | \
>>>>> +	LANDLOCK_ACCESS_NET_LISTEN_TCP)
>>>>> +
>>>>> +/* clang-format on */
>>>>> +
>>>>>    const short sock_port_start = (1 << 10);
>>>>>    static const char loopback_ipv4[] = "127.0.0.1";
>>>>> @@ -282,6 +293,16 @@ static int connect_variant(const int sock_fd,
>>>>>    	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
>>>>>    }
>>>>> +static int listen_variant(const int sock_fd, const int backlog)
>>>>
>>>> I believe socket_variant(), connect_variant() and bind_variant() were called
>>>> like that because they got an instance of a service_fixture as an argument.  The
>>>> fixture instances are called variants.  But we don't use these fixtures here.
> 
> Correct
> 
>>>>
>>>> In fs_test.c, we also have some functions that behave much like system calls,
>>>> but clean up after themselves and return errno, for easier use in assert.  The
>>>> naming scheme we have used there is "test_foo" (e.g. test_open()).  I think this
>>>> would be more appropriate here as a name?
>>>>
>>>>> +{
>>>>> +	int ret;
>>>>> +
>>>>> +	ret = listen(sock_fd, backlog);
>>>>> +	if (ret < 0)
>>>>> +		return -errno;
>>>>> +	return ret;
>>>
>>> listen() can only return -1 or 0.  It might be simpler to just return 0 here,
>>> to make it more obvious that this returns an error code.
>>
>> Agreed, thanks. I'll do such refactoring for the connect_variant() as
>> well.
>>
>>>
>>>>> +}
>>>
>>> Another remark about listen_variant(): The helper functions in net_test.c return
>>> negative error codes, whereas the ones in fs_test.c return positive error codes.
>>> We should probably make that more consistent.
> 
> The test_*() helpers either return 0 on success or errno on error,
> but not something else (e.g. not a file descriptor).  Some test_*()
> helper directly takes _metadata argument, so in this case they don't
> need to return anything.
> 
>>
>> socket_variant() returns positive descriptor in a case of success, so
>> let's use negative ones.
> 
> The *_variant() helpers may indeed return a file descriptor so we should
> return -errno if there is an error.  Anyway, calling to the existing
> helpers should always succeed and return a file descriptor (greater or
> equal to 0).
> 
> However, all *_variant() helpers should take as argument a fixture
> variant.  If this is not needed, we either check the returned value of
> the syscall and errno, or we can create a sys_<syscall>() helper that
> return -errno on error.

Agreed, I've suggested similar variant (do_listen()) here [1]. Can I do
sys_listen() to simplify errno checks?

[1] 
https://lore.kernel.org/all/2f67fa30-d4e6-3a1b-7166-eee33c734899@huawei-partners.com/

> 
>>
>> Should it be a separate patch btw?
> 
> Please just remove this listen_variant() helper and the related changes,
> and use listen() + errno checks instead.

Separate patch suggestion is more about refactoring inconsistent
posivite/negative errno return values in existing *_variant() helpers.
I'll remove listen_variant() anyway.

> 
>>
>>>
>>>>> +
>>>>>    FIXTURE(protocol)
>>>>>    {
>>>>>    	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
>>>>> @@ -438,9 +459,11 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_datagram) {
>>>>>    	},
>>>>>    };
>>>>> -static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>>>> -				  const struct service_fixture *const srv,
>>>>> -				  const bool deny_bind, const bool deny_connect)
>>>>> +static void test_restricted_net_fixture(struct __test_metadata *const _metadata,
>>>>> +					const struct service_fixture *const srv,
>>>>> +					const bool deny_bind,
>>>>> +					const bool deny_connect,
>>>>> +					const bool deny_listen)
>>>>>    {
>>>>>    	char buf = '\0';
>>>>>    	int inval_fd, bind_fd, client_fd, status, ret;
>>>>> @@ -512,8 +535,14 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>>>>    		EXPECT_EQ(0, ret);
>>>>>    		/* Creates a listening socket. */
>>>>> -		if (srv->protocol.type == SOCK_STREAM)
>>>>> -			EXPECT_EQ(0, listen(bind_fd, backlog));
>>>>> +		if (srv->protocol.type == SOCK_STREAM) {
>>>>> +			ret = listen_variant(bind_fd, backlog);
>>>>> +			if (deny_listen) {
>>>>> +				EXPECT_EQ(-EACCES, ret);
>>>>> +			} else {
>>>>> +				EXPECT_EQ(0, ret);
>>>>> +			}
>>>>
>>>> Hmm, passing the expected error code instead of a boolean to this function was not possible?
>>>> Then you could just write
>>>>
>>>>     EXPECT_EQ(expected_listen_error, listen_variant(bind_fd, backlog));
>>>>
>>>> ?  (Apologies if this was discussed already.)
>>>>
>>>>> +		}
>>>>>    	}
>>>>>    	child = fork();
>>>>> @@ -530,7 +559,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>>>>    		ret = connect_variant(connect_fd, srv);
>>>>>    		if (deny_connect) {
>>>>>    			EXPECT_EQ(-EACCES, ret);
>>>>> -		} else if (deny_bind) {
>>>>> +		} else if (deny_bind || deny_listen) {
>>>>>    			/* No listening server. */
>>>>>    			EXPECT_EQ(-ECONNREFUSED, ret);
>>>>>    		} else {
>>>>> @@ -545,7 +574,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>>>>    	/* Accepts connection from the child. */
>>>>>    	client_fd = bind_fd;
>>>>> -	if (!deny_bind && !deny_connect) {
>>>>> +	if (!deny_bind && !deny_connect && !deny_listen) {
>>>>>    		if (srv->protocol.type == SOCK_STREAM) {
>>>>>    			client_fd = accept(bind_fd, NULL, 0);
>>>>>    			ASSERT_LE(0, client_fd);
>>>>> @@ -571,16 +600,15 @@ TEST_F(protocol, bind)
>>>>>    {
>>>>>    	if (variant->sandbox == TCP_SANDBOX) {
>>>>>    		const struct landlock_ruleset_attr ruleset_attr = {
>>>>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +			.handled_access_net = ACCESS_ALL,
>>>>>    		};
>>>>> -		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>>>>> +			.allowed_access = ACCESS_ALL,
>>>>>    			.port = self->srv0.port,
>>>>>    		};
>>>>> -		const struct landlock_net_port_attr tcp_connect_p1 = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_denied_bind_p1 = {
>>>>> +			.allowed_access = ACCESS_ALL &
>>>>> +					  ~LANDLOCK_ACCESS_NET_BIND_TCP,
>>>>>    			.port = self->srv1.port,
>>>>>    		};
>>>>>    		int ruleset_fd;
>>>>> @@ -589,48 +617,47 @@ TEST_F(protocol, bind)
>>>>>    						     sizeof(ruleset_attr), 0);
>>>>>    		ASSERT_LE(0, ruleset_fd);
>>>>> -		/* Allows connect and bind for the first port.  */
>>>>> +		/* Allows all actions for the first port. */
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_bind_connect_p0, 0));
>>>>> +					    &tcp_not_restricted_p0, 0));
>>>>> -		/* Allows connect and denies bind for the second port. */
>>>>> +		/* Allows all actions despite bind. */
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_connect_p1, 0));
>>>>> +					    &tcp_denied_bind_p1, 0));
>>>>>    		enforce_ruleset(_metadata, ruleset_fd);
>>>>>    		EXPECT_EQ(0, close(ruleset_fd));
>>>>>    	}
>>>>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>>>>>    	/* Binds a socket to the first port. */
>>>>> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>>>>> +				    false);
>>>>>    	/* Binds a socket to the second port. */
>>>>> -	test_bind_and_connect(_metadata, &self->srv1,
>>>>> -			      is_restricted(&variant->prot, variant->sandbox),
>>>>> -			      false);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv1, restricted, false,
>>>>> +				    false);
>>>>>    	/* Binds a socket to the third port. */
>>>>> -	test_bind_and_connect(_metadata, &self->srv2,
>>>>> -			      is_restricted(&variant->prot, variant->sandbox),
>>>>> -			      is_restricted(&variant->prot, variant->sandbox));
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>>>>> +				    restricted, restricted);
>>>>>    }
>>>>>    TEST_F(protocol, connect)
>>>>>    {
>>>>>    	if (variant->sandbox == TCP_SANDBOX) {
>>>>>    		const struct landlock_ruleset_attr ruleset_attr = {
>>>>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +			.handled_access_net = ACCESS_ALL,
>>>>>    		};
>>>>> -		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>>>>> +			.allowed_access = ACCESS_ALL,
>>>>>    			.port = self->srv0.port,
>>>>>    		};
>>>>> -		const struct landlock_net_port_attr tcp_bind_p1 = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_denied_connect_p1 = {
>>>>> +			.allowed_access = ACCESS_ALL &
>>>>> +					  ~LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>>    			.port = self->srv1.port,
>>>>>    		};
>>>>>    		int ruleset_fd;
>>>>> @@ -639,28 +666,27 @@ TEST_F(protocol, connect)
>>>>>    						     sizeof(ruleset_attr), 0);
>>>>>    		ASSERT_LE(0, ruleset_fd);
>>>>> -		/* Allows connect and bind for the first port. */
>>>>> +		/* Allows all actions for the first port. */
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_bind_connect_p0, 0));
>>>>> +					    &tcp_not_restricted_p0, 0));
>>>>> -		/* Allows bind and denies connect for the second port. */
>>>>> +		/* Allows all actions despite connect. */
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_bind_p1, 0));
>>>>> +					    &tcp_denied_connect_p1, 0));
>>>>>    		enforce_ruleset(_metadata, ruleset_fd);
>>>>>    		EXPECT_EQ(0, close(ruleset_fd));
>>>>>    	}
>>>>> -
>>>>> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
>>>>> -
>>>>> -	test_bind_and_connect(_metadata, &self->srv1, false,
>>>>> -			      is_restricted(&variant->prot, variant->sandbox));
>>>>> -
>>>>> -	test_bind_and_connect(_metadata, &self->srv2,
>>>>> -			      is_restricted(&variant->prot, variant->sandbox),
>>>>> -			      is_restricted(&variant->prot, variant->sandbox));
>>>>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>>>>> +
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>>>>> +				    false);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, restricted,
>>>>> +				    false);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>>>>> +				    restricted, restricted);
>>>>>    }
>>>>>    TEST_F(protocol, bind_unspec)
>>>>> @@ -761,7 +787,7 @@ TEST_F(protocol, connect_unspec)
>>>>>    	ASSERT_LE(0, bind_fd);
>>>>>    	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
>>>>>    	if (self->srv0.protocol.type == SOCK_STREAM)
>>>>> -		EXPECT_EQ(0, listen(bind_fd, backlog));
>>>>> +		EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>>>>    	child = fork();
>>>>>    	ASSERT_LE(0, child);
>>>>> @@ -1127,8 +1153,8 @@ TEST_F(tcp_layers, ruleset_overlap)
>>>>>    	 * Forbids to connect to the socket because only one ruleset layer
>>>>>    	 * allows connect.
>>>>>    	 */
>>>>> -	test_bind_and_connect(_metadata, &self->srv0, false,
>>>>> -			      variant->num_layers >= 2);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>>>>> +				    variant->num_layers >= 2, false);
>>>>>    }
>>>>>    TEST_F(tcp_layers, ruleset_expand)
>>>>> @@ -1208,11 +1234,12 @@ TEST_F(tcp_layers, ruleset_expand)
>>>>>    		EXPECT_EQ(0, close(ruleset_fd));
>>>>>    	}
>>>>> -	test_bind_and_connect(_metadata, &self->srv0, false,
>>>>> -			      variant->num_layers >= 3);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>>>>> +				    variant->num_layers >= 3, false);
>>>>> -	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >= 1,
>>>>> -			      variant->num_layers >= 2);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv1,
>>>>> +				    variant->num_layers >= 1,
>>>>> +				    variant->num_layers >= 2, false);
>>>>>    }
>>>>>    /* clang-format off */
>>>>> @@ -1230,16 +1257,6 @@ FIXTURE_TEARDOWN(mini)
>>>>>    {
>>>>>    }
>>>>> -/* clang-format off */
>>>>> -
>>>>> -#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
>>>>> -
>>>>> -#define ACCESS_ALL ( \
>>>>> -	LANDLOCK_ACCESS_NET_BIND_TCP | \
>>>>> -	LANDLOCK_ACCESS_NET_CONNECT_TCP)
> 
> I'd like to avoid changes that impact existing tests.  For now, tests
> can only run against the kernel in the same tree, but I'd like to make
> these tests able to run against previous kernel versions too.  We're not
> there yet, but that's one reason why we should not change such constants
> but use some kind of argument instead.

Ok, I'll fix this.

> 
>>>>> -
>>>>> -/* clang-format on */
>>>>> -
>>>>>    TEST_F(mini, network_access_rights)
>>>>>    {
>>>>>    	const struct landlock_ruleset_attr ruleset_attr = {
>>>>> @@ -1454,8 +1471,9 @@ TEST_F(mini, tcp_port_overflow)
>>>>>    	enforce_ruleset(_metadata, ruleset_fd);
>>>>> -	test_bind_and_connect(_metadata, &srv_denied, true, true);
>>>>> -	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
>>>>> +	test_restricted_net_fixture(_metadata, &srv_denied, true, true, false);
>>>>> +	test_restricted_net_fixture(_metadata, &srv_max_allowed, false, false,
>>>>> +				    false);
>>>>>    }
>>>>>    FIXTURE(ipv4_tcp)
>>>>> @@ -1485,22 +1503,21 @@ FIXTURE_TEARDOWN(ipv4_tcp)
>>>>>    TEST_F(ipv4_tcp, port_endianness)
>>>>>    {
>>>>>    	const struct landlock_ruleset_attr ruleset_attr = {
>>>>> -		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		.handled_access_net = ACCESS_ALL,
>>>>>    	};
>>>>>    	const struct landlock_net_port_attr bind_host_endian_p0 = {
>>>>>    		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>>>>    		/* Host port format. */
>>>>>    		.port = self->srv0.port,
>>>>>    	};
>>>>> -	const struct landlock_net_port_attr connect_big_endian_p0 = {
>>>>> -		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +	const struct landlock_net_port_attr connect_listen_big_endian_p0 = {
>>>>> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP |
>>>>> +				  LANDLOCK_ACCESS_NET_LISTEN_TCP,
>>>>>    		/* Big endian port format. */
>>>>>    		.port = htons(self->srv0.port),
>>>>>    	};
>>>>> -	const struct landlock_net_port_attr bind_connect_host_endian_p1 = {
>>>>> -		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +	const struct landlock_net_port_attr not_restricted_host_endian_p1 = {
>>>>> +		.allowed_access = ACCESS_ALL,
>>>>>    		/* Host port format. */
>>>>>    		.port = self->srv1.port,
>>>>>    	};
>>>>> @@ -1514,16 +1531,18 @@ TEST_F(ipv4_tcp, port_endianness)
>>>>>    	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>>    				       &bind_host_endian_p0, 0));
>>>>>    	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -				       &connect_big_endian_p0, 0));
>>>>> +				       &connect_listen_big_endian_p0, 0));
>>>>>    	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -				       &bind_connect_host_endian_p1, 0));
>>>>> +				       &not_restricted_host_endian_p1, 0));
>>>>>    	enforce_ruleset(_metadata, ruleset_fd);
>>>>>    	/* No restriction for big endinan CPU. */
>>>>> -	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>>>>> +				    little_endian, little_endian);
>>>>>    	/* No restriction for any CPU. */
>>>>> -	test_bind_and_connect(_metadata, &self->srv1, false, false);
>>>>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
>>>>> +				    false);
>>>>>    }
>>>>>    TEST_F(ipv4_tcp, with_fs)
>>>>> @@ -1691,7 +1710,7 @@ TEST_F(port_specific, bind_connect_zero)
>>>>>    	ret = bind_variant(bind_fd, &self->srv0);
>>>>>    	EXPECT_EQ(0, ret);
>>>>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>>>>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>>>>    	/* Connects on port 0. */
>>>>>    	ret = connect_variant(connect_fd, &self->srv0);
>>>>> @@ -1714,26 +1733,23 @@ TEST_F(port_specific, bind_connect_zero)
>>>>>    	EXPECT_EQ(0, close(bind_fd));
>>>>>    }
>>>>> -TEST_F(port_specific, bind_connect_1023)
>>>>> +TEST_F(port_specific, port_1023)
>>>>>    {
>>>>>    	int bind_fd, connect_fd, ret;
>>>>> -	/* Adds a rule layer with bind and connect actions. */
>>>>> +	/* Adds a rule layer with all actions. */
>>>>>    	if (variant->sandbox == TCP_SANDBOX) {
>>>>>    		const struct landlock_ruleset_attr ruleset_attr = {
>>>>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP
>>>>> +			.handled_access_net = ACCESS_ALL
>>>>>    		};
>>>>>    		/* A rule with port value less than 1024. */
>>>>> -		const struct landlock_net_port_attr tcp_bind_connect_low_range = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_low_range_port = {
>>>>> +			.allowed_access = ACCESS_ALL,
>>>>>    			.port = 1023,
>>>>>    		};
>>>>>    		/* A rule with 1024 port. */
>>>>> -		const struct landlock_net_port_attr tcp_bind_connect = {
>>>>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>>> +		const struct landlock_net_port_attr tcp_port_1024 = {
>>>>> +			.allowed_access = ACCESS_ALL,
>>>>>    			.port = 1024,
>>>>>    		};
>>>>>    		int ruleset_fd;
>>>>> @@ -1744,10 +1760,10 @@ TEST_F(port_specific, bind_connect_1023)
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_bind_connect_low_range, 0));
>>>>> +					    &tcp_low_range_port, 0));
>>>>>    		ASSERT_EQ(0,
>>>>>    			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>>>> -					    &tcp_bind_connect, 0));
>>>>> +					    &tcp_port_1024, 0));
>>>>>    		enforce_ruleset(_metadata, ruleset_fd);
>>>>>    		EXPECT_EQ(0, close(ruleset_fd));
>>>>> @@ -1771,7 +1787,7 @@ TEST_F(port_specific, bind_connect_1023)
>>>>>    	ret = bind_variant(bind_fd, &self->srv0);
>>>>>    	clear_cap(_metadata, CAP_NET_BIND_SERVICE);
>>>>>    	EXPECT_EQ(0, ret);
>>>>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>>>>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>>>>    	/* Connects on the binded port 1023. */
>>>>>    	ret = connect_variant(connect_fd, &self->srv0);
>>>>> @@ -1791,7 +1807,7 @@ TEST_F(port_specific, bind_connect_1023)
>>>>>    	/* Binds on port 1024. */
>>>>>    	ret = bind_variant(bind_fd, &self->srv0);
>>>>>    	EXPECT_EQ(0, ret);
>>>>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>>>>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>>>>    	/* Connects on the binded port 1024. */
>>>>>    	ret = connect_variant(connect_fd, &self->srv0);
>>>>> -- 
>>>>> 2.34.1
>>>>>
>>>>
>>>> —Günther
>>
