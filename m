From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH net] ipvs: call ip_vs_dst_notifier before ipv6_dev_notf
Date: Tue, 13 Nov 2018 21:51:35 +0200 (EET)
Message-ID: <alpine.LFD.2.21.1811132137510.2785@ja.home.ssi.bg>
References: <4bfc74f2a94e3721afd5ee4dd3cb60f8e4b68c7c.1542129933.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, pablo@netfilter.org,
        Hans Schillstrom <hans@schillstrom.com>,
        Simon Horman <horms@verge.net.au>
To: Xin Long <lucien.xin@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4bfc74f2a94e3721afd5ee4dd3cb60f8e4b68c7c.1542129933.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


	Hello,

On Wed, 14 Nov 2018, Xin Long wrote:

> ip_vs_dst_event is supposed to clean up all dst used in ipvs'
> destinations when a net dev is going down. But it works only
> when the dst's dev is the same as the dev from the event.
> 
> Now with the same priority but late registration,
> ip_vs_dst_notifier is always called after ipv6_dev_notf where
> the dst's dev is set to lo for NETDEV_DOWN event.
> 
> As the dst's dev lo is not the same as the dev from the event
> in ip_vs_dst_event(), ipv6_dev_notf can actually never work.
> Also as these dst have to wait for dest_trash_timer to clean
> them up. It would cause some non-permanent kernel warnings:
> 
>   unregister_netdevice: waiting for br0 to become free. Usage count = 3
> 
> To fix it, call ip_vs_dst_notifier before ipv6_dev_notf by
> increasing its priority to ADDRCONF_NOTIFY_PRIORITY + 5.
> 
> Fixes: 7a4f0761fce3 ("IPVS: init and cleanup restructuring")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

	OK,

Acked-by: Julian Anastasov <ja@ssi.bg>

	But this fix may hide another problem...

	Isn't that racy to change dst.dev during NETDEV_DOWN?
IPv4 calls rt_flush_dev() only on NETDEV_UNREGISTER, while
rt6_uncached_list_flush_dev() is called in rt6_disable_ip(),
even on NETDEV_DOWN. How fatal is to call it only on
NETDEV_UNREGISTER? By this way, we rely on synchronize_net()
before the NETDEV_UNREGISTER event to avoid any dst.dev access.

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 83395bf6..aded477 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -3980,6 +3980,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct netns_ipvs *ipvs)
>  
>  static struct notifier_block ip_vs_dst_notifier = {
>  	.notifier_call = ip_vs_dst_event,
> +	.priority = ADDRCONF_NOTIFY_PRIORITY + 5,
>  };
>  
>  int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
> -- 
> 2.1.0

Regards
