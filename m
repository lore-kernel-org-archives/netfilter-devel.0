From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: reject: don't send icmp error if packet
 has invalid checksum
Date: Wed, 11 Feb 2015 16:16:54 +0100
Message-ID: <20150211151654.GA22887@breakpoint.cc>
References: <1422525586-9760-1-git-send-email-fw@strlen.de>
 <20150129102157.GB5794@salvia>
 <20150131214717.GA24751@breakpoint.cc>
 <20150211150112.GA4315@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43386 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416AbbBKPQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2015 10:16:56 -0500
Content-Disposition: inline
In-Reply-To: <20150211150112.GA4315@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Jan 31, 2015 at 10:47:17PM +0100, Florian Westphal wrote:
> > Some issues that I found:
> > Doesn't work in INPUT since skb->dev is the bridge port, so we end
> > with NULL br_port_get_rcu (no crash, br_deliver is noop).
> > 
> > After fixing INPUT issue, nft reject from bridge works if
> > nf-call-iptables is on, most likely due to extra pskb_trim_rcsum
> > done by bridge_netfilter before PREROUTING invocation for ipv4.
> > 
> > Adding an explicit call to pskb_trim_rcsum() seemed to make reject
> > work from bridge layer in both prerouting and input.
> 
> Will you send me formal submission for this?

I considered it ugly kludge but given we're dropping anyway
it should be ok.  So yes, I'll send you a formal patch, but not this
week, sorry :-|

> > Untested further possible issues:
> > 
> > seems nf*_ip_checksum() only works for UDP or TCP, not with
> > e.g. SCTP or UDPLITE.
> 
> I guess you'll have to add checks in that function for all transport
> protocols that we support, may require some ifdefs.

Seems ifdefs are not enough, e.g. sctp would need libcrc32c module :-(

Not sure what to do at the moment, perhaps only do csum validation for
UDP and TCP, and rely on ipv4 csum alone for the rest?

For ipv6, this would obviously mean no csum validation except
for tcp and udp.
