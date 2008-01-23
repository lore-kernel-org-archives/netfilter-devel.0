From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Wed, 23 Jan 2008 23:29:55 +0100
Message-ID: <4797BFE3.6090603@trash.net>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jaco@uls.co.za
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57660 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYAWWaK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:30:10 -0500
In-Reply-To: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On top of standard net branch, no previous patch required.
>
> ===
> commit 46bfc78a6b91251fd55140b27f382259fc3333a2
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 23 16:35:00 2008 +0100
>
>     [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
>     
>     The TCPMSS target in Xtables should consider the MTU of the reverse
>     route on forwarded packets as part of the path MTU.
>     
>     Point in case: IN=ppp0, OUT=eth0. MSS set to 1460 in spite of MTU of
>     ppp0 being 1392.
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>   

Applied, thanks.
> +static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
> +{
> +	struct flowi fl = {.nl_u = {.ip4_u = {
> +		.daddr = iph->saddr,
> +		.tos   = RT_TOS(iph->tos),
>   

This doesn't make much sense, we don't know the ToS value
that will be used in the reverse direction. People might also
use routing rules based on source address, iif etc., so I
think we should make this optional.

I'm on my way out the door, I'll take care of that tommorrow.

