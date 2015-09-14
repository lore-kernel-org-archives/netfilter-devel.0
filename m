From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH nf v2] netfilter: bridge: fix routing of bridge frames
 with =?UTF-8?Q?call-iptables=3D=31?=
Date: Mon, 14 Sep 2015 21:03:24 +0200
Message-ID: <7bdbd9942c9e6fef4cda571c0a453821@eikelenboom.it>
References: <1442243187-19855-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:36693 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbbINTRp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 15:17:45 -0400
In-Reply-To: <1442243187-19855-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2015-09-14 17:06, Florian Westphal wrote:
> We can't re-use the physoutdev storage area.
> 
> 1.  When using NFQUEUE in PREROUTING, we attempt to bump a bogus
> refcnt since nf_bridge->physoutdev is garbage (ipv4/ipv6 address)
> 
> 2. for same reason, we crash in physdev match in FORWARD or later if
> skb is routed instead of bridged.
> 
> This increases nf_bridge_info to 40 bytes, but we have no other choice.
> 
> Fixes: 72b1e5e4cac7 ("netfilter: bridge: reduce nf_bridge_info to 32
> bytes again")
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Either
> - hard-reset nf.git to obliterate the v1 of the patch, then
> apply this one instead, OR,
> - revert v1 and apply this on top.

re-tested, and for my case this patch also works, thx again !
--
Sander

> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 2738d35..9987af0 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -179,6 +179,9 @@ struct nf_bridge_info {
>  	u8			bridged_dnat:1;
>  	__u16			frag_max_size;
>  	struct net_device	*physindev;
> +
> +	/* always valid & non-NULL from FORWARD on, for physdev match */
> +	struct net_device	*physoutdev;
>  	union {
>  		/* prerouting: detect dnat in orig/reply direction */
>  		__be32          ipv4_daddr;
> @@ -189,9 +192,6 @@ struct nf_bridge_info {
>  		 * skb is out in neigh layer.
>  		 */
>  		char neigh_header[8];
> -
> -		/* always valid & non-NULL from FORWARD on, for physdev match */
> -		struct net_device *physoutdev;
>  	};
>  };
>  #endif
