Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B50C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 19:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiDHTgW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiDHTgU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 15:36:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2C576281
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 12:34:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ncuN3-000475-KY; Fri, 08 Apr 2022 21:34:13 +0200
Date:   Fri, 8 Apr 2022 21:34:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next RFC 2/2] netfilter: conntrack: skip event
 delivery for the netns exit path
Message-ID: <20220408193413.GC7920@breakpoint.cc>
References: <20220408125837.221673-1-pablo@netfilter.org>
 <20220408125837.221673-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408125837.221673-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 70e9942f17a6 ("netfilter: nf_conntrack: make event callback registration
> per-netns") introduced a per-netns callback for events to workaround a
> crash when delivering conntrack events on a stale per-netns nfnetlink
> kernel socket.
> 
> This patch adds a new flag to the nf_ct_iter_data object to skip event
> delivery from the netns cleanup path to address this issue.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> compiled tested only.
> @Florian: Maybe this helps to remove the per-netns nf_conntrack_event_cb
> callback without having to update nfnetlink to deal with this corner case?

Old crash recipe is (from your changelog of the 'make it pernet' change):

 0) make sure nf_conntrack_netlink and nf_conntrack_ipv4 are loaded.
 1) container is started.
 2) connect to it via lxc-console.
 3) generate some traffic with the container to create some conntrack
    entries in its table.
 4) stop the container: you hit one oops because the conntrack table
    cleanup tries to report the destroy event to user-space but the
    per-netns nfnetlink socket has already gone (as the nfnetlink
    socket is per-netns but event callback registration is global).

Pernet exit handlers are called in reverse order of the module load
order, so normally this means:

ctnetlink exit handlers
nfnetlink_net_exit_batch, removes nfnl socket
nf_conntrack_pernet_exit(), removes entries,

Because callback is pernet atm this prevents crash after nfntlink sk
has been closed.

If thats no longer the case, we need some other way to suppress
calls with stale nfnl sk.

With the proposed patch series its still possible that we end up
in nfnetlink via  the ctnl event handler.

E.g. gc worker could evit at the right time, or some kfree_skb call
ends up dropping last reference.

If you really dislike the nfnl changes I will respin without this
and will keep the pernet ctnetlink callback.
