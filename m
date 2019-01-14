From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] vrf: Fix conntrack-dnat conflict in vrf-device
 PREROUTING  hook
Date: Mon, 14 Jan 2019 22:40:43 +0100
Message-ID: <20190114214043.pji6usreyngezczt@salvia>
References: <1547251399-15997-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547251399-15997-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jan 12, 2019 at 08:03:19AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the ip_rcv the skb go through the PREROUTING hook first,
> Then jump in vrf device go through the same hook again.
> When conntrack dnat work with vrf, there will be some conflict for rules.
> Because the package go through the hook twice with different nf status

Then, the first hook applies NAT, while the second is simply ignored.

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
> So This patch avoid already dnat packet go through the prerouting hook for the
> second time.
> 
> Fixes: 73e20b761acf8 ("net: vrf: Add support for PREROUTING rules on vrf
> device")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  drivers/net/vrf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 95909e2..9b01ca871 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -38,6 +38,10 @@
>  #include <net/fib_rules.h>
>  #include <net/netns/generic.h>
>  
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +#include <net/netfilter/nf_conntrack.h>
> +#endif
> +
>  #define DRV_NAME	"vrf"
>  #define DRV_VERSION	"1.0"
>  
> @@ -898,6 +902,14 @@ static struct sk_buff *vrf_rcv_nfhook(u8 pf, unsigned int hook,
>  				      struct net_device *dev)
>  {
>  	struct net *net = dev_net(dev);
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct && (ct->status & IPS_DST_NAT))
> +		return skb;
> +#endif

I think we need to scrub the packet here, from the beginning of the
vrf path. The vrf represents a new virtual space, not sure we should
be sharing connection tracking information between different vrf.
