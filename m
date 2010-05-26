From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: xt_statistic: remove nth_lock spinlock
Date: Wed, 26 May 2010 14:29:54 +0200
Message-ID: <1274876994.2672.215.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	 <1274874846.2672.192.camel@edumazet-laptop>
	 <AANLkTilaed7xvxsrxYzub6-NogFHXKOlPtdnaXEgiYz5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0EZM37 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 08:29:59 -0400
Received: by fxm5 with SMTP id 5so4344590fxm.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 05:29:57 -0700 (PDT)
In-Reply-To: <AANLkTilaed7xvxsrxYzub6-NogFHXKOlPtdnaXEgiYz5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 26 mai 2010 =C3=A0 20:07 +0800, Changli Gao a =C3=A9crit :
> On Wed, May 26, 2010 at 7:54 PM, Eric Dumazet <eric.dumazet@gmail.com=
> wrote:
> >
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> > diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statis=
tic.c
> > index 96e62b8..0114d2b 100644
> > --- a/net/netfilter/xt_statistic.c
> > +++ b/net/netfilter/xt_statistic.c
> > @@ -18,8 +18,8 @@
> >  #include <linux/netfilter/x_tables.h>
> >
> >  struct xt_statistic_priv {
> > -       uint32_t count;
> > -};
> > +       atomic_t count;
> > +} ____cacheline_aligned_in_smp;
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
> > @@ -27,13 +27,12 @@ MODULE_DESCRIPTION("Xtables: statistics-based m=
atching (\"Nth\", random)");
> >  MODULE_ALIAS("ipt_statistic");
> >  MODULE_ALIAS("ip6t_statistic");
> >
> > -static DEFINE_SPINLOCK(nth_lock);
> > -
> >  static bool
> >  statistic_mt(const struct sk_buff *skb, struct xt_action_param *pa=
r)
> >  {
> >        const struct xt_statistic_info *info =3D par->matchinfo;
> >        bool ret =3D info->flags & XT_STATISTIC_INVERT;
> > +       int nval, oval;
> >
> >        switch (info->mode) {
> >        case XT_STATISTIC_MODE_RANDOM:
> > @@ -41,12 +40,14 @@ statistic_mt(const struct sk_buff *skb, struct =
xt_action_param *par)
> >                        ret =3D !ret;
> >                break;
> >        case XT_STATISTIC_MODE_NTH:
> > -               spin_lock_bh(&nth_lock);
> > -               if (info->master->count++ =3D=3D info->u.nth.every)=
 {
> > -                       info->master->count =3D 0;
> > +               do {
> > +                       oval =3D atomic_read(&info->master->count);
> > +                       nval =3D oval + 1;
> > +                       if (nval =3D=3D info->u.nth.every)
> > +                               nval =3D 0;
>=20
> these lines should be:
>                            if (oval =3D=3D info->u.nth.every)
>                                     nval =3D 0;
>                            else
>                                     nval =3D oval + 1;

Good catch, this "every" counter is off by one...

Thanks

[PATCH v2] netfilter: xt_statistic: remove nth_lock spinlock

Use atomic_cmpxchg() to avoid dirtying a shared location.

xt_statistic_priv smp aligned to avoid sharing same cache line with
other stuff.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/xt_statistic.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.=
c
index 96e62b8..42ecb71 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -18,8 +18,8 @@
 #include <linux/netfilter/x_tables.h>
=20
 struct xt_statistic_priv {
-	uint32_t count;
-};
+	atomic_t count;
+} ____cacheline_aligned_in_smp;
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
@@ -27,13 +27,12 @@ MODULE_DESCRIPTION("Xtables: statistics-based match=
ing (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
=20
-static DEFINE_SPINLOCK(nth_lock);
-
 static bool
 statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_statistic_info *info =3D par->matchinfo;
 	bool ret =3D info->flags & XT_STATISTIC_INVERT;
+	int nval, oval;
=20
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
@@ -41,12 +40,12 @@ statistic_mt(const struct sk_buff *skb, struct xt_a=
ction_param *par)
 			ret =3D !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
-		spin_lock_bh(&nth_lock);
-		if (info->master->count++ =3D=3D info->u.nth.every) {
-			info->master->count =3D 0;
+		do {
+			oval =3D atomic_read(&info->master->count);
+			nval =3D (oval =3D=3D info->u.nth.every) ? 0 : oval + 1;
+		} while (atomic_cmpxchg(&info->master->count, oval, nval) !=3D oval)=
;
+		if (nval =3D=3D 0)
 			ret =3D !ret;
-		}
-		spin_unlock_bh(&nth_lock);
 		break;
 	}
=20
@@ -64,7 +63,7 @@ static int statistic_mt_check(const struct xt_mtchk_p=
aram *par)
 	info->master =3D kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master =3D=3D NULL)
 		return -ENOMEM;
-	info->master->count =3D info->u.nth.count;
+	atomic_set(&info->master->count, info->u.nth.count);
=20
 	return 0;
 }


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
