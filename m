From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/27] xt_conntrack match, revision 1
Date: Fri, 04 Jan 2008 15:53:49 +0100
Message-ID: <477E487D.8000901@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48751 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYADO4v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:56:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7e6ab7f2e7eb220d2ee5ce7f744a22deb10a5144
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:55:31 2008 +0100
> 
>     [NETFILTER]: xt_conntrack match, revision 1
>     
>     Introduces the xt_conntrack match revision 1. It uses fixed types, the
>     new nf_inet_addr and comes with IPv6 support, thereby completely
>     superseding xt_state.

Applied, but

> diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
> index 70b6f71..d2492a3 100644
> --- a/include/linux/netfilter/xt_conntrack.h
> +++ b/include/linux/netfilter/xt_conntrack.h
> @@ -6,7 +6,9 @@
>  #define _XT_CONNTRACK_H
>  
>  #include <linux/netfilter/nf_conntrack_tuple_common.h>
> -#include <linux/in.h>
> +#ifdef __KERNEL__
> +#	include <linux/in.h>
> +#endif

Is that really necessary? I would prefer the only in-kernel user of this
file to include it directly. Or simply include netfilter.h, which seems
necessary for nf_inet_addr anyway.
