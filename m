From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 4/6] Merge ipt_TOS into xt_DSCP
Date: Tue, 27 Nov 2007 01:02:07 +0100
Message-ID: <474B5E7F.9080009@trash.net>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711270043040.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39100 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbXK0ACM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:02:12 -0500
In-Reply-To: <Pine.LNX.4.64.0711270043040.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Merge ipt_TOS into xt_DSCP.
>
> Merge ipt_TOS (tos v0 target) into xt_DSCP. They both modify the same
> field in the IPv4 header, so it seems reasonable to keep them in one
> piece. This is part two of the implicit 4-patch series to move tos to
> xtables and extend it by IPv6.
>
> +	{
> +		.name       = "TOS",
> +		.revision   = 0,
> +		.family     = AF_INET,
> +		.table      = "mangle",
> +		.target     = tos_tg_v0,
> +		.targetsize = sizeof(struct ipt_tos_target_info),
> +		.checkentry = tos_tg_check_v0,
> +		.me         = THIS_MODULE,
> +	},
>  };
>  

Also applied but fixed indentation. Thanks.
