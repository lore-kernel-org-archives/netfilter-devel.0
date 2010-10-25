From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: remove modulo operations
Date: Mon, 25 Oct 2010 11:26:50 +0200
Message-ID: <1287998810.2826.46.camel@edumazet-laptop>
References: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63981 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0JYJ0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:26:55 -0400
Received: by fxm16 with SMTP id 16so2703149fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Oct 2010 02:26:54 -0700 (PDT)
In-Reply-To: <1287891635-30207-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 24 octobre 2010 =C3=A0 11:40 +0800, Changli Gao a =C3=A9cri=
t :
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ---
>  net/netfilter/xt_NFQUEUE.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
> index 039cce1..3962770 100644
> --- a/net/netfilter/xt_NFQUEUE.c
> +++ b/net/netfilter/xt_NFQUEUE.c
> @@ -72,10 +72,12 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct x=
t_action_param *par)
> =20
>  	if (info->queues_total > 1) {
>  		if (par->family =3D=3D NFPROTO_IPV4)
> -			queue =3D hash_v4(skb) % info->queues_total + queue;
> +			queue =3D (((u64) hash_v4(skb) * info->queues_total) >>
> +				 32) + queue;
>  #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLE=
S_MODULE)
>  		else if (par->family =3D=3D NFPROTO_IPV6)
> -			queue =3D hash_v6(skb) % info->queues_total + queue;
> +			queue =3D (((u64) hash_v6(skb) * info->queues_total) >>
> +				 32) + queue;
>  #endif
>  	}
>  	return NF_QUEUE_NR(queue);


Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Maybe its time to add a new helper in include/linux/reciprocal_div.h
to make this trick documented...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
