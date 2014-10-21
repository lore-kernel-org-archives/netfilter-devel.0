From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch] netfilter: ipset: off by one in
 ip_set_nfnl_get_byindex()
Date: Tue, 21 Oct 2014 11:51:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410211146160.27469@blackhole.kfki.hu>
References: <20141021082812.GB28426@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Kosina <jkosina@suse.cz>,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Joe Perches <joe@perches.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:41753 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaJUJuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:50:37 -0400
In-Reply-To: <20141021082812.GB28426@mwanda>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 21 Oct 2014, Dan Carpenter wrote:

> The ->ip_set_list[] array is initialized in ip_set_net_init() and it
> has ->ip_set_max elements so this check should be >= instead of >
> otherwise we are off by one.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I am not very familiar with this code, so please review cautiously.
> This is an old bug which should go to -stable.
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 912e5a0..86f9d76 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -659,7 +659,7 @@ ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index)
>  	struct ip_set *set;
>  	struct ip_set_net *inst = ip_set_pernet(net);
>  
> -	if (index > inst->ip_set_max)
> +	if (index >= inst->ip_set_max)
>  		return IPSET_INVALID_ID;
>  
>  	nfnl_lock(NFNL_SUBSYS_IPSET);
> 

Absolutely right and it should go to stable too!

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
