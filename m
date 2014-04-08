From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC 2/3] netfilter: nf_tables: Add meta expression key for
 bridge interface name
Date: Tue, 8 Apr 2014 10:34:18 +0200
Message-ID: <20140408083418.GA5272@localhost>
References: <1395911972-17259-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1395911972-17259-3-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20140408080642.GA3904@localhost>
 <5343B153.30804@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaDHIe1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:34:27 -0400
Content-Disposition: inline
In-Reply-To: <5343B153.30804@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 08, 2014 at 11:20:35AM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >Please, also rework this so we have one _init function for the get and
> >the set variants, ie. nft_meta_bridge_get_init and
> >nft_meta_bridge_set_init, I'd suggest.
> >
> >Apart from that, this patch looks fine to me. Thanks.
> 
> I fully changed that on the version 2. This RFC is no longer valid, prior to
> Patrick's comments and also his changes on nft_meta.c

Right, I looked at the wrong patchset, sorry.

In http://patchwork.ozlabs.org/patch/336891/, I can still see there
this chunk though.

+static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
+                                    struct nft_data data[NFT_REG_MAX
+ 1],
+                                    const struct nft_pktinfo *pkt)
+{
+       const struct nft_meta *priv = nft_expr_priv(expr);
+       const struct net_device *in = pkt->in, *out = pkt->out;
+       struct nft_data *dest = &data[priv->dreg];
+       const struct net_bridge_port *p;
+
+       if (pkt->ops->pf != NFPROTO_BRIDGE)

Do you really need this or is it just defensive?
