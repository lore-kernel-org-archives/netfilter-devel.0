From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter:ipset: fix the compile warning in
 ip_set_create
Date: Fri, 4 Mar 2011 10:00:46 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1103040956050.29227@blackhole.kfki.hu>
References: <4D70960B.2040209@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:32938 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDJAt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:00:49 -0500
In-Reply-To: <4D70960B.2040209@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Mar 2011, Shan Wei wrote:

> net/netfilter/ipset/ip_set_core.c:615: warning: ?clash? may be used uninitialized in this function
> 
> Signed-off-by: shanw <shanw@shanw-desktop.(none)>
> ---
>  net/netfilter/ipset/ip_set_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 8b1a54c..618a615 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -612,7 +612,7 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
>  	      const struct nlmsghdr *nlh,
>  	      const struct nlattr * const attr[])
>  {
> -	struct ip_set *set, *clash;
> +	struct ip_set *set, *clash = NULL;
>  	ip_set_id_t index = IPSET_INVALID_ID;
>  	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1] = {};
>  	const char *name, *typename;
> -- 
> 1.6.3.3

Thanks, I applied your patch in my tree.

Patrick, please apply it too.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
