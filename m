From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables queue target aborts rules processing unconditionally
Date: Fri, 3 Mar 2017 17:01:49 +0100
Message-ID: <20170303160149.GI29213@breakpoint.cc>
References: <1942735443.286636.1488553299817.JavaMail.zimbra@tpip.net>
 <20170303154124.GH29213@breakpoint.cc>
 <323159116.287095.1488556655720.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50768 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751601AbdCCQ1U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 11:27:20 -0500
Content-Disposition: inline
In-Reply-To: <323159116.287095.1488556655720.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andreas Schultz <aschultz@tpip.net> wrote:
> ok, somewhat unexpected (or rather undocumented), but I can live
> with that.
> 
> I've now experimented with NF_REPEAT to achieve something similar.
> Can I assume that NF_REPEAT should restart the current "netfilter hook*?

Yes.

> e.g. when we are somewhere in FILTER FORWARD, it will restart with the
> first rule of that hook?

It restarts the hook, yes.

> My experiments show that this works with nft when I don't modify the
> ruleset. However, when I modify the ruleset before returning NF_REPEAT,
> the packet will skip the current hook completely.

Hmm, that shouldn't happen.
REPEAT should always just re-start the current hook.
If that hook gets deleted (and possibly re-created) while packet was
queued the kernel is supposed to drop the packet.

> I don't modify the chain the packet is currently traversing. I only add
> new chains and modify the vmap.

The netfilter infrastructure is a layer below nftables/iptables so it
is not even aware of rule set modifications.

> >> It also appears as if the nft trace infrastructure does not now how to
> >> deal with queues. The above rules lead to this annotated trace output:
> >> 
> >> > trace id 10d53daf ip filter client_to_any packet: iif "upstream" oif "ens256"
> >> > ether saddr 00:50:56:96:9b:1c ether daddr 00:0c:29:46:1f:53 ether type ip6
> >> 
> >> That's rule #11... Where is the hit on the queue rule and the return??
> > 
> > No idea, I will have a closer look next week.
> > Glancing at the code it should work just fine.
> 
> There might a event buffering issue. I have now sometimes seen the queueing
> trace. At other times the event is lost. So maybe the netlink buffer is not
> large enough?

How many events are there...?
If there aren't hundreds of events going on that really should not be an
issue.

