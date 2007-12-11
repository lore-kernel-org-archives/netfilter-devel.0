From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/7] xt_MARK target rev 2
Date: Tue, 11 Dec 2007 11:27:36 +0100
Message-ID: <475E6618.5080007@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341310.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXLKK1h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:27:37 -0500
In-Reply-To: <Pine.LNX.4.64.0712070341310.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Introduce the xt_MARK target revision 2. It uses fixed types, with the
> goal of obsoleting revision 0 and 1 some day (uses nonfixed types).
> xt_MARK rev 2 also uses more expressive XOR logic.

Can I see a userspace patch for this please? :)

> @@ -158,6 +169,22 @@ static struct xt_target mark_tg_reg[] __
>  		.table		= "mangle",
>  		.me		= THIS_MODULE,
>  	},
> +	{
> +		.name       = "MARK",
> +		.revision   = 2,
> +		.family     = AF_INET,
> +		.target     = mark_tg,
> +		.targetsize = sizeof(struct xt_mark_target_info_v2),
> +		.me         = THIS_MODULE,
> +	},

And please keep this aligned to the already existing ones.
