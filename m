Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80C2C2FC20
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Aug 2023 12:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350991AbjHQMyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 08:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350997AbjHQMyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 08:54:25 -0400
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [IPv6:2001:1600:4:17::190c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8469A2D79
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Aug 2023 05:54:21 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4RRQ1k5lxvzMq6cb;
        Thu, 17 Aug 2023 12:54:18 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4RRQ1k2CJ9zMpnPp;
        Thu, 17 Aug 2023 14:54:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1692276858;
        bh=gWg5Au5qNjkmKNc2JaoMVUE3kXc5yOumLKtoxOkV/Lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xDMPiSE08gXVzmly5tGHSAcSTSAARAkOws6zkOlnV+Q71UNWdXj57nBM8klo9U92D
         uP2wC5/DHtzHnBiaVUtBuSTvAvQWbIR7XhBx7tdIM6cRsQAU30eroqJNIFBl7c2YvR
         k+rmIViKhELKhuI2uEg4Q924hsyr8/E7ciTfHaXo=
Date:   Thu, 17 Aug 2023 14:54:10 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com, yusongping@huawei.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Message-ID: <20230817.theivaoThia9@digikod.net>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <d261a7ae-fd9c-902a-10f7-61d08cab0435@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d261a7ae-fd9c-902a-10f7-61d08cab0435@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 12, 2023 at 12:03:02AM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/6/2023 5:55 PM, Mickaël Salaün пишет:
> > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > 
> > This patch is a revamp of the v11 tests [1] with new tests (see the
> > "Changes since v11" description).  I (Mickaël) only added the following
> > todo list and the "Changes since v11" sections in this commit message.
> > I think this patch is good but it would appreciate reviews.
> > You can find the diff of my changes here but it is not really readable:
> > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
> > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
> > TODO:
> > - Rename all "net_service" to "net_port".
> > - Fix the two kernel bugs found with the new tests.
> > - Update this commit message with a small description of all tests.
> > 
> > These test suites try to check edge cases for TCP sockets
> > bind() and connect() actions.
> > 
> > inet:
> > * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> > * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> > * bind_afunspec: Tests with non-landlocked/landlocked restrictions
> > for bind action with AF_UNSPEC socket family.
> > * connect_afunspec: Tests with non-landlocked/landlocked restrictions
> > for connect action with AF_UNSPEC socket family.
> > * ruleset_overlap: Tests with overlapping rules for one port.
> > * ruleset_expanding: Tests with expanding rulesets in which rules are
> > gradually added one by one, restricting sockets' connections.
> > * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets
> > and with port values more than U16_MAX.
> > 
> > port:
> > * inval: Tests with invalid user space supplied data:
> >      - out of range ruleset attribute;
> >      - unhandled allowed access;
> >      - zero port value;
> >      - zero access value;
> >      - legitimate access values;
> > * bind_connect_inval_addrlen: Tests with invalid address length.
> > * bind_connect_unix_*_socket: Tests to make sure unix sockets' actions
> > are not restricted by Landlock rules applied to TCP ones.
> > 
> > layout1:
> > * with_net: Tests with network bind() socket action within
> > filesystem directory access test.
> > 
> > Test coverage for security/landlock is 94.8% of 934 lines according
> > to gcc/gcov-11.
> > 
> > Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > Co-developed-by: Mickaël Salaün <mic@digikod.net>
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>

[...]

> > +// Kernel FIXME: tcp_sandbox_with_tcp and tcp_sandbox_with_udp
> 
>      I debugged the code in qemu and came to a conclusion that we don't
> check if socket's family equals to address's one in check_socket_access(...)
> function in net.c
> So I added the next lines (marked with !!!):
> 
> 	static int check_socket_access(struct socket *const sock,
> 			       struct sockaddr *const address,
> 			       const int addrlen,
> 			       const access_mask_t access_request)
> {
> 	__be16 port;
> 	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_NET] = {};
> 	const struct landlock_rule *rule;
> 	access_mask_t handled_access;
> 	struct landlock_id id = {
> 		.type = LANDLOCK_KEY_NET_PORT,
> 	};
> 	const struct landlock_ruleset *const domain = 	
>         get_current_net_domain();
> 
> 	if (!domain)
> 		return 0;
> 	if (WARN_ON_ONCE(domain->num_layers < 1))
> 		return -EACCES;
> 
> 	/* FIXES network tests */ !!!
> 	if (sock->sk->__sk_common.skc_family != address->sa_family) !!!
> 		return 0; !!!
> 	/* Checks if it's a TCP socket. */
> 	if (sock->type != SOCK_STREAM)
> 		return 0;
> 	......
> 
> So now all network tests pass.
> What do you think?

Good catch, we should indeed check this inconsistency, but this fix also
adds two issues:
- sa_family is read before checking if it is out of bound (see
  offsetofend() check bellow). A simple fix is to move down the new
  check.
- access request with AF_UNSPEC on a bind operation doesn't go through
  the specific AF_UNSPEC handling branch.  There are two things to fix
  here: handle AF_UNSPEC specifically in this new af_family check, and
  add a new test to make sure bind with AF_UNSPEC and INADDR_ANY is
  properly restricted.

I'll reply to this message with a patch extending your fix.


> 
> > +TEST_F(ipv4, from_unix_to_inet)
> > +{
> > +	int unix_stream_fd, unix_dgram_fd;
> > +
> > +	if (variant->sandbox == TCP_SANDBOX) {
> > +		const struct landlock_ruleset_attr ruleset_attr = {
> > +			.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> > +					      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +		};
> > +		const struct landlock_net_service_attr tcp_bind_connect_p0 = {
> > +			.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> > +					  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> > +			.port = self->srv0.port,
> > +		};
> > +		int ruleset_fd;
> > +
> > +		/* Denies connect and bind to check errno value. */
> > +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> > +						     sizeof(ruleset_attr), 0);
> > +		ASSERT_LE(0, ruleset_fd);
> > +
> > +		/* Allows connect and bind for srv0.  */
> > +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> > +					       LANDLOCK_RULE_NET_SERVICE,
> > +					       &tcp_bind_connect_p0, 0));
> > +
> > +		enforce_ruleset(_metadata, ruleset_fd);
> > +		EXPECT_EQ(0, close(ruleset_fd));
> > +	}
> > +
> > +	unix_stream_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
> > +	ASSERT_LE(0, unix_stream_fd);
> > +
> > +	unix_dgram_fd = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
> 
>         Minor mistyping SOCK_STREAM -> SOCK_DGRAM.

Good catch!

> 
> > +	ASSERT_LE(0, unix_dgram_fd);
> > +
> > +	/* Checks unix stream bind and connect for srv0. */
> > +	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv0));
> > +	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv0));
> > +
> > +	/* Checks unix stream bind and connect for srv1. */
> > +	EXPECT_EQ(-EINVAL, bind_variant(unix_stream_fd, &self->srv1))
> > +	{
> > +		TH_LOG("Wrong bind error: %s", strerror(errno));
> > +	}
> > +	EXPECT_EQ(-EINVAL, connect_variant(unix_stream_fd, &self->srv1));
> > +
> > +	/* Checks unix datagram bind and connect for srv0. */
> > +	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv0));
> > +	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv0));
> > +
> > +	/* Checks unix datagram bind and connect for srv0. */
> 
>         Should be "Checks... for srv1."

indeed

> 
> > +	EXPECT_EQ(-EINVAL, bind_variant(unix_dgram_fd, &self->srv1));
> > +	EXPECT_EQ(-EINVAL, connect_variant(unix_dgram_fd, &self->srv1));
> > +}
