From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: revert broken reject icmp code support
Date: Fri, 20 Jun 2014 20:02:03 +0100
Message-ID: <20140620190202.GA328@macbook.localnet>
References: <1403281015-9774-1-git-send-email-pablo@netfilter.org>
 <20140620180626.GB3479@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alvaroneay@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaFTTCI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:02:08 -0400
Content-Disposition: inline
In-Reply-To: <20140620180626.GB3479@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 20, 2014 at 08:06:26PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 20, 2014 at 06:16:55PM +0200, Pablo Neira Ayuso wrote:
> > This patch reverts Alvaro's 34040b1 ("reject: add ICMP code parameter
> > for indicating the type of error") and 11b2bb2 ("reject: Use protocol
> > context for indicating the reject type").
> > 
> > These patches are flawed by several things:
> > 
> > 1) IPv6 support is broken, only ICMP codes are considered.
> > 2) If you don't specify any transport context, the utility exits without
> >    adding the rule, eg. nft add rule ip filter input reject.
> > 3) If you mistype the ICMP code name, the tool doesn't bail out.
> > 
> > Let's revert this until we can provide appropriate reject reason support.

ACK for the revert, the patch has a couple of more problems. Just mentioning
that for any future attempt:

+       base = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+       if (base == NULL)
+               return -1;

Causes silent failure in the inet table. It needs to print an error.

+       if (strcmp(base->name, "tcp") == 0)
+               stmt->reject.type = NFT_REJECT_TCP_RST;
+       else
+               stmt->reject.type = NFT_REJECT_ICMP_UNREACH;

Should not use strcmp but the protocol values.

> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > On top of this, there's another problem we have to solve. If reject
> > is used from the inet table, it uses the same ICMP code but that is
> > not good since IPv4 and IPv6 destination unreachable codes are different
> > and they don't overlap.
> > 
> > I'm considering different alternatives to fix this, such as renaming
> > NFTA_REJECT_ICMP_CODE to NFTA_REJECT_REASON which provides an abstract
> > representation. But the abstraction doesn't seem straight forward to me.
> 
> Thinking it well, I think we can resolve this from userspace, eg.
> 
>     nft add rule inet filter input reject with icmp-net-unreach
> 
> The rule for IPv6 in the inet table would look like:
> 
>     nft add rule inet filter input reject with icmpv6-port-unreach
> 
> based on the icmp-* / icmpv6-* the protocol context is set so the
> rule is restricted to IPv4 / IPv6.

That should be good enough for now.
