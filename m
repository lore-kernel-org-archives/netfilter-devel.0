From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: xt_statistic: remove nth_lock spinlock
Date: Wed, 26 May 2010 13:54:06 +0200
Message-ID: <1274874846.2672.192.camel@edumazet-laptop>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com>
	 <1274861468.2672.9.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:50731 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab0EZLyP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 07:54:15 -0400
Received: by wwb13 with SMTP id 13so242941wwb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2010 04:54:09 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 26 mai 2010 =C3=A0 11:47 +0200, Jan Engelhardt a =C3=A9crit=
 :
> On Wednesday 2010-05-26 10:11, Eric Dumazet wrote:
> >Le mardi 25 mai 2010 =C3=A0 21:31 -0300, Felipe W Damasio a =C3=A9cr=
it :
> >>
> >>   So I'd like to know if I can cycle through all these rules based=
 on
> >> the number of connections.
> >>=20
> >>   Is it possible?
> >>=20
> >>   If it isn't currently, can this functionality be added? How can =
I help?
> >
> >So all connections are coming from the NAT device, with a single IP,=
 and
> >ports from say 30000 to 60000 (check your NAT device)
> >
> >iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -m multip=
ort=20
> >--source-ports 30000:31000 -j TPROXY --tproxy-mark 0x1/0x1 --on-port=
 3127
>=20
> There may be a non-uniform distribution so it may not be advisable.
> Instead perhaps,
>=20
> -A PREROUTING -m conntrack --ctstate NEW -j extrachain
> for (I =3D 0; I < N; ++I)
> 	-A extrachain -m statistic --mode nth --every I \
> 		-j CONNMARK --set-mark I
> for (I =3D 0; I < N; ++I)
> 	-A PREROUTING -m connmark --mark I -j TPROXY \
> 		--tproxy-mark I/0xff --on-port I+3127

ok, you probably meant "-A extrachain -m statistic --mode nth --every
N ..."


packet for target "N" will take N time the nth_lock spinlock, but yes,
it should work.

This nth_lock should be removed BTW...

[PATCH] netfilter: xt_statistic: remove nth_lock spinlock

Use atomic_cmpxchg() to avoid dirtying a shared location.

xt_statistic_priv smp aligned to avoid sharing same cache line with
other stuff.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.=
c
index 96e62b8..0114d2b 100644
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
@@ -41,12 +40,14 @@ statistic_mt(const struct sk_buff *skb, struct xt_a=
ction_param *par)
 			ret =3D !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
-		spin_lock_bh(&nth_lock);
-		if (info->master->count++ =3D=3D info->u.nth.every) {
-			info->master->count =3D 0;
+		do {
+			oval =3D atomic_read(&info->master->count);
+			nval =3D oval + 1;
+			if (nval =3D=3D info->u.nth.every)
+				nval =3D 0;
+		} while (atomic_cmpxchg(&info->master->count, oval, nval) !=3D oval)=
;
+		if (nval =3D=3D 0)
 			ret =3D !ret;
-		}
-		spin_unlock_bh(&nth_lock);
 		break;
 	}
=20
@@ -64,7 +65,7 @@ static int statistic_mt_check(const struct xt_mtchk_p=
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
