From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH V2] ipvs: disable inline net_ipvs function with CONFIG_IP_VS
 not being set
Date: Wed, 25 Mar 2015 11:25:54 +0100
Message-ID: <55128D32.50201@6wind.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com> <1427275043-1192-1-git-send-email-zajec5@gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36589 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbCYKZ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 06:25:58 -0400
Received: by wgra20 with SMTP id a20so21726719wgr.3
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 03:25:56 -0700 (PDT)
In-Reply-To: <1427275043-1192-1-git-send-email-zajec5@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/03/2015 10:17, Rafa=C5=82 Mi=C5=82ecki a =C3=A9crit :
> Including net/ip_vs.h without CONFIG_IP_VS was causing:
> include/net/ip_vs.h: In function 'net_ipvs':
> include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'i=
pvs'
>
> Fixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS =
disabled")
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
> V2: Disable function totally instead of returning NULL.
> ---
>   include/net/ip_vs.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 615b20b..e6f2f2a 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -29,11 +29,13 @@
>   #endif
>   #include <net/net_namespace.h>		/* Netw namespace */
>
> +#if IS_ENABLED(CONFIG_IP_VS)
>   /* Generic access of ipvs struct */
>   static inline struct netns_ipvs *net_ipvs(struct net* net)
>   {
>   	return net->ipvs;
>   }
> +#endif
Ok, but this fix nothing, there is no bug upstream. This file is only i=
ncluded
by ipvs module files.
=46or me, it's a bit strange to have '#ifdef CONFIG_IP_VS' in a file sp=
ecific to
this module. This just fix your third party module.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
