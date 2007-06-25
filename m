From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 13:11:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-1846785167-1182769909=:3137"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467BAF07.6020502@trash.net>
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

---699020219-1846785167-1182769909=:3137
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Jun 22 2007 13:14, Patrick McHardy wrote:

>As Pablo mentioned, you need to force 8 byte alignment to
>avoid 32/64 bit issues.
>
>list_for_each_entry_safe
>
>Please no assignments in comparisons.
>
>It should support other protocols as well. Also nothing guarantees that
>you're looking at a TCP connection here.
>
>You can remove this with list_for_each_entry_safe
>
>Thats just me I think, but I have an aversion to "rv" for return value.
>"err" or "ret"?
>
>Switching the two expressions seems more logical.
>
>Excessive debugging, also shouldn't use ifdef but pr_debug if
>absolutely necessary.
>
>list_for_each_entry_safe


Subject: Add the connlimit match from POM-NG

Along comes... the connlimit match that has been in POM-NG for a long tim=
e.
Plus:

    *	2007-06-02: works with 2.6.22, xtables'ified and all that

    *	2007-06-02: will request nf_conntrack_ipv4 upon load
	(otherwise it hotdrops every packet - a glitch that goes back
	to at least 2.6.20.2)

    *   2007-06-05: fixed: deadlock after OOM

    *   2007-06-05: any-protocol support

    *   2007-06-06: Using jhash, as suggested by Eric Dumazet.
        ( https://lists.netfilter.org/pipermail/netfilter-devel/2007-June=
/028056.html )


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_connlimit.h |   14 +
 net/netfilter/Kconfig                  |    7=20
 net/netfilter/Makefile                 |    1=20
 net/netfilter/xt_connlimit.c           |  278 ++++++++++++++++++++++++++=
+++++++
 4 files changed, 300 insertions(+)

Index: linux-2.6.22/include/linux/netfilter/xt_connlimit.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ linux-2.6.22/include/linux/netfilter/xt_connlimit.h
@@ -0,0 +1,14 @@
+#ifndef _XT_CONNLIMIT_H
+#define _XT_CONNLIMIT_H
+
+struct xt_connlimit_data;
+
+struct xt_connlimit_info {
+	u_int32_t mask;
+	unsigned int limit, inverse;
+
+	/* this needs to be at the end */
+	struct xt_connlimit_data __attribute__((aligned(8))) *data;
+};
+
+#endif /* _XT_CONNLIMIT_H */
Index: linux-2.6.22/net/netfilter/Kconfig
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Kconfig
+++ linux-2.6.22/net/netfilter/Kconfig
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
Index: linux-2.6.22/net/netfilter/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/Makefile
+++ linux-2.6.22/net/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSEC
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
@@ -0,0 +1,278 @@
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
+#include <linux/ip.h>
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
+static u_int32_t connlimit_iphash_rnd;
+
+static inline unsigned int connlimit_iphash(u_int32_t addr)
+{
+	/*
+	 * Since iphash (in struct xt_connlimit_data) has 256 entries, we need
+	 * to "% 256" it. "& mask" works too, but _only_ if the iphash array
+	 * size is exactly a {power of two} minus 1.
+	 */
+	return jhash_1word(addr, connlimit_iphash_rnd) & 0xFF;
+}
+
+#ifdef DEBUG
+static const char *connection_state(const struct nf_conn *conn)
+{
+	static const char const *tcp_state[] =3D {
+		"none", "established", "syn_sent", "syn_recv", "fin_wait",
+		"time_wait", "close", "close_wait", "last_ack", "listen"
+	};
+	if (conn =3D=3D NULL)
+		return "gone";
+	if (conn->tuplehash[0].tuple.dst.protonum =3D=3D IPPROTO_TCP)
+		return tcp_state[found_ct->proto.tcp.state]);
+	return "";
+}
+#else
+static inline const char *connection_state(const struct nf_conn *conn)
+{
+	return "";
+}
+#endif
+
+static bool already_closed(const struct nf_conn *conn)
+{
+	u_int16_t proto =3D conn->tuplehash[0].tuple.dst.protonum;
+	if (proto =3D=3D IPPROTO_TCP)
+		return conn->proto.tcp.state =3D=3D TCP_CONNTRACK_TIME_WAIT;
+	else if (proto =3D=3D IPPROTO_SCTP)
+		/* ACK_SENT the right thing? */
+		return conn->proto.sctp.state =3D=3D SCTP_CONNTRACK_SHUTDOWN_ACK_SENT;
+	else
+		return 0;
+}
+
+static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
+		      u_int32_t mask, struct nf_conn *ct)
+{
+	struct nf_conntrack_tuple_hash *found;
+	struct nf_conntrack_tuple tuple;
+	struct xt_connlimit_conn *conn;
+	struct xt_connlimit_conn *tmp;
+	struct nf_conn *found_ct;
+	struct list_head *hash;
+	bool addit =3D true;
+	int matches =3D 0;
+
+	tuple =3D ct->tuplehash[0].tuple;
+	hash  =3D &data->iphash[connlimit_iphash(addr & mask)];
+
+	/* check the saved connections */
+	list_for_each_entry_safe(conn, tmp, hash, list) {
+		found    =3D nf_conntrack_find_get(&conn->tuple, ct);
+		found_ct =3D NULL;
+
+		if (found !=3D NULL)
+			found_ct =3D nf_ct_tuplehash_to_ctrack(found);
+
+		if (found_ct !=3D NULL &&
+		    memcmp(&conn->tuple, &tuple, sizeof(tuple)) =3D=3D 0 &&
+		    !already_closed(found_ct))
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			addit =3D false;
+
+		pr_debug(KERN_WARNING "xt_connlimit [%u]: src=3D%u.%u.%u.%u:%u "
+		         "dst=3D%u.%u.%u.%u:%d %s\n",
+		         connlimit_iphash(addr & mask),
+		         NIPQUAD(conn->tuple.src.u3.ip),
+		         ntohs(conn->tuple.src.u.tcp.port),
+		         NIPQUAD(conn->tuple.dst.u3.ip),
+		         ntohs(conn->tuple.dst.u.tcp.port),
+			 connection_state(found_ct));
+
+		if (found =3D=3D NULL) {
+			/* this one is gone */
+			list_del(&conn->list);
+			kfree(conn);
+			continue;
+		}
+
+		if (already_closed(found_ct)) {
+
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			list_del(&conn->list);
+			kfree(conn);
+			nf_conntrack_put(&found_ct->ct_general);
+			continue;
+		}
+
+		if ((addr & mask) =3D=3D (conn->tuple.src.u3.ip & mask))
+			/* same source network -> be counted! */
+			++matches;
+
+		nf_conntrack_put(&found_ct->ct_general);
+	}
+
+	if (addit) {
+		/* save the new connection in our list */
+#ifdef DEBUG
+		pr_debug(KERN_WARNING "xt_connlimit [%u]: src=3D%u.%u.%u.%u:%u "
+		         "dst=3D%u.%u.%u.%u:%u new\n",
+		         connlimit_iphash(addr & mask),
+		         NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
+		         NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
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
+	enum ip_conntrack_info ctinfo;
+	const struct iphdr *iph;
+	struct nf_conn *ct;
+	int connections;
+
+	ct =3D nf_ct_get(skb, &ctinfo);
+	if (ct =3D=3D NULL) {
+		printk(KERN_INFO "xt_connlimit: INVALID connection\n");
+		*hotdrop =3D true;
+		return false;
+	}
+
+	iph =3D ip_hdr(skb);
+	spin_lock_bh(&info->data->lock);
+	connections =3D count_them(info->data, iph->saddr, info->mask, ct);
+	spin_unlock_bh(&info->data->lock);
+
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		printk(KERN_DEBUG "xt_connlimit: kmalloc failed\n");
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
+	unsigned int i;
+
+	nf_ct_l3proto_module_put(match->family);
+
+	for (i =3D 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
+		list_for_each_entry_safe(conn, tmp,
+		    &info->data->iphash[i], list) {
+			list_del(&conn->list);
+			kfree(conn);
+		}
+	}
+
+	kfree(info->data);
+}
+
+static struct xt_match connlimit_reg =3D {
+	.name       =3D "connlimit",
+	.family     =3D AF_INET,
+	.checkentry =3D connlimit_check,
+	.match      =3D connlimit_match,
+	.matchsize  =3D sizeof(struct xt_connlimit_info),
+	.destroy    =3D connlimit_destroy,
+	.me         =3D THIS_MODULE,
+};
+
+static int __init xt_connlimit_init(void)
+{
+	get_random_bytes(&connlimit_iphash_rnd, sizeof(connlimit_iphash_rnd));
+	return xt_register_match(&connlimit_reg);
+}
+
+static void __exit xt_connlimit_exit(void)
+{
+	xt_unregister_match(&connlimit_reg);
+}
+
+module_init(xt_connlimit_init);
+module_exit(xt_connlimit_exit);
+MODULE_AUTHOR("Jan Engelhardt <jengelh@gmx.de>");
+MODULE_DESCRIPTION("netfilter xt_connlimit match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_connlimit");
---699020219-1846785167-1182769909=:3137--
