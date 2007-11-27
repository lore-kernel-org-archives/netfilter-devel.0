From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 3/6] Merge ipt_tos into xt_dscp
Date: Tue, 27 Nov 2007 01:01:02 +0100
Message-ID: <474B5E3E.5090501@trash.net>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711270042410.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbXK0ABH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:01:07 -0500
In-Reply-To: <Pine.LNX.4.64.0711270042410.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Merge ipt_tos into xt_dscp.
>
> Merge ipt_tos (tos v0 match) into xt_dscp. They both modify the same
> field in the IPv4 header, so it seems reasonable to keep them in one
> piece. This is part one of the implicit 4-patch series to move tos to
> xtables and extend it by IPv6.
>
>  static struct xt_match dscp_mt_reg[] __read_mostly = {
>  	{
>  		.name		= "dscp",
> @@ -77,6 +89,14 @@ static struct xt_match dscp_mt_reg[] __r
>  		.matchsize	= sizeof(struct xt_dscp_info),
>  		.me		= THIS_MODULE,
>  	},
> +	{
> +		.name      = "tos",
> +		.revision  = 0,
> +		.family    = AF_INET,
> +		.match     = tos_mt_v0,
> +		.matchsize = sizeof(struct ipt_tos_info),
> +		.me        = THIS_MODULE,
> +	},


Applied, but changed the last part to match the indentation of
the other match structs.


