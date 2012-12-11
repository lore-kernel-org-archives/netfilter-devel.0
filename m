From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfnetlink_log mac address for 6in4 tunnels
Date: Tue, 11 Dec 2012 12:33:35 +0100
Message-ID: <20121211113335.GB23201@1984>
References: <5368964.1354730721679.JavaMail.root@elwamui-rustique.atl.sa.earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Bob Hockney <bhockney@ix.netcom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55251 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2LKLdn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:33:43 -0500
Content-Disposition: inline
In-Reply-To: <5368964.1354730721679.JavaMail.root@elwamui-rustique.atl.sa.earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Bob,

Thanks for spotting this.

On Wed, Dec 05, 2012 at 11:05:21AM -0700, Bob Hockney wrote:
> For tunnelled ipv6in4 packets, the LOG target (xt_LOG.c) adjusts the
> start of the mac field to start at the ethernet header instead of
> the ipv4 header for the tunnel.  This patch conforms what is passed
> by the NFLOG target through nfnetlink to what the LOG target does.
> Code borrowed from xt_LOG.c.

At quick look, this seems good to me, but still I have a couple of
comments:

Can send me a log line of xt_LOG to see how it looks in the SIT case?

Would you resend me this patch including the Signed-off-by tag?

> ===
> --- a/net/netfilter/nfnetlink_log.c        2012-11-28 17:11:02.285514325 -0700
> +++ b/net/netfilter/nfnetlink_log.c 2012-11-28 17:10:38.551830948 -0700
> @@ -382,6 +382,7 @@
>         struct nfgenmsg *nfmsg;
>         sk_buff_data_t old_tail = inst->skb->tail;
>         struct sock *sk;
> +       const unsigned char *hwhdrp;
> 
>         nlh = nlmsg_put(inst->skb, 0, 0,
>                         NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
> @@ -483,9 +484,16 @@
>         if (indev && skb_mac_header_was_set(skb)) {
>                 if (nla_put_be16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type)) ||
>                     nla_put_be16(inst->skb, NFULA_HWLEN,
> -                                htons(skb->dev->hard_header_len)) ||
> -                   nla_put(inst->skb, NFULA_HWHEADER, skb->dev->hard_header_len,
> -                           skb_mac_header(skb)))
> +                                htons(skb->dev->hard_header_len)))
> +                       goto nla_put_failure;
> +
> +               hwhdrp = skb_mac_header(skb);
> +
> +               if (skb->dev->type == ARPHRD_SIT)
> +                       hwhdrp -= ETH_HLEN;
> +
> +               if (!(hwhdrp < skb->head)  && nla_put(inst->skb, NFULA_HWHEADER,

hwhdrp >= skb->head seems easier to read to me.

> +                           skb->dev->hard_header_len, hwhdrp))
>                         goto nla_put_failure;
>         }
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
