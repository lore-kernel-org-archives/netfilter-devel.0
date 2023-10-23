Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE34C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 08:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjJWIob (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 04:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJWIoa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 04:44:30 -0400
Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [IPv6:2001:1600:3:17::42a9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07664D6E
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 01:44:24 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4SDTJR260GzMq5nY;
        Mon, 23 Oct 2023 08:44:23 +0000 (UTC)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4SDTJQ3y7RzMpnPh;
        Mon, 23 Oct 2023 10:44:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1698050663;
        bh=mRbxDt6BnKDvStM7SuOmxKeweRvRbzy4MfXVFI9gLes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+e8FtALGS3FlUB1tFlGEUtSiX7b5OoXeZKoy5nrJLfgfFj0O5cLLDlpPG0eSJ4Wk
         5iPu2AUtnAAKG72XdPW9QNrOxEytx1y+crlPAAV9z7+nJTNxwk6wvaXaw9Ba+Ez/nU
         v1uozPPIyBHjFPAW2cOs5PwFe4q2MuYhaZtVJ1Yc=
Date:   Mon, 23 Oct 2023 10:44:19 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v13 10/12] selftests/landlock: Add 7 new test variants
 dedicated to network
Message-ID: <20231023.DaeGeighe3qu@digikod.net>
References: <20231016015030.1684504-1-konstantin.meskhidze@huawei.com>
 <20231016015030.1684504-11-konstantin.meskhidze@huawei.com>
 <20231016.phei8Is2weod@digikod.net>
 <9fe690cb-a6ca-4c54-dd38-4d7a3cb02a4b@huawei.com>
 <20231020.zahs6Cahch6N@digikod.net>
 <36fcda5b-cd8d-1e2e-ff0d-3284ab60c06b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36fcda5b-cd8d-1e2e-ff0d-3284ab60c06b@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 23, 2023 at 10:09:54AM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 10/20/2023 6:40 PM, Mickaël Salaün пишет:
> > On Fri, Oct 20, 2023 at 02:41:42PM +0300, Konstantin Meskhidze (A) wrote:
> > > 
> > > 
> > > 10/18/2023 3:32 PM, Mickaël Salaün пишет:
> > > > You can update the subject with:
> > > > "selftests/landlock: Add network tests"
> > > 
> > > Ok.
> > > > > On Mon, Oct 16, 2023 at 09:50:28AM +0800, Konstantin Meskhidze
> > > wrote:
> > > > > These test suites try to check edge cases for TCP sockets
> > > > > bind() and connect() actions.
> > > > > You can replace with that:
> > > > Add 77 test suites to check edge cases related to bind() and connect()
> > > > actions. They are defined with 6 fixtures and their variants:
> > > > > > > > protocol:
> > > > > * bind: Tests with non-landlocked/landlocked ipv4, ipv6 and unix sockets.
> > > > > As you already did, you can write one paragraph per fixture, but
> > > > starting by explaining the fixture and its related variants, and then
> > > > listing the tests and explaining their specificities. For instance:
> > > > > The "protocol" fixture is extended with 12 variants defined as a
> > > matrix
> > > > of: sandboxed/not-sandboxed, IPv4/IPv6/unix network domain, and
> > > > stream/datagram socket. 4 related tests suites are defined:
> > > > * bind: Test bind combinations with increasingly more
> > > >    restricting domains.
> > > > * connect: Test connect combinations with increasingly more
> > > >    restricting domains.
> > > > ...
> > > 
> > >   Ok. Will be updated.
> > > > > s/ipv/IPv/g
> > > 
> > >   Got it. Thanks.
> > > > > > * connect: Tests with non-landlocked/landlocked ipv4, ipv6 and
> > > unix
> > > > > sockets.
> > > > > * bind_unspec: Tests with non-landlocked/landlocked restrictions
> > > > > for bind action with AF_UNSPEC socket family.
> > > > > * connect_unspec: Tests with non-landlocked/landlocked restrictions
> > > > > for connect action with AF_UNSPEC socket family.
> > > > > > > ipv4:
> > > > > * from_unix_to_inet: Tests to make sure unix sockets' actions are not
> > > > > restricted by Landlock rules applied to TCP ones.
> > > > > > > tcp_layers:
> > > > > * ruleset_overlap.
> > > > > * ruleset_expand.
> > > > > > > mini:
> > > > > * network_access_rights: Tests with  legitimate access values.
> > > > > * unknown_access_rights: Tests with invalid attributes, out of access range.
> > > > > * inval:
> > > > >     - unhandled allowed access.
> > > > >     - zero access value.
> > > > > * tcp_port_overflow: Tests with wrong port values more than U16_MAX.
> > > > > > > ipv4_tcp:
> > > > > * port_endianness: Tests with big/little endian port formats.
> > > > > > > port_specific:
> > > > > * bind_connect: Tests with specific port values.
> > > > > > > layout1:
> > > > > * with_net: Tests with network bind() socket action within
> > > > > filesystem directory access test.
> > > > > > > Test coverage for security/landlock is 94.5% of 932 lines
> > > according
> > > > > to gcc/gcov-11.
> > > > > > > Signed-off-by: Konstantin Meskhidze
> > > <konstantin.meskhidze@huawei.com>
> > > > > Link: https://lore.kernel.org/r/20230920092641.832134-11-konstantin.meskhidze@huawei.com
> > > > > Co-developed-by:: Mickaël Salaün <mic@digikod.net>
> > > > > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > > > > ---
> > > > > > > Changes since v12:
> > > > > * Renames port_zero to port_specific fixture.
> > > > > * Refactors port_specific test:
> > > > >     - Adds set_port() and get_binded_port() helpers.
> > > > >     - Adds checks for port 0, allowed by Landlock in this version.
> > > > >     - Adds checks for port 1023.
> > > > > * Refactors commit message.
> > > > > > > > +static void set_port(struct service_fixture *const srv,
> > > in_port_t port)
> > > > > +{
> > > > > +	switch (srv->protocol.domain) {
> > > > > +	case AF_UNSPEC:
> > > > > +	case AF_INET:
> > > > > +		srv->ipv4_addr.sin_port = port;
> > > > > We should call htons() here, and make port a uint16_t.
> > > 
> > >   Done.
> > > > > > +		return;
> > > > > +
> > > > > +	case AF_INET6:
> > > > > +		srv->ipv6_addr.sin6_port = port;
> > > > > +		return;
> > > > > +
> > > > > +	default:
> > > > > +		return;
> > > > > +	}
> > > > > +}
> > > > > +
> > > > > +static in_port_t get_binded_port(int socket_fd,
> > > > > The returned type should be uint16_t (i.e. host endianess).
> > > 
> > >   Done.
> > > > > > +				 const struct protocol_variant *const prot)
> > > > > +{
> > > > > +	struct sockaddr_in ipv4_addr;
> > > > > +	struct sockaddr_in6 ipv6_addr;
> > > > > +	socklen_t ipv4_addr_len, ipv6_addr_len;
> > > > > +
> > > > > +	/* Gets binded port. */
> > > > > +	switch (prot->domain) {
> > > > > +	case AF_UNSPEC:
> > > > > +	case AF_INET:
> > > > > +		ipv4_addr_len = sizeof(ipv4_addr);
> > > > > +		getsockname(socket_fd, &ipv4_addr, &ipv4_addr_len);
> > > > > +		return ntohs(ipv4_addr.sin_port);
> > > > > +
> > > > > +	case AF_INET6:
> > > > > +		ipv6_addr_len = sizeof(ipv6_addr);
> > > > > +		getsockname(socket_fd, &ipv6_addr, &ipv6_addr_len);
> > > > > +		return ntohs(ipv6_addr.sin6_port);
> > > > > +
> > > > > +	default:
> > > > > +		return 0;
> > > > > +	}
> > > > > +}
> > > > > These are good helpers!
> > > > > > > +FIXTURE_TEARDOWN(ipv4)
> > > > > +{
> > > > > +}
> > > > > +
> > > > > +// Kernel FIXME: tcp_sandbox_with_tcp and tcp_sandbox_with_udp
> > > > > No FIXME should remain.
> > > 
> > >   Ok. Deleted.
> > > > > > +TEST_F(ipv4, from_unix_to_inet)
> > > > > > +TEST_F(mini, network_access_rights)
> > > > > +{
> > > > > +	const struct landlock_ruleset_attr ruleset_attr = {
> > > > > +		.handled_access_net = ACCESS_ALL,
> > > > > +	};
> > > > > +	struct landlock_net_port_attr net_service = {
> > > > > Please rename to "net_port" everywhere.
> > > 
> > >   Done.
> > > > > > +TEST_F(port_specific, bind_connect)
> > > > > +{
> > > > > +	int socket_fd, ret;
> > > > > +
> > > > > +	/* Adds the first rule layer with bind and connect actions. */
> > > > > +	if (variant->sandbox == TCP_SANDBOX) {
> > > > > +		const struct landlock_ruleset_attr ruleset_attr = {
> > > > > +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> > > > > +					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > +		};
> > > > > +		const struct landlock_net_port_attr tcp_bind_connect_zero = {
> > > > > +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> > > > > +					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > > > > +			.port = htons(0),
> > > > > We don't need any htons() calls anymore. It doesn't change the 0
> > > value
> > > > in this case but this is not correct.
> > > 
> > >  Yep. We call htons(port) in landlock_append_net_rule().
> > >  Thanks.
> > > > > > +		};
> > > > > +
> > > > > Useless new line.
> > > 
> > >   Ok. Thanks.
> > > > > > +		int ruleset_fd;
> > > > > +
> > > > > +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> > > > > +						     sizeof(ruleset_attr), 0);
> > > > > +		ASSERT_LE(0, ruleset_fd);
> > > > > +
> > > > > +		/* Checks zero port value on bind and connect actions. */
> > > > > +		EXPECT_EQ(0,
> > > > > +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > > > > +					    &tcp_bind_connect_zero, 0));
> > > > > +
> > > > > +		enforce_ruleset(_metadata, ruleset_fd);
> > > > > +		EXPECT_EQ(0, close(ruleset_fd));
> > > > > +	}
> > > > > +
> > > > > +	socket_fd = socket_variant(&self->srv0);
> > > > > +	ASSERT_LE(0, socket_fd);
> > > > > +
> > > > > +	/* Sets address port to 0 for both protocol families. */
> > > > > +	set_port(&self->srv0, htons(0));
> > > > > ditto
> > > > > > +
> > > > > +	/* Binds on port 0. */
> > > > > +	ret = bind_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	} else {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > If the results are the same, no need to add an if block.
> > > 
> > >   Right. Updated.
> > > > > > +	}
> > > > > +
> > > > > +	/* Connects on port 0. */
> > > > > +	ret = connect_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		EXPECT_EQ(-ECONNREFUSED, ret);
> > > > > +	} else {
> > > > > +		EXPECT_EQ(-ECONNREFUSED, ret);
> > > > > +	}
> > > > > ditto
> > > >  Updated.
> > > > > +
> > > > > +	/* Binds on port 0. */
> > > > > Please close sockets once they are used, and recreate one for
> > > another
> > > > bind/connect to avoid wrong checks.
> > > 
> > >   Ok. But I can reuse socket_fd after closeing a socket. Correct?
> > 
> > It would be clearer to have one variable for the client socket
> > (connect_fd) and another variable for the server socket (bind_fd).
> > But once the socket is closed, you can reuse the same variable by
> > storing a new socket in it. You then only need two variables for sockets
> > in this test.
> 
>  Ok. Thanks.
> > 
> > > > > > +	ret = bind_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	} else {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	}
> > > > > Why this second bind() block? Furthermore, it is using the same
> > > > socket_fd.
> > 
> > Is this block useful?
> 
>   For a self-connected socket after connection try we need to rebind it
> again. I checked this logic in a small standalone test (with gdb on). So for
> 2 sockets (differnt fds) there is no need to do that.
> > 
> > > 
> > >   I will refactor the code this way -  sockets will be recreated for each
> > > bind/connect, and I prefer to use self-connected sockets (use one socket
> > > descriptor) in these tests to make code simpler; testing logic remains the
> > > same way as if we have 2 sockets.
> > > 
> > > What do you think???
> > 
> > I find it confusing to use self-connected sockets, it's not clear at all
> > what is going on, and AFAIK it doesn't reflect real use cases. Please
> > don't do that.
> > 
> > Using the same variable for both bind and connect socket will lead to
> > issues difficult to debug, and leaked FDs. For instance with the bind +
> > get_binded_port + connect test you should use one variable per socket.
> > To make it easier to read, please follow this rule everywhere (the only
> > case when this is done seems to be with the port_specific.bind_connect
> > test).
> 
>   OK. I will use 2 fds for bind and connect sockets.
> > 
> > > 
> > > > > > +
> > > > > +	/* Sets binded port for both protocol families. */
> > > > > +	set_port(&self->srv0,
> > > > > +		 htons(get_binded_port(socket_fd, &variant->prot)));
> > > > > Ditto, these two endianess translations are useless.
> > > 
> > >   Updated. Thanks.
> > > > > You can also add this to make sure the returned port is not 0:
> > > > port = get_binded_port(socket_fd, &variant->prot);
> > > > EXPECT_NE(0, port);
> > > > set_port(&self->srv0, port);
> > > 
> > >   Ok. Thanks for the tip.
> > > > > > +
> > > > > +	/* Connects on the binded port. */
> > > > > +	ret = connect_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		/* Denied by Landlock. */
> > > > > +		EXPECT_EQ(-EACCES, ret);
> > > > > +	} else {
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	}
> > > > > +
> > > > > +	EXPECT_EQ(0, close(socket_fd));
> > > > > +
> > > > > > > > +	/* Adds the second rule layer with just bind action. */
> > > > > There is not only bind actions here.
> > > 
> > >   Right.
> > > > > This second part of the tests should be in a dedicated
> > > > TEST_F(port_specific, bind_1023).
> > > 
> > >   Got it.
> > > > > > +	if (variant->sandbox == TCP_SANDBOX) {
> > > > > +		const struct landlock_ruleset_attr ruleset_attr = {
> > > > > +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> > > > > +					      LANDLOCK_ACCESS_NET_CONNECT_TCP
> > > > > +		};
> > > > > +
> > > > > +		const struct landlock_net_port_attr tcp_bind_zero = {
> > > > > +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> > > > > +			.port = htons(0),
> > > > > +		};
> > > > > +
> > > > > Useless new lines.
> > > 
> > >   Got it.
> > > > > > +		/* A rule with port value less than 1024. */
> > > > > +		const struct landlock_net_port_attr tcp_bind_lower_range = {
> > > > > +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> > > > > +			.port = htons(1023),
> > > > > +		};
> > > > > +
> > > > > Useless new line.
> > > 
> > >   Got it.
> > > > > > +		int ruleset_fd;
> > > > > +
> > > > > +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> > > > > +						     sizeof(ruleset_attr), 0);
> > > > > +		ASSERT_LE(0, ruleset_fd);
> > > > > +
> > > > > +		ASSERT_EQ(0,
> > > > > +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > > > > +					    &tcp_bind_lower_range, 0));
> > > > > +		ASSERT_EQ(0,
> > > > > +			  landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_PORT,
> > > > > +					    &tcp_bind_zero, 0));
> > > > > +
> > > > > +		enforce_ruleset(_metadata, ruleset_fd);
> > > > > +		EXPECT_EQ(0, close(ruleset_fd));
> > > > > +	}
> > > > > +
> > > > > +	socket_fd = socket_variant(&self->srv0);
> > > > > We must have one socket FD dedicated to bind an another
> > > dedicated to
> > > > connect, e.g. bind_fd and connect_fd, an close them after each use,
> > > > otherwise tests might be inconsistent.
> > > 
> > >   Why can't we use self-connected sockets here? Why tests might be
> > > inconsistent? Tests will be working the same way as if we have 2 sockets,
> > > plus the code is simpler.
> > 
> > AFAIK it doesn't reflect real use cases of sockets, and I find it really
> > confusing. Where did you see this kind of usage?
> > 
> > Test might be inconsistent for instance if you change the port from 1023
> > to 1024 and you adjust the (denied by system) EXPECT_EQ(-EACCES, ret),
> > you'll get a new error in the following block, which doesn't make sense
> > at first, but then you realize it is because the socket is already
> > binded.  To avoid this kind of issues, and avoid leaking FDs, please use
> > a socket per usage and close them before testing something else.
> 
>  Ok. Got it.
> > 
> > > > > > +	ASSERT_LE(0, socket_fd);
> > > > > +
> > > > > +	/* Sets address port to 1023 for both protocol families. */
> > > > > +	set_port(&self->srv0, htons(1023));
> > > > > +
> > > > > +	/* Binds on port 1023. */
> > > > > +	ret = bind_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > No need to add this check if the result is the same for
> > > sandboxed and
> > > > not sandboxed tests.
> > > 
> > >  Ok. Thanks.
> > > > > Instead, use set_cap(_metadata, CAP_NET_BIND_SERVICE) and
> > > clear_cap()
> > > > around this bind_variant() to make this test useful.
> > > > > You will also need to patch common.h like this:
> > > > @@ -112,10 +112,13 @@ static void _init_caps(struct __test_metadata *const _metadata, bool drop_all)
> > > >          cap_t cap_p;
> > > >          /* Only these three capabilities are useful for the tests. */
> > > >          const cap_value_t caps[] = {
> > > > +               /* clang-format off */
> > > >                  CAP_DAC_OVERRIDE,
> > > >                  CAP_MKNOD,
> > > >                  CAP_SYS_ADMIN,
> > > >                  CAP_SYS_CHROOT,
> > > > +               CAP_NET_BIND_SERVICE,
> > > > +               /* clang-format on */
> > > >          };
> > > 
> > >  OK. Thanks.
> > > > > > +		/* Denied by the system. */
> > > > > +		EXPECT_EQ(-EACCES, ret);
> > > > > +	} else {
> > > > > +		/* Denied by the system. */
> > > > > +		EXPECT_EQ(-EACCES, ret);
> > > > > +	}
> > > > > +
> > > > > I don't see why the following part is useful. Why did you add
> > > it?
> > >   Binding to ports < 1024 are forbidden by the system, not by Landlock.
> > >   I added a rule with port 1023 to make sure it works as expected.
> > 
> > Landlock, as any LSM, can only add more restrictions. That's why it
> > would make more sense to test with CAP_NET_BIND_SERVICE, to make sure
> > Landlock rules work the same with this kind of privileged ports, but you
> > can test both cases (all within the same TEST_F though, and without
> > other tests).
> 
>  Do you mean during the test to set CAP_NET_BIND_SERVICE, check it with
> landlock (it will success), then switch  CAP_NET_BIND_SERVICE cap off and
> bind it again ( will be refused by the system)?
> Am I correct?

Yes, you can use something like this:

set_cap(_metadata, CAP_NET_BIND_SERVICE);
ret = bind_variant(socket_fd, &self->srv0);
clear_cap(_metadata, CAP_NET_BIND_SERVICE);


> > 
> > > 
> > > > Why tcp_bind_zero?
> > >    Beacause it's a bind action with port zero rule.
> > 
> > Yes but I don't see why it's relevant to test that here, because it was
> > tested just before.
> > 
>   OK. I just leave binding to 1023 port here.
>   I'm thinking to add binding to 1024 port then to show that this port is
> allowed by the system but denied by landlock ( we have just rule with 1023
> port).
>   What do you think?

Yes, you can do that. I guess you could use test_bind_and_connect() for
this test. You can group these checks (ports 1023 and 1024) in the same
dedicated TEST_F.

> > > 
> > > > > The other parts are good though!
> > > > > > +	/* Sets address port to 0 for both protocol families. */
> > > > > +	set_port(&self->srv0, htons(0));
> > > > > +
> > > > > +	/* Binds on port 0. */
> > > > > +	ret = bind_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	} else {
> > > > > +		/* Binds to a random port within ip_local_port_range. */
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	}
> > > > > +
> > > > > +	/* Sets binded port for both protocol families. */
> > > > > +	set_port(&self->srv0,
> > > > > +		 htons(get_binded_port(socket_fd, &variant->prot)));
> > > > > +
> > > > > +	/* Connects on the binded port. */
> > > > > +	ret = connect_variant(socket_fd, &self->srv0);
> > > > > +	if (is_restricted(&variant->prot, variant->sandbox)) {
> > > > > +		/* Denied by Landlock. */
> > > > > +		EXPECT_EQ(-EACCES, ret);
> > > > > +	} else {
> > > > > +		EXPECT_EQ(0, ret);
> > > > > +	}
> > > > > +
> > > > > +	EXPECT_EQ(0, close(socket_fd));
> > > > > +}
> > > > > +
> > > > > +TEST_HARNESS_MAIN
> > > > > --
> > > > > 2.25.1
> > > > > > .
> > .
