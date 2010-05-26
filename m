From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: xt_statistic: remove nth_lock spinlock
Date: Wed, 26 May 2010 20:07:34 +0800
Message-ID: <AANLkTilaed7xvxsrxYzub6-NogFHXKOlPtdnaXEgiYz5@mail.gmail.com>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	<1274861468.2672.9.camel@edumazet-laptop> <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
	<1274874846.2672.192.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41271 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0EZMHz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 08:07:55 -0400
Received: by pwi7 with SMTP id 7so136731pwi.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 05:07:54 -0700 (PDT)
In-Reply-To: <1274874846.2672.192.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 26, 2010 at 7:54 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statisti=
c.c
> index 96e62b8..0114d2b 100644
> --- a/net/netfilter/xt_statistic.c
> +++ b/net/netfilter/xt_statistic.c
> @@ -18,8 +18,8 @@
> =C2=A0#include <linux/netfilter/x_tables.h>
>
> =C2=A0struct xt_statistic_priv {
> - =C2=A0 =C2=A0 =C2=A0 uint32_t count;
> -};
> + =C2=A0 =C2=A0 =C2=A0 atomic_t count;
> +} ____cacheline_aligned_in_smp;
>
> =C2=A0MODULE_LICENSE("GPL");
> =C2=A0MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
> @@ -27,13 +27,12 @@ MODULE_DESCRIPTION("Xtables: statistics-based mat=
ching (\"Nth\", random)");
> =C2=A0MODULE_ALIAS("ipt_statistic");
> =C2=A0MODULE_ALIAS("ip6t_statistic");
>
> -static DEFINE_SPINLOCK(nth_lock);
> -
> =C2=A0static bool
> =C2=A0statistic_mt(const struct sk_buff *skb, struct xt_action_param =
*par)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct xt_statistic_info *info =3D p=
ar->matchinfo;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0bool ret =3D info->flags & XT_STATISTIC_IN=
VERT;
> + =C2=A0 =C2=A0 =C2=A0 int nval, oval;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (info->mode) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case XT_STATISTIC_MODE_RANDOM:
> @@ -41,12 +40,14 @@ statistic_mt(const struct sk_buff *skb, struct xt=
_action_param *par)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ret =3D !ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case XT_STATISTIC_MODE_NTH:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&nth_=
lock);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (info->master->=
count++ =3D=3D info->u.nth.every) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 info->master->count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 oval =3D atomic_read(&info->master->count);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 nval =3D oval + 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (nval =3D=3D info->u.nth.every)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nval =3D 0;

these lines should be:
                           if (oval =3D=3D info->u.nth.every)
                                    nval =3D 0;
                           else
                                    nval =3D oval + 1;


> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } while (atomic_cm=
pxchg(&info->master->count, oval, nval) !=3D oval);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (nval =3D=3D 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ret =3D !ret;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&nt=
h_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> @@ -64,7 +65,7 @@ static int statistic_mt_check(const struct xt_mtchk=
_param *par)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0info->master =3D kzalloc(sizeof(*info->mas=
ter), GFP_KERNEL);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (info->master =3D=3D NULL)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM=
;
> - =C2=A0 =C2=A0 =C2=A0 info->master->count =3D info->u.nth.count;
> + =C2=A0 =C2=A0 =C2=A0 atomic_set(&info->master->count, info->u.nth.c=
ount);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0}
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
