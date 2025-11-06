Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBAF2C237E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Nov 2025 23:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472810; cv=none; b=RVV7tigmk7JoLSc1OLXJQrjlcp4UCwi6aZiVzaSl0H/YmRKWN509/NSJhpjYfwL+U5rTJukEzvIhl8Zv+n6jnNriKlv+eA/i3oiss1GFM1IsocsFc+KlsdZkr2xo9Ym5fuREqLGGued9QEvKs7cJinsOc6W63NrlroXds/a8Fdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472810; c=relaxed/simple;
	bh=Gdfjn9KPu1OLY3psN0MYZ7vBRlHcj16FndSX41v/FWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRXirE4DL8fU2XU1gRQ6NL3dR8VP89oVNeH4iBpBNn1h8v7L3N3kwqjVu0p22hsQNmE4tIz5hj7B8TZ0DJVb4inO6ausPHOJ+pGfU5k3MpY/LyQrF4sjWyleYRv7ZXs+Eo0fos0/SR7pkTWnFsuckppSciZfGbz+tv2glUznaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C37E2601A1; Fri,  7 Nov 2025 00:46:45 +0100 (CET)
Date: Fri, 7 Nov 2025 00:46:45 +0100
From: Florian Westphal <fw@strlen.de>
To: "Antoine C." <acalando@free.fr>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: Re: bug report: MAC src + protocol optiomization failing with 802.1Q
 frames
Message-ID: <aQ0zZe__4AKOWCj3@strlen.de>
References: <aP-76gB9axgCebpL@strlen.de>
 <628074913.12181179.1761604837771.JavaMail.root@zimbra62-e11.priv.proxad.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <628074913.12181179.1761604837771.JavaMail.root@zimbra62-e11.priv.proxad.net>

Antoine C. <acalando@free.fr> wrote:
> ----- Florian Westphal <fw@strlen.de> a écrit :
> > Antoine C. <acalando@free.fr> wrote:
> > > 
> > > This bug does not seem to get a lot of attention but may be it
> > > deserves at least to be filed ?
> > 
> > Its a design bug and so far not a single solution was
> > presented.
> > 
> > And no one answered any of the questions that I asked.
> > 
> > So, whats YOUR opinion?
> > 
> > > > Should "ip saddr 1.2.3.4" match:
> > > > 
> > > > Only in classic ethernet case?
> > > > In VLAN?
> > > > In QinQ?
> > > > 
> > > > What about IP packet in a PPPOE frame?
> > > > What about other L2 protocols?
> 
> As a user, my answer would be of course that "ip xxx" rules 
> work seamlessly whatever the encapsulation is above. I have

Thanks.  I believe that this is the way to go, i.e., if user asks
to match L3, then we should be greedy and attempt to provide the
relevant context.

TL;DR: I think
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251104145728.517197-4-ericwouds@gmail.com/

is the way to go with only minor changes needed.

Unfortunately this isn't as easy as it sounds.
Lets see where we are:

When user asks for 'ip saddr 1.2.3.4'. we must provide context
for matching to work in first place.

1. Kernel doesn't always know where to start the matching (the network
header offset in this case).  For ethernet and vlan the kernel will
know.

But for other procotols on top of ethernet that might not be the case
especially if the kernel is only forwarding frames.

To make 'ip saddr' work on bridge with other encapsulations, e.g. PPPoE,
this needs kernel changes.

That also means that existing rules behave differently when updating
kernel with new L2 encap protocol support.

2. Even if kernel knows where in the frame the network header starts,
'ip saddr 1.2.3.4' must not match e.g. an ipv6 packet.

This is solved (or rather, supposed to be solved) by nftables userspace:
For bridge family nft will insert a protocol dependency check
internally, in the given example it is
'meta load protocol;cmp eq 0x0800'.

- It excludes non-ipv4 (no false matches). This is wanted behavior.
- It includes VLAN encapsulated frames because kernel (by default)
  removes vlan headers and thus replaces the 0x8100 vlan type with
  the upper protocol.
- If kernel is configured to not do that, then this will only match
  normal (non-vlan) ipv4 ethernet frames.

If we want to make 'ip saddr 1.2.3.4' always match for netdev and bridge
families, then we need to make changes on both userspace and/or kernel:

- kernel must, for bridge and netdev chains, follow the L2 encap trail
  until it finds ip/ip6 protocol or it can't follow any further.

 This means extension to also skip PPPoE, q-in-q and so on and would
 be largely identical to what Eric Woudstras patches already do.

Downside: Behaviour change on kernel upgrade: packets that were
not matched before now will be, UNLESS we don't update
skb->protocol value and e.g. add a new l3proto field to nft_pktinfo.

That in turn is also problematic, because it means that we'd have to
add a new 'meta l3proto' that can extract this from nft_pktinfo
as a replacement of 'meta protocol'.

Semantics would be:
meta protocol == skb->protocol

meta l3proto == "last" ETH_P_ that kernel could figure out.
It is similar to 'ip6 nexthdr' vs. 'meta l4proto';
former is just the first next header value, the latter the last
protocol header with all extension headers, if any, skipped.

The problem is that, given its a new extension, we can't update
nftables to use it for implicit dependencies; else rule add
fails on older kernels.

If we ignore that and pretend we could change this, then
the behaviour of:

ip saddr 1.2.3.4 (with meta l3proto dep)
ip saddr 1.2.3.4 (with current meta protocol)

... are identical between the two options
(i.e., follow dependency trail and update skb->protocol to last
 known ETH_P value) resp. 'stash last known ETH_P in nft_pktinfo)
from user perspective.

That would also mean that nftables netdev family should be
fixed to follow the bridge dependency approach consistently
if possible.
