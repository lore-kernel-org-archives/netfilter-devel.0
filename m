From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: x_tables: add xt_tunnel match
Date: Thu, 10 Jan 2019 19:15:14 +0100
Message-ID: <20190110181514.76mkggdfbgdvxkav@salvia>
References: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 10, 2019 at 01:16:08PM +0800, wenxu@ucloud.cn wrote:
[...]
> +static struct xt_match tunnel_mt_reg __read_mostly = {
> +	.name           = "tunnel",
> +	.revision       = 0,
> +	.family         = NFPROTO_UNSPEC,
> +	.match          = tunnel_mt,
> +	.matchsize      = sizeof(struct xt_tunnel_mtinfo),
> +	.hooks          = ((1 << NF_INET_PRE_ROUTING) |
> +					  (1 << NF_INET_POST_ROUTING) |
> +					  (1 << NF_INET_LOCAL_OUT) |
> +					  (1 << NF_INET_FORWARD)),

Are you sure this works from the forward chain? This template is
dropped after the route lookup.

Thanks.
