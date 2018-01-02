From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] netfilter: add nf_queue_entry forward declaration
Date: Tue, 2 Jan 2018 09:27:41 -0800
Message-ID: <92911fb4-570f-4dd1-739d-9d20d2a37f30@infradead.org>
References: <20180102101644.200962-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180102101644.200962-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 01/02/2018 02:16 AM, Arnd Bergmann wrote:
> The newly added callback pointers cause a warning for some configurations:
> 
> In file included from net/ipv6/af_inet6.c:45:0:
> include/linux/netfilter_ipv6.h:38:51: error: 'struct nf_queue_entry' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
> 
> Adding a forward declaration for the type avoids the warnings.
> 
> Fixes: 9faa679ee7ec ("netfilter: move reroute indirection to struct nf_ipv6_ops")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-and-tested-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  include/linux/netfilter_ipv4.h | 2 ++
>  include/linux/netfilter_ipv6.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
> index 0259bcde6d2e..b31dabfdb453 100644
> --- a/include/linux/netfilter_ipv4.h
> +++ b/include/linux/netfilter_ipv4.h
> @@ -18,6 +18,8 @@ struct ip_rt_info {
>  
>  int ip_route_me_harder(struct net *net, struct sk_buff *skb, unsigned addr_type);
>  
> +struct nf_queue_entry;
> +
>  #ifdef CONFIG_INET
>  __sum16 nf_ip_checksum(struct sk_buff *skb, unsigned int hook,
>  		       unsigned int dataoff, u_int8_t protocol);
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index e4cdcfdce0f9..288c597e75b3 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -18,6 +18,8 @@ struct ip6_rt_info {
>  	u_int32_t mark;
>  };
>  
> +struct nf_queue_entry;
> +
>  /*
>   * Hook functions for ipv6 to allow xt_* modules to be built-in even
>   * if IPv6 is a module.
> 


-- 
~Randy
