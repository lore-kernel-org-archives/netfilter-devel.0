From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 3/3] acct: add input and output interface index
Date: Thu, 17 Oct 2013 13:06:30 +0200
Message-ID: <20131017110630.GA11148@localhost>
References: <20130926153150.280914229@eitzenberger.org>
 <20130926154005.592908761@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54324 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3JQLGf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:06:35 -0400
Content-Disposition: inline
In-Reply-To: <20130926154005.592908761@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Holger,

I like patches 1/3 and 2/3, they are nice cleanups.

Some comments regarding this patch.

On Thu, Sep 26, 2013 at 05:31:53PM +0200, Holger Eitzenberger wrote:
> The interface indices are exported as uint32_t, although being
> signed integer inside the kernel, which goes in line with
> what nfnetlink_queue does.
> 
> Both interface indices are wrapped inside CTA_ACCT.
> 
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> 
> Index: net-next-ipfix/include/net/netfilter/nf_conntrack_acct.h
> ===================================================================
> --- net-next-ipfix.orig/include/net/netfilter/nf_conntrack_acct.h
> +++ net-next-ipfix/include/net/netfilter/nf_conntrack_acct.h
> @@ -21,6 +21,8 @@ struct nf_conn_counter {
>  
>  struct nf_conn_acct {
>  	struct nf_conn_counter counter[IP_CT_DIR_MAX];
> +	int indev;
> +	int outdev;
>  };
>  
>  static inline
> Index: net-next-ipfix/net/netfilter/nf_conntrack_core.c
> ===================================================================
> --- net-next-ipfix.orig/net/netfilter/nf_conntrack_core.c
> +++ net-next-ipfix/net/netfilter/nf_conntrack_core.c
> @@ -33,6 +33,7 @@
>  #include <linux/mm.h>
>  #include <linux/nsproxy.h>
>  #include <linux/rculist_nulls.h>
> +#include <net/dst.h>
>  
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_l3proto.h>
> @@ -1110,6 +1111,7 @@ void __nf_ct_refresh_acct(struct nf_conn
>  acct:
>  	if (do_acct) {
>  		struct nf_conn_acct *acct;
> +		struct dst_entry *dst;
>  
>  		acct = nf_conn_acct_find(ct);
>  		if (acct) {
> @@ -1117,6 +1119,13 @@ acct:
>  
>  			atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
>  			atomic64_add(skb->len, &counter[CTINFO2DIR(ctinfo)].bytes);
> +
> +			if (acct->indev == 0 && skb->dev)
> +				acct->indev = skb->dev->ifindex;
> +
> +			dst = skb_dst(skb);
> +			if (acct->outdev == 0 && dst && dst->dev)
> +				acct->outdev = dst->dev->ifindex;

If you only set indev/outdev once we can skip the conntrack extension
by passing the skb to nf_ct_deliver_cached_events and include this
information in the conntrack events. That would not allow to dump the
device from conntrack dumps though. I still have concerns with this
approach as this doesn't seem to cover the scenario in which the
in/outdev changes.

Regards.
