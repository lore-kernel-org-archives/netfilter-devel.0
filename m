From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] remove ipt_MIRROR target from 2.6.x
Date: Sat, 23 Aug 2003 22:49:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823204923.GG10603@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cVp8NMj01v+Em8Se"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cVp8NMj01v+Em8Se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following (trivial) patch removes the MIRROR target from the
2.6.0-test4 kernel. =20

We have decided to remove the MIRROR target, since it was considered a
stupid and potentially dangeroups example code of the early netfilter
days that should never be used on the internet anyway.

Since there is no lack of example netfilter/iptables modules these days,
we'd rather keep it in patch-o-matic, where lots of other modules that
are only useful in some obscure scenarios are doomed to stay.

Now that we don't have to keep it for compatibility reasons, we'd like
to remove it before 2.6.0 final is released.

Thanks.

diff -Nru linux-2.6.0-test4-plain/net/ipv4/netfilter/Kconfig linux-2.6.0-te=
st4-mirror/net/ipv4/netfilter/Kconfig
--- linux-2.6.0-test4-plain/net/ipv4/netfilter/Kconfig	2003-08-23 01:58:50.=
000000000 +0200
+++ linux-2.6.0-test4-mirror/net/ipv4/netfilter/Kconfig	2003-08-23 22:42:01=
=2E000000000 +0200
@@ -324,16 +324,6 @@
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
-config IP_NF_TARGET_MIRROR
-	tristate "MIRROR target support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IP_NF_FILTER
-	help
-	  The MIRROR target allows a filtering rule to specify that an
-	  incoming packet should be bounced back to the sender.
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
-
 config IP_NF_NAT
 	tristate "Full NAT"
 	depends on IP_NF_IPTABLES && IP_NF_CONNTRACK
diff -Nru linux-2.6.0-test4-plain/net/ipv4/netfilter/Makefile linux-2.6.0-t=
est4-mirror/net/ipv4/netfilter/Makefile
--- linux-2.6.0-test4-plain/net/ipv4/netfilter/Makefile	2003-08-23 01:53:09=
=2E000000000 +0200
+++ linux-2.6.0-test4-mirror/net/ipv4/netfilter/Makefile	2003-08-23 22:42:0=
9.000000000 +0200
@@ -68,7 +68,6 @@
=20
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) +=3D ipt_REJECT.o
-obj-$(CONFIG_IP_NF_TARGET_MIRROR) +=3D ipt_MIRROR.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) +=3D ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) +=3D ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) +=3D ipt_DSCP.o
diff -Nru linux-2.6.0-test4-plain/net/ipv4/netfilter/ipt_MIRROR.c linux-2.6=
=2E0-test4-mirror/net/ipv4/netfilter/ipt_MIRROR.c
--- linux-2.6.0-test4-plain/net/ipv4/netfilter/ipt_MIRROR.c	2003-08-23 02:0=
2:40.000000000 +0200
+++ linux-2.6.0-test4-mirror/net/ipv4/netfilter/ipt_MIRROR.c	1970-01-01 01:=
00:00.000000000 +0100
@@ -1,222 +0,0 @@
-/*
-  This is a module which is used for resending packets with inverted src a=
nd dst.
-
-  Based on code from: ip_nat_dumb.c,v 1.9 1999/08/20
-  and various sources.
-
-  Copyright (C) 2000 Emmanuel Roger <winfield@freegates.be>
-
-  Changes:
-	25 Aug 2001 Harald Welte <laforge@gnumonks.org>
-		- decrement and check TTL if not called from FORWARD hook
-	18 Jul 2003 Harald Welte <laforge@netfilter.org>
-		- merge Patrick McHardy's mirror fixes from 2.4.22 to
-		  2.6.0-test1
-	19 Jul 2003 Harald Welte <laforge@netfilter.org>
-		- merge Patrick McHardy's rp_filter fixes from 2.4.22 to
-		  2.6.0-test1
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of the GNU General Public License as published by the
-  Free Software Foundation; either version 2 of the License, or (at your
-  option) any later version.
-
-  This program is distributed in the hope that it will be useful, but
-  WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-  General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; if not, write to the Free Software Foundation,
-  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/ip.h>
-#include <net/icmp.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netdevice.h>
-#include <linux/route.h>
-#include <net/route.h>
-
-#if 0
-#define DEBUGP printk
-#else
-#define DEBUGP(format, args...)
-#endif
-
-static inline struct rtable *route_mirror(struct sk_buff *skb, int local)
-{
-        struct iphdr *iph =3D skb->nh.iph;
-	struct dst_entry *odst;
-	struct flowi fl =3D {};
-	struct rtable *rt;
-
-	if (local) {
-		fl.nl_u.ip4_u.daddr =3D iph->saddr;
-		fl.nl_u.ip4_u.saddr =3D iph->daddr;
-		fl.nl_u.ip4_u.tos =3D RT_TOS(iph->tos);
-
-		if (ip_route_output_key(&rt, &fl) !=3D 0)
-			return NULL;
-	} else {
-		/* non-local src, find valid iif to satisfy
-		 * rp-filter when calling ip_route_input(). */
-		fl.nl_u.ip4_u.daddr =3D iph->daddr;
-		if (ip_route_output_key(&rt, &fl) !=3D 0)
-			return NULL;
-
-		odst =3D skb->dst;
-		if (ip_route_input(skb, iph->saddr, iph->daddr,
-					RT_TOS(iph->tos), rt->u.dst.dev) !=3D 0) {
-			dst_release(&rt->u.dst);
-			return NULL;
-		}
-		dst_release(&rt->u.dst);
-		rt =3D (struct rtable *)skb->dst;
-		skb->dst =3D odst;
-	}
-
-	if (rt->u.dst.error) {
-		dst_release(&rt->u.dst);
-		rt =3D NULL;
-	}
-
-	return rt;
-}
-
-static inline void ip_rewrite(struct sk_buff *skb)
-{
-	u32 odaddr, osaddr;
-
-	odaddr =3D skb->nh.iph->saddr;
-	osaddr =3D skb->nh.iph->daddr;
-
-	skb->nfcache |=3D NFC_ALTERED;
-
-	/* Rewrite IP header */
-	skb->nh.iph->daddr =3D odaddr;
-	skb->nh.iph->saddr =3D osaddr;
-}
-
-/* Stolen from ip_finish_output2 */
-static void ip_direct_send(struct sk_buff *skb)
-{
-	struct dst_entry *dst =3D skb->dst;
-	struct hh_cache *hh =3D dst->hh;
-
-	if (hh) {
-		int hh_alen;
-
-		read_lock_bh(&hh->hh_lock);
-		hh_alen =3D HH_DATA_ALIGN(hh->hh_len);
-  		memcpy(skb->data - hh_alen, hh->hh_data, hh_alen);
-		read_unlock_bh(&hh->hh_lock);
-	        skb_push(skb, hh->hh_len);
-		hh->hh_output(skb);
-	} else if (dst->neighbour)
-		dst->neighbour->output(skb);
-	else {
-		printk(KERN_DEBUG "khm in MIRROR\n");
-		kfree_skb(skb);
-	}
-}
-
-static unsigned int ipt_mirror_target(struct sk_buff **pskb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      unsigned int hooknum,
-				      const void *targinfo,
-				      void *userinfo)
-{
-	struct rtable *rt;
-	struct sk_buff *nskb;
-	unsigned int hh_len;
-
-	/* Make skb writable */
-	if (!skb_ip_make_writable(pskb, sizeof(struct iphdr)))
-		return 0;
-
-	/* If we are not at FORWARD hook (INPUT/PREROUTING),
-	 * the TTL isn't decreased by the IP stack */
-	if (hooknum !=3D NF_IP_FORWARD) {
-		if ((*pskb)->nh.iph->ttl <=3D 1) {
-			/* this will traverse normal stack, and=20
-			 * thus call conntrack on the icmp packet */
-			icmp_send(*pskb, ICMP_TIME_EXCEEDED,=20
-				  ICMP_EXC_TTL, 0);
-			return NF_DROP;
-		}
-		ip_decrease_ttl((*pskb)->nh.iph);
-	}
-
-	if ((rt =3D route_mirror(*pskb, hooknum =3D=3D NF_IP_LOCAL_IN)) =3D=3D NU=
LL)
-		return NF_DROP;
-
-	hh_len =3D (rt->u.dst.dev->hard_header_len + 15) & ~15;
-
-	/* Copy skb (even if skb is about to be dropped, we can't just
-	 * clone it because there may be other things, such as tcpdump,
-	 * interested in it). We also need to expand headroom in case
-	 * hh_len of incoming interface < hh_len of outgoing interface */
-	nskb =3D skb_copy_expand(*pskb, hh_len, skb_tailroom(*pskb), GFP_ATOMIC);
-	if (nskb =3D=3D NULL) {
-		dst_release(&rt->u.dst);
-		return NF_DROP;
-	}
-
-	dst_release(nskb->dst);
-	nskb->dst =3D &rt->u.dst;
-
-	ip_rewrite(nskb);
-	/* Don't let conntrack code see this packet:
-	 * it will think we are starting a new
-	 * connection! --RR */
-	ip_direct_send(nskb);
-
-	return NF_DROP;
-}
-
-static int ipt_mirror_checkentry(const char *tablename,
-				 const struct ipt_entry *e,
-				 void *targinfo,
-				 unsigned int targinfosize,
-				 unsigned int hook_mask)
-{
-	/* Only on INPUT, FORWARD or PRE_ROUTING, otherwise loop danger. */
-	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING)
-			  | (1 << NF_IP_FORWARD)
-			  | (1 << NF_IP_LOCAL_IN))) {
-		DEBUGP("MIRROR: bad hook\n");
-		return 0;
-	}
-
-	if (targinfosize !=3D IPT_ALIGN(0)) {
-		DEBUGP("MIRROR: targinfosize %u !=3D 0\n", targinfosize);
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct ipt_target ipt_mirror_reg =3D {
-	.name		=3D "MIRROR",
-	.target		=3D ipt_mirror_target,
-	.checkentry	=3D ipt_mirror_checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_target(&ipt_mirror_reg);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_target(&ipt_mirror_reg);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cVp8NMj01v+Em8Se
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9NSXaXGVTD0i/8RAoR+AJ4w6v+k/WAGbpu65RZ4Q4VKtpMJLgCgoASx
QO8wKn8G2e4GTKTPlswBEqo=
=9CzJ
-----END PGP SIGNATURE-----

--cVp8NMj01v+Em8Se--
