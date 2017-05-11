From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] netfilter: synproxy: fix conntrackd interaction
Date: Thu, 11 May 2017 18:14:28 +0200
Message-ID: <20170511181428.4b3416cc@redhat.com>
References: <20170511132255.13805-1-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        brouer@redhat.com
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757777AbdEKQOx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2017 12:14:53 -0400
In-Reply-To: <20170511132255.13805-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 11 May 2017 15:22:55 +0200
Eric Leblond <eric@regit.org> wrote:

> This patch fixes the creation of connection tracking entry from
> netlink when synproxy is used. It was missing the addition of
> the synproxy extension.
> 
> This was causing kernel crashes when a conntrack entry created by
> conntrackd was used after the switch of traffic from active node
> to the passive node.

You are missing a Signed-off-by line ;-)

> ---
>  net/netfilter/nf_conntrack_netlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index dcf561b5c97a..1a127677ffe1 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -45,6 +45,8 @@
>  #include <net/netfilter/nf_conntrack_zones.h>
>  #include <net/netfilter/nf_conntrack_timestamp.h>
>  #include <net/netfilter/nf_conntrack_labels.h>
> +#include <net/netfilter/nf_conntrack_seqadj.h>
> +#include <net/netfilter/nf_conntrack_synproxy.h>
>  #ifdef CONFIG_NF_NAT_NEEDED
>  #include <net/netfilter/nf_nat_core.h>
>  #include <net/netfilter/nf_nat_l4proto.h>
> @@ -1828,6 +1830,8 @@ ctnetlink_create_conntrack(struct net *net,
>  	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
>  	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
>  	nf_ct_labels_ext_add(ct);
> +	nfct_seqadj_ext_add(ct);
> +	nfct_synproxy_ext_add(ct);
>  
>  	/* we must add conntrack extensions before confirmation. */
>  	ct->status |= IPS_CONFIRMED;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
