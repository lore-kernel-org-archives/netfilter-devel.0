From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 3 Jun 2007 13:12:55 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Mailing List <netfilter@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761937AbXFCLN6@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Adds the connlimit match that has been in POM-NG for a long time.

    *	works with 2.6.22, xtables'ified and all that

    *	will request nf_conntrack_ipv4 upon load
	(otherwise it hotdrops every packet - a glitch that goes back
	to at least 2.6.20.2)


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/nf_conntrack_common.h  |    1=20
 include/linux/netfilter/xt_connlimit.h         |   14 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    5=20
 net/netfilter/Kconfig                          |    7=20
 net/netfilter/Makefile                         |    1=20
 net/netfilter/xt_connlimit.c                   |  250 ++++++++++++++++=
+++++++++
 6 files changed, 278 insertions(+)

Index: linux-2.6.22-rc3-git6/include/linux/netfilter/nf_conntrack_commo=
n.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc3-git6.orig/include/linux/netfilter/nf_conntrack_com=
mon.h
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/nf_conntrack_common.h
@@ -164,6 +164,7 @@ struct ip_conntrack_stat
=20
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_conntrack(void);
+extern void need_conntrack_ipv4(void);
=20
 #endif /* __KERNEL__ */
=20
Index: linux-2.6.22-rc3-git6/include/linux/netfilter/xt_connlimit.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22-rc3-git6/include/linux/netfilter/xt_connlimit.h
@@ -0,0 +1,14 @@
+#ifndef _XT_CONNLIMIT_H
+#define _XT_CONNLIMIT_H
+
+struct xt_connlimit_data;
+
+struct xt_connlimit_info {
+	uint32_t mask;
+	unsigned int limit, inverse;
+
+	/* this needs to be at the end */
+	struct xt_connlimit_data *data;
+};
+
+#endif /* _XT_CONNLIMIT_H */
Index: linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_conntrack_l3proto_ip=
v4.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc3-git6.orig/net/ipv4/netfilter/nf_conntrack_l3proto_=
ipv4.c
+++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.=
c
@@ -519,3 +519,8 @@ static void __exit nf_conntrack_l3proto_
=20
 module_init(nf_conntrack_l3proto_ipv4_init);
 module_exit(nf_conntrack_l3proto_ipv4_fini);
+
+void need_conntrack_ipv4(void)
+{
+}
+EXPORT_SYMBOL(need_conntrack_ipv4);
Index: linux-2.6.22-rc3-git6/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc3-git6.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc3-git6/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
=20
+config NETFILTER_XT_MATCH_CONNLIMIT
+	tristate '"connlimit" match support"'
+	depends on NETFILTER_XTABLES && NF_CONNTRACK_IPV4
+	---help---
+	  This match allows you to match against the number of parallel TCP
+	  connections to a server per client IP address (or address block).
+
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
Index: linux-2.6.22-rc3-git6/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc3-git6.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc3-git6/net/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSEC
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) +=3D xt_connbytes.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) +=3D xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) +=3D xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) +=3D xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) +=3D xt_dccp.o
Index: linux-2.6.22-rc3-git6/net/netfilter/xt_connlimit.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_connlimit.c
@@ -0,0 +1,250 @@
+/*
+ * netfilter module to limit the number of parallel tcp
+ * connections per IP address.
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *
+ * based on ...
+ *
+ * Kernel module to match connection tracking information.
+ * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+ */
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tcp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_connlimit.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+#define DEBUG 0
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
+static inline unsigned int connlimit_iphash(uint32_t addr)
+{
+	return (addr ^ (addr >> 8) ^ (addr >> 16) ^ (addr >> 24)) & 0xff;
+}
+
+static int count_them(struct xt_connlimit_data *data, uint32_t addr,
+		      uint32_t mask, struct nf_conn *ct)
+{
+#if DEBUG
+	static const char const *tcp_state[] =3D {
+		"none", "established", "syn_sent", "syn_recv", "fin_wait",
+		"time_wait", "close", "close_wait", "last_ack", "listen"
+	};
+#endif
+	struct nf_conntrack_tuple_hash *found;
+	struct nf_conntrack_tuple tuple;
+	struct xt_connlimit_conn *conn;
+	struct list_head *hash, *lh;
+	int addit =3D 1, matches =3D 0;
+	struct nf_conn *found_ct;
+
+	spin_lock_bh(&data->lock);
+	tuple =3D ct->tuplehash[0].tuple;
+	hash  =3D &data->iphash[connlimit_iphash(addr & mask)];
+
+	/* check the saved connections */
+	for (lh =3D hash->next; lh !=3D hash; lh =3D lh->next) {
+		conn     =3D list_entry(lh, struct xt_connlimit_conn, list);
+		found    =3D nf_conntrack_find_get(&conn->tuple, ct);
+		found_ct =3D NULL;
+
+		if (found !=3D NULL &&
+		    (found_ct =3D nf_ct_tuplehash_to_ctrack(found)) !=3D NULL &&
+		    memcmp(&conn->tuple, &tuple, sizeof(tuple)) =3D=3D 0 &&
+		    found_ct->proto.tcp.state !=3D TCP_CONNTRACK_TIME_WAIT)
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			addit =3D 0;
+
+#if DEBUG
+		printk(KERN_WARNING "xt_connlimit [%u]: src=3D%u.%u.%u.%u:%u "
+		       "dst=3D%u.%u.%u.%u:%d %s\n",
+		       connlimit_iphash(addr & mask),
+		       NIPQUAD(conn->tuple.src.u3.ip),
+		       ntohs(conn->tuple.src.u.tcp.port),
+		       NIPQUAD(conn->tuple.dst.u3.ip),
+		       ntohs(conn->tuple.dst.u.tcp.port),
+		       (found =3D=3D NULL) ? "gone" :
+				tcp_state[found_ct->proto.tcp.state]);
+#endif
+
+		if (found =3D=3D NULL) {
+			/* this one is gone */
+			lh =3D lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			continue;
+		}
+
+		if (found_ct->proto.tcp.state =3D=3D TCP_CONNTRACK_TIME_WAIT) {
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			lh =3D lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			nf_conntrack_put(&found_ct->ct_general);
+			continue;
+		}
+
+		if ((addr & mask) =3D=3D (conn->tuple.src.u3.ip & mask))
+			/* same source IP address -> be counted! */
+			++matches;
+
+		nf_conntrack_put(&found_ct->ct_general);
+	}
+
+	if (addit) {
+		/* save the new connection in our list */
+#if DEBUG
+		printk(KERN_WARNING "xt_connlimit [%u]: src=3D%u.%u.%u.%u:%u "
+		       "dst=3D%u.%u.%u.%u:%u new\n",
+		       connlimit_iphash(addr & mask),
+		       NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
+		       NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
+#endif
+
+		conn =3D kzalloc(sizeof(*conn), GFP_ATOMIC);
+		if (conn =3D=3D NULL)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&conn->list);
+		conn->tuple =3D tuple;
+		list_add(&conn->list, hash);
+		++matches;
+	}
+
+	spin_unlock_bh(&data->lock);
+	return matches;
+}
+
+static int xt_connlimit_match(const struct sk_buff *skb,
+			      const struct net_device *in,
+			      const struct net_device *out,
+			      const struct xt_match *match,
+			      const void *matchinfo, int offset,
+			      unsigned int protoff, int *hotdrop)
+{
+	const struct xt_connlimit_info *info =3D matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct iphdr *iph;
+	int connections, rv;
+	struct nf_conn *ct;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct =3D=3D NULL) {
+		printk(KERN_INFO "xt_connlimit: INVALID connection or "
+		       "nf_conntrack_ipv4 not loaded\n");
+		*hotdrop =3D 1;
+		return false;
+	}
+
+	iph =3D ip_hdr(skb);
+	connections =3D count_them(info->data, iph->saddr, info->mask, ct);
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		printk(KERN_DEBUG "xt_connlimit: kmalloc failed\n");
+		*hotdrop =3D 1;
+		return false;
+	}
+
+	rv =3D info->inverse ^ (connections > info->limit);
+#if DEBUG
+	printk(KERN_DEBUG "xt_connlimit: src=3D%u.%u.%u.%u mask=3D%u.%u.%u.%u=
 "
+	       "connections=3D%d limit=3D%u match=3D%s\n",
+	       NIPQUAD(iph->saddr), NIPQUAD(info->mask),
+	       connections, info->limit, match ? "yes" : "no");
+#endif
+
+	return rv;
+}
+
+static int xt_connlimit_check(const char *tablename, const void *ip,
+			      const struct xt_match *match, void *matchinfo,
+			      unsigned int hook_mask)
+{
+	struct xt_connlimit_info *info =3D matchinfo;
+	unsigned int i;
+
+	/* init private data */
+	info->data =3D kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
+	spin_lock_init(&info->data->lock);
+	for (i =3D 0; i < 256; ++i)
+		INIT_LIST_HEAD(&info->data->iphash[i]);
+
+	return 1;
+}
+
+static void xt_connlimit_destroy(const struct xt_match *match, void *m=
atchinfo)
+{
+	struct xt_connlimit_info *info =3D matchinfo;
+	struct xt_connlimit_conn *conn;
+	struct list_head *hash;
+	unsigned int i;
+
+	for (i =3D 0; i < 256; ++i) {
+		hash =3D &info->data->iphash[i];
+		while (hash !=3D hash->next) {
+			conn =3D list_entry(hash->next,
+			       struct xt_connlimit_conn, list);
+			list_del(hash->next);
+			kfree(conn);
+		}
+	}
+
+	kfree(info->data);
+	return;
+}
+
+static struct xt_match xt_connlimit_reg =3D {
+	.name       =3D "connlimit",
+	.family     =3D AF_INET,
+	.proto      =3D IPPROTO_TCP,
+	.checkentry =3D xt_connlimit_check,
+	.match      =3D xt_connlimit_match,
+	.matchsize  =3D sizeof(struct xt_connlimit_info),
+	.destroy    =3D xt_connlimit_destroy,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_connlimit_init(void)
+{
+	need_conntrack_ipv4();
+	return xt_register_match(&xt_connlimit_reg);
+}
+
+static void __exit xt_connlimit_exit(void)
+{
+	xt_unregister_match(&xt_connlimit_reg);
+	return;
+}
+
+module_init(xt_connlimit_init);
+module_exit(xt_connlimit_exit);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_connlimit");
