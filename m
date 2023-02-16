Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F29C61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Feb 2023 15:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBPPSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Feb 2023 10:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPPSc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2023 10:18:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970CA5598
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2023 07:18:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pSg1e-0005Oh-LY; Thu, 16 Feb 2023 16:18:22 +0100
Date:   Thu, 16 Feb 2023 16:18:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Bryce Kahle <bryce.kahle@datadoghq.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
Message-ID: <20230216151822.GB14032@breakpoint.cc>
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc>
 <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> I have posted the reproducer at
> https://github.com/brycekahle/netfilter-reproducer

Thanks.  Resolving this in a backwards compatible way is
intrusive because at the time the ctnetlink subscription happens
nsid isn't set yet.

We'd need a new callback in netlink_kernel_cfg so that ctnetlink
can be informed about activation of 'allnet' option on an existing
socket.

We'd also need a new flag in netfilter/core.c for that and not in
ctnetlink because else we'd create an unwanted module dependency in
nf_conntrack.

I can think of 3 alternative solutions:
1. revert back to 'default 1'.
   I don't want to do that because for almost all conntrack use
   cases the extension allocation is unecessary.

2. Switch netns creation behaviour to enable the extensions if
   init_net has nf_conntrack_events=1.
   This would require user intervention, but probably fine.
   Downside is that this will be different from all the other
   settings.

3. Add a module param to conntrack to override the default
   setting.  We already have such params for accounting and timestamps.

I'd go with 3).  Bryce, would that work for you?

Pablo, whats your take on this?
If you prefer I can work on the new netlink_kernel_cfg callback
to see how intrusive it really is.

Breakage scenario is:

1. Parent netns opens ctnetlink event sk
2. Parent netns sets ALL_NSID flag
3. No events from child netns, because no ctnetlink
   event sockets were created in this netns and thus
   conntrack objects get no event extension.

Extending the existing bind callback doesn't work because
ALL_NSID flag is set after event subscription.
