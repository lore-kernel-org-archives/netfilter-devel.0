From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH RFC,net-next 1/3] ip_tunnel: add type field to struct
 ip_tunnel_info
Date: Thu, 4 Oct 2018 11:25:33 +0200
Message-ID: <81675bff-ec49-a40a-ffab-2c298b506154@iogearbox.net>
References: <20181004000345.2380-1-pablo@netfilter.org>
 <20181004000345.2380-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        amir@vadai.me, pshelar@ovn.org, u9012063@gmail.com,
        alexei.starovoitov@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181004000345.2380-2-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 10/04/2018 02:03 AM, Pablo Neira Ayuso wrote:
> This new field allows you to restrict the metadata template for a given
> tunnel driver. This is convenient in scenarios that combine different
> tunneling drivers, to deal with possible misconfigurations given that
> the template can be interpreted by any target tunnel driver. Default
> value is IP_TUNNEL_TYPE_UNSPEC, to retain the existing behaviour. This
> also implicitly exposes what drivers are currently supported in the
> IP_TUNNEL_INFO_TX mode.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  drivers/net/geneve.c           |  3 ++-
>  drivers/net/vxlan.c            | 13 +++++++------
>  include/net/dst_metadata.h     |  1 +
>  include/net/ip_tunnels.h       | 16 ++++++++++++++++
>  net/ipv4/ip_gre.c              |  2 ++
>  net/ipv6/ip6_gre.c             |  2 ++
>  net/openvswitch/flow_netlink.c |  1 +
>  7 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 6625fabe2c88..c383c394f0d2 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -920,7 +920,8 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	if (geneve->collect_md) {
>  		info = skb_tunnel_info(skb);
> -		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
> +		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX) ||
> +			     !ip_tunnel_type(info, IP_TUNNEL_TYPE_GENEVE))) {
>  			err = -EINVAL;
>  			netdev_dbg(dev, "no tunnel metadata\n");
>  			goto tx_error;
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index e5d236595206..8cca91b572bd 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2296,14 +2296,15 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
>  	skb_reset_mac_header(skb);
>  
>  	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) {
> -		if (info && info->mode & IP_TUNNEL_INFO_BRIDGE &&
> -		    info->mode & IP_TUNNEL_INFO_TX) {
> +		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX) ||
> +			     !ip_tunnel_type(info, IP_TUNNEL_TYPE_VXLAN))) {
> +			kfree_skb(skb);
> +			return NETDEV_TX_OK;
> +		}
> +		if (info->mode & IP_TUNNEL_INFO_BRIDGE) {
>  			vni = tunnel_id_to_key32(info->key.tun_id);
>  		} else {
> -			if (info && info->mode & IP_TUNNEL_INFO_TX)
> -				vxlan_xmit_one(skb, dev, vni, NULL, false);
> -			else
> -				kfree_skb(skb);
> +			vxlan_xmit_one(skb, dev, vni, NULL, false);
>  			return NETDEV_TX_OK;
>  		}
>  	}
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 56cb3c38569a..674116f7fa4a 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -100,6 +100,7 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>  	if (!tun_dst)
>  		return NULL;
>  
> +	tun_dst->u.tun_info.type = IP_TUNNEL_TYPE_UNSPEC;
>  	tun_dst->u.tun_info.options_len = 0;
>  	tun_dst->u.tun_info.mode = 0;
>  	return tun_dst;
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index b0d022ff6ea1..985d24b6a102 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -66,7 +66,16 @@ struct ip_tunnel_key {
>  	GENMASK((FIELD_SIZEOF(struct ip_tunnel_info,		\
>  			      options_len) * BITS_PER_BYTE) - 1, 0)
>  
> +enum ip_tunnel_type {
> +	IP_TUNNEL_TYPE_UNSPEC	= 0,
> +	IP_TUNNEL_TYPE_GRE,
> +	IP_TUNNEL_TYPE_VXLAN,
> +	IP_TUNNEL_TYPE_GENEVE,
> +	IP_TUNNEL_TYPE_ERSPAN,
> +};
> +
>  struct ip_tunnel_info {
> +	enum ip_tunnel_type	type;
>  	struct ip_tunnel_key	key;
>  #ifdef CONFIG_DST_CACHE
>  	struct dst_cache	dst_cache;
> @@ -75,6 +84,13 @@ struct ip_tunnel_info {
>  	u8			mode;
>  };
>  
> +static inline bool ip_tunnel_type(const struct ip_tunnel_info *tun_info,
> +				  enum ip_tunnel_type type)
> +{
> +	return tun_info->type == IP_TUNNEL_TYPE_UNSPEC ||
> +	       tun_info->type == type;
> +}
> +
>  /* 6rd prefix/relay information */
>  #ifdef CONFIG_IPV6_SIT_6RD
>  struct ip_tunnel_6rd_parm {
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index c3385a84f8ff..3ad12135c3d3 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -534,6 +534,7 @@ static void gre_fb_xmit(struct sk_buff *skb, struct net_device *dev,
>  
>  	tun_info = skb_tunnel_info(skb);
>  	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
> +		     !ip_tunnel_type(tun_info, IP_TUNNEL_TYPE_GRE) ||
>  		     ip_tunnel_info_af(tun_info) != AF_INET))
>  		goto err_free_skb;
>  
> @@ -585,6 +586,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev,
>  
>  	tun_info = skb_tunnel_info(skb);
>  	if (unlikely(!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
> +		     !ip_tunnel_type(tun_info, IP_TUNNEL_TYPE_ERSPAN) ||
>  		     ip_tunnel_info_af(tun_info) != AF_INET))
>  		goto err_free_skb;
>  
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index 515adbdba1d2..675f373809ee 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -732,6 +732,7 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
>  		tun_info = skb_tunnel_info(skb);
>  		if (unlikely(!tun_info ||
>  			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
> +			     !ip_tunnel_type(tun_info, IP_TUNNEL_TYPE_GRE) ||
>  			     ip_tunnel_info_af(tun_info) != AF_INET6))
>  			return -EINVAL;
>  
> @@ -960,6 +961,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
>  		tun_info = skb_tunnel_info(skb);
>  		if (unlikely(!tun_info ||
>  			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
> +			     !ip_tunnel_type(tun_info, IP_TUNNEL_TYPE_ERSPAN) ||
>  			     ip_tunnel_info_af(tun_info) != AF_INET6))
>  			return -EINVAL;
>  
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index a70097ecf33c..1ee2509534df 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -2602,6 +2602,7 @@ static int validate_and_copy_set_tun(const struct nlattr *attr,
>  	ovs_tun->tun_dst = tun_dst;
>  
>  	tun_info = &tun_dst->u.tun_info;
> +	tun_info->type = IP_TUNNEL_TYPE_UNSPEC;
>  	tun_info->mode = IP_TUNNEL_INFO_TX;
>  	if (key.tun_proto == AF_INET6)
>  		tun_info->mode |= IP_TUNNEL_INFO_IPV6;
> 

If so then this should also be made explicit IP_TUNNEL_TYPE_UNSPEC in BPF code
since all these tunnel types are supported there as well.

Thanks,
Daniel
