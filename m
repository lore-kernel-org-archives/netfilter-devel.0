From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/08]: x_tables: add connlimit match
Date: Sat, 14 Jul 2007 17:12:42 +0200 (MEST)
Message-ID: <20070714151158.9829.19623.sendpatchset@localhost.localdomain>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add connlimit match

ipt_connlimit has been sitting in POM-NG for a long time.
Here is a new shiny xt_connlimit with:

 * xtables'ified
 * will request the layer3 module
   (previously it hotdropped every packet when it was not loaded)
 * fixed: there was a deadlock in case of an OOM condition
 * support for any layer4 protocol (e.g. UDP/SCTP)
 * using jhash, as suggested by Eric Dumazet
 * ipv6 support

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ce0ae6ad80f3673eaaa2fb1cab9771939c7e84c6
tree 4078537dc92a3d24c9e42f9b4651c72fc4079fa6
parent f1cdf0338ecef77b6c1999ae177b4fd21134e625
author Jan Engelhardt <jengelh@gmx.de> Sat, 14 Jul 2007 17:02:26 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:05:25 +0200

 include/linux/netfilter/xt_connlimit.h |   17 ++
 net/netfilter/Kconfig                  |    7 +
 net/netfilter/Makefile                 |    1 
 net/netfilter/xt_connlimit.c           |  313 ++++++++++++++++++++++++++++++++
 4 files changed, 338 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
new file mode 100644
index 0000000..90ae8b4
--- /dev/null
+++ b/include/linux/netfilter/xt_connlimit.h
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df5e8da..9415b9a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -423,6 +423,13 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
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
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 58b4245..3e4a16a 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
new file mode 100644
index 0000000..fba803f
--- /dev/null
+++ b/net/netfilter/xt_connlimit.c
@@ -0,0 +1,313 @@
+/*
+ * netfilter module to limit the number of parallel tcp
+ * connections per IP address.
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   Copyright © Jan Engelhardt <jengelh@gmx.de>, 2007
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
+		connlimit_rnd_inited = true;
+	}
+	return jhash_1word(addr, connlimit_rnd) & 0xFF;
+}
+
+static inline unsigned int
+connlimit_iphash6(const union nf_conntrack_address *addr,
+		  const union nf_conntrack_address *mask)
+{
+	union nf_conntrack_address res;
+	unsigned int i;
+
+	if (unlikely(!connlimit_rnd_inited)) {
+		get_random_bytes(&connlimit_rnd, sizeof(connlimit_rnd));
+		connlimit_rnd_inited = true;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i)
+		res.ip6[i] = addr->ip6[i] & mask->ip6[i];
+
+	return jhash2(res.ip6, ARRAY_SIZE(res.ip6), connlimit_rnd) & 0xFF;
+}
+
+static inline bool already_closed(const struct nf_conn *conn)
+{
+	u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
+
+	if (proto == IPPROTO_TCP)
+		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
+	else
+		return 0;
+}
+
+static inline unsigned int
+same_source_net(const union nf_conntrack_address *addr,
+		const union nf_conntrack_address *mask,
+		const union nf_conntrack_address *u3, unsigned int family)
+{
+	if (family == AF_INET) {
+		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
+	} else {
+		union nf_conntrack_address lh, rh;
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i) {
+			lh.ip6[i] = addr->ip6[i] & mask->ip6[i];
+			rh.ip6[i] = u3->ip6[i] & mask->ip6[i];
+		}
+
+		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6)) == 0;
+	}
+}
+
+static int count_them(struct xt_connlimit_data *data,
+		      const struct nf_conntrack_tuple *tuple,
+		      const union nf_conntrack_address *addr,
+		      const union nf_conntrack_address *mask,
+		      const struct xt_match *match)
+{
+	struct nf_conntrack_tuple_hash *found;
+	struct xt_connlimit_conn *conn;
+	struct xt_connlimit_conn *tmp;
+	struct nf_conn *found_ct;
+	struct list_head *hash;
+	bool addit = true;
+	int matches = 0;
+
+
+	if (match->family == AF_INET6)
+		hash = &data->iphash[connlimit_iphash6(addr, mask)];
+	else
+		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
+
+	read_lock_bh(&nf_conntrack_lock);
+
+	/* check the saved connections */
+	list_for_each_entry_safe(conn, tmp, hash, list) {
+		found    = __nf_conntrack_find(&conn->tuple, NULL);
+		found_ct = NULL;
+
+		if (found != NULL)
+			found_ct = nf_ct_tuplehash_to_ctrack(found);
+
+		if (found_ct != NULL &&
+		    nf_ct_tuple_equal(&conn->tuple, tuple) &&
+		    !already_closed(found_ct))
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			addit = false;
+
+		if (found == NULL) {
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
+		conn = kzalloc(sizeof(*conn), GFP_ATOMIC);
+		if (conn == NULL)
+			return -ENOMEM;
+		conn->tuple = *tuple;
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
+	const struct xt_connlimit_info *info = matchinfo;
+	union nf_conntrack_address addr, mask;
+	struct nf_conntrack_tuple tuple;
+	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
+	enum ip_conntrack_info ctinfo;
+	const struct nf_conn *ct;
+	int connections;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct != NULL)
+		tuple_ptr = &ct->tuplehash[0].tuple;
+	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+				    match->family, &tuple))
+		goto hotdrop;
+
+	if (match->family == AF_INET6) {
+		const struct ipv6hdr *iph = ipv6_hdr(skb);
+		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
+		memcpy(&mask.ip6, info->v6_mask, sizeof(info->v6_mask));
+	} else {
+		const struct iphdr *iph = ip_hdr(skb);
+		addr.ip = iph->saddr;
+		mask.ip = info->v4_mask;
+	}
+
+	spin_lock_bh(&info->data->lock);
+	connections = count_them(info->data, tuple_ptr, &addr, &mask, match);
+	spin_unlock_bh(&info->data->lock);
+
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		*hotdrop = true;
+		return false;
+	}
+
+	return (connections > info->limit) ^ info->inverse;
+
+ hotdrop:
+	*hotdrop = true;
+	return false;
+}
+
+static bool connlimit_check(const char *tablename, const void *ip,
+			    const struct xt_match *match, void *matchinfo,
+			    unsigned int hook_mask)
+{
+	struct xt_connlimit_info *info = matchinfo;
+	unsigned int i;
+
+	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+		printk(KERN_WARNING "cannot load conntrack support for "
+		       "address family %u\n", match->family);
+		return false;
+	}
+
+	/* init private data */
+	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
+	if (info->data == NULL) {
+		nf_ct_l3proto_module_put(match->family);
+		return false;
+	}
+
+	spin_lock_init(&info->data->lock);
+	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
+		INIT_LIST_HEAD(&info->data->iphash[i]);
+
+	return true;
+}
+
+static void connlimit_destroy(const struct xt_match *match, void *matchinfo)
+{
+	struct xt_connlimit_info *info = matchinfo;
+	struct xt_connlimit_conn *conn;
+	struct xt_connlimit_conn *tmp;
+	struct list_head *hash = info->data->iphash;
+	unsigned int i;
+
+	nf_ct_l3proto_module_put(match->family);
+
+	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i) {
+		list_for_each_entry_safe(conn, tmp, &hash[i], list) {
+			list_del(&conn->list);
+			kfree(conn);
+		}
+	}
+
+	kfree(info->data);
+}
+
+static struct xt_match connlimit_reg[] __read_mostly = {
+	{
+		.name       = "connlimit",
+		.family     = AF_INET,
+		.checkentry = connlimit_check,
+		.match      = connlimit_match,
+		.matchsize  = sizeof(struct xt_connlimit_info),
+		.destroy    = connlimit_destroy,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "connlimit",
+		.family     = AF_INET6,
+		.checkentry = connlimit_check,
+		.match      = connlimit_match,
+		.matchsize  = sizeof(struct xt_connlimit_info),
+		.destroy    = connlimit_destroy,
+		.me         = THIS_MODULE,
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
