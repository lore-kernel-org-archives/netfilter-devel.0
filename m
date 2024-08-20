Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784CF18FDB7;
	Tue, 20 Aug 2024 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724157142; cv=none; b=I8WaJgYZjpEHq77IgS05+EBv88xcN/Grb4MQEwyYmRPL1fu/OQsKdMGnxCdqYR4i4bDBYcKizz2LGH6bJ5/9fOK0K1254MSB0alT57mSJitgXAFjCekOX/AJidIkJt4U8hoyhqtMQmDfCDsFytQ7q1ZsGLYRo1V7j36Y+Dnkx/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724157142; c=relaxed/simple;
	bh=0gVkYi5xoB6ZD/MyFff6jmqNz/K/xJkYBvUN6uZEgwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=T8VoWbVwpgMaOzFd/AFrZTIfdDKH/NPAdORE9QnlKwiwPAv5ltbI2RinlDf1rHOSr8VYXj362vWGgGMuCO3dkaH+q0HZInWXyMDqp1uFu9p/GbzBYVDVfRtDaesHiv073d/WvOduDbFx5TrreCWPRBfl0qExjNeHuAiZY6Hd7oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wp7yB3cPXz2CmvJ;
	Tue, 20 Aug 2024 20:27:14 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id 519F41401F2;
	Tue, 20 Aug 2024 20:32:14 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 20:32:10 +0800
Message-ID: <2f67fa30-d4e6-3a1b-7166-eee33c734899@huawei-partners.com>
Date: Tue, 20 Aug 2024 15:32:06 +0300
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
To: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>
CC: <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
	<gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-4-ivanov.mikhail1@huawei-partners.com>
 <ZsO-pIGsTl6T5AL1@google.com>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <ZsO-pIGsTl6T5AL1@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 dggpemm500020.china.huawei.com (7.185.36.49)

8/20/2024 12:52 AM, Günther Noack wrote:
> On Wed, Aug 14, 2024 at 11:01:45AM +0800, Mikhail Ivanov wrote:
>> * Add listen_variant() to simplify listen(2) return code checking.
>> * Rename test_bind_and_connect() to test_restricted_net_fixture().
>> * Extend current net rules with LANDLOCK_ACCESS_NET_LISTEN_TCP access.
>> * Rename test port_specific.bind_connect_1023 to
>>    port_specific.port_1023.
>> * Check little endian port restriction for listen in
>>    ipv4_tcp.port_endianness.
>> * Some local renames and comment changes.
>>
>> Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 198 +++++++++++---------
>>   1 file changed, 107 insertions(+), 91 deletions(-)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index f21cfbbc3638..8126f5c0160f 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -2,7 +2,7 @@
>>   /*
>>    * Landlock tests - Network
>>    *
>> - * Copyright © 2022-2023 Huawei Tech. Co., Ltd.
>> + * Copyright © 2022-2024 Huawei Tech. Co., Ltd.
>>    * Copyright © 2023 Microsoft Corporation
>>    */
>>   
>> @@ -22,6 +22,17 @@
>>   
>>   #include "common.h"
>>   
>> +/* clang-format off */
>> +
>> +#define ACCESS_LAST LANDLOCK_ACCESS_NET_LISTEN_TCP
>> +
>> +#define ACCESS_ALL ( \
>> +	LANDLOCK_ACCESS_NET_BIND_TCP | \
>> +	LANDLOCK_ACCESS_NET_CONNECT_TCP | \
>> +	LANDLOCK_ACCESS_NET_LISTEN_TCP)
>> +
>> +/* clang-format on */
>> +
>>   const short sock_port_start = (1 << 10);
>>   
>>   static const char loopback_ipv4[] = "127.0.0.1";
>> @@ -282,6 +293,16 @@ static int connect_variant(const int sock_fd,
>>   	return connect_variant_addrlen(sock_fd, srv, get_addrlen(srv, false));
>>   }
>>   
>> +static int listen_variant(const int sock_fd, const int backlog)
> 
> I believe socket_variant(), connect_variant() and bind_variant() were called
> like that because they got an instance of a service_fixture as an argument.  The
> fixture instances are called variants.  But we don't use these fixtures here.
> 
> In fs_test.c, we also have some functions that behave much like system calls,
> but clean up after themselves and return errno, for easier use in assert.  The
> naming scheme we have used there is "test_foo" (e.g. test_open()).  I think this
> would be more appropriate here as a name?
I think such naming is suitable when a function represents a simple
separate test for specific operation that doesn't affect the behavior
of the caller. In current case we just need a wrapper under listen(2)
which returns -errno on failure. Pros of "listen_variant()" is that
it follows the style of other tested syscall helpers ("bind_variant()",
..) but it does seem to be semantically incorrect indeed.

I suggest using a listen(2) synonym - "do_listen()". WDYT?

> 
>> +{
>> +	int ret;
>> +
>> +	ret = listen(sock_fd, backlog);
>> +	if (ret < 0)
>> +		return -errno;
>> +	return ret;
>> +}
>> +
>>   FIXTURE(protocol)
>>   {
>>   	struct service_fixture srv0, srv1, srv2, unspec_any0, unspec_srv0;
>> @@ -438,9 +459,11 @@ FIXTURE_VARIANT_ADD(protocol, tcp_sandbox_with_unix_datagram) {
>>   	},
>>   };
>>   
>> -static void test_bind_and_connect(struct __test_metadata *const _metadata,
>> -				  const struct service_fixture *const srv,
>> -				  const bool deny_bind, const bool deny_connect)
>> +static void test_restricted_net_fixture(struct __test_metadata *const _metadata,
>> +					const struct service_fixture *const srv,
>> +					const bool deny_bind,
>> +					const bool deny_connect,
>> +					const bool deny_listen)
>>   {
>>   	char buf = '\0';
>>   	int inval_fd, bind_fd, client_fd, status, ret;
>> @@ -512,8 +535,14 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>   		EXPECT_EQ(0, ret);
>>   
>>   		/* Creates a listening socket. */
>> -		if (srv->protocol.type == SOCK_STREAM)
>> -			EXPECT_EQ(0, listen(bind_fd, backlog));
>> +		if (srv->protocol.type == SOCK_STREAM) {
>> +			ret = listen_variant(bind_fd, backlog);
>> +			if (deny_listen) {
>> +				EXPECT_EQ(-EACCES, ret);
>> +			} else {
>> +				EXPECT_EQ(0, ret);
>> +			}
> 
> Hmm, passing the expected error code instead of a boolean to this function was not possible?
> Then you could just write
> 
>    EXPECT_EQ(expected_listen_error, listen_variant(bind_fd, backlog));
> 
> ?  (Apologies if this was discussed already.)

deny_* arguments are required not only to check an appropriate syscall
behavior. They also test and control the behavior of other operations in
the current helper (e.g. connect(2) returns -ECONNREFUSED on
"deny_bind | deny_listen", listen(2) is not called if deny_bind is set).

> 
>> +		}
>>   	}
>>   
>>   	child = fork();
>> @@ -530,7 +559,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>   		ret = connect_variant(connect_fd, srv);
>>   		if (deny_connect) {
>>   			EXPECT_EQ(-EACCES, ret);
>> -		} else if (deny_bind) {
>> +		} else if (deny_bind || deny_listen) {
>>   			/* No listening server. */
>>   			EXPECT_EQ(-ECONNREFUSED, ret);
>>   		} else {
>> @@ -545,7 +574,7 @@ static void test_bind_and_connect(struct __test_metadata *const _metadata,
>>   
>>   	/* Accepts connection from the child. */
>>   	client_fd = bind_fd;
>> -	if (!deny_bind && !deny_connect) {
>> +	if (!deny_bind && !deny_connect && !deny_listen) {
>>   		if (srv->protocol.type == SOCK_STREAM) {
>>   			client_fd = accept(bind_fd, NULL, 0);
>>   			ASSERT_LE(0, client_fd);
>> @@ -571,16 +600,15 @@ TEST_F(protocol, bind)
>>   {
>>   	if (variant->sandbox == TCP_SANDBOX) {
>>   		const struct landlock_ruleset_attr ruleset_attr = {
>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +			.handled_access_net = ACCESS_ALL,
>>   		};
>> -		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>> +			.allowed_access = ACCESS_ALL,
>>   			.port = self->srv0.port,
>>   		};
>> -		const struct landlock_net_port_attr tcp_connect_p1 = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		const struct landlock_net_port_attr tcp_denied_bind_p1 = {
>> +			.allowed_access = ACCESS_ALL &
>> +					  ~LANDLOCK_ACCESS_NET_BIND_TCP,
>>   			.port = self->srv1.port,
>>   		};
>>   		int ruleset_fd;
>> @@ -589,48 +617,47 @@ TEST_F(protocol, bind)
>>   						     sizeof(ruleset_attr), 0);
>>   		ASSERT_LE(0, ruleset_fd);
>>   
>> -		/* Allows connect and bind for the first port.  */
>> +		/* Allows all actions for the first port. */
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_bind_connect_p0, 0));
>> +					    &tcp_not_restricted_p0, 0));
>>   
>> -		/* Allows connect and denies bind for the second port. */
>> +		/* Allows all actions despite bind. */
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_connect_p1, 0));
>> +					    &tcp_denied_bind_p1, 0));
>>   
>>   		enforce_ruleset(_metadata, ruleset_fd);
>>   		EXPECT_EQ(0, close(ruleset_fd));
>>   	}
>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>>   
>>   	/* Binds a socket to the first port. */
>> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>> +				    false);
>>   
>>   	/* Binds a socket to the second port. */
>> -	test_bind_and_connect(_metadata, &self->srv1,
>> -			      is_restricted(&variant->prot, variant->sandbox),
>> -			      false);
>> +	test_restricted_net_fixture(_metadata, &self->srv1, restricted, false,
>> +				    false);
>>   
>>   	/* Binds a socket to the third port. */
>> -	test_bind_and_connect(_metadata, &self->srv2,
>> -			      is_restricted(&variant->prot, variant->sandbox),
>> -			      is_restricted(&variant->prot, variant->sandbox));
>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>> +				    restricted, restricted);
>>   }
>>   
>>   TEST_F(protocol, connect)
>>   {
>>   	if (variant->sandbox == TCP_SANDBOX) {
>>   		const struct landlock_ruleset_attr ruleset_attr = {
>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +			.handled_access_net = ACCESS_ALL,
>>   		};
>> -		const struct landlock_net_port_attr tcp_bind_connect_p0 = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		const struct landlock_net_port_attr tcp_not_restricted_p0 = {
>> +			.allowed_access = ACCESS_ALL,
>>   			.port = self->srv0.port,
>>   		};
>> -		const struct landlock_net_port_attr tcp_bind_p1 = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +		const struct landlock_net_port_attr tcp_denied_connect_p1 = {
>> +			.allowed_access = ACCESS_ALL &
>> +					  ~LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>   			.port = self->srv1.port,
>>   		};
>>   		int ruleset_fd;
>> @@ -639,28 +666,27 @@ TEST_F(protocol, connect)
>>   						     sizeof(ruleset_attr), 0);
>>   		ASSERT_LE(0, ruleset_fd);
>>   
>> -		/* Allows connect and bind for the first port. */
>> +		/* Allows all actions for the first port. */
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_bind_connect_p0, 0));
>> +					    &tcp_not_restricted_p0, 0));
>>   
>> -		/* Allows bind and denies connect for the second port. */
>> +		/* Allows all actions despite connect. */
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_bind_p1, 0));
>> +					    &tcp_denied_connect_p1, 0));
>>   
>>   		enforce_ruleset(_metadata, ruleset_fd);
>>   		EXPECT_EQ(0, close(ruleset_fd));
>>   	}
>> -
>> -	test_bind_and_connect(_metadata, &self->srv0, false, false);
>> -
>> -	test_bind_and_connect(_metadata, &self->srv1, false,
>> -			      is_restricted(&variant->prot, variant->sandbox));
>> -
>> -	test_bind_and_connect(_metadata, &self->srv2,
>> -			      is_restricted(&variant->prot, variant->sandbox),
>> -			      is_restricted(&variant->prot, variant->sandbox));
>> +	bool restricted = is_restricted(&variant->prot, variant->sandbox);
>> +
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false, false,
>> +				    false);
>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, restricted,
>> +				    false);
>> +	test_restricted_net_fixture(_metadata, &self->srv2, restricted,
>> +				    restricted, restricted);
>>   }
>>   
>>   TEST_F(protocol, bind_unspec)
>> @@ -761,7 +787,7 @@ TEST_F(protocol, connect_unspec)
>>   	ASSERT_LE(0, bind_fd);
>>   	EXPECT_EQ(0, bind_variant(bind_fd, &self->srv0));
>>   	if (self->srv0.protocol.type == SOCK_STREAM)
>> -		EXPECT_EQ(0, listen(bind_fd, backlog));
>> +		EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>   
>>   	child = fork();
>>   	ASSERT_LE(0, child);
>> @@ -1127,8 +1153,8 @@ TEST_F(tcp_layers, ruleset_overlap)
>>   	 * Forbids to connect to the socket because only one ruleset layer
>>   	 * allows connect.
>>   	 */
>> -	test_bind_and_connect(_metadata, &self->srv0, false,
>> -			      variant->num_layers >= 2);
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>> +				    variant->num_layers >= 2, false);
>>   }
>>   
>>   TEST_F(tcp_layers, ruleset_expand)
>> @@ -1208,11 +1234,12 @@ TEST_F(tcp_layers, ruleset_expand)
>>   		EXPECT_EQ(0, close(ruleset_fd));
>>   	}
>>   
>> -	test_bind_and_connect(_metadata, &self->srv0, false,
>> -			      variant->num_layers >= 3);
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>> +				    variant->num_layers >= 3, false);
>>   
>> -	test_bind_and_connect(_metadata, &self->srv1, variant->num_layers >= 1,
>> -			      variant->num_layers >= 2);
>> +	test_restricted_net_fixture(_metadata, &self->srv1,
>> +				    variant->num_layers >= 1,
>> +				    variant->num_layers >= 2, false);
>>   }
>>   
>>   /* clang-format off */
>> @@ -1230,16 +1257,6 @@ FIXTURE_TEARDOWN(mini)
>>   {
>>   }
>>   
>> -/* clang-format off */
>> -
>> -#define ACCESS_LAST LANDLOCK_ACCESS_NET_CONNECT_TCP
>> -
>> -#define ACCESS_ALL ( \
>> -	LANDLOCK_ACCESS_NET_BIND_TCP | \
>> -	LANDLOCK_ACCESS_NET_CONNECT_TCP)
>> -
>> -/* clang-format on */
>> -
>>   TEST_F(mini, network_access_rights)
>>   {
>>   	const struct landlock_ruleset_attr ruleset_attr = {
>> @@ -1454,8 +1471,9 @@ TEST_F(mini, tcp_port_overflow)
>>   
>>   	enforce_ruleset(_metadata, ruleset_fd);
>>   
>> -	test_bind_and_connect(_metadata, &srv_denied, true, true);
>> -	test_bind_and_connect(_metadata, &srv_max_allowed, false, false);
>> +	test_restricted_net_fixture(_metadata, &srv_denied, true, true, false);
>> +	test_restricted_net_fixture(_metadata, &srv_max_allowed, false, false,
>> +				    false);
>>   }
>>   
>>   FIXTURE(ipv4_tcp)
>> @@ -1485,22 +1503,21 @@ FIXTURE_TEARDOWN(ipv4_tcp)
>>   TEST_F(ipv4_tcp, port_endianness)
>>   {
>>   	const struct landlock_ruleset_attr ruleset_attr = {
>> -		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		.handled_access_net = ACCESS_ALL,
>>   	};
>>   	const struct landlock_net_port_attr bind_host_endian_p0 = {
>>   		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>   		/* Host port format. */
>>   		.port = self->srv0.port,
>>   	};
>> -	const struct landlock_net_port_attr connect_big_endian_p0 = {
>> -		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +	const struct landlock_net_port_attr connect_listen_big_endian_p0 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP |
>> +				  LANDLOCK_ACCESS_NET_LISTEN_TCP,
>>   		/* Big endian port format. */
>>   		.port = htons(self->srv0.port),
>>   	};
>> -	const struct landlock_net_port_attr bind_connect_host_endian_p1 = {
>> -		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +	const struct landlock_net_port_attr not_restricted_host_endian_p1 = {
>> +		.allowed_access = ACCESS_ALL,
>>   		/* Host port format. */
>>   		.port = self->srv1.port,
>>   	};
>> @@ -1514,16 +1531,18 @@ TEST_F(ipv4_tcp, port_endianness)
>>   	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>>   				       &bind_host_endian_p0, 0));
>>   	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -				       &connect_big_endian_p0, 0));
>> +				       &connect_listen_big_endian_p0, 0));
>>   	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -				       &bind_connect_host_endian_p1, 0));
>> +				       &not_restricted_host_endian_p1, 0));
>>   	enforce_ruleset(_metadata, ruleset_fd);
>>   
>>   	/* No restriction for big endinan CPU. */
>> -	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
>> +	test_restricted_net_fixture(_metadata, &self->srv0, false,
>> +				    little_endian, little_endian);
>>   
>>   	/* No restriction for any CPU. */
>> -	test_bind_and_connect(_metadata, &self->srv1, false, false);
>> +	test_restricted_net_fixture(_metadata, &self->srv1, false, false,
>> +				    false);
>>   }
>>   
>>   TEST_F(ipv4_tcp, with_fs)
>> @@ -1691,7 +1710,7 @@ TEST_F(port_specific, bind_connect_zero)
>>   	ret = bind_variant(bind_fd, &self->srv0);
>>   	EXPECT_EQ(0, ret);
>>   
>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>   
>>   	/* Connects on port 0. */
>>   	ret = connect_variant(connect_fd, &self->srv0);
>> @@ -1714,26 +1733,23 @@ TEST_F(port_specific, bind_connect_zero)
>>   	EXPECT_EQ(0, close(bind_fd));
>>   }
>>   
>> -TEST_F(port_specific, bind_connect_1023)
>> +TEST_F(port_specific, port_1023)
>>   {
>>   	int bind_fd, connect_fd, ret;
>>   
>> -	/* Adds a rule layer with bind and connect actions. */
>> +	/* Adds a rule layer with all actions. */
>>   	if (variant->sandbox == TCP_SANDBOX) {
>>   		const struct landlock_ruleset_attr ruleset_attr = {
>> -			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					      LANDLOCK_ACCESS_NET_CONNECT_TCP
>> +			.handled_access_net = ACCESS_ALL
>>   		};
>>   		/* A rule with port value less than 1024. */
>> -		const struct landlock_net_port_attr tcp_bind_connect_low_range = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		const struct landlock_net_port_attr tcp_low_range_port = {
>> +			.allowed_access = ACCESS_ALL,
>>   			.port = 1023,
>>   		};
>>   		/* A rule with 1024 port. */
>> -		const struct landlock_net_port_attr tcp_bind_connect = {
>> -			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> -					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		const struct landlock_net_port_attr tcp_port_1024 = {
>> +			.allowed_access = ACCESS_ALL,
>>   			.port = 1024,
>>   		};
>>   		int ruleset_fd;
>> @@ -1744,10 +1760,10 @@ TEST_F(port_specific, bind_connect_1023)
>>   
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_bind_connect_low_range, 0));
>> +					    &tcp_low_range_port, 0));
>>   		ASSERT_EQ(0,
>>   			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
>> -					    &tcp_bind_connect, 0));
>> +					    &tcp_port_1024, 0));
>>   
>>   		enforce_ruleset(_metadata, ruleset_fd);
>>   		EXPECT_EQ(0, close(ruleset_fd));
>> @@ -1771,7 +1787,7 @@ TEST_F(port_specific, bind_connect_1023)
>>   	ret = bind_variant(bind_fd, &self->srv0);
>>   	clear_cap(_metadata, CAP_NET_BIND_SERVICE);
>>   	EXPECT_EQ(0, ret);
>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>   
>>   	/* Connects on the binded port 1023. */
>>   	ret = connect_variant(connect_fd, &self->srv0);
>> @@ -1791,7 +1807,7 @@ TEST_F(port_specific, bind_connect_1023)
>>   	/* Binds on port 1024. */
>>   	ret = bind_variant(bind_fd, &self->srv0);
>>   	EXPECT_EQ(0, ret);
>> -	EXPECT_EQ(0, listen(bind_fd, backlog));
>> +	EXPECT_EQ(0, listen_variant(bind_fd, backlog));
>>   
>>   	/* Connects on the binded port 1024. */
>>   	ret = connect_variant(connect_fd, &self->srv0);
>> -- 
>> 2.34.1
>>
> 
> —Günther
