Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2D4C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 15:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243450AbiDJPZR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 11:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiDJPZQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 11:25:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9628F17075
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 08:23:05 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4996263045;
        Sun, 10 Apr 2022 17:19:07 +0200 (CEST)
Date:   Sun, 10 Apr 2022 17:23:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next RFC 2/2] netfilter: conntrack: skip event
 delivery for the netns exit path
Message-ID: <YlL2Vfn3ijjh9O97@salvia>
References: <20220408125837.221673-1-pablo@netfilter.org>
 <20220408125837.221673-2-pablo@netfilter.org>
 <20220408193413.GC7920@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220408193413.GC7920@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 08, 2022 at 09:34:13PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 70e9942f17a6 ("netfilter: nf_conntrack: make event callback registration
> > per-netns") introduced a per-netns callback for events to workaround a
> > crash when delivering conntrack events on a stale per-netns nfnetlink
> > kernel socket.
> > 
> > This patch adds a new flag to the nf_ct_iter_data object to skip event
> > delivery from the netns cleanup path to address this issue.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > compiled tested only.
> > @Florian: Maybe this helps to remove the per-netns nf_conntrack_event_cb
> > callback without having to update nfnetlink to deal with this corner case?
> 
> Old crash recipe is (from your changelog of the 'make it pernet' change):
> 
>  0) make sure nf_conntrack_netlink and nf_conntrack_ipv4 are loaded.
>  1) container is started.
>  2) connect to it via lxc-console.
>  3) generate some traffic with the container to create some conntrack
>     entries in its table.
>  4) stop the container: you hit one oops because the conntrack table
>     cleanup tries to report the destroy event to user-space but the
>     per-netns nfnetlink socket has already gone (as the nfnetlink
>     socket is per-netns but event callback registration is global).
> 
> Pernet exit handlers are called in reverse order of the module load
> order, so normally this means:
> 
> ctnetlink exit handlers
> nfnetlink_net_exit_batch, removes nfnl socket
> nf_conntrack_pernet_exit(), removes entries,
> 
> Because callback is pernet atm this prevents crash after nfntlink sk
> has been closed.
> 
> If thats no longer the case, we need some other way to suppress
> calls with stale nfnl sk.
> 
> With the proposed patch series its still possible that we end up
> in nfnetlink via  the ctnl event handler.
> 
> E.g. gc worker could evit at the right time, or some kfree_skb call
> ends up dropping last reference.
> 
> If you really dislike the nfnl changes I will respin without this
> and will keep the pernet ctnetlink callback.

OK, my patch is not covering all the possible cases then.

Probably we can remove the hooks from .pre_exit, then force a run of
the garbage collector from there. Then .exit path skips event delivery
as my patch does.

This would allow to remove the per-netns callback workaround, and all
would be handled from nf_conntrack instead?
