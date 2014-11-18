From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND] netfilter: bridge: unshare bridge info before
 change it
Date: Tue, 18 Nov 2014 19:34:19 +0100
Message-ID: <20141118183419.GA5078@salvia>
References: <1416203323-22745-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56175 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbaKRSc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:32:26 -0500
Content-Disposition: inline
In-Reply-To: <1416203323-22745-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 17, 2014 at 01:48:43PM +0800, Gao feng wrote:
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 1a4f32c..b4612b9 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -653,7 +643,11 @@ static int br_nf_forward_finish(struct sk_buff *skb)
>  		in = nf_bridge->physindev;
>  		if (nf_bridge->mask & BRNF_PKT_TYPE) {
>  			skb->pkt_type = PACKET_OTHERHOST;
> -			nf_bridge->mask ^= BRNF_PKT_TYPE;
> +
> +			if (!nf_bridge_unset_mask(skb, BRNF_PKT_TYPE)) {
> +				kfree_skb(skb);
> +				return 0;
> +			}

This can now release the packet and, thus, drop it.

However, br_nf_forward_ip() always returns NF_STOLEN.

Could you revisit the error paths and confirm they are correct?

Thanks.

>  		}
>  		nf_bridge_update_protocol(skb);
>  	} else {
