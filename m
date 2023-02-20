Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AFCC636CC
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Feb 2023 14:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjBTOnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Feb 2023 09:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjBTOnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Feb 2023 09:43:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 607D11421A
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Feb 2023 06:43:53 -0800 (PST)
Date:   Mon, 20 Feb 2023 15:43:48 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Bryce Kahle <bryce.kahle@datadoghq.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
Message-ID: <Y/OHJKR7eh+DhymU@salvia>
References: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
 <20230215100236.GC9908@breakpoint.cc>
 <CALvGib8TSNk47Spapt2dMe+R_ohzZZz9yC5Ou3qqRxJqtYfBmg@mail.gmail.com>
 <20230216151822.GB14032@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230216151822.GB14032@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 16, 2023 at 04:18:22PM +0100, Florian Westphal wrote:
> Bryce Kahle <bryce.kahle@datadoghq.com> wrote:
> > I have posted the reproducer at
> > https://github.com/brycekahle/netfilter-reproducer
> 
> Thanks.  Resolving this in a backwards compatible way is
> intrusive because at the time the ctnetlink subscription happens
> nsid isn't set yet.
> 
> We'd need a new callback in netlink_kernel_cfg so that ctnetlink
> can be informed about activation of 'allnet' option on an existing
> socket.
> 
> We'd also need a new flag in netfilter/core.c for that and not in
> ctnetlink because else we'd create an unwanted module dependency in
> nf_conntrack.
> 
> I can think of 3 alternative solutions:
> 1. revert back to 'default 1'.
>    I don't want to do that because for almost all conntrack use
>    cases the extension allocation is unecessary.
> 
> 2. Switch netns creation behaviour to enable the extensions if
>    init_net has nf_conntrack_events=1.
>    This would require user intervention, but probably fine.
>    Downside is that this will be different from all the other
>    settings.
> 
> 3. Add a module param to conntrack to override the default
>    setting.  We already have such params for accounting and timestamps.
> 
> I'd go with 3).  Bryce, would that work for you?
>
> Pablo, whats your take on this?
>
> If you prefer I can work on the new netlink_kernel_cfg callback
> to see how intrusive it really is.
>
> Breakage scenario is:
> 
> 1. Parent netns opens ctnetlink event sk
> 2. Parent netns sets ALL_NSID flag
> 3. No events from child netns, because no ctnetlink
>    event sockets were created in this netns and thus
>    conntrack objects get no event extension.
> 
> Extending the existing bind callback doesn't work because
> ALL_NSID flag is set after event subscription.

I would prefer netlink_kernel_cfg .setsockopt callback as you suggest.
