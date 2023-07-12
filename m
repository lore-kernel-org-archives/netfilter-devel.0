Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C69EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 07:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjGLHCZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 03:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjGLHCY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 03:02:24 -0400
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc08])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35397139
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2023 00:02:22 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4R17wC505VzMqCst;
        Wed, 12 Jul 2023 07:02:19 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4R17wB5TwJzMpssQ;
        Wed, 12 Jul 2023 09:02:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1689145339;
        bh=uBFEgv+D43qz/E8Ty4/xC3D5uopMDIzrTHD3MKLr97c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=b0sMtGycYRG+VewQ/EZ+jNYhMeOm+g2HMo+5zUSQo2TBDRJTvuZ+ix4Piabsn2MlW
         IJrD07BVLbGPN8S/6n2PLeFamLDlbJDrpsR2fsOuSNrSAl0g7j/t9MsmDbg5yW6Lw9
         ky1piJDYjJMh+f4ob+6+V6bO58tq+MrTxkxfyiqg=
Message-ID: <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
Date:   Wed, 12 Jul 2023 09:02:17 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com, yusongping@huawei.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230706145543.1284007-1-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 06/07/2023 16:55, Mickaël Salaün wrote:
> From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
> This patch is a revamp of the v11 tests [1] with new tests (see the
> "Changes since v11" description).  I (Mickaël) only added the following
> todo list and the "Changes since v11" sections in this commit message.
> I think this patch is good but it would appreciate reviews.
> You can find the diff of my changes here but it is not really readable:
> https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
> [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
> TODO:
> - Rename all "net_service" to "net_port".
> - Fix the two kernel bugs found with the new tests.
> - Update this commit message with a small description of all tests.

[...]

> +FIXTURE_SETUP(ipv4)
> +{
> +	const struct protocol_variant prot = {
> +		.domain = AF_INET,
> +		.type = variant->type,
> +	};
> +
> +	disable_caps(_metadata);
> +
> +	set_service(&self->srv0, prot, 0);
> +	set_service(&self->srv1, prot, 1);
> +
> +	setup_loopback(_metadata);
> +};
> +
> +FIXTURE_TEARDOWN(ipv4)
> +{
> +}
> +
> +// Kernel FIXME: tcp_sandbox_with_tcp and tcp_sandbox_with_udp
> +TEST_F(ipv4, from_unix_to_inet)
> +{
> +	int unix_stream_fd, unix_dgram_fd;
> +
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		};
> +		const struct landlock_net_service_attr tcp_bind_connect_p0 = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +			.port = self->srv0.port,
> +		};
> +		int ruleset_fd;
> +
> +		/* Denies connect and bind to check errno value. */
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Allows connect and bind for srv0.  */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &tcp_bind_connect_p0, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	unix_stream_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, unix_stream_fd);
> +
> +	unix_dgram_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, unix_dgram_fd);
> +
> +	/* Checks unix stream bind and connect for srv0. */
> +	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv0));
> +	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv0));
> +
> +	/* Checks unix stream bind and connect for srv1. */
> +	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv1))
> +	{
> +		TH_LOG("Wrong bind error: %s", strerror(errno));
> +	}
> +	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv1));
> +
> +	/* Checks unix datagram bind and connect for srv0. */
> +	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv0));
> +	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv0));
> +
> +	/* Checks unix datagram bind and connect for srv0. */
> +	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv1));
> +	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv1));
> +}

We should also add a test to make sure errno is the same with and 
without sandboxing when using port 0 for connect and consistent with 
bind (using an available port). The test fixture and variants should be 
quite similar to the "ipv4" ones, but we can also add AF_INET6 variants, 
which will result in 8 "ip" variants:

TEST_F(ip, port_zero)
{
	if (variant->sandbox == TCP_SANDBOX) {
		/* Denies any connect and bind. */
	}
	/* Checks errno for port 0. */
}

[...]

> +FIXTURE(inet)
> +{
> +	struct service_fixture srv0, srv1;
> +};

The "inet" variants are useless and should be removed. The "inet" 
fixture can then be renamed to "ipv4_tcp".


> +
> +FIXTURE_VARIANT(inet)
> +{
> +	const bool is_sandboxed;
> +	const struct protocol_variant prot;
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv4) {
> +	/* clang-format on */
> +	.is_sandboxed = false,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv4) {
> +	/* clang-format on */
> +	.is_sandboxed = true,
> +	.prot = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, no_sandbox_with_ipv6) {
> +	/* clang-format on */
> +	.is_sandboxed = false,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(inet, sandbox_with_ipv6) {
> +	/* clang-format on */
> +	.is_sandboxed = true,
> +	.prot = {
> +		.domain = AF_INET6,
> +		.type = SOCK_STREAM,
> +	},
> +};
> +
> +FIXTURE_SETUP(inet)
> +{
> +	const struct protocol_variant ipv4_tcp = {
> +		.domain = AF_INET,
> +		.type = SOCK_STREAM,
> +	};
> +
> +	disable_caps(_metadata);
> +
> +	ASSERT_EQ(0, set_service(&self->srv0, ipv4_tcp, 0));
> +	ASSERT_EQ(0, set_service(&self->srv1, ipv4_tcp, 1));
> +
> +	setup_loopback(_metadata);
> +};
> +
> +FIXTURE_TEARDOWN(inet)
> +{
> +}
> +
> +TEST_F(inet, port_endianness)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	const struct landlock_net_service_attr bind_host_endian_p0 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		/* Host port format. */
> +		.port = self->srv0.port,
> +	};
> +	const struct landlock_net_service_attr connect_big_endian_p0 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		/* Big endian port format. */
> +		.port = htons(self->srv0.port),
> +	};
> +	const struct landlock_net_service_attr bind_connect_host_endian_p1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		/* Host port format. */
> +		.port = self->srv1.port,
> +	};
> +	const unsigned int one = 1;
> +	const char little_endian = *(const char *)&one;
> +	int ruleset_fd;
> +
> +	ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &bind_host_endian_p0, 0));
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &connect_big_endian_p0, 0));
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &bind_connect_host_endian_p1, 0));
> +	enforce_ruleset(_metadata, ruleset_fd);
> +
> +	/* No restriction for big endinan CPU. */
> +	test_bind_and_connect(_metadata, &self->srv0, false, little_endian);
> +
> +	/* No restriction for any CPU. */
> +	test_bind_and_connect(_metadata, &self->srv1, false, false);
> +}
> +
> +TEST_HARNESS_MAIN
