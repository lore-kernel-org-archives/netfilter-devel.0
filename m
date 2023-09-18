Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1B4CD13D2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 06:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbjIRG4l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 02:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbjIRG4a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 02:56:30 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [84.16.66.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E608ED
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Sep 2023 23:56:22 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4RpwYw44wgzMpvj8;
        Mon, 18 Sep 2023 06:56:20 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4RpwYv6pBhzMpp9q;
        Mon, 18 Sep 2023 08:56:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1695020180;
        bh=W0JS7Bsx1CtCiU+24S/P6j4fgRH6Nm/XGb0DMnycSRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PuCP25W3BWxawH4FD41ECC4I/T+/fGUZai+OpF8YFpl8xNgHCHuk6ncer63+nxfQF
         CoKF35XYAssQVf21LhB3vIJJB/xrf59n91vR9uxpGuy1A4S2oBOCnMPyXr1u6TRmao
         g1MaS+PpRZkv4AYsy8x2ekqJoqsgoLkFXWSgK/YY=
Date:   Mon, 18 Sep 2023 08:56:16 +0200
From:   =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     Paul Moore <paul@paul-moore.com>, artem.kuzin@huawei.com,
        gnoack3000@gmail.com, willemdebruijn.kernel@gmail.com,
        yusongping@huawei.com, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v11.1] selftests/landlock: Add 11 new test suites
 dedicated to network
Message-ID: <20230918.shauB5gei9Ai@digikod.net>
References: <20230515161339.631577-11-konstantin.meskhidze@huawei.com>
 <20230706145543.1284007-1-mic@digikod.net>
 <3db64cf8-6a45-a361-aa57-9bfbaf866ef8@digikod.net>
 <b2a94da1-f9df-b684-7666-1c63060f68f1@huawei.com>
 <20230817.koh5see0eaLa@digikod.net>
 <239800f3-baf4-1c7d-047f-8ba90b097bee@huawei.com>
 <20230914.ASu9sho1Aef0@digikod.net>
 <076bfaa6-1e0b-c95b-5727-00001c79f2c0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <076bfaa6-1e0b-c95b-5727-00001c79f2c0@huawei.com>
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 15, 2023 at 11:54:46AM +0300, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/14/2023 11:08 AM, Mickaël Salaün пишет:
> > On Mon, Sep 11, 2023 at 01:13:24PM +0300, Konstantin Meskhidze (A) wrote:
> > > 
> > > 
> > > 8/17/2023 6:08 PM, Mickaël Salaün пишет:
> > > > On Sat, Aug 12, 2023 at 05:37:00PM +0300, Konstantin Meskhidze (A) wrote:
> > > > > > > > > 7/12/2023 10:02 AM, Mickaël Salaün пишет:
> > > > > > > On 06/07/2023 16:55, Mickaël Salaün wrote:
> > > > > > > From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> > > > > > > > > This patch is a revamp of the v11 tests [1] with new tests
> > > > > (see the
> > > > > > > "Changes since v11" description).  I (Mickaël) only added the following
> > > > > > > todo list and the "Changes since v11" sections in this commit message.
> > > > > > > I think this patch is good but it would appreciate reviews.
> > > > > > > You can find the diff of my changes here but it is not really readable:
> > > > > > > https://git.kernel.org/mic/c/78edf722fba5 (landlock-net-v11 branch)
> > > > > > > [1] https://lore.kernel.org/all/20230515161339.631577-11-konstantin.meskhidze@huawei.com/
> > > > > > > TODO:
> > > > > > > - Rename all "net_service" to "net_port".
> > > > > > > - Fix the two kernel bugs found with the new tests.
> > > > > > > - Update this commit message with a small description of all tests.
> > > > > > > [...]
> > > > > > > We should also add a test to make sure errno is the same
> > > with and
> > > > > > without sandboxing when using port 0 for connect and consistent with
> > > > > > bind (using an available port). The test fixture and variants should be
> > > > > > quite similar to the "ipv4" ones, but we can also add AF_INET6 variants,
> > > > > > which will result in 8 "ip" variants:
> > > > > > > TEST_F(ip, port_zero)
> > > > > > {
> > > > > > 	if (variant->sandbox == TCP_SANDBOX) {
> > > > > > 		/* Denies any connect and bind. */
> > > > > > 	}
> > > > > > 	/* Checks errno for port 0. */
> > > > > > }
> > > > > As I understand the would be the next test cases:
> > > > > > > 	1. ip4, sandboxed, bind port 0 -> should return EACCES
> > > (denied by
> > > > > landlock).
> > > > > Without any allowed port, yes. This test case is useful.
> > > > > By tuning /proc/sys/net/ipv4/ip_local_port_range (see
> > > > inet_csk_find_open_port call) we should be able to pick a specific
> > > > allowed port and test it.  We can also test for the EADDRINUSE error to
> > > > make sure error ordering is correct (compared with -EACCES).
> > >   Sorry, did not get this case. Could please explain it with more details?
> > 
> > According to bind(2), if no port are available, the syscall should
> > return EADDRINUSE. And this returned value should be the same whatever
> > the process is sandbox or not (and never EACCES). But as I explained
> > just below, we cannot know this random port from the LSM hook, so no
> > need to tweak /proc/sys/net/ipv4/ip_local_port_range, and your this is
> > correct:
> > 
> > 1. ip4, sandboxed, bind port 0 -> should return EACCES (denied by
> > landlock).
> 
>   yep, adding rule with port 0 (for bind) returns EINVAL then
>   calling bind port 0 returns EACCES cause there is no rule with port 0.
> > 
> > > > > However, I think the current LSM API don't enable to infer this
> > > random
> > > > port because the LSM hook is called before a port is picked.  If this is
> > > > correct, the best way to control port binding would be to always deny
> > > > binding on port zero/random (when restricting port binding, whatever
> > > > exception rules are in place). This explanation should be part of a
> > > > comment for this specific exception.
> > > 
> > >   Yep, if some LSM rule (for bind) has been applied a with specific port,
> > > other attemps to bind with zero/random ports would be refused by LSM
> > > security checks.
> > 
> > To say it another way, we should not allow to add a rule with port 0 for
> > LANDLOCK_ACCESS_NET_BIND_TCP, but return -EINVAL in this case. This
> > limitation should be explained, documented and tested.
> > 
> > With (only) LANDLOCK_ACCESS_NET_CONNECT_TCP it should be allowed though
> > (except if there is also LANDLOCK_ACCESS_NET_BIND_TCP) of course.
> > Another test should cover the case with a new rule with these two access
> > rights and port 0.
> 
>  I think it's possible to have LANDLOCK_ACCESS_NET_CONNECT_TCP with port 0
> with LANDLOCK_ACCESS_NET_BIND_TCP at the same time, cause
> LANDLOCK_ACCESS_NET_BIND_TCP rule is allowed (by Landlock) with any other
> port but 0.

It would mask the fact that port zero cannot be allowed, which could be
possible one day. So for now we need to return EINVAL in this case.
