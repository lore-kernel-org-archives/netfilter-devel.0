From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 20/27] Update modules' descriptions
Date: Tue, 08 Jan 2008 16:50:26 +0100
Message-ID: <47839BC2.8060703@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022130450.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYAHPyX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:54:23 -0500
In-Reply-To: <Pine.LNX.4.64.0801022130450.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 09ab883e3163255acb54221de305237368c0803d
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:29:57 2008 +0100
> 
>     [NETFILTER]: Update modules' descriptions
>     
>     Updates the MODULE_DESCRIPTION() tags for all Netfilter modules,
>     actually describing what the module does and not just
>     "netfilter XYZ target".
>     

>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
> -MODULE_DESCRIPTION("iptables target for CLUSTERIP");
> +MODULE_DESCRIPTION("Netfilter: CLUSTERIP target");


I think the reference to iptables is actually more useful
than just netfilter. Could you resend after doing global
search and replace of Netfilter: with ip_tables/ip6_tables
etc.?
