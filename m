From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH] ipvs: fix header inline net_ipvs function to work without
 CONFIG_IP_VS
Date: Wed, 25 Mar 2015 10:03:02 +0100
Message-ID: <551279C6.1090407@6wind.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:32943 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbCYJDF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 05:03:05 -0400
Received: by wgbcc7 with SMTP id cc7so19424355wgb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 02:03:04 -0700 (PDT)
In-Reply-To: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 25/03/2015 09:53, Rafa=C5=82 Mi=C5=82ecki a =C3=A9crit :
> Including net/ip_vs.h without CONFIG_IP_VS was causing:
> include/net/ip_vs.h: In function 'net_ipvs':
> include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'i=
pvs'
>
> Fixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS =
disabled")
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>   include/net/ip_vs.h | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 615b20b..cd3942f 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -32,7 +32,10 @@
>   /* Generic access of ipvs struct */
>   static inline struct netns_ipvs *net_ipvs(struct net* net)
>   {
> +#if IS_ENABLED(CONFIG_IP_VS)
>   	return net->ipvs;
> +#endif
> +	return NULL;
>   }
This function is used only by the ipvs module, maybe it should be defin=
ed only
when CONFIG_IP_VS is set?

Anyway, it must not return NULL, all callers assume that the pointer is=
 valid.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
