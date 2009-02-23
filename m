From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: conntrack: account packets drop by
 tcp_packet()
Date: Mon, 23 Feb 2009 11:48:48 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902231147390.29210@fbirervta.pbzchgretzou.qr>
References: <20090223101551.7309.61740.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZBWKsu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:48:50 -0500
In-Reply-To: <20090223101551.7309.61740.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-23 11:15, Pablo Neira Ayuso wrote:
>diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
>index 8b9dbb7..4503727 100644
>--- a/net/netfilter/nf_conntrack_core.c
>+++ b/net/netfilter/nf_conntrack_core.c
>@@ -733,6 +733,8 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
> 		nf_conntrack_put(skb->nfct);
> 		skb->nfct = NULL;
> 		NF_CT_STAT_INC_ATOMIC(net, invalid);
>+		if (-ret == NF_DROP)
>+			NF_CT_STAT_INC_ATOMIC(net, drop);
> 		return -ret;
> 	}
> 

*boggle* Why not just "ret == -NF_DROP"?
The assumption would be near that "-NF_DROP" is a constant just
as "NF_DROP" would be, but "-ret" involves an extra instruction
for negating ret.

