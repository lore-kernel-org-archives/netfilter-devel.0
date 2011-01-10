From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH][resend] netfilter: ebtables: make broute table work
 again
Date: Mon, 10 Jan 2011 08:05:02 +0100
Message-ID: <1294643102.2709.874.camel@edumazet-laptop>
References: <1294609729-13039-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35415 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1AJHFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:05:11 -0500
Received: by wwa36 with SMTP id 36so367295wwa.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Jan 2011 23:05:10 -0800 (PST)
In-Reply-To: <1294609729-13039-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 09 janvier 2011 =C3=A0 22:48 +0100, Florian Westphal a =C3=A9=
crit :
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
> Can't simply use "if (rhook(skb)", because br_should_route_hook_t *rh=
ook
> is not a function.
>=20
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Eric, does this patch look sane to you?
>=20
>  Pablo, only the if_bridge.h change is needed.
>  If you do not like the br_input.c change, feel
>  free to remove it when applying.
>=20
>  Thanks!
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

Hi Florian

It seems I was on crack at that time, but I remember having problem wit=
h
sparse on :

net/bridge/netfilter/ebtable_broute.c:90:2: error: cannot dereference t=
his type

Lets ignore sparse for the time being...

Please dont change the invocation of (*rhook) to make clear its an
indirect call. Both syntaxes are valid in C.

You also can remove one un needed cast now.

Soemthing like :

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index f7e73c3..dd3f201 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -103,7 +103,7 @@ struct __fdb_entry {
=20
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, =
void __user *));
=20
-typedef int (*br_should_route_hook_t)(struct sk_buff *skb);
+typedef int br_should_route_hook_t(struct sk_buff *skb);
 extern br_should_route_hook_t __rcu *br_should_route_hook;
=20
 #endif
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilt=
er/ebtable_broute.c
index 1bcaf36..ae3f106 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -87,8 +87,7 @@ static int __init ebtable_broute_init(void)
 	if (ret < 0)
 		return ret;
 	/* see br_input.c */
-	rcu_assign_pointer(br_should_route_hook,
-			   (br_should_route_hook_t *)ebt_broute);
+	rcu_assign_pointer(br_should_route_hook, ebt_broute);
 	return 0;
 }
=20

Thanks !


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
