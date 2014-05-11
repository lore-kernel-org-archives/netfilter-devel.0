From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 09/15] br_netfilter: pernet_operations brnf_net_ops without
 per-netns sysctl registration
Date: Sun, 11 May 2014 21:26:15 +0200
Message-ID: <536FCED7.3050400@pandora.be>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org> <536D4868.9020707@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:42725 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaEKT0S (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:18 -0400
In-Reply-To: <536D4868.9020707@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 9/05/2014 23:28:
> pernet_operations was added,
> rollback in br_netfilter_init was reworked
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>   net/bridge/br_netfilter.c |   60 ++++++++++++++++++++++++++++++++++++++------
>   1 files changed, 51 insertions(+), 9 deletions(-)
>
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index e3ab72f8..460917c 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -35,6 +35,7 @@
>   #include <net/ip.h>
>   #include <net/ipv6.h>
>   #include <net/route.h>
> +#include <net/netns/generic.h>
>
>   #include <asm/uaccess.h>
>   #include "br_private.h"
> @@ -47,6 +48,7 @@
>   #define store_orig_dstaddr(skb)	 (skb_origaddr(skb) = ip_hdr(skb)->daddr)
>   #define dnat_took_place(skb)	 (skb_origaddr(skb) != ip_hdr(skb)->daddr)
>
> +int brnf_net_id __read_mostly;

Should be static.

cheers,
Bart

