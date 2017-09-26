From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: ipset: pernet ops must be unregistered
 last
Date: Tue, 26 Sep 2017 09:49:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709260945100.17493@blackhole.kfki.hu>
References: <20170925224413.24412-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39741 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964802AbdIZHtk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 03:49:40 -0400
In-Reply-To: <20170925224413.24412-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, 26 Sep 2017, Florian Westphal wrote:

> Removing the ipset module leaves a small window where one cpu performs
> module removal while another runs a command like 'ipset flush'.
> 
> ipset uses net_generic(), unregistering the pernet ops frees this
> storage area.
> 
> Fix it by first removing the user-visible api handlers and the pernet
> ops last.
> 
> Fixes: 1785e8f473082 ("netfiler: ipset: Add net namespace for ipset")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipset/ip_set_core.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index e495b5e484b1..5ec7740c2088 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -2072,25 +2072,27 @@ static struct pernet_operations ip_set_net_ops = {
>  static int __init
>  ip_set_init(void)
>  {
> -	int ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
> +	int ret = register_pernet_subsys(&ip_set_net_ops);
> +	if (ret) {
> +		pr_err("ip_set: cannot register pernet_subsys.\n");
> +		return ret;
> +	}
>  
> +	ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
>  	if (ret != 0) {
>  		pr_err("ip_set: cannot register with nfnetlink.\n");
> +		unregister_pernet_subsys(&ip_set_net_ops);
>  		return ret;
>  	}
> +
>  	ret = nf_register_sockopt(&so_set);
>  	if (ret != 0) {
>  		pr_err("SO_SET registry failed: %d\n", ret);
>  		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
> +		unregister_pernet_subsys(&ip_set_net_ops);
>  		return ret;
>  	}
> -	ret = register_pernet_subsys(&ip_set_net_ops);
> -	if (ret) {
> -		pr_err("ip_set: cannot register pernet_subsys.\n");
> -		nf_unregister_sockopt(&so_set);
> -		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
> -		return ret;
> -	}
> +
>  	pr_info("ip_set: protocol %u\n", IPSET_PROTOCOL);
>  	return 0;
>  }
> @@ -2098,9 +2100,10 @@ ip_set_init(void)
>  static void __exit
>  ip_set_fini(void)
>  {
> -	unregister_pernet_subsys(&ip_set_net_ops);
> -	nf_unregister_sockopt(&so_set);
>  	nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
> +	nf_unregister_sockopt(&so_set);
> +
> +	unregister_pernet_subsys(&ip_set_net_ops);
>  	pr_debug("these are the famous last words\n");
>  }

Following the registration sequence in backward order, shouldn't first the 
sockopt, then the netlink_subsys be unregistered? Even if it doesn't 
matter, I think it'd be more consistent.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
