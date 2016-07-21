From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Use IS_ERR_OR_NULL instead of IS_ERR and
 NULl check to simplify the codes in ip_vs_genl_dump_dests and
 resolve_normal_ct
Date: Thu, 21 Jul 2016 18:45:53 +0200
Message-ID: <20160721164553.GA10667@salvia>
References: <1469110159-19200-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469110159-19200-1-git-send-email-fgao@ikuai8.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch title is too long, no more than 80 chars please, when it
goes over that boundary it becomes a description ;)

More comments below.

On Thu, Jul 21, 2016 at 10:09:19PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v1: Initial Version
> 
>  net/netfilter/ipvs/ip_vs_ctl.c    | 2 +-
>  net/netfilter/nf_conntrack_core.c | 6 ++----
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
[...]
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 153e33f..634d592 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1108,10 +1108,8 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
>  	if (!h) {
>  		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
>  				   skb, dataoff, hash);
> -		if (!h)
> -			return NULL;
> -		if (IS_ERR(h))
> -			return (void *)h;
> +		if (IS_ERR_OR_NULL(h))
> +			return ERR_CAST(h);

Interesting.

I think we can actually simplify this patch, I'm sending a patch for
this now.
