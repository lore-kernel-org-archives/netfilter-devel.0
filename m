From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 04/15] br_netfilter: switch sysctl nf_call_iptables to
 init_brnf_net
Date: Sun, 11 May 2014 21:35:25 +0200
Message-ID: <536FD0FD.8010204@pandora.be>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org> <536D4837.1090707@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:49367 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbaEKTf0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2014 15:35:26 -0400
In-Reply-To: <536D4837.1090707@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Vasily Averin schreef op 9/05/2014 23:27:
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>   net/bridge/br_netfilter.c |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 2b0dda80..cb75e80 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -61,13 +61,11 @@ static struct brnf_net init_brnf_net = {
>
>   #ifdef CONFIG_SYSCTL
>   static struct ctl_table_header *brnf_sysctl_header;
> -static int brnf_call_iptables __read_mostly = 1;
>   static int brnf_call_ip6tables __read_mostly = 1;
>   static int brnf_filter_vlan_tagged __read_mostly = 0;
>   static int brnf_filter_pppoe_tagged __read_mostly = 0;
>   static int brnf_pass_vlan_indev __read_mostly = 0;
>   #else
> -#define brnf_call_iptables 1

Your patch creates extra unneeded overhead in case CONFIG_SYSCTL isn't 
defined (a compile-time check of brnf_call_iptables is replaced by a 
runtime check of brnf_net(dev_net(skb->dev))->brnf_call_iptables). 
Please refactor to remove this extra overhead (for all flags).

cheers,
Bart


