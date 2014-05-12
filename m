From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC v2 02/11] br_netfilter: default sysctl settings in
 init_brnf_net
Date: Mon, 12 May 2014 15:07:06 +0100
Message-ID: <20140512140706.GA22082@macbook.localnet>
References: <536FD0FD.8010204@pandora.de>
 <cover.1399897184.git.vvs@openvz.org>
 <5370C519.4040300@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Vasily Averin <vvs@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaELOHM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 10:07:12 -0400
Content-Disposition: inline
In-Reply-To: <5370C519.4040300@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 12, 2014 at 04:56:57PM +0400, Vasily Averin wrote:
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>  net/bridge/br_netfilter.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 2acf7fa..3e81fd6 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -64,6 +64,18 @@ static int brnf_pass_vlan_indev __read_mostly = 0;
>  #define brnf_pass_vlan_indev 0
>  #endif
>  
> +#ifdef CONFIG_SYSCTL
> +static struct brnf_net init_brnf_net = {
> +	.hdr			= NULL,
> +	.call_arptables		= brnf_call_arptables,
> +	.call_iptables		= brnf_call_iptables,
> +	.call_ip6tables		= brnf_call_ip6tables,
> +	.filter_vlan_tagged	= brnf_filter_vlan_tagged,
> +	.filter_pppoe_tagged	= brnf_filter_pppoe_tagged,
> +	.pass_vlan_indev	= brnf_pass_vlan_indev,
> +};
> +#endif

These patches are split in an unnecessary excessive fashion and are hard
to review. The rule is one patch per logical change, not one patch per
file. Introducing a structure and not using it might be acceptable, but
adding a structure definition and not using it is just stupid.

Also introducing all these init_brnf_net conversion that are completely
replaced afterwards is just useless noise. Please combine them in a more
reasonable fashion and resend.
