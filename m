From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 01/15] br_netfilter: brnf_net structure
Date: Sun, 11 May 2014 21:26:18 +0200
Message-ID: <536FCEDA.1030508@pandora.be>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org> <536D481A.1060700@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:42769 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968AbaEKT0T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:19 -0400
In-Reply-To: <536D481A.1060700@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 9/05/2014 23:26:
> struct brnf_net for per-netns settings in br_netfilters
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>   net/bridge/br_private.h |   15 +++++++++++++++
>   1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 06811d7..e29ae83 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -312,6 +312,21 @@ struct br_input_skb_cb {
>   # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
>   #endif
>
> +#ifdef CONFIG_BRIDGE_NETFILTER
> +struct brnf_net {
> +	struct net *net;

Unless I missed something, the net member is only really needed for 
CONFIG_SYSCTL.

cheers,
Bart

