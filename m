Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F70CDB483
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjJRMcZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjJRMcY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:32:24 -0400
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [45.157.188.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAB4A3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 05:32:20 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4S9Vbl2NjJzMpnw0;
        Wed, 18 Oct 2023 12:32:19 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4S9Vbk67HWzMppC1;
        Wed, 18 Oct 2023 14:32:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1697632339;
        bh=aa6pncm5zcJg8l7+9ze3hApwsDn1Pd9rDGyYpu5vSwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NyCP1/w2a1cjV3HpgUYxh2HJvelTd4aETIf7GDcefxYpL1WK8DjPOqnuDJdrPLHDg
         uWPzxnTmOVPq4UbNNUGRd5OuuX64CdiJe3fOcSV7mUdaB04JLU9Es0JjUO4bdNHkTT
         khZ914nGczSAlwFfR4Z/w8CPhkf2Pj0UVfmJfMII=
Date:   Wed, 18 Oct 2023 14:32:17 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v13 10/12] selftests/landlock: Add 7 new test variants
 dedicated to network
Message-ID: <20231016.phei8Is2weod@digikod.net>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-11-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231016015030.1684504-11-konstantin.meskhidze@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

You can update the subject with:
"selftests/landlock: Add network tests"

On Mon, Oct 16, 2023 at 09:50:28AM +0800, Konstantin Meskhidze wrote:
> These test suites try to check edge cases for TCP sockets
> bind() and connect() actions.

You can replace with that:
Add 77 test suites to check edge cases related to bind() and connect()
actions. They are defined with 6 fixtures and their variants:

> 
> protocol:
> * bind: Tests with non-landlocked/landlocked ipv4, ipv6 and unix sockets.

As you already did, you can write one paragraph per fixture, but
starting by explaining the fixture and its related variants, and then
listing the tests and explaining their specificities. For instance:

The "protocol" fixture is extended with 12 variants defined as a matrix
of: sandboxed/not-sandboxed, IPv4/IPv6/unix network domain, and
stream/datagram socket. 4 related tests suites are defined:
* bind: Test bind combinations with increasingly more
  restricting domains.
* connect: Test connect combinations with increasingly more
  restricting domains.
...

s/ipv/IPv/g

> * connect: Tests with non-landlocked/landlocked ipv4, ipv6 and unix
> sockets.
> * bind_unspec: Tests with non-landlocked/landlocked restrictions
> for bind action with AF_UNSPEC socket family.
> * connect_unspec: Tests with non-landlocked/landlocked restrictions
> for connect action with AF_UNSPEC socket family.
> 
> ipv4:
> * from_unix_to_inet: Tests to make sure unix sockets' actions are not
> restricted by Landlock rules applied to TCP ones.
> 
> tcp_layers:
> * ruleset_overlap.
> * ruleset_expand.
> 
> mini:
> * network_access_rights: Tests with  legitimate access values.
> * unknown_access_rights: Tests with invalid attributes, out of access range.
> * inval:
>     - unhandled allowed access.
>     - zero access value.
> * tcp_port_overflow: Tests with wrong port values more than U16_MAX.
> 
> ipv4_tcp:
> * port_endianness: Tests with big/little endian port formats.
> 
> port_specific:
> * bind_connect: Tests with specific port values.
> 
> layout1:
> * with_net: Tests with network bind() socket action within
> filesystem directory access test.
> 
> Test coverage for security/landlock is 94.5% of 932 lines according
> to gcc/gcov-11.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> Link: https://lore.kernel.org/r/20230920092641.832134-11-konstantin.meskhidze@huawei.com
> Co-developed-by:: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> ---
> 
> Changes since v12:
> * Renames port_zero to port_specific fixture.
> * Refactors port_specific test:
>     - Adds set_port() and get_binded_port() helpers.
>     - Adds checks for port 0, allowed by Landlock in this version.
>     - Adds checks for port 1023.
> * Refactors commit message.
> 

> +static void set_port(struct service_fixture *const srv, in_port_t port)
> +{
> +	switch (srv->protocol.domain) {
> +	case AF_UNSPEC:
> +	case AF_INET:
> +		srv->ipv4_addr.sin_port = port;

We should call htons() here, and make port a uint16_t.

> +		return;
> +
> +	case AF_INET6:
> +		srv->ipv6_addr.sin6_port = port;
> +		return;
> +
> +	default:
> +		return;
> +	}
> +}
> +
> +static in_port_t get_binded_port(int socket_fd,

The returned type should be uint16_t (i.e. host endianess).

> +				 const struct protocol_variant *const prot)
> +{
> +	struct sockaddr_in ipv4_addr;
> +	struct sockaddr_in6 ipv6_addr;
> +	socklen_t ipv4_addr_len, ipv6_addr_len;
> +
> +	/* Gets binded port. */
> +	switch (prot->domain) {
> +	case AF_UNSPEC:
> +	case AF_INET:
> +		ipv4_addr_len = sizeof(ipv4_addr);
> +		getsockname(socket_fd, &ipv4_addr, &ipv4_addr_len);
> +		return ntohs(ipv4_addr.sin_port);
> +
> +	case AF_INET6:
> +		ipv6_addr_len = sizeof(ipv6_addr);
> +		getsockname(socket_fd, &ipv6_addr, &ipv6_addr_len);
> +		return ntohs(ipv6_addr.sin6_port);
> +
> +	default:
> +		return 0;
> +	}
> +}

These are good helpers!


> +FIXTURE_TEARDOWN(ipv4)
> +{
> +}
> +
> +// Kernel FIXME: tcp_sandbox_with_tcp and tcp_sandbox_with_udp

No FIXME should remain.

> +TEST_F(ipv4, from_unix_to_inet)

> +TEST_F(mini, network_access_rights)
> +{
> +	const struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = ACCESS_ALL,
> +	};
> +	struct landlock_net_port_attr net_service = {

Please rename to "net_port" everywhere.

> +TEST_F(port_specific, bind_connect)
> +{
> +	int socket_fd, ret;
> +
> +	/* Adds the first rule layer with bind and connect actions. */
> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> +		};
> +		const struct landlock_net_port_attr tcp_bind_connect_zero = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +			.port = htons(0),

We don't need any htons() calls anymore. It doesn't change the 0 value
in this case but this is not correct.

> +		};
> +

Useless new line.

> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/* Checks zero port value on bind and connect actions. */
> +		EXPECT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_bind_connect_zero, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	socket_fd = socket_variant(&self->srv0);
> +	ASSERT_LE(0, socket_fd);
> +
> +	/* Sets address port to 0 for both protocol families. */
> +	set_port(&self->srv0, htons(0));

ditto

> +
> +	/* Binds on port 0. */
> +	ret = bind_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);
> +	} else {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);

If the results are the same, no need to add an if block.

> +	}
> +
> +	/* Connects on port 0. */
> +	ret = connect_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		EXPECT_EQ(-ECONNREFUSED, ret);
> +	} else {
> +		EXPECT_EQ(-ECONNREFUSED, ret);
> +	}

ditto

> +
> +	/* Binds on port 0. */

Please close sockets once they are used, and recreate one for another
bind/connect to avoid wrong checks.

> +	ret = bind_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);
> +	} else {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);
> +	}

Why this second bind() block? Furthermore, it is using the same
socket_fd.

> +
> +	/* Sets binded port for both protocol families. */
> +	set_port(&self->srv0,
> +		 htons(get_binded_port(socket_fd, &variant->prot)));

Ditto, these two endianess translations are useless.

You can also add this to make sure the returned port is not 0:
port = get_binded_port(socket_fd, &variant->prot);
EXPECT_NE(0, port);
set_port(&self->srv0, port);

> +
> +	/* Connects on the binded port. */
> +	ret = connect_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Denied by Landlock. */
> +		EXPECT_EQ(-EACCES, ret);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +
> +	EXPECT_EQ(0, close(socket_fd));
> +



> +	/* Adds the second rule layer with just bind action. */

There is not only bind actions here.

This second part of the tests should be in a dedicated
TEST_F(port_specific, bind_1023).

> +	if (variant->sandbox == TCP_SANDBOX) {
> +		const struct landlock_ruleset_attr ruleset_attr = {
> +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> +		};
> +
> +		const struct landlock_net_port_attr tcp_bind_zero = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +			.port = htons(0),
> +		};
> +

Useless new lines.

> +		/* A rule with port value less than 1024. */
> +		const struct landlock_net_port_attr tcp_bind_lower_range = {
> +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +			.port = htons(1023),
> +		};
> +

Useless new line.

> +		int ruleset_fd;
> +
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		ASSERT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_bind_lower_range, 0));
> +		ASSERT_EQ(0,
> +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> +					    &tcp_bind_zero, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd);
> +		EXPECT_EQ(0, close(ruleset_fd));
> +	}
> +
> +	socket_fd = socket_variant(&self->srv0);

We must have one socket FD dedicated to bind an another dedicated to
connect, e.g. bind_fd and connect_fd, an close them after each use,
otherwise tests might be inconsistent.

> +	ASSERT_LE(0, socket_fd);
> +
> +	/* Sets address port to 1023 for both protocol families. */
> +	set_port(&self->srv0, htons(1023));
> +
> +	/* Binds on port 1023. */
> +	ret = bind_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {

No need to add this check if the result is the same for sandboxed and
not sandboxed tests.

Instead, use set_cap(_metadata, CAP_NET_BIND_SERVICE) and clear_cap()
around this bind_variant() to make this test useful.

You will also need to patch common.h like this:
@@ -112,10 +112,13 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
        cap_t cap_p;
        /* Only these three capabilities are useful for the tests. */
        const cap_value_t caps[] = {
+               /* clang-format off */
                CAP_DAC_OVERRIDE,
                CAP_MKNOD,
                CAP_SYS_ADMIN,
                CAP_SYS_CHROOT,
+               CAP_NET_BIND_SERVICE,
+               /* clang-format on */
        };

> +		/* Denied by the system. */
> +		EXPECT_EQ(-EACCES, ret);
> +	} else {
> +		/* Denied by the system. */
> +		EXPECT_EQ(-EACCES, ret);
> +	}
> +

I don't see why the following part is useful. Why did you add it?
Why tcp_bind_zero?

The other parts are good though!

> +	/* Sets address port to 0 for both protocol families. */
> +	set_port(&self->srv0, htons(0));
> +
> +	/* Binds on port 0. */
> +	ret = bind_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);
> +	} else {
> +		/* Binds to a random port within ip_local_port_range. */
> +		EXPECT_EQ(0, ret);
> +	}
> +
> +	/* Sets binded port for both protocol families. */
> +	set_port(&self->srv0,
> +		 htons(get_binded_port(socket_fd, &variant->prot)));
> +
> +	/* Connects on the binded port. */
> +	ret = connect_variant(socket_fd, &self->srv0);
> +	if (is_restricted(&variant->prot, variant->sandbox)) {
> +		/* Denied by Landlock. */
> +		EXPECT_EQ(-EACCES, ret);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +
> +	EXPECT_EQ(0, close(socket_fd));
> +}
> +
> +TEST_HARNESS_MAIN
> --
> 2.25.1
> 
