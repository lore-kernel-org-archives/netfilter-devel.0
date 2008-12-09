From: Patrick McHardy <kaber@trash.net>
Subject: Re: libxt_rateest: fix segfault
Date: Tue, 09 Dec 2008 15:05:17 +0100
Message-ID: <493E7B1D.7030003@trash.net>
References: <alpine.LNX.1.10.0812081818050.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64647 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYLIOFX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:05:23 -0500
In-Reply-To: <alpine.LNX.1.10.0812081818050.2016@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 48c13b071a7f37ea57f93312c2547d5512b78f3e
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Dec 8 18:23:12 2008 +0100
> 
> libxt_rateest: fix segfault
> 
> When running `ip6tables -m rateest` without any other arguments,
> rateest did segfault.
> ---
>  extensions/libxt_rateest.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
> index ebea437..f0dd577 100644
> --- a/extensions/libxt_rateest.c
> +++ b/extensions/libxt_rateest.c
> @@ -306,7 +306,7 @@ rateest_final_check(unsigned int flags)
>  {
>  	struct xt_rateest_match_info *info = rateest_info;
>  
> -	if (!(info->flags & XT_RATEEST_MATCH_REL))
> +	if (info != NULL && !(info->flags & XT_RATEEST_MATCH_REL))
>  		info->flags |= XT_RATEEST_MATCH_ABS;

I think we should print an error message instead. The kernel will
refuse it anyways.
