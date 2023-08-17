Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC88CC3063A
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Aug 2023 15:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352868AbjHQPJw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352889AbjHQPJZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 11:09:25 -0400
X-Greylist: delayed 7724 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Aug 2023 08:08:56 PDT
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6873E35A9
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Aug 2023 08:08:56 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4RRT0G3WtWzMqFhx;
        Thu, 17 Aug 2023 15:08:14 +0000 (UTC)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4RRT0F71QczMppDk;
        Thu, 17 Aug 2023 17:08:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1692284894;
        bh=QHWtlroPj2hZlSNyG+J3nFkb3cwxfQDXOmS4vwr9mGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NlP/uINpHLxaQAztZiaEK4a27TrexN9upfFqxUFl93VqHqDYJwEzSRjAw9itMfcPP
         gjJvO1veCCtfnSejN9clh2VziocEGR/RMN4UCB9MBtOwlU8Y5gvmSRGo/79GDmuEku
         wpnSkCPB3KDeCBuzTyX4+pvvNuoVsWcFylU1yL1I=
Date:   Thu, 17 Aug 2023 17:08:09 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     artem.kuzin@huawei.com, gnoack3000@gmail.com,
        willemdebruijn.kernel@gmail.com, yusongping@huawei.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Message-ID: <20230817.koh5see0eaLa@digikod.net>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
 <b2a94da1-f9df-b684-7666-1c63060f68f1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2a94da1-f9df-b684-7666-1c63060f68f1@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 12, 2023 at 05:37:00PM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/12/2023 10:02 AM, Mickaël Salaün пишет:
> > 
> > On 06/07/2023 16:55, Mickaël Salaün wrote:
> > > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > > 
> > > This patch is a revamp of the v11 tests [1] with new tests (see the
> > > "Changes since v11" description).  I (Mickaël) only added the following
> > > todo list and the "Changes since v11" sections in this commit message.
> > > I think this patch is good but it would appreciate reviews.
> > > You can find the diff of my changes here but it is not really readable:
> > > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
> > > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
> > > TODO:
> > > - Rename all "net_service" to "net_port".
> > > - Fix the two kernel bugs found with the new tests.
> > > - Update this commit message with a small description of all tests.
> > 
> > [...]

> > We should also add a test to make sure errno is the same with and
> > without sandboxing when using port 0 for connect and consistent with
> > bind (using an available port). The test fixture and variants should be
> > quite similar to the "ipv4" ones, but we can also add AF_INET6 variants,
> > which will result in 8 "ip" variants:
> > 
> > TEST_F(ip, port_zero)
> > {
> > 	if (variant->sandbox == TCP_SANDBOX) {
> > 		/* Denies any connect and bind. */
> > 	}
> > 	/* Checks errno for port 0. */
> > }
> As I understand the would be the next test cases:
> 
> 	1. ip4, sandboxed, bind port 0 -> should return EACCES (denied by
> landlock).

Without any allowed port, yes. This test case is useful.

By tuning /proc/sys/net/ipv4/ip_local_port_range (see
inet_csk_find_open_port call) we should be able to pick a specific
allowed port and test it.  We can also test for the EADDRINUSE error to
make sure error ordering is correct (compared with -EACCES).

However, I think the current LSM API don't enable to infer this random
port because the LSM hook is called before a port is picked.  If this is
correct, the best way to control port binding would be to always deny
binding on port zero/random (when restricting port binding, whatever
exception rules are in place). This explanation should be part of a
comment for this specific exception.

Cc Paul

> 	2. ip4, non-sandboxed, bind port 0 -> should return 0 (should be bounded to
> random port).

I think so but we need to make sure the random port cannot be < 1024, I
guess with /proc/sys/net/ipv4/ip_local_port_range but I don't know for
IPv6.

> 	3. ip6, sandboxed, bind port 0 -> should return EACCES (denied by
> landlock).
> 	4. ip6, non-sandboxed, bind port 0 -> should return 0 (should be bounded to
> random port).
> 	5. ip4, sandboxed, bind some available port, connect port 0 -> should
> return -EACCES (denied by landlock).

Yes, but don't need to bind to anything (same for the next ones).

> 	6. ip4, non-sandboxed, bind some available port, connect port 0 -> should
> return ECONNREFUSED.

Yes, but without any binding.

> 	7. ip6, sandboxed, bind some available port, connect port 0 -> should
> return -EACCES (denied by landlock)
> 	8. ip6, non-sandboxed, some bind available port, connect port 0 -> should
> return ECONNREFUSED.
> 
> Correct?

Thinking more about this case, being able to add a rule with port zero
*for a connect action* looks legitimate.  A rule with both connect and
bind actions on port zero should then be denied.  We should fix
add_rule_net_service() and test that (with a first layer allowing port
zero, and a second without rule, for connect).


> 
> > 
> > [...]
> > 
> > > +FIXTURE(inet)
> > > +{
> > > +	struct service_fixture srv0, srv1;
> > > +};
> > 
> > The "inet" variants are useless and should be removed. The "inet"
> > fixture can then be renamed to "ipv4_tcp".
> > 
>   So inet should be changed to ipv4_tcp and ipv6_tcp with next variants:
> 
>   - ipv4_tcp.no_sandbox_with_ipv4.port_endianness
>   - ipv4_tcp.sandbox_with_ipv4.port_endianness
>   - ipv6_tcp.no_sandbox_with_ipv6.port_endianness
>   - ipv6_tcp.sandbox_with_ipv6.port_endianness
> ????
> 
>    in this case we need double copy of TEST_F(inet, port_endianness) :
> 	TEST_F(ipv4_tcp, port_endianness)
> 	TEST_F(ipv6_tcp, port_endianness)

There is no need for any variant for the port_endianness test. You can
rename "inet" to "ipv4_tcp" (and not "inet_tcp" like I said before).
