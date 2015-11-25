From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Thu, 26 Nov 2015 00:19:40 +0100
Message-ID: <20151125231939.GN23215@breakpoint.cc>
References: <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125225256.GL23215@breakpoint.cc>
 <20151125231557.GC20093@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35057 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbbKYXTm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:19:42 -0500
Content-Disposition: inline
In-Reply-To: <20151125231557.GC20093@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 25.11, Florian Westphal wrote:
> > I could also get rid of all formatting of course, i.e. remove the
> > libnftnl_trace_*printf functions, so libnftnl would just provide
> > the nftnl_trace struct to nftables frontend and the internal translation
> > of netlink messages to that struct.
> 
> I think having some printing is useful to trace/debug netlink communication
> itself, IOW the basic data. Just the full header decoding seems rather
> unnecessary.

Okay.

> > Yes, this DEV_TYPE attribute is only included for NFPROTO_NETDEV where L2
> > could be anything ...
> 
> I actually changed that in my local version to include it whenever we have
> pkt->in so we can decode ARP using dev_proto_desc(). I'm also including the
> LL header whenever present so its now also used for f.i. incoming IPv4/v6
> packets:
> 
> trace id 847cdc00 ip packet: iif ens3 ether daddr c9:4b:a9:00:54:52 ether saddr 63:f6:4b:00:54:52 ip hdrlength 4 ip version 5 ip tos 16 ip length 60 ip id 44588 ip frag-off 16384 ip ttl 64 ip checksum 5849 ip saddr 192.168.122.1 ip daddr 192.168.122.84 tcp sport 43178 tcp dport 10000
> 
> I've attached that change to the mail. At least the DEV_TYPE part is needed
> to make sense out of the ARP ll header in a generic way.

I see, thanks!

> +	if (pkt->in &&
> +	    nla_put_be16(nlskb, NFTA_TRACE_DEV_TYPE, htons(pkt->in->type)))
> +		return false;

Yes, much better.  Thanks Patrick!
