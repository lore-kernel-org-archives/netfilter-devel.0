From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft_flow_offload: Make flow offload work with vrf slave
 device correct
Date: Thu, 10 Jan 2019 01:40:04 +0100
Message-ID: <20190110004004.v3djxtj6bjenk72l@salvia>
References: <1546078225-22699-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1546078225-22699-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Dec 29, 2018 at 06:10:25PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the forward chain the iif is changed from slave device to master vrf
> device. It will lead the offload not match on lower slave device.
> 
> This patch make the flollowing example can work correct
> 
> ip addr add dev eth0 1.1.1.1/24
> ip addr add dev eth1 10.0.0.1/24
> ip link add user1 type vrf table 1
> ip l set user1 up
> ip l set dev eth0 master user1
> ip l set dev eth1 master user1
> 
> nft add table firewall
> nft add flowtable f fb1 { hook ingress priority 0 \; devices = { eth0, eth1 } \; }
> nft add chain f ftb-all {type filter hook forward priority 0 \; policy accept \; }
> nft add rule f ftb-all ct zone 1 ip protocol tcp flow offload @fb1
> nft add rule f ftb-all ct zone 1 ip protocol udp flow offload @fb1
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nft_flow_offload.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 974525e..a5995c0 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -30,9 +30,11 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>  	switch (nft_pf(pkt)) {
>  	case NFPROTO_IPV4:
>  		fl.u.ip4.daddr = ct->tuplehash[!dir].tuple.dst.u3.ip;
> +		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
>  		break;
>  	case NFPROTO_IPV6:
>  		fl.u.ip6.daddr = ct->tuplehash[!dir].tuple.dst.u3.in6;
> +		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
>  		break;
>  	}
>  
> @@ -41,7 +43,15 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>  		return -ENOENT;
>  
>  	route->tuple[dir].dst		= this_dst;
> -	route->tuple[dir].ifindex	= nft_in(pkt)->ifindex;
> +	if (netif_is_l3_master(nft_in(pkt))) {
> +		if (other_dst->dev)
> +			route->tuple[dir].ifindex = other_dst->dev->ifindex;
> +		else
> +			route->tuple[dir].ifindex = nft_in(pkt)->ifindex;
> +	} else {
> +		route->tuple[dir].ifindex = nft_in(pkt)->ifindex;
> +	}

Could we just use the the ifindex that we pass via
route->tuple[dir].dst from flow_offload_fill_dir()?

We could just remove this route->tuple[dir].ifindex field.

> +
>  	route->tuple[!dir].dst		= other_dst;
>  	route->tuple[!dir].ifindex	= nft_out(pkt)->ifindex;
>  
> -- 
> 1.8.3.1
> 
