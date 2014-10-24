From: Ana Rey <anarey@gmail.com>
Subject: Re: [PATCH 1/3] iptables-compat: fix chain policy reset with iptables
 -L -n
Date: Fri, 24 Oct 2014 09:49:27 +0200
Message-ID: <CAD7o0sgY+kuG6Qmf3rq=gDvC_+6-WJOWhdKjbFKm0XMQBGMvDw@mail.gmail.com>
References: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45372 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbaJXHtt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:49:49 -0400
Received: by mail-lb0-f180.google.com with SMTP id n15so2063737lbi.25
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2014 00:49:48 -0700 (PDT)
In-Reply-To: <1414063129-10091-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-10-23 13:18 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Initialize built-in tables/chains if they don't exists, otherwise
> simply skip.
>
> This avoids the chain policy reset to NF_ACCEPT by when you call
> iptables -L -n.
>
> Reported-by: Ana Rey <anarey@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Ana Rey <anarey@gmail.com>


> ---
>  iptables/nft.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/iptables/nft.c b/iptables/nft.c
> index ca199cd..b68b275 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -620,11 +620,17 @@ __nft_chain_builtin_init(struct nft_handle *h,
>                          int policy)
>  {
>         int i, default_policy;
> +       struct nft_chain_list *list = nft_chain_dump(h);
> +       struct nft_chain *c;
>
> -       /* Initialize all built-in chains. Exception, for e one received as
> -        * parameter, set the default policy as requested.
> -        */
> +       /* Initialize built-in chains if they don't exist yet */
>         for (i=0; i<NF_IP_NUMHOOKS && table->chains[i].name != NULL; i++) {
> +
> +               c = nft_chain_list_find(list, table->name,
> +                                       table->chains[i].name);
> +               if (c != NULL)
> +                       continue;
> +
>                 if (chain && strcmp(table->chains[i].name, chain) == 0)
>                         default_policy = policy;
>                 else
> @@ -633,6 +639,8 @@ __nft_chain_builtin_init(struct nft_handle *h,
>                 nft_chain_builtin_add(h, table, &table->chains[i],
>                                         default_policy);
>         }
> +
> +       nft_chain_list_free(list);
>  }
>
>  int
> --
> 1.7.10.4
>



-- 
Ana Rey (@anaRB)
http://about.me/anarey
