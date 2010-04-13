From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] netfilter: ipv6: add IPSKB_REROUTED exclusion to
 NF_HOOK/POSTROUTING invocation
Date: Tue, 13 Apr 2010 15:33:23 +0200
Message-ID: <4BC472A3.90107@trash.net>
References: <1271162268-28131-1-git-send-email-jengelh@medozas.de> <1271162268-28131-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090801060101070602070608"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49648 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0DMNdY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:33:24 -0400
In-Reply-To: <1271162268-28131-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090801060101070602070608
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> Similar to how IPv4's ip_output.c works, have ip6_output also check
> the IPSKB_REROUTED flag. It will be set from xt_TEE for cloned packets
> since Xtables can currently only deal with a single packet in flight
> at a time.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv6/ip6_output.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index f314ba4..7e10f62 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -172,8 +172,9 @@ int ip6_output(struct sk_buff *skb)
>  		return 0;
>  	}
>  
> -	return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
> -		       ip6_finish_output);
> +	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
> +			    ip6_finish_output,
> +			    !(IP6CB(skb)->flags & IPSKB_REROUTED));

This needs to use an IP6SKB value to avoid clashes. I've fixed it up
as follows:

I'll also fix up the TEE patch to use the proper value for IPv6.

--------------090801060101070602070608
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 9c6eb28aca52d562f3ffbaebaa56385df9972a43
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Apr 13 15:32:16 2010 +0200

    netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
    
    Similar to how IPv4's ip_output.c works, have ip6_output also check
    the IPSKB_REROUTED flag. It will be set from xt_TEE for cloned packets
    since Xtables can currently only deal with a single packet in flight
    at a time.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Acked-by: David S. Miller <davem@davemloft.net>
    [Patrick: changed to use an IP6SKB value instead of IPSKB]
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index e0cc9a7..7bdf6ff 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -250,6 +250,7 @@ struct inet6_skb_parm {
 
 #define IP6SKB_XFRM_TRANSFORMED	1
 #define IP6SKB_FORWARDED	2
+#define IP6SKB_REROUTED		4
 };
 
 #define IP6CB(skb)	((struct inet6_skb_parm*)((skb)->cb))
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 236ac78..c10a38a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -172,8 +172,9 @@ int ip6_output(struct sk_buff *skb)
 		return 0;
 	}
 
-	return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
-		       ip6_finish_output);
+	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING, skb, NULL, dev,
+			    ip6_finish_output,
+			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
 }
 
 /*

--------------090801060101070602070608--
