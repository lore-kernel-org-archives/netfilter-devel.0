From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] netfilter: ebtables: make broute table work again
Date: Mon, 10 Jan 2011 17:28:34 +0100
Message-ID: <1294676914.3491.10.camel@edumazet-laptop>
References: <20110110162009.GD31228@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41088 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1AJQ3y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:29:54 -0500
Received: by wyb28 with SMTP id 28so19594369wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jan 2011 08:29:52 -0800 (PST)
In-Reply-To: <20110110162009.GD31228@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 10 janvier 2011 =C3=A0 17:20 +0100, Florian Westphal a =C3=A9c=
rit :
> broute table init hook sets up the "br_should_route_hook" pointer,
> which then gets called from br_input.
>=20
> commit a386f99025f13b32502fe5dedf223c20d7283826
> (bridge: add proper RCU annotation to should_route_hook)
> introduced a typedef, and then changed this to:
>=20
> br_should_route_hook_t *rhook;
> [..]
> rhook =3D rcu_dereference(br_should_route_hook);
> if (*rhook(skb))
>=20
> problem is that "br_should_route_hook" contains the address of the fu=
nction,
> so calling *rhook() results in kernel panic.
>=20
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/if_bridge.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index f7e73c3..dd3f201 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -103,7 +103,7 @@ struct __fdb_entry {
> =20
>  extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int=
, void __user *));
> =20
> -typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
> +typedef int br_should_route_hook_t(struct sk_buff *skb);
>  extern br_should_route_hook_t __rcu *br_should_route_hook;
> =20
>  #endif

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks !


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
