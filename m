From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 12/24] libxt_ipvs: restore network-byte order
Date: Wed, 25 May 2011 09:31:53 +0900
Message-ID: <20110525003152.GI5387@verge.net.au>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
 <1306278506-11463-13-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:48873 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab1EYAb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 20:31:57 -0400
Content-Disposition: inline
In-Reply-To: <1306278506-11463-13-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 25, 2011 at 01:08:13AM +0200, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Reviewed-by: Simon Horman <horms@verge.net.au>
> ---
>  extensions/libxt_ipvs.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
> index 88d235f..4672766 100644
> --- a/extensions/libxt_ipvs.c
> +++ b/extensions/libxt_ipvs.c
> @@ -32,12 +32,14 @@ static const struct xt_option_entry ipvs_mt_opts[] = {
>  	{.name = "vaddr", .id = O_VADDR, .type = XTTYPE_HOSTMASK,
>  	 .flags = XTOPT_INVERT},
>  	{.name = "vport", .id = O_VPORT, .type = XTTYPE_PORT,
> -	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vport)},
> +	 .flags = XTOPT_NBO | XTOPT_INVERT | XTOPT_PUT,
> +	 XTOPT_POINTER(s, vport)},
>  	{.name = "vdir", .id = O_VDIR, .type = XTTYPE_STRING},
>  	{.name = "vmethod", .id = O_VMETHOD, .type = XTTYPE_STRING,
>  	 .flags = XTOPT_INVERT},
>  	{.name = "vportctl", .id = O_VPORTCTL, .type = XTTYPE_PORT,
> -	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vportctl)},
> +	 .flags = XTOPT_NBO | XTOPT_INVERT | XTOPT_PUT,
> +	 XTOPT_POINTER(s, vportctl)},
>  	XTOPT_TABLEEND,
>  };
>  #undef s
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
