From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: How to send nf trace notifications to userspace?
Date: Sat, 7 Nov 2015 17:38:35 +0100
Message-ID: <20151107163835.GA962@salvia>
References: <20151106232900.GA24154@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45512 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbbKGQbM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 11:31:12 -0500
Content-Disposition: inline
In-Reply-To: <20151106232900.GA24154@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 07, 2015 at 12:29:00AM +0100, Florian Westphal wrote:
[...]
> However, the code uses nfnetlink_log.  It appears that its
> unicast only, i.e. its not possible to run another 'nft trace' in parallel
> and also clashes with ulogd or other running logger.
> 
> Thats a non-starter.
> 
> So I'm inclined to toss the nfnetlink_log based changes and
> instead (re-)use the infrastructure that we have for chain, rule, ... notifications.

Something that integrates tightly with the infrastructure is the way
to go. I'd suggest you add a new NFNLGRP_NFTABLES_TRACE nfnetlink
group.

> [...] Also saves us from the 'rule counting' that we're currently
> doing in kernel.

I think we'll have to keep that counting around to provide the legacy
output from the compat layer.

> $ src/nft trace
> SRC=192.168.7.1 DST=192.168.7.10 LEN=88 TTL=64 ID=39366 PROTO=6 SPT=47028 DPT=22 raw prerouting (# handle 6)
> ACCEPT raw prerouting
> filter input (# handle 7)
>         tcp dport ssh jump foo
> filter foo (# handle 5)
>         ip daddr 192.168.7.10
> filter foo (# handle 6)
>         counter packets 912 bytes 63619
> RETURN filter foo
> filter input (# handle 8)
>         ip protocol tcp ip daddr 192.168.7.10
> filter input (# handle 9)
>         tcp dport ssh accept

I guess this is a draft proposal, but I think it would be good to have
a more compact output that can be easily read, eg.

matches: filter input tcp dport ssh accept # handle 9

> Do you think its useful to also dump skb data (i.e. in/outdev,
> packet payload, etc?)

Such information is useful to know what packet is matching what rules.

If we have a way to uniquely identify the packet (probably part of the
skbuff address as we do with conntrack ID from ctnetlink?), we can
just dump this packet data and metadata only once when setting
skb->nf_trace to 1, then from the trace event we only include the
packet ID that results from matching a rule, so userspace can
correlate.

On a different front but related, I think this infrastructure may
allow us to implement the packet path test infrastructure that we
discussed many times before during netfilter workshops at some point.
Kind of similar thing that Rusty made time ago with nfsim.

Thanks for taking over this.
