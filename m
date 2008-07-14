From: Patrick McHardy <kaber@trash.net>
Subject: Re: 10/13 [NETFILTER]: Give AF-independent extensions an arpt_ aliases
Date: Mon, 14 Jul 2008 15:38:43 +0200
Message-ID: <487B56E3.5060203@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101528480.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45217 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYGNNkM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:40:12 -0400
In-Reply-To: <alpine.LNX.1.10.0807101528480.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Jul 8 00:39:24 2008 +0200
> 
> [NETFILTER]: Give AF-independent extensions an arpt_ aliases
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/netfilter/xt_CLASSIFY.c  |    1 +
>  net/netfilter/xt_MARK.c      |    1 +
>  net/netfilter/xt_RATEEST.c   |    1 +
>  net/netfilter/xt_limit.c     |    1 +
>  net/netfilter/xt_mark.c      |    1 +
>  net/netfilter/xt_quota.c     |    1 +
>  net/netfilter/xt_rateest.c   |    1 +
>  net/netfilter/xt_statistic.c |    1 +
>  net/netfilter/xt_time.c      |    1 +
>  net/netfilter/xt_u32.c       |    1 +

arp_tables doesn't support external matches, so the match
aliases don't make much sense.
