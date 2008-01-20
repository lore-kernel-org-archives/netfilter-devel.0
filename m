From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] [NETFILTER]: xt_TCPMSS: Consider incoming device's
 MTU in clamp-to-pmtu
Date: Sun, 20 Jan 2008 14:48:23 +0100
Message-ID: <47935127.30902@trash.net>
References: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58282 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYATNtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 08:49:23 -0500
In-Reply-To: <Pine.LNX.4.64.0801201318040.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 1ed78bbf75455dfe77a028f2da2f351cff4028f2
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Jan 20 13:13:33 2008 +0100
> 
>     [NETFILTER]: xt_TCPMSS: Consider incoming device's MTU in clamp-to-pmtu
>     
>     The TCPMSS target in Xtables should consider the MTU of the input
>     device on forwarded packets as part of the path MTU.
>     
>     Point in case: IN=ppp0, OUT=eth0. MSS set to 1460 in spite of MTU of
>     ppp0 being 1392.


> -				   sizeof(*ipv6h) + sizeof(struct tcphdr));
> +	ret = tcpmss_mangle_packet(skb, targinfo, (in == NULL) ? ~0U : in->mtu,
> +	      tcphoff, sizeof(*ipv6h) + sizeof(struct tcphdr));


This is slightly better than what we currently have, but it should
actually use the MTU from the dst_entry for the reverse direction.
I've tried adding this not too long ago and ran into some problems,
but I can't remember the exact details.
