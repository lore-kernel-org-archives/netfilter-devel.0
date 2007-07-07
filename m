From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_connlimit 20070707 kernel
Date: Sat, 7 Jul 2007 19:51:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
	<4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
	<46891C50.1020904@trash.net>
	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
	<468A2F91.3040002@trash.net>
	<Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>
	<468A3446.9050505@trash.net>
	<Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>
	<468BB421.3090801@trash.net>
	<Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-335201785-1183830662=:1536"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468E3E06.3080305@trash.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-335201785-1183830662=:1536
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jul 6 2007 15:05, Patrick McHardy wrote:
>>=20
>> Ok so what should I put in for nhoff, dataoff, what_l3 and what_l4?
>
>
>Check out nf_conntrack_in() and the IPv4/IPv6 prepare functions.
>

Does this look ok?

Thanks,
	Jan
=3D=3D=3D

Add the xt_connlimit match

ipt_connlimit has been sitting in POM-NG for a long time.
Here is a new shiny xt_connlimit with:

 * xtables'ified and all that
 * will request the layer3 module
   (previously it hotdropped every packet when it was not loaded)
 * fixed: there was a deadlock in case of an OOM condition
 * support for any layer4 protocol (e.g. UDP/SCTP)
 * using jhash, as suggested by Eric Dumazet
 * ipv6 support


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_connlimit.h |   17 +
 net/netfilter/Kconfig                  |    7=20
 net/netfilter/Makefile                 |    1=20
 net/netfilter/xt_connlimit.c           |  334 ++++++++++++++++++++++++++=
+++++++
 4 files changed, 359 insertions(+)

Index: linux-2.6.22/include/linux/netfilter/xt_connlimit.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22/include/linux/netfilter/xt_connlimit.h
@@ -0,0 +1,17 @@
+#ifndef _XT_CONNLIMIT_H
+#define _XT_CONNLIMIT_H
+
+struct xt_connlimit_data;
+
+struct xt_connlimit_info {
+	union {
+		u_int32_t v4_mask;
+		u_int32_t v6_mask[4];
+	};
+	unsigned int limit, inverse;
+
+	/* this needs to be at the end */
+	struct xt_connlimit_data *data __attribute__((aligned(8)));
+};
+
+#endif /* _XT_CONNLIMIT_H */
Index: linux-2.6.22/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Kconfig
+++ linux-2.6.22/net/netfilter/Kconfig
@@ -423,6 +423,13 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
=20
+config NETFILTER_XT_MATCH_CONNLIMIT
+	tristate '"connlimit" match support"'
+	depends on NETFILTER_XTABLES
+	---help---
+	  This match allows you to match against the number of parallel
+	  connections to a server per client IP address (or address block).
+
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.22/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Makefile
+++ linux-2.6.22/net/netfilter/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSEC
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) +=3D xt_connbytes.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) +=3D xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) +=3D xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) +=3D xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) +=3D xt_dccp.o
Index: linux-2.6.22/net/netfilter/xt_connlimit.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22/net/netfilter/xt_connlimit.c
@@ -0,0 +1,334 @@
+/*
+ * netfilter module to limit the number of parallel tcp
+ * connections per IP address.
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *
+ * based on ...
+ *
+ * Kernel module to match connection tracking information.
+ * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+ */
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/jhash.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_connlimit.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+/* we will save the tuples of all connections we care about */
+struct xt_connlimit_conn {
+	struct list_head list;
+	struct nf_conntrack_tuple tuple;
+};
+
+struct xt_connlimit_data {
+	struct list_head iphash[256];
+	spinlock_t lock;
+};
+
+static u_int32_t connlimit_rnd;
+static bool connlimit_rnd_inited;
+
+static inline unsigned int connlimit_iphash(u_int32_t addr)
+{
+	if (unlikely(!connlimit_rnd_inited)) {
+		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
+		connlimit_rnd_inited =3D true;
+	}
+	return jhash_1word(addr, connlimit_rnd) & 0xFF;
+}
+
+static inline unsigned int
+connlimit_iphash6(const union nf_conntrack_address *addr,
+                  const union nf_conntrack_address *mask)
+{
+	union nf_conntrack_address res;
+	unsigned int i;
+
+	if (unlikely(!connlimit_rnd_inited)) {
+		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
+		connlimit_rnd_inited =3D true;
+	}
+
+	for (i =3D 0; i < ARRAY_SIZE(addr->ip6); ++i)
+		res.ip6[i] =3D addr->ip6[i] & mask->ip6[i];
+
+	return jhash2(res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
+}
+
+static inline bool already_closed(const struct nf_conn *conn)
+{
+	u_int16_t proto =3D conn->tuplehash[0].tuple.dst.protonum;
+
+	if (proto =3D=3D IPPROTO_TCP)
+		return conn->proto.tcp.state =3D=3D TCP_CONNTRACK_TIME_WAIT;
+	else
+		return 0;
+}
+
+static inline unsigned int
+same_source_net(const union nf_conntrack_address *addr,
+                const union nf_conntrack_address *mask,
+                const union nf_conntrack_address *u3, unsigned int famil=
y)
+{
+	if (family =3D=3D AF_INET) {
+		return (addr->ip & mask->ip) =3D=3D (u3->ip & mask->ip);
+	} else {
+		union nf_conntrack_address lh, rh;
+		unsigned int i;
+
+		for (i =3D 0; i < ARRAY_SIZE(addr->ip6); ++i) {
+			lh.ip6[i] =3D addr->ip6[i] & mask->ip6[i];
+			rh.ip6[i] =3D u3->ip6[i] & mask->ip6[i];
+		}
+
+		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6)) =3D=3D 0;
+	}
+}
+
+static int count_them(struct xt_connlimit_data *data,
+                      const struct nf_conntrack_tuple *tuple,
+                      const union nf_conntrack_address *addr,
+                      const union nf_conntrack_address *mask,
+                      const struct xt_match *match)
+{
+	struct nf_conntrack_tuple_hash *found;
+	struct xt_connlimit_conn *conn;
+	struct xt_connlimit_conn *tmp;
+	struct nf_conn *found_ct;
+	struct list_head *hash;
+	bool addit =3D true;
+	int matches =3D 0;
+
+
+	if (match->family =3D=3D AF_INET6)
+		hash =3D &data->iphash[connlimit_iphash6(addr, mask)];
+	else
+		hash =3D &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
+
+	read_lock_bh(&nf_conntrack_lock);
+
+	/* check the saved connections */
+	list_for_each_entry_safe(conn, tmp, hash, list) {
+		found    =3D __nf_conntrack_find(&conn->tuple, NULL);
+		found_ct =3D NULL;
+
+		if (found !=3D NULL)
+			found_ct =3D nf_ct_tuplehash_to_ctrack(found);
+
+		if (found_ct !=3D NULL &&
+		    nf_ct_tuple_equal(&conn->tuple, tuple) &&
+		    !already_closed(found_ct))
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			addit =3D false;
+
+		if (found =3D=3D NULL) {
+			/* this one is gone */
+			list_del(&conn->list);
+			kfree(conn);
+			continue;
+		}
+
+		if (already_closed(found_ct)) {
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			list_del(&conn->list);
+			kfree(conn);
+			continue;
+		}
+
+		if (same_source_net(addr, mask, &conn->tuple.src.u3,
+		    match->family))
+			/* same source network -> be counted! */
+			++matches;
+	}
+
+	read_unlock_bh(&nf_conntrack_lock);
+
+	if (addit) {
+		/* save the new connection in our list */
+		conn =3D kzalloc(sizeof(*conn), GFP_ATOMIC);
+		if (conn =3D=3D NULL)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&conn->list);
+		conn->tuple =3D *tuple;
+		list_add(&conn->list, hash);
+		++matches;
+	}
+
+	return matches;
+}
+
+static bool connlimit_match(const struct sk_buff *skb,
+			    const struct net_device *in,
+			    const struct net_device *out,
+			    const struct xt_match *match,
+			    const void *matchinfo, int offset,
+			    unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_connlimit_info *info =3D matchinfo;
+	const struct nf_conntrack_tuple *tuple_ptr;
+	union nf_conntrack_address addr, mask;
+	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	int connections;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct !=3D NULL) {
+		tuple_ptr =3D &ct->tuplehash[0].tuple;
+	} else {
+		struct nf_conntrack_l3proto *l3proto;
+		struct nf_conntrack_l4proto *l4proto;
+
+		l3proto =3D nf_ct_l3proto_find_get(match->family);
+		if (l3proto =3D=3D NULL) {
+			*hotdrop =3D true;
+			return false;
+		}
+		l4proto =3D nf_ct_l4proto_find_get(match->family, match->proto);
+		if (l4proto =3D=3D NULL) {
+			nf_ct_l3proto_put(l3proto);
+			*hotdrop =3D true;
+			return false;
+		}
+		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
+		    &tuple, NULL, NULL) !=3D 0) {
+			nf_ct_l3proto_put(l3proto);
+			nf_ct_l4proto_put(l4proto);
+			*hotdrop =3D true;
+			return false;
+		}
+		tuple_ptr =3D &tuple;
+		nf_ct_l3proto_put(l3proto);
+		nf_ct_l4proto_put(l4proto);
+	}
+
+	if (match->family =3D=3D AF_INET6) {
+		const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
+		memcpy(&mask.ip6, info->v6_mask, sizeof(info->v6_mask));
+	} else {
+		const struct iphdr *iph =3D ip_hdr(skb);
+		addr.ip =3D iph->saddr;
+		mask.ip =3D info->v4_mask;
+	}
+
+	spin_lock_bh(&info->data->lock);
+	connections =3D count_them(info->data, tuple_ptr, &addr, &mask, match);
+	spin_unlock_bh(&info->data->lock);
+
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		*hotdrop =3D 1;
+		return false;
+	}
+
+	return (connections > info->limit) ^ info->inverse;
+}
+
+static bool connlimit_check(const char *tablename, const void *ip,
+			    const struct xt_match *match, void *matchinfo,
+			    unsigned int hook_mask)
+{
+	struct xt_connlimit_info *info =3D matchinfo;
+	unsigned int i;
+
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "address family %u\n", match->family);
+		return false;
+	}
+
+	/* init private data */
+	info->data =3D kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
+	if (info->data =3D=3D NULL) {
+		nf_ct_l3proto_module_put(match->family);
+		return false;
+	}
+
+	spin_lock_init(&info->data->lock);
+	for (i =3D 0; i < ARRAY_SIZE(info->data->iphash); ++i)
+		INIT_LIST_HEAD(&info->data->iphash[i]);
+
+	return true;
+}
+
+static void connlimit_destroy(const struct xt_match *match, void *matchi=
nfo)
+{
+	struct xt_connlimit_info *info =3D matchinfo;
+	struct xt_connlimit_conn *conn;
+	struct xt_connlimit_conn *tmp;
+	struct list_head *hash =3D info->data->iphash;
+	unsigned int i;
+
+	nf_ct_l3proto_module_put(match->family);
+
+	for (i =3D 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
+		list_for_each_entry_safe(conn, tmp, &hash[i], list) {
+			list_del(&conn->list);
+			kfree(conn);
+		}
+	}
+
+	kfree(info->data);
+}
+
+static struct xt_match connlimit_reg[] __read_mostly =3D {
+	{
+		.name       =3D "connlimit",
+		.family     =3D AF_INET,
+		.checkentry =3D connlimit_check,
+		.match      =3D connlimit_match,
+		.matchsize  =3D sizeof(struct xt_connlimit_info),
+		.destroy    =3D connlimit_destroy,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "connlimit",
+		.family     =3D AF_INET6,
+		.checkentry =3D connlimit_check,
+		.match      =3D connlimit_match,
+		.matchsize  =3D sizeof(struct xt_connlimit_info),
+		.destroy    =3D connlimit_destroy,
+		.me         =3D THIS_MODULE,
+	},
+};
+
+static int __init xt_connlimit_init(void)
+{
+	return xt_register_matches(connlimit_reg, ARRAY_SIZE(connlimit_reg));
+}
+
+static void __exit xt_connlimit_exit(void)
+{
+	xt_unregister_matches(connlimit_reg, ARRAY_SIZE(connlimit_reg));
+}
+
+module_init(xt_connlimit_init);
+module_exit(xt_connlimit_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter xt_connlimit match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_connlimit");
+MODULE_ALIAS("ip6t_connlimit");
---699020219-335201785-1183830662=:1536--
