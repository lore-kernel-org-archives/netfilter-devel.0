From: Ulrich Weber <ulrich.weber@gmail.com>
Subject: Re: [RFC PATCH 1/4] netfilter: ip6t_NPT: Fix checksuming.
Date: Tue, 29 Jan 2013 15:42:39 +0100
Message-ID: <5107DFDF.4050504@gmail.com>
References: <5104227C.3030306@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070706020304090800030500"
Cc: netfilter-devel@vger.kernel.org, jm@dilly.me, fw@strlen.de
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:43520 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3A2Omp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:42:45 -0500
Received: by mail-la0-f43.google.com with SMTP id ek20so354561lab.30
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jan 2013 06:42:43 -0800 (PST)
In-Reply-To: <5104227C.3030306@linux-ipv6.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070706020304090800030500
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi Yoshofuji,

thanks for your patches! If I add a onces complement
to the return value of csum_fold() it works for my setup.

Cheers
Ulrich

On 01/26/13 19:37, YOSHIFUJI Hideaki wrote:
> Cast __wsum from/to __sum16 is wrong.  Instead, apply appropriate
> conversion function: csum_unfold() or csum_fold().
>
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> ---
>  net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
> index 7302b0b..3ff281b 100644
> --- a/net/ipv6/netfilter/ip6t_NPT.c
> +++ b/net/ipv6/netfilter/ip6t_NPT.c
> @@ -30,7 +30,7 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
>  				(__force __wsum)npt->dst_pfx.in6.s6_addr16[i]);
>  	}
>  
> -	npt->adjustment = (__force __sum16) csum_sub(src_sum, dst_sum);
> +	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
>  	return 0;
>  }
>  
> @@ -66,8 +66,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
>  			return false;
>  	}
>  
> -	sum = (__force __sum16) csum_add((__force __wsum)addr->s6_addr16[idx],
> -			 npt->adjustment);
> +	sum = csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
> +				 csum_unfold(npt->adjustment)));
>  	if (sum == CSUM_MANGLED_0)
>  		sum = 0;
>  	*(__force __sum16 *)&addr->s6_addr16[idx] = sum;


--------------070706020304090800030500
Content-Type: text/x-patch;
 name="0001-netfilter-ip6t_NTP-Use-onces-complement-of-csum_fold.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-ip6t_NTP-Use-onces-complement-of-csum_fold.pa";
 filename*1="tch"

>From 40e0c6d86514a8dcc80f18fbe8a2945c6ee78f6d Mon Sep 17 00:00:00 2001
From: Ulrich Weber <ulrich.weber@sophos.com>
Date: Tue, 29 Jan 2013 15:24:21 +0100
Subject: [PATCH] netfilter: ip6t_NTP: Use onces complement of csum_fold

we need a 16bit value but not folded

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 74e171d..61a9b95 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -35,7 +35,7 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_param *par)
 	src_sum = csum_partial(&npt->src_pfx.in6, sizeof(npt->src_pfx.in6), 0);
 	dst_sum = csum_partial(&npt->dst_pfx.in6, sizeof(npt->dst_pfx.in6), 0);
 
-	npt->adjustment = csum_fold(csum_sub(src_sum, dst_sum));
+	npt->adjustment = ~csum_fold(csum_sub(src_sum, dst_sum));
 	return 0;
 }
 
@@ -71,8 +71,8 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
 			return false;
 	}
 
-	sum = csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
-				 csum_unfold(npt->adjustment)));
+	sum = ~csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr16[idx]),
+				  csum_unfold(npt->adjustment)));
 	if (sum == CSUM_MANGLED_0)
 		sum = 0;
 	*(__force __sum16 *)&addr->s6_addr16[idx] = sum;
-- 
1.7.9.5


--------------070706020304090800030500--
