From: Harald Welte <laforge@netfilter.org>
Subject: ctnetlink: support for flow-based accounting
Date: Sat, 16 Apr 2005 11:34:32 +0200
Message-ID: <20050416093432.GA15942@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Cc: pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Just to let you know that I'm currently working on this.  I'll merge
Pablo's latest ctnetlink changes into svn later today, and put my
modifications for 'list-conntrack-and-zero-counters' on top of it.

I've also already modified the 'conntrack-tool' and libctnetlink to deal
with the new message type. =20

Pablo: I think we should put the contrack tool into svn.netfilter.org.
You would get svn write access, of course.  The module name will be
'conntrack' ('iptables' also isn't called 'iptables-tool').

Cheers,
	Harald

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ctnetlink-conntrack_acct.patch"
Content-Transfer-Encoding: quoted-printable

Index: linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack_netl=
ink.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.12-rc2-ctnl.orig/include/linux/netfilter_ipv4/ip_conntrack_ne=
tlink.h	2005-04-15 18:40:44.000000000 +0200
+++ linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack_netlink=
=2Eh	2005-04-16 11:29:04.000000000 +0200
@@ -8,13 +8,13 @@
 /* TODO: Add more message types:
  *
  * 	o IPCTNL_MSG_UPDCONNTRACK, update conntracks
- * 	o IPCTNL_MSG_DMPCONNTRACK, dump conntrack table
  * 	o IPCTNL_MSG_FSHCONNTRACK, flush conntrack table
  */
 enum cntl_msg_types {
 	IPCTNL_MSG_NEWCONNTRACK,
 	IPCTNL_MSG_GETCONNTRACK,
 	IPCTNL_MSG_DELCONNTRACK,
+	IPCTNL_MSG_GETCT_CTRZERO,
=20
 	IPCTNL_MSG_NEWEXPECT,
 	IPCTNL_MSG_GETEXPECT,
@@ -36,6 +36,7 @@
 	CTA_HELPINFO,   /* [cta_help] Helper specific information. */
 	CTA_TIMEOUT,    /* [unsigned long] timer */
 	CTA_MARK,       /* [unsigned long] mark .*/
+	CTA_COUNTERS,	/* [cta_counters] packet/byte counters */
 =09
 	CTA_EXP_TUPLE,	/* [ip_conntrack_tuple] Expected tuple */
 	CTA_EXP_MASK,	/* [ip_conntrack_tuple] Mask for EXP_TUPLE */
@@ -65,6 +66,11 @@
 	union ip_conntrack_expect_proto proto;
 };
=20
+struct cta_counters {
+	struct ip_conntrack_counter orig;
+	struct ip_conntrack_counter reply;
+};
+
 /* ctnetlink multicast groups: reports any change of ctinfo,
  * ctstatus, or protocol state change.
  */
Index: linux-2.6.12-rc2-ctnl/net/ipv4/netfilter/ip_conntrack_netlink.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.12-rc2-ctnl.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	20=
05-04-15 18:40:44.000000000 +0200
+++ linux-2.6.12-rc2-ctnl/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-04=
-16 11:27:06.000000000 +0200
@@ -27,6 +27,7 @@
 #include <linux/net.h>
 #include <linux/fcntl.h>
 #include <linux/skbuff.h>
+#include <linux/errno.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <net/sock.h>
@@ -53,7 +54,7 @@
=20
 MODULE_LICENSE("GPL");
=20
-static char __initdata ctversion[] =3D "0.50";
+static char __initdata ctversion[] =3D "0.52";
=20
 #if 0
 #define DEBUGP printk
@@ -131,11 +132,42 @@
 	return -1;
 }
=20
+#ifdef CONFIG_IP_NF_CT_ACCT
+static inline int
+ctnetlink_dump_counters(struct sk_buff *skb, const struct ip_conntrack *ct)
+{
+	const struct ip_conntrack_counter *ctr;
+	struct cta_counters cc;
+
+	ctr =3D &ct->counters[IP_CT_DIR_ORIGINAL];
+	memcpy(&cc.orig, ctr, sizeof(cc.orig));
+
+	ctr =3D &ct->counters[IP_CT_DIR_REPLY];
+	memcpy(&cc.reply, ctr, sizeof(cc.reply));
+=09
+	NFA_PUT(skb, CTA_COUNTERS, sizeof(cc), &cc);
+	return 0;
+
+nfattr_failure:
+	return -1;
+}
+#else
+#define ctnetlink_dump_counters(a, b) (0)
+#endif
+
+#ifdef CONFIG_IP_NF_CONNTRACK_MARK
 static inline int
 ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
 {
+	NFA_PUT(skb, CTA_MARK, sizeof(unsigned long), &ct->mark);
 	return 0;
+
+nfattr_failure:
+	return -1;
 }
+#else
+#define ctnetlink_dump_mark(a, b) (0)
+#endif
=20
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
@@ -158,6 +190,7 @@
 	if (ctnetlink_dump_tuples(skb, ct) < 0 ||
 	    ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
+	    ctnetlink_dump_counters(skb, ct) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0)
@@ -277,6 +310,8 @@
 	[CTA_PROTOINFO-1]	=3D sizeof(struct cta_proto),
 	[CTA_HELPINFO-1]	=3D sizeof(struct cta_help),
 	[CTA_TIMEOUT-1]		=3D sizeof(unsigned long),
+	[CTA_MARK-1]		=3D sizeof(unsigned long),
+	[CTA_COUNTERS-1]	=3D sizeof(struct cta_counters),
=20
 	[CTA_EXP_TUPLE-1]	=3D sizeof(struct ip_conntrack_tuple),
 	[CTA_EXP_MASK-1]	=3D sizeof(struct ip_conntrack_tuple),
@@ -387,6 +422,45 @@
 	return skb->len;
 }
=20
+#ifdef CONFIG_IP_NF_CT_ACCT
+static int
+ctnetlink_dump_table_w(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct ip_conntrack *ct =3D NULL;
+	struct ip_conntrack_tuple_hash *h;
+	struct list_head *i;
+
+	DEBUGP("entered %s, last bucket=3D%lu id=3D%lu\n", __FUNCTION__,=20
+			cb->args[0], cb->args[1]);
+
+	WRITE_LOCK(&ip_conntrack_lock);
+	for (; cb->args[0] < ip_conntrack_htable_size;=20
+					cb->args[0]++, cb->args[1]=3D0) {
+		list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
+			h =3D (struct ip_conntrack_tuple_hash *) i;
+			if (DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
+				continue;
+			ct =3D tuplehash_to_ctrack(h);
+			if (ct->id <=3D cb->args[1])
+				continue;
+			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
+		                        	cb->nlh->nlmsg_seq,
+						IPCTNL_MSG_NEWCONNTRACK,
+						1, ct) < 0)
+				break;
+			cb->args[1] =3D ct->id;
+
+			memset(&ct->counters, 0, sizeof(ct->counters));
+		}
+	}
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	DEBUGP("leaving, last bucket=3D%lu id=3D%lu\n", cb->args[0], cb->args[1]);
+
+	return skb->len;
+}
+#endif
+
 static int
 ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,=20
 			struct nlmsghdr *nlh, int *errp)
@@ -407,10 +481,22 @@
 		if (msg->nfgen_family !=3D AF_INET)
 			return -EAFNOSUPPORT;
=20
-		if ((*errp =3D netlink_dump_start(ctnl, skb, nlh,
-		                                ctnetlink_dump_table,
-		                                ctnetlink_done)) !=3D 0)
+		if (NFNL_MSG_TYPE(nlh->nlmsg_type) =3D=3D
+					IPCTNL_MSG_GETCT_CTRZERO) {
+#ifdef CONFIG_IP_NF_CT_ACCT
+			if ((*errp =3D netlink_dump_start(ctnl, skb, nlh,
+						ctnetlink_dump_table_w,
+						ctnetlink_done)) !=3D 0)
+				return -EINVAL;
+#else
+			return -ENOTSUPP;
+#endif
+		} else {
+			if ((*errp =3D netlink_dump_start(ctnl, skb, nlh,
+		      		                        ctnetlink_dump_table,
+		                                	ctnetlink_done)) !=3D 0)
 			return -EINVAL;
+		}
=20
 		rlen =3D NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > skb->len)
@@ -722,7 +808,9 @@
 	return err;
 }
=20
-/* EXPECT */
+/***********************************************************************=
=20
+ * EXPECT=20
+ ***********************************************************************/=
=20
=20
 static inline int
 ctnetlink_exp_dump_tuples(struct sk_buff *skb,
@@ -1173,6 +1261,8 @@
 	ctnl_subsys->cb[IPCTNL_MSG_DELCONNTRACK].cap_required =3D CAP_NET_ADMIN;
 	ctnl_subsys->cb[IPCTNL_MSG_GETCONNTRACK].call =3D ctnetlink_get_conntrack;
 	ctnl_subsys->cb[IPCTNL_MSG_GETCONNTRACK].cap_required =3D CAP_NET_ADMIN;
+	ctnl_subsys->cb[IPCTNL_MSG_GETCT_CTRZERO].call =3Dctnetlink_get_conntrack;
+	ctnl_subsys->cb[IPCTNL_MSG_GETCT_CTRZERO].cap_required =3D CAP_NET_ADMIN;
 	ctnl_subsys->cb[IPCTNL_MSG_NEWEXPECT].call =3D ctnetlink_new_expect;
 	ctnl_subsys->cb[IPCTNL_MSG_NEWEXPECT].cap_required =3D CAP_NET_ADMIN;
 	ctnl_subsys->cb[IPCTNL_MSG_DELEXPECT].call =3D ctnetlink_del_expect;
Index: linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.12-rc2-ctnl.orig/include/linux/netfilter_ipv4/ip_conntrack.h	=
2005-04-15 18:40:33.000000000 +0200
+++ linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack.h	2005-=
04-16 10:43:54.000000000 +0200
@@ -153,6 +153,12 @@
 	struct ip_ct_irc_master ct_irc_info;
 };
=20
+struct ip_conntrack_counter
+{
+	u_int64_t packets;
+	u_int64_t bytes;
+};
+
 #ifdef __KERNEL__
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 #include <linux/netfilter_ipv4/ip_nat.h>
@@ -174,12 +180,6 @@
 #define IP_NF_ASSERT(x)
 #endif
=20
-struct ip_conntrack_counter
-{
-	u_int64_t packets;
-	u_int64_t bytes;
-};
-
 struct ip_conntrack_helper;
=20
 struct ip_conntrack

--ZPt4rx8FFjLCG7dd--

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCYNwoXaXGVTD0i/8RAowtAJ96HQIovwZwTglAIXz4o3ORqZk4DACgmobS
JmzpcGo5I18Zc2Ypn9iPUd0=
=JD52
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
