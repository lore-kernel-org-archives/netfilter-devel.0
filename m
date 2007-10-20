From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add xt_tos
Date: Sat, 20 Oct 2007 17:48:08 +0200
Message-ID: <471A2338.6060501@trash.net>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34285 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbXJTPtI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:49:08 -0400
In-Reply-To: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> --- /dev/null
> +++ gitone/include/linux/netfilter/xt_tos.h
> @@ -0,0 +1,13 @@
> +#ifndef _XT_TOS_MATCH_H
> +#define _XT_TOS_MATCH_H
> +
> +struct xt_tos_info {
> +	u_int8_t tos;
> +	u_int8_t invert;
> +};
>   

I think this will break compatiblity on CRIS, which IIRC doesn't
perform any alignment (XT_ALIGN becomes a NOP) and thus the
structure size increases.

I've already queued up the patch with some changes (capital
letters removed from function names, keep ipt_TOS.h, Kbuild),
could you send me a fix on top of that? I guess the options
are to remove inversion or to introduce a new revision (or
to convice me that I'm wrong :))
