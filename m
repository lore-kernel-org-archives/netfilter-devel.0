From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3 1/4] netfilter: bridge: detect NAT66 correctly and
 change MAC address
Date: Fri, 29 May 2015 02:11:12 +0200
Message-ID: <20150529001112.GA705@salvia>
References: <1432801419-11832-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de, Sven Eckelmann <sven@open-mesh.com>
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42119 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbbE2AGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 20:06:08 -0400
Content-Disposition: inline
In-Reply-To: <1432801419-11832-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 28, 2015 at 10:23:39AM +0200, Bernhard Thaler wrote:
> IPv4 iptables allows to REDIRECT/DNAT/SNAT any traffic over a bridge.
> 
> e.g. REDIRECT
> $ sysctl -w net.bridge.bridge-nf-call-iptables=1
> $ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
>   -j REDIRECT --to-ports 81
> 
> This does not work with ip6tables on a bridge in NAT66 scenario
> because the REDIRECT/DNAT/SNAT is not correctly detected.
> 
> The bridge pre-routing (finish) netfilter hook has to check for a possible
> redirect and then fix the destination mac address. This allows to use the
> ip6tables rules for local REDIRECT/DNAT/SNAT REDIRECT similar to the IPv4
> iptables version.
> 
> e.g. REDIRECT
> $ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
> $ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 \
>   -j REDIRECT --to-ports 81
> 
> This patch makes it possible to use IPv6 NAT66 on a bridge. It was tested
> on a bridge with two interfaces using SNAT/DNAT NAT66 rules.
> 
> Reported-by: Artie Hamilton <artiemhamilton@yahoo.com>
> Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
> [bernhard.thaler@wvnet.at: rebased, adjust function order]
> [bernhard.thaler@wvnet.at: add indirect call to ip6_route_input()]
> [bernhard.thaler@wvnet.at: rebased]
> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
> ---
> Patch revision history:
> 
> v3
> * re-base again to davem's current net-next
> * changed subject to include netfilter 
> 
> v2
> * re-base again to davem's current net-next
> * add indirect call to ip6_route_input via nf_ipv6_ops to avoid 
>   direct dependency to ipv6.ko just because of function calls
> 
> v1
> * rebase "bridge: Allow to redirect IPv6 traffic to local machine"
>   to davem's current net-next
> * adjust function order to avoid prototype for br_nf_pre_routing_finish_bridge
>    
> (v0)
> * originally there were two patches solving this problem
> * Patch from Sven Eckelmann was chosen to base solution on 
>   see: bridge: Allow to redirect IPv6 traffic to local machine
>   see: bridge: Fix NAT66ed IPv6 packets not being bridged correctly
> 
>  include/linux/netfilter_ipv6.h |    1 +
>  include/linux/skbuff.h         |    7 ++-
>  net/bridge/br_netfilter.c      |  105 ++++++++++++++++++++++++++++------------
>  net/ipv6/netfilter.c           |    1 +
>  4 files changed, 81 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 64dad1cc..e2d1969 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -25,6 +25,7 @@ void ipv6_netfilter_fini(void);
>  struct nf_ipv6_ops {
>  	int (*chk_addr)(struct net *net, const struct in6_addr *addr,
>  			const struct net_device *dev, int strict);
> +	void (*route_input)(struct sk_buff *skb);
>  };
>  
>  extern const struct nf_ipv6_ops __rcu *nf_ipv6_ops;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 6b41c15..369643b 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -37,6 +37,8 @@
>  #include <net/flow_dissector.h>
>  #include <linux/splice.h>
>  

Please, remove the empty line above.

> +#include <uapi/linux/in6.h>

I think you can use <linux/in6.h> instead.

> +
>  /* A. Checksumming of received packets by device.
>   *
>   * CHECKSUM_NONE:
> @@ -179,7 +181,10 @@ struct nf_bridge_info {
>  		struct net_device *physoutdev;
>  		char neigh_header[8];
>  	};
> -	__be32			ipv4_daddr;
> +	union {
> +		__be32          ipv4_daddr;
> +		struct in6_addr ipv6_daddr;
> +	};
>  };
>  #endif
>  
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 46660a2..ea8e063 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -278,37 +278,6 @@ static void nf_bridge_update_protocol(struct sk_buff *skb)
>  	}
>  }
>  
> -/* PF_BRIDGE/PRE_ROUTING *********************************************/
> -/* Undo the changes made for ip6tables PREROUTING and continue the
> - * bridge PRE_ROUTING hook. */
> -static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
> -{
> -	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
> -	struct rtable *rt;
> -
> -	if (nf_bridge->pkt_otherhost) {
> -		skb->pkt_type = PACKET_OTHERHOST;
> -		nf_bridge->pkt_otherhost = false;
> -	}
> -	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
> -
> -	rt = bridge_parent_rtable(nf_bridge->physindev);
> -	if (!rt) {
> -		kfree_skb(skb);
> -		return 0;
> -	}
> -	skb_dst_set_noref(skb, &rt->dst);
> -
> -	skb->dev = nf_bridge->physindev;
> -	nf_bridge_update_protocol(skb);
> -	nf_bridge_push_encap_header(skb);
> -	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, sk, skb,
> -		       skb->dev, NULL,
> -		       br_handle_frame_finish, 1);
> -
> -	return 0;
> -}
> -
>  /* Obtain the correct destination MAC address, while preserving the original
>   * source MAC address. If we already know this address, we just copy it. If we
>   * don't, we use the neighbour framework to find out. In both cases, we make
> @@ -357,7 +326,75 @@ free_skb:
>  static bool daddr_was_changed(const struct sk_buff *skb,
>  			      const struct nf_bridge_info *nf_bridge)
>  {
> -	return ip_hdr(skb)->daddr != nf_bridge->ipv4_daddr;
> +	if (skb->protocol == htons(ETH_P_IP))
> +		return ip_hdr(skb)->daddr != nf_bridge->ipv4_daddr;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6))
> +		return memcmp(&nf_bridge->ipv6_daddr, &ipv6_hdr(skb)->daddr,
> +			      sizeof(ipv6_hdr(skb)->daddr)) != 0;

could you use a switch for this instead?

> +
> +	return false;
> +}
> +
> +/* PF_BRIDGE/PRE_ROUTING *********************************************/
> +/* Undo the changes made for ip6tables PREROUTING and continue the
> + * bridge PRE_ROUTING hook.
> + */
> +
> +/* see comment for br_nf_pre_routing_finish
> + * same logic is used here but equivalent IPv6 function
> + * ip6_route_input() called indirectly
> + */

I know you're copying and pasting an original comment, but could you
convert this to:

/* PF_BRIDGE/PRE_ROUTING: Undo the changes made for ip6tables
 * PREROUTING and continue the bridge PRE_ROUTING hook. See comment
 * for br_nf_pre_routing_finish(), same logic is used here but
 * equivalent IPv6 function ip6_route_input() called indirectly.
 */

> +static int br_nf_pre_routing_finish_ipv6(struct sock *sk, struct sk_buff *skb)
> +{
> +	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
> +	struct rtable *rt;
> +	struct net_device *dev = skb->dev;
> +	const struct nf_ipv6_ops *v6ops = nf_get_ipv6_ops();
> +
> +	if (nf_bridge->pkt_otherhost) {
> +		skb->pkt_type = PACKET_OTHERHOST;
> +		nf_bridge->pkt_otherhost = false;
> +	}
> +	nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;

I already suggested that this toggle is sloppy, I'd suggest:

        nf_bridge->mask &= ~BRNF_NF_BRIDGE_PREROUTING.

to unset this bit.

> +
> +	if (daddr_was_changed(skb, nf_bridge)) {
> +		skb_dst_drop(skb);
> +		v6ops->route_input(skb);
> +
> +		if (skb_dst(skb)->error) {
> +			kfree_skb(skb);
> +			return 0;
> +		}
> +
> +		if (skb_dst(skb)->dev == dev) {
> +			skb->dev = nf_bridge->physindev;
> +			nf_bridge_update_protocol(skb);
> +			nf_bridge_push_encap_header(skb);
> +			NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING,
> +				       sk, skb, skb->dev, NULL,
> +				       br_nf_pre_routing_finish_bridge,
> +				       1);
> +			return 0;
> +		}
> +		ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
> +		skb->pkt_type = PACKET_HOST;
> +	} else {
> +		rt = bridge_parent_rtable(nf_bridge->physindev);
> +		if (!rt) {
> +			kfree_skb(skb);
> +			return 0;
> +		}
> +		skb_dst_set_noref(skb, &rt->dst);
> +	}
> +
> +	skb->dev = nf_bridge->physindev;
> +	nf_bridge_update_protocol(skb);
> +	nf_bridge_push_encap_header(skb);
> +	NF_HOOK_THRESH(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, sk, skb,
> +		       skb->dev, NULL,
> +		       br_handle_frame_finish, 1);
> +	return 0;
>  }
>  
>  /* This requires some explaining. If DNAT has taken place,
> @@ -578,6 +615,7 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
>  					   struct sk_buff *skb,
>  					   const struct nf_hook_state *state)
>  {
> +	struct nf_bridge_info *nf_bridge;
>  	const struct ipv6hdr *hdr;
>  	u32 pkt_len;
>  
> @@ -609,6 +647,9 @@ static unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
>  	if (!setup_pre_routing(skb))
>  		return NF_DROP;
>  
> +	nf_bridge = nf_bridge_info_get(skb);
> +	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
> +
>  	skb->protocol = htons(ETH_P_IPV6);
>  	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->sk, skb,
>  		skb->dev, NULL,
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index d958718..bbca09f 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -191,6 +191,7 @@ static __sum16 nf_ip6_checksum_partial(struct sk_buff *skb, unsigned int hook,
>  
>  static const struct nf_ipv6_ops ipv6ops = {
>  	.chk_addr	= ipv6_chk_addr,
> +	.route_input    = ip6_route_input
>  };
>  
>  static const struct nf_afinfo nf_ip6_afinfo = {
> -- 
> 1.7.10.4
> 
