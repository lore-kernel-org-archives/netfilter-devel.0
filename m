From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3 11/21] clusterip: exit_net cleanup check added
Date: Mon, 6 Nov 2017 14:40:41 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1711061435191.6547@blackhole.kfki.hu>
References: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com> <66995620-efe8-59ed-9097-a4fd96e30ae1@virtuozzo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <66995620-efe8-59ed-9097-a4fd96e30ae1@virtuozzo.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello Vasily,

On Mon, 6 Nov 2017, Vasily Averin wrote:

> Be sure that configs list initialized in net_init hook was return
> to initial state.

What is the goal of the patch series you sent in the third version in a 
row?

- If the deinitializations are missing from the files, the patches 
  do not fix them, just emit warnings.
- If the deinitializations are not missing, the patches are totally 
  unnecessary.

It looks like debugging... but not expressed that way, neither in the 
subject lines nor in the patch descriptions.

Best regards,
Jozsef

> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/ipv4/netfilter/ipt_CLUSTERIP.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index 17b4ca5..4364a88 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -819,6 +819,9 @@ static void clusterip_net_exit(struct net *net)
>  	cn->procdir = NULL;
>  #endif
>  	nf_unregister_net_hook(net, &cip_arp_ops);
> +	WARN_ONCE(!list_empty(&cn->configs),
> +		  "net %x %s: configs list is not empty\n",
> +		  net->ns.inum, __func__);
>  }
>  
>  static struct pernet_operations clusterip_net_ops = {
> -- 
> 2.7.4
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
