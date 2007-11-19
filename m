From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] xt_TOS target
Date: Mon, 19 Nov 2007 11:40:09 +0100
Message-ID: <47416809.60900@trash.net>
References: <Pine.LNX.4.64.0711161357050.3340@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711161400170.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbXKSKk2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:40:28 -0500
In-Reply-To: <Pine.LNX.4.64.0711161400170.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Posted for review and checkup.
> 
> +++ net-2.6.25/include/linux/netfilter/xt_TOS.h
> @@ -0,0 +1,13 @@
> +#ifndef _XT_TOS_TARGET_H
> +#define _XT_TOS_TARGET_H
> +
> +#ifndef IPTOS_NORMALSVC
> +#	define IPTOS_NORMALSVC 0
> +#endif
> +
> +struct xt_tos_target_info {
> +	u_int8_t tos_value;
> +	u_int8_t tos_mask;


Is the mask thing really useful?

> --- net-2.6.25.orig/include/linux/netfilter_ipv4/Kbuild
> +++ net-2.6.25/include/linux/netfilter_ipv4/Kbuild
> @@ -9,7 +9,6 @@ header-y += ipt_NFQUEUE.h
>  header-y += ipt_REJECT.h
>  header-y += ipt_SAME.h
>  header-y += ipt_TCPMSS.h
> -header-y += ipt_TOS.h


We also need to keep this one I think.
