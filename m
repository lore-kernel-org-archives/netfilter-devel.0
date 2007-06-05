From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: xt_connlimit 20070605
Date: Tue, 5 Jun 2007 14:06:50 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706051405510.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706051315400.20829@yvahk01.tjqt.qr>
	<46654BF8.30406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46654BF8.30406@trash.net>
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


On Jun 5 2007 13:41, Patrick McHardy wrote:
>> 
>> xt_connlimit cleanups as you requested. I hope I did not miss any 
>> either.
>> 
>>     *   2007-06-05: fixed: deadlock after OOM
>> 
>>     *   2007-06-05: UDP support
>
>Seem my previous mail please.




Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/netfilter/xt_connlimit.h |   14 +
 net/netfilter/Kconfig                  |    7 
 net/netfilter/Makefile                 |    1 
 net/netfilter/xt_connlimit.c           |  255 +++++++++++++++++++++++++++++++++
 4 files changed, 277 insertions(+)

Index: linux-2.6.22-rc4/include/linux/netfilter/xt_connlimit.h
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/include/linux/netfilter/xt_connlimit.h
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
+	struct xt_connlimit_data *data;
+};
+
+#endif /* _XT_CONNLIMIT_H */
Index: linux-2.6.22-rc4/net/netfilter/Kconfig
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Kconfig
+++ linux-2.6.22-rc4/net/netfilter/Kconfig
@@ -411,6 +411,13 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
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
Index: linux-2.6.22-rc4/net/netfilter/Makefile
===================================================================
--- linux-2.6.22-rc4.orig/net/netfilter/Makefile
+++ linux-2.6.22-rc4/net/netfilter/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSEC
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) += xt_comment.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNBYTES) += xt_connbytes.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CONNLIMIT) += xt_connlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
Index: linux-2.6.22-rc4/net/netfilter/xt_connlimit.c
===================================================================
--- /dev/null
+++ linux-2.6.22-rc4/net/netfilter/xt_connlimit.c
@@ -0,0 +1,255 @@
+/*
+ * netfilter module to limit the number of parallel tcp
+ * connections per IP address.
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   © Jan Engelhardt <jengelh@gmx.de>, 2007
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
+static inline unsigned int connlimit_iphash(u_int32_t addr)
+{
+	return (addr ^ (addr >> 8) ^ (addr >> 16) ^ (addr >> 24)) & 0xff;
+}
+
+static int count_them(struct xt_connlimit_data *data, u_int32_t addr,
+		      u_int32_t mask, struct nf_conn *ct)
+{
+#if DEBUG
+	static const char const *tcp_state[] = {
+		"none", "established", "syn_sent", "syn_recv", "fin_wait",
+		"time_wait", "close", "close_wait", "last_ack", "listen"
+	};
+#endif
+	struct nf_conntrack_tuple_hash *found;
+	struct nf_conntrack_tuple tuple;
+	struct xt_connlimit_conn *conn;
+	const struct list_head *lh;
+	struct nf_conn *found_ct;
+	struct list_head *hash;
+	bool addit = true;
+	int matches = 0;
+
+	tuple = ct->tuplehash[0].tuple;
+	hash  = &data->iphash[connlimit_iphash(addr & mask)];
+
+	/* check the saved connections */
+	for (lh = hash->next; lh != hash; lh = lh->next) {
+		conn     = list_entry(lh, struct xt_connlimit_conn, list);
+		found    = nf_conntrack_find_get(&conn->tuple, ct);
+		found_ct = NULL;
+
+		if (found != NULL &&
+		    (found_ct = nf_ct_tuplehash_to_ctrack(found)) != NULL &&
+		    memcmp(&conn->tuple, &tuple, sizeof(tuple)) == 0 &&
+		    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT)
+			/*
+			 * Just to be sure we have it only once in the list.
+			 * We should not see tuples twice unless someone hooks
+			 * this into a table without "-p tcp --syn".
+			 */
+			addit = false;
+
+#if DEBUG
+		printk(KERN_WARNING "xt_connlimit [%u]: src=%u.%u.%u.%u:%u "
+		       "dst=%u.%u.%u.%u:%d %s\n",
+		       connlimit_iphash(addr & mask),
+		       NIPQUAD(conn->tuple.src.u3.ip),
+		       ntohs(conn->tuple.src.u.tcp.port),
+		       NIPQUAD(conn->tuple.dst.u3.ip),
+		       ntohs(conn->tuple.dst.u.tcp.port),
+		       (found == NULL) ? "gone" :
+				tcp_state[found_ct->proto.tcp.state]);
+#endif
+
+		if (found == NULL) {
+			/* this one is gone */
+			lh = lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			continue;
+		}
+
+		if (found_ct->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
+			/*
+			 * we do not care about connections which are
+			 * closed already -> ditch it
+			 */
+			lh = lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			nf_conntrack_put(&found_ct->ct_general);
+			continue;
+		}
+
+		if ((addr & mask) == (conn->tuple.src.u3.ip & mask))
+			/* same source network -> be counted! */
+			++matches;
+
+		nf_conntrack_put(&found_ct->ct_general);
+	}
+
+	if (addit) {
+		/* save the new connection in our list */
+#if DEBUG
+		printk(KERN_WARNING "xt_connlimit [%u]: src=%u.%u.%u.%u:%u "
+		       "dst=%u.%u.%u.%u:%u new\n",
+		       connlimit_iphash(addr & mask),
+		       NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
+		       NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
+#endif
+
+		conn = kzalloc(sizeof(*conn), GFP_ATOMIC);
+		if (conn == NULL)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&conn->list);
+		conn->tuple = tuple;
+		list_add(&conn->list, hash);
+		++matches;
+	}
+
+	return matches;
+}
+
+static bool xt_connlimit_match(const struct sk_buff *skb,
+			       const struct net_device *in,
+			       const struct net_device *out,
+			       const struct xt_match *match,
+			       const void *matchinfo, int offset,
+			       unsigned int protoff, bool *hotdrop)
+{
+	const struct xt_connlimit_info *info = matchinfo;
+	enum ip_conntrack_info ctinfo;
+	const struct iphdr *iph;
+	int connections, rv;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL) {
+		printk(KERN_INFO "xt_connlimit: INVALID connection\n");
+		*hotdrop = 1;
+		return false;
+	}
+
+	iph = ip_hdr(skb);
+	spin_lock_bh(&info->data->lock);
+	connections = count_them(info->data, iph->saddr, info->mask, ct);
+	spin_unlock_bh(&info->data->lock);
+
+	if (connections < 0) {
+		/* kmalloc failed, drop it entirely */
+		printk(KERN_DEBUG "xt_connlimit: kmalloc failed\n");
+		*hotdrop = 1;
+		return false;
+	}
+
+	rv = info->inverse ^ (connections > info->limit);
+#if DEBUG
+	printk(KERN_DEBUG "xt_connlimit: src=%u.%u.%u.%u mask=%u.%u.%u.%u "
+	       "connections=%d limit=%u match=%s\n",
+	       NIPQUAD(iph->saddr), NIPQUAD(info->mask),
+	       connections, info->limit, match ? "yes" : "no");
+#endif
+
+	return rv;
+}
+
+static bool xt_connlimit_check(const char *tablename, const void *ip,
+			       const struct xt_match *match, void *matchinfo,
+			       unsigned int hook_mask)
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
+	spin_lock_init(&info->data->lock);
+	for (i = 0; i < 256; ++i)
+		INIT_LIST_HEAD(&info->data->iphash[i]);
+
+	return true;
+}
+
+static void xt_connlimit_destroy(const struct xt_match *match, void *matchinfo)
+{
+	struct xt_connlimit_info *info = matchinfo;
+	struct xt_connlimit_conn *conn;
+	struct list_head *hash;
+	unsigned int i;
+
+	nf_ct_l3proto_module_put(match->family);
+
+	for (i = 0; i < 256; ++i) {
+		hash = &info->data->iphash[i];
+		while (hash != hash->next) {
+			conn = list_entry(hash->next,
+			       struct xt_connlimit_conn, list);
+			list_del(hash->next);
+			kfree(conn);
+		}
+	}
+
+	kfree(info->data);
+}
+
+static struct xt_match xt_connlimit_reg = {
+	.name       = "connlimit",
+	.family     = AF_INET,
+	.checkentry = xt_connlimit_check,
+	.match      = xt_connlimit_match,
+	.matchsize  = sizeof(struct xt_connlimit_info),
+	.destroy    = xt_connlimit_destroy,
+	.me         = THIS_MODULE,
+};
+
+static int __init xt_connlimit_init(void)
+{
+	return xt_register_match(&xt_connlimit_reg);
+}
+
+static void __exit xt_connlimit_exit(void)
+{
+	xt_unregister_match(&xt_connlimit_reg);
+}
+
+module_init(xt_connlimit_init);
+module_exit(xt_connlimit_exit);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_connlimit");
