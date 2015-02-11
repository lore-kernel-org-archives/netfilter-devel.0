From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: reject: don't send icmp error if packet
 has invalid checksum
Date: Wed, 11 Feb 2015 16:01:12 +0100
Message-ID: <20150211150112.GA4315@salvia>
References: <1422525586-9760-1-git-send-email-fw@strlen.de>
 <20150129102157.GB5794@salvia>
 <20150131214717.GA24751@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60385 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbbBKO56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 09:57:58 -0500
Content-Disposition: inline
In-Reply-To: <20150131214717.GA24751@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 31, 2015 at 10:47:17PM +0100, Florian Westphal wrote:
> Some issues that I found:
> Doesn't work in INPUT since skb->dev is the bridge port, so we end
> with NULL br_port_get_rcu (no crash, br_deliver is noop).
> 
> After fixing INPUT issue, nft reject from bridge works if
> nf-call-iptables is on, most likely due to extra pskb_trim_rcsum
> done by bridge_netfilter before PREROUTING invocation for ipv4.
> 
> Adding an explicit call to pskb_trim_rcsum() seemed to make reject
> work from bridge layer in both prerouting and input.

Will you send me formal submission for this?

> Untested further possible issues:
> 
> seems nf*_ip_checksum() only works for UDP or TCP, not with
> e.g. SCTP or UDPLITE.

I guess you'll have to add checks in that function for all transport
protocols that we support, may require some ifdefs. We may still reply
to unknown transport protocols depending on the iptables
configuration, but there's little we can do on that.

Thanks Florian.
