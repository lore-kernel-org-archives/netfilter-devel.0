From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] netfilter: fix clusterip_net_exit build regression
Date: Thu, 7 Dec 2017 19:29:47 +0300
Message-ID: <9b5dc366-0bbc-d9f2-ae11-75ed7be6afd6@virtuozzo.com>
References: <20171207132636.259066-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [195.214.232.25] ([195.214.232.25]:44266 "EHLO relay.sw.ru"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753101AbdLGQaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 11:30:07 -0500
In-Reply-To: <20171207132636.259066-1-arnd@arndb.de>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

thank you,
it was mu fault.

Reviewed-by: Vasily Averin <vvs@virtuozzo.com>

On 2017-12-07 16:26, Arnd Bergmann wrote:
> The added check produces a build error when CONFIG_PROC_FS is
> disabled:
> 
> net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_net_exit':
> net/ipv4/netfilter/ipt_CLUSTERIP.c:822:28: error: 'cn' undeclared (first use in this function)
> 
> This moves the variable declaration out of the #ifdef to make it
> available to the WARN_ON_ONCE().
> 
> Fixes: 613d0776d3fe ("netfilter: exit_net cleanup check added")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index e35b8d074f06..69060e3abe85 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -813,8 +813,8 @@ static int clusterip_net_init(struct net *net)
>  
>  static void clusterip_net_exit(struct net *net)
>  {
> -#ifdef CONFIG_PROC_FS
>  	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
> +#ifdef CONFIG_PROC_FS
>  	proc_remove(cn->procdir);
>  	cn->procdir = NULL;
>  #endif
> 
