From: Patrick McHardy <kaber@trash.net>
Subject: Re: [16/19] libxt_iprange r0
Date: Sun, 20 Jan 2008 14:42:17 +0100
Message-ID: <47934FB9.20203@trash.net>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58168 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYATNnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:43:16 -0500
In-Reply-To: <Pine.LNX.4.64.0801161453070.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Move libipt_iprange to libxt_iprange.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> ---
>  extensions/libipt_iprange.c                |  175 -----------------------------
>  extensions/libipt_iprange.man              |    7 -
>  extensions/libxt_iprange.c                 |  170 ++++++++++++++++++++++++++++
>  extensions/libxt_iprange.man               |    7 +
>  include/linux/netfilter/xt_iprange.h       |   17 ++
>  include/linux/netfilter_ipv4/ipt_iprange.h |    8 -
>  7 files changed, 198 insertions(+), 188 deletions(-)

Applied.

> Index: iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
> ===================================================================
> --- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_iprange.h
> +++ iptables-modules/include/linux/netfilter_ipv4/ipt_iprange.h
> @@ -1,14 +1,12 @@
>  #ifndef _IPT_IPRANGE_H
>  #define _IPT_IPRANGE_H
>  
> -#define IPRANGE_SRC		0x01	/* Match source IP address */
> -#define IPRANGE_DST		0x02	/* Match destination IP address */
> -#define IPRANGE_SRC_INV		0x10	/* Negate the condition */
> -#define IPRANGE_DST_INV		0x20	/* Negate the condition */
> +#include <linux/types.h>
> +#include <linux/netfilter/xt_iprange.h>
>  
>  struct ipt_iprange {
>  	/* Inclusive: network order. */
> -	u_int32_t min_ip, max_ip;
> +	__be32 min_ip, max_ip;
>  };
>  
>  struct ipt_iprange_info
> 

Do we really want to keep this file?
