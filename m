From: Patrick McHardy <kaber@trash.net>
Subject: Re: 07/13 [NETFILTER]: Introduce NFPROTO_* constants
Date: Mon, 14 Jul 2008 15:31:55 +0200
Message-ID: <487B554B.1000109@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101526050.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44922 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYGNNdY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:33:24 -0400
In-Reply-To: <alpine.LNX.1.10.0807101526050.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Apr 10 10:50:33 2008 +0200
> 
> [NETFILTER]: Introduce NFPROTO_* constants
> 
> The netfilter subsystem only supports a handful of protocols (much
> less than PF_*) and even non-PF protocols like ARP and
> pseudo-protocols like PF_BRIDGE. By creating NFPROTO_*, we can earn a
> few memory savings on arrays that previously were always PF_MAX-sized
> and keep the pseudo-protocols to ourselves.
> 
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index 8c83d2e..0f37245 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -52,6 +52,15 @@ enum nf_inet_hooks {
>  	NF_INET_NUMHOOKS
>  };
>  
> +enum {
> +	NFPROTO_UNSPEC =  0,
> +	NFPROTO_IPV4   =  2,
> +	NFPROTO_ARP    =  3,
> +	NFPROTO_BRIDGE =  7,
> +	NFPROTO_IPV6   = 10,
> +	NFPROTO_NUMPROTO,
> +};

What about DECnet?
