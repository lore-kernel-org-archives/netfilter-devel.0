From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 2] Re: what's the lockingrules for
	ip_conntrack_expect_list?
Date: 12 Oct 2002 17:32:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034436775.7595.96.camel@tux>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
	<1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux>
	<20021012163620.C13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-P0aiDMRMb+gvurFrsD6K"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021012163620.C13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-P0aiDMRMb+gvurFrsD6K
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2002-10-12 at 16:36, Harald Welte wrote:
> On Sat, Oct 12, 2002 at 03:29:12PM +0200, Martin Josefsson wrote:
> > Attached patch changes the write-locked tuple_lock to cover the entire
> > function.
> > Is this ok with you?
> 
> looks fine.  Now we only need the find_proto() change, and I'll submit 
> the two combined to the kernel.

The find_proto() change is a little trickier... it depends on
ip_conntrack_protocol.h. I suggest that we move find_proto() to
ip_conntrack_protocol.h. And then find_proto() also depends on
listhelp.h... include-dependencies isn't fun.

Making find_proto() an inline adds two exported symbols, protocol_list
and ip_conntrack_generic_protocol.

I've attached a patch that at least compiles, I havn't tried booting it
yet. Does this look even remotely ok to you? If it does I'll try booting
it and send you a combined patch.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-P0aiDMRMb+gvurFrsD6K
Content-Disposition: attachment; filename=find_proto-inline.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=find_proto-inline.diff; charset=ISO-8859-15

--- linux-2.4.20-pre10/include/linux/netfilter_ipv4/ip_conntrack_core.h.mee=
p	2002-10-12 16:54:30.000000000 +0200
+++ linux-2.4.20-pre10/include/linux/netfilter_ipv4/ip_conntrack_core.h	200=
2-10-12 17:17:16.000000000 +0200
@@ -16,9 +16,6 @@
=20
 struct ip_conntrack_protocol;
 extern struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol);
-/* Like above, but you already have conntrack read lock. */
-extern struct ip_conntrack_protocol *__find_proto(u_int8_t protocol);
-extern struct list_head protocol_list;
=20
 /* Returns conntrack if it dealt with ICMP, and filled in skb->nfct */
 extern struct ip_conntrack *icmp_error_track(struct sk_buff *skb,
--- linux-2.4.20-pre10/include/linux/netfilter_ipv4/ip_conntrack_protocol.h=
.meep	2002-10-12 16:55:28.000000000 +0200
+++ linux-2.4.20-pre10/include/linux/netfilter_ipv4/ip_conntrack_protocol.h=
	2002-10-12 17:14:40.000000000 +0200
@@ -62,4 +62,28 @@
 extern struct ip_conntrack_protocol ip_conntrack_protocol_udp;
 extern struct ip_conntrack_protocol ip_conntrack_protocol_icmp;
 extern int ip_conntrack_protocol_tcp_init(void);
+
+extern struct list_head protocol_list;
+extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
+
+static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
+			      u_int8_t protocol)
+{
+	return protocol =3D=3D curr->proto;
+}
+
+static inline struct ip_conntrack_protocol *__find_proto(u_int8_t protocol=
)
+{
+	struct ip_conntrack_protocol *p;
+
+	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	p =3D LIST_FIND(&protocol_list, proto_cmpfn,
+		      struct ip_conntrack_protocol *, protocol);
+	if (!p)
+		p =3D &ip_conntrack_generic_protocol;
+
+	return p;
+}
+
+
 #endif /*_IP_CONNTRACK_PROTOCOL_H*/
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c.meep	2002-10-=
12 15:29:47.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-12 17=
:09:32.000000000 +0200
@@ -39,11 +39,11 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #define IP_CONNTRACK_VERSION	"2.1"
=20
@@ -66,27 +66,6 @@
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
=20
-extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
-
-static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
-			      u_int8_t protocol)
-{
-	return protocol =3D=3D curr->proto;
-}
-
-struct ip_conntrack_protocol *__find_proto(u_int8_t protocol)
-{
-	struct ip_conntrack_protocol *p;
-
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	p =3D LIST_FIND(&protocol_list, proto_cmpfn,
-		      struct ip_conntrack_protocol *, protocol);
-	if (!p)
-		p =3D &ip_conntrack_generic_protocol;
-
-	return p;
-}
-
 struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol)
 {
 	struct ip_conntrack_protocol *p;
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_core.c.meep	2002-10-12 15:=
37:02.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_core.c	2002-10-12 17:30:38=
.000000000 +0200
@@ -21,6 +21,7 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
@@ -29,7 +30,6 @@
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk
@@ -739,7 +739,7 @@
 	int ret =3D 1;
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
+	proto =3D __find_proto((*pskb)->nh.iph->protocol);
 	if (proto->exp_matches_pkt)
 		ret =3D proto->exp_matches_pkt(exp, pskb);
=20
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_standalone.c.meep	20=
02-10-12 17:00:17.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_standalone.c	2002-10=
-12 17:25:42.000000000 +0200
@@ -21,11 +21,11 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk
@@ -361,6 +361,8 @@
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh);
 EXPORT_SYMBOL(ip_ct_find_proto);
+EXPORT_SYMBOL(protocol_list);
+EXPORT_SYMBOL(ip_conntrack_generic_protocol);
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_generic.c.meep=
	2002-10-12 17:09:55.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2002=
-10-12 17:11:35.000000000 +0200
@@ -1,7 +1,12 @@
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
 #define GENERIC_TIMEOUT (600*HZ)
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.meep	200=
2-10-12 17:11:56.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-10-=
12 17:12:24.000000000 +0200
@@ -11,6 +11,10 @@
=20
 #include <net/tcp.h>
=20
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_udp.c.meep	200=
2-10-12 17:12:34.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2002-10-=
12 17:12:55.000000000 +0200
@@ -4,6 +4,11 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/udp.h>
+
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
 #define UDP_TIMEOUT (30*HZ)
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_icmp.c.meep	20=
02-10-12 17:13:10.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2002-10=
-12 17:13:22.000000000 +0200
@@ -4,6 +4,11 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/icmp.h>
+
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
=20
 #define ICMP_TIMEOUT (30*HZ)
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_helper.c.meep	2002-10-12 1=
7:15:10.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_helper.c	2002-10-12 17:15:=
19.000000000 +0200
@@ -26,13 +26,13 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_rule.c.meep	2002-10-12 17:=
15:28.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_rule.c	2002-10-12 17:15:45=
.000000000 +0200
@@ -15,11 +15,11 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_standalone.c.meep	2002-10-=
12 17:15:53.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_nat_standalone.c	2002-10-12 17=
:16:01.000000000 +0200
@@ -28,6 +28,7 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_rule.h>
 #include <linux/netfilter_ipv4/ip_nat_protocol.h>
@@ -35,7 +36,6 @@
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk
--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_fw_compat_masq.c.meep	2002-10-=
12 17:20:08.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_fw_compat_masq.c	2002-10-12 17=
:20:35.000000000 +0200
@@ -20,11 +20,11 @@
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
=20
+#include <linux/netfilter_ipv4/listhelp.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
-#include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
 #define DEBUGP printk

--=-P0aiDMRMb+gvurFrsD6K--
