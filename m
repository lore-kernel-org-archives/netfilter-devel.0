From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: x_tables: add xt_tunnel match
Date: Wed, 9 Jan 2019 17:41:43 +0100
Message-ID: <20190109164143.d6gqky7dvxfxg7jr@salvia>
References: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 21, 2018 at 06:12:24PM +0800, wenxu@ucloud.cn wrote:
[...]
> +static struct xt_match tunnel_mt_reg __read_mostly = {
> +	.name           = "tunnel",
> +	.revision       = 0,
> +	.family         = NFPROTO_UNSPEC,
> +	.match          = tunnel_mt,
> +	.matchsize      = sizeof(struct xt_tunnel_mtinfo),

Does this work away from the prerouting hook?

> +	.me             = THIS_MODULE,
> +};
> +
> +static int __init tunnel_mt_init(void)
> +{
> +	int ret;
> +
> +	ret = xt_register_match(&tunnel_mt_reg);
> +	if (ret < 0)
> +		return ret;

Probably one single line for this?
