From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: remove redundant skb check in
 nf_conntrack_put_reasm
Date: Thu, 20 Jun 2013 11:49:41 +0200
Message-ID: <20130620094941.GA23325@localhost>
References: <20130619142735.GA2758@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60694 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757304Ab3FTJtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:49:49 -0400
Content-Disposition: inline
In-Reply-To: <20130619142735.GA2758@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 19, 2013 at 10:27:35AM -0400, Phil Oester wrote:
> kfree_skb already checks for skb existence - remove redundant check from
> nf_conntrack_put_reasm.

Applied with changes. I have added this chunk to this patch.

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -154,8 +154,7 @@ static unsigned int nf_hashfn(struct
inet_frag_queue *q)
 
 static void nf_skb_free(struct sk_buff *skb)
 {
-       if (NFCT_FRAG6_CB(skb)->orig)
-               kfree_skb(NFCT_FRAG6_CB(skb)->orig);
+       kfree_skb(NFCT_FRAG6_CB(skb)->orig);
 }
 
 static void nf_ct_frag6_expire(unsigned long data)

Thanks.
