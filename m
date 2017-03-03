From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables queue target aborts rules processing unconditionally
Date: Fri, 3 Mar 2017 16:41:24 +0100
Message-ID: <20170303154124.GH29213@breakpoint.cc>
References: <1942735443.286636.1488553299817.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752020AbdCCQ1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 11:27:22 -0500
Content-Disposition: inline
In-Reply-To: <1942735443.286636.1488553299817.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andreas Schultz <aschultz@tpip.net> wrote:
> Hi,
> 
> The nft queueing seems to have broken the continuation of
> rule processing when NF_ACCEPT is returned.

No, see below

> If have the following rules:
> 
> table ip filter {
> 	map client_to_any {
> 		type ipv4_addr : verdict
> 		elements = { 10.180.200.72 : goto CIn_1}
> 	}
> 
> 	chain FORWARD {
> 		type filter hook forward priority 0; policy accept;
> 		iif { "eth0"} counter packets 1 bytes 84 goto client_to_any
> 
> 	chain client_to_any {
> 		nftrace set 1 # handle 11
> 		counter packets 1 bytes 84 ip saddr vmap @client_to_any # handle 12
> 		counter packets 1 bytes 84 queue num 0 # handle 13
> 		counter packets 0 bytes 0 # handle 14
> 		counter packets 0 bytes 0 ip saddr vmap @client_to_any # handle 16
> 		goto DENY # handle 17
> 	}
> 
> }
> The idea is that the first packet for an yet unknown client will
> bypass rules #12, match rule 13 and land in queue 0. The userspace
> process then generates the appropriate rules and return an NF_ACCEPT
> on the queue.
> 
> This should continue the rule processing at rule #14 and finally
> match on the update vmap in rule #16.

No, unfortunately thats not how NF_QUEUE operates.

On a QUEUE verdict the packet leaves the rule set context,
both in iptables and nftables.

> The problem is that the rule processing is not continuing as
> you can see on the counters.
> 
> http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.txt
> clearly states:
> 
> > 1. NF_ACCEPT: continue traversal as normal.
> 
> So, why is the processing aborted?

NF_ACCEPT makes packets move to the next *netfilter hook*,
but thats not the same as the next (nf|ip)tables rule.

e.g. in iptables if you NFQUEUE in mangle input packet re-appears
in filter input after an ACCEPT reinject.

> It also appears as if the nft trace infrastructure does not now how to
> deal with queues. The above rules lead to this annotated trace output:
> 
> > trace id 10d53daf ip filter client_to_any packet: iif "upstream" oif "ens256" ether saddr 00:50:56:96:9b:1c ether daddr 00:0c:29:46:1f:53 ether type ip6 
> 
> That's rule #11... Where is the hit on the queue rule and the return??

No idea, I will have a closer look next week.
Glancing at the code it should work just fine.

> The missing trace are only cosmetic (albeit confusing during debugging), but
> that the queue aborts the rule processing seems to be a bug.

Unfortunately no, this is how it has always been.

I think we could make it work better in nftables but it would require
a lot more work and it would leak nf_tables details into the generic
core.

We would have to
1. store a pointer to the rule head that caused the queueing in
nf_queue_entry struct
2. also store the current generation counter of the table
3. on reinject we'd have to check that rule head pointer is nonzero
(i.e. queued from nftables), then call into an nftables specific
reinject function that would check if the generation counter is
identical (to detect when rules might have been changed in meantime).
