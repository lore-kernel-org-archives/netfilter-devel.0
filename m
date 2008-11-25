From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: nfmark routing in OUTPUT, mangle, NFQUEUE
Date: Tue, 25 Nov 2008 12:17:38 +0100
Message-ID: <492BDED2.2000505@trash.net>
References: <1227559607-3077-1-git-send-email-eric@inl.fr> <1227559607-3077-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Laurent Licour <laurent@licour.com>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55750 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYKYLRs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:17:48 -0500
In-Reply-To: <1227559607-3077-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Laurent Licour <laurent@licour.com>
> 
> This patch let nfmark to be evaluated for routing decision for OUTPUT
> packet, in mangle table, when process paquet in NFQUEUE
> Until now, only change (in NFQUEUE process) on fields src_addr,
> dest_addr and tos could make netfilter to reevalute the routing.

Applied, thanks.

> diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
> index 6efdb70..3f2fc81 100644
> --- a/net/ipv4/netfilter.c
> +++ b/net/ipv4/netfilter.c
> @@ -125,6 +125,7 @@ struct ip_rt_info {
>  	__be32 daddr;
>  	__be32 saddr;
>  	u_int8_t tos;
> +	__u32 mark;

I've changed this to u_int32_t for consistency. The double
underscore types are only needed in headers made available
to userspace or for the endian annotated types.
