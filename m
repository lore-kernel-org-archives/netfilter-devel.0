From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH V2] ipvs: disable inline net_ipvs function with CONFIG_IP_VS
 not being set
Date: Wed, 25 Mar 2015 22:04:23 +0200 (EET)
Message-ID: <alpine.LFD.2.11.1503252148420.1795@ja.home.ssi.bg>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com> <1427275043-1192-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811672-1866668304-1427313865=:1795"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@verge.net.au>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:56756 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbbCYURo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 16:17:44 -0400
In-Reply-To: <1427275043-1192-1-git-send-email-zajec5@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1866668304-1427313865=:1795
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Wed, 25 Mar 2015, Rafał Miłecki wrote:

> Including net/ip_vs.h without CONFIG_IP_VS was causing:
> include/net/ip_vs.h: In function 'net_ipvs':
> include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'ipvs'
> 
> Fixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS disabled")
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: Disable function totally instead of returning NULL.

	While this version is better, the commit message
looks scary, it should explain that problem happens only
for modules out of kernel tree, we do not want other admins
to wonder whether they need this commit for their trees.

	And of course, it is better to implement your
own ip_vs_check_diff4 version, it is some inline stuff...

> ---
>  include/net/ip_vs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 615b20b..e6f2f2a 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -29,11 +29,13 @@
>  #endif
>  #include <net/net_namespace.h>		/* Netw namespace */
>  
> +#if IS_ENABLED(CONFIG_IP_VS)
>  /* Generic access of ipvs struct */
>  static inline struct netns_ipvs *net_ipvs(struct net* net)
>  {
>  	return net->ipvs;
>  }
> +#endif
>  
>  /* Get net ptr from skb in traffic cases
>   * use skb_sknet when call is from userland (ioctl or netlink)
> -- 
> 1.8.4.5

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1866668304-1427313865=:1795--
