From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type
Date: Fri, 18 Jan 2019 15:24:30 +0100
Message-ID: <20190118142430.rsnru4hyrbsodobf@salvia>
References: <1547596431-31824-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547596431-31824-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cc'ing dsahern.

On Wed, Jan 16, 2019 at 07:53:51AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the ip_rcv the skb go through the PREROUTING hook first,
> Then jump in vrf device go through the same hook again.
> When conntrack dnat work with vrf, there will be some conflict for rules.
> Because the package go through the hook twice with different nf status
> 
> ip link add user1 type vrf table 1
> ip link add user2 type vrf table 2
> ip l set dev tun1 master user1
> ip l set dev tun2 master user2
> 
> nft add table firewall
> nft add chain firewall zones { type filter hook prerouting  priority - 300 \; }
> nft add rule firewall zones counter ct zone set iif map { "tun1" : 1, "tun2" : 2 }
> nft add chain firewall rule-1000-ingress
> nft add rule firewall rule-1000-ingress ct zone 1 tcp dport 22 ct state new counter accept
> nft add rule firewall rule-1000-ingress counter drop
> nft add chain firewall rule-1000-egress
> nft add rule firewall rule-1000-egress tcp dport 22 ct state new counter drop
> nft add rule firewall rule-1000-egress counter accept
> 
> nft add chain firewall rules-all { type filter hook prerouting priority - 150 \; }
> nft add rule firewall rules-all ip daddr vmap { "2.2.2.11" : jump rule-1000-ingress }
> nft add rule firewall rules-all ct zone vmap { 1 : jump rule-1000-egress }
> 
> nft add rule firewall dnat-all ct zone vmap { 1 : jump dnat-1000 }
> nft add rule firewall dnat-1000 ip daddr 2.2.2.11 counter dnat to 10.0.0.7
> 
> For a package with ip daddr 2.2.2.11 and tcp dport 22, first time accept in the
> rule-1000-ingress and dnat to 10.0.0.7. Then second time the packet goto the wrong
> chain rule-1000-egress which leads the packet drop
> 
> so with this patch userspace can add the 'don't re-do entire ruleset for vrf' policy
> itself like the following
> 
> nft add rule firewall rules-all meta iifkind "vrf" counter accept
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>  net/netfilter/nft_meta.c                 | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 7de4f1b..046b997 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -789,6 +789,8 @@ enum nft_exthdr_attributes {
>   * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
>   * @NFT_META_PRANDOM: a 32bit pseudo-random number
>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
> + * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
> + * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -817,6 +819,8 @@ enum nft_meta_keys {
>  	NFT_META_CGROUP,
>  	NFT_META_PRANDOM,
>  	NFT_META_SECPATH,
> +	NFT_META_IIFKIND,
> +	NFT_META_OIFKIND,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 6df486c..987d2d6 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -244,6 +244,16 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>  		return;
>  #endif
> +	case NFT_META_IIFKIND:
> +		if (in == NULL || in->rtnl_link_ops == NULL)
> +			goto err;
> +		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);

It seems kind can be arbitrarily large, no limitation in its length.

Thinking...

There is no other way to identify a vft device rather than this
string? The only l3mdev that exists if vrf, right?

If there is no other alternative, we can just place this in the tree,
but probably it would be better to have a numeric way to identify a
vrf device?

Thanks.
