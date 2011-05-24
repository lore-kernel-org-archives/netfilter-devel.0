From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/13] libxt_rateest: avoid optional arguments
Date: Tue, 24 May 2011 08:46:05 +0200
Message-ID: <4DDB542D.5060006@trash.net>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de> <1306161564-4370-11-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48502 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1EXGql (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 02:46:41 -0400
In-Reply-To: <1306161564-4370-11-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.05.2011 16:39, Jan Engelhardt wrote:
> Optional arguments make parsing unnecessarily harder - even more so
> than two-args. Right now, rateest even crashes because of it.
> 
>  static const struct option rateest_opts[] = {
>  	{.name = "rateest1",      .has_arg = true,  .val = OPT_RATEEST1},
>  	{.name = "rateest",       .has_arg = true,  .val = OPT_RATEEST1}, /* alias for absolute mode */
>  	{.name = "rateest2",      .has_arg = true,  .val = OPT_RATEEST2},
> -	{.name = "rateest-bps1",  .has_arg = false, .val = OPT_RATEEST_BPS1},
> -	{.name = "rateest-pps1",  .has_arg = false, .val = OPT_RATEEST_PPS1},
> -	{.name = "rateest-bps2",  .has_arg = false, .val = OPT_RATEEST_BPS2},
> -	{.name = "rateest-pps2",  .has_arg = false, .val = OPT_RATEEST_PPS2},
> -	{.name = "rateest-bps",   .has_arg = false, .val = OPT_RATEEST_BPS2}, /* alias for absolute mode */
> -	{.name = "rateest-pps",   .has_arg = false, .val = OPT_RATEEST_PPS2}, /* alias for absolute mode */
> +	{.name = "rateest-bps1",  .has_arg = true, .val = OPT_RATEEST_BPS1},
> +	{.name = "rateest-pps1",  .has_arg = true, .val = OPT_RATEEST_PPS1},
> +	{.name = "rateest-bps2",  .has_arg = true, .val = OPT_RATEEST_BPS2},
> +	{.name = "rateest-pps2",  .has_arg = true, .val = OPT_RATEEST_PPS2},
> +	{.name = "rateest-bps",   .has_arg = true, .val = OPT_RATEEST_BPS2}, /* alias for absolute mode */
> +	{.name = "rateest-pps",   .has_arg = true, .val = OPT_RATEEST_PPS2}, /* alias for absolute mode */
>  	{.name = "rateest-delta", .has_arg = false, .val = OPT_RATEEST_DELTA},
>  	{.name = "rateest-lt",    .has_arg = false, .val = OPT_RATEEST_LT},
>  	{.name = "rateest-gt",    .has_arg = false, .val = OPT_RATEEST_GT},
>  	{.name = "rateest-eq",    .has_arg = false, .val = OPT_RATEEST_EQ},
> +	{.name = "bytes",   .has_arg = false, .val = OPT_RATEEST_BYTES},
> +	{.name = "packets", .has_arg = false, .val = OPT_RATEEST_PACKETS},
>  	XT_GETOPT_TABLEEND,
>  };

This appears to be breaking backwards compatibility.
