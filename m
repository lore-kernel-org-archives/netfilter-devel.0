From: Tim Gardner <timg@tpi.com>
Subject: ipt_connlimit patch for 2.6.0-test5
Date: Mon, 22 Sep 2003 20:03:37 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200309222003.37529.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_1Q9NYJQXXP518FM82547"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_1Q9NYJQXXP518FM82547
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Harald,

Here is a patch to add the connection limit filter from the 2.4 series.

rtg
--=20
Tim Gardner - timg@tpi.com 406-443-5357
TriplePoint, Inc. - http://www.tpi.com
PGP: http://www.tpi.com/PGP/Tim.txt
--------------Boundary-00=_1Q9NYJQXXP518FM82547
Content-Type: text/x-diff;
  charset="us-ascii";
  name="ipt_connlimit.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ipt_connlimit.diff"

diff -r -u --new-file linux-2.6.0-test5.smp/include/linux/netfilter_ipv4/ipt_connlimit.h linux.curr/include/linux/netfilter_ipv4/ipt_connlimit.h
--- linux-2.6.0-test5.smp/include/linux/netfilter_ipv4/ipt_connlimit.h	1969-12-31 17:00:00.000000000 -0700
+++ linux.curr/include/linux/netfilter_ipv4/ipt_connlimit.h	2003-09-22 10:10:52.000000000 -0600
@@ -0,0 +1,12 @@
+#ifndef _IPT_CONNLIMIT_H
+#define _IPT_CONNLIMIT_H
+
+struct ipt_connlimit_data;
+
+struct ipt_connlimit_info {
+	int limit;
+	int inverse;
+	u_int32_t mask;
+	struct ipt_connlimit_data *data;
+};
+#endif /* _IPT_CONNLIMIT_H */
diff -r -u --new-file linux-2.6.0-test5.smp/net/ipv4/netfilter/Kconfig linux.curr/net/ipv4/netfilter/Kconfig
--- linux-2.6.0-test5.smp/net/ipv4/netfilter/Kconfig	2003-09-08 13:50:21.000000000 -0600
+++ linux.curr/net/ipv4/netfilter/Kconfig	2003-09-22 10:17:18.000000000 -0600
@@ -94,6 +94,16 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
 # The simple matches.
+config IP_NF_MATCH_CONNLIMIT
+	tristate "IP connection limit match support"
+	depends on IP_NF_IPTABLES
+	help
+	  This match allows you to restrict the number of parallel TCP
+	  connections to a server per client IP address (or address block).
+
+          If you want to compile it as a module, say M here and read
+          <file:Documentation/modules.txt>.  If unsure, say `N'.
+	
 config IP_NF_MATCH_LIMIT
 	tristate "limit match support"
 	depends on IP_NF_IPTABLES
diff -r -u --new-file linux-2.6.0-test5.smp/net/ipv4/netfilter/Makefile linux.curr/net/ipv4/netfilter/Makefile
--- linux-2.6.0-test5.smp/net/ipv4/netfilter/Makefile	2003-09-08 13:49:57.000000000 -0600
+++ linux.curr/net/ipv4/netfilter/Makefile	2003-09-22 10:19:39.000000000 -0600
@@ -42,6 +42,7 @@
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper.o
 obj-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit.o
+obj-$(CONFIG_IP_NF_MATCH_CONNLIMIT) += ipt_connlimit.o
 obj-$(CONFIG_IP_NF_MATCH_MARK) += ipt_mark.o
 obj-$(CONFIG_IP_NF_MATCH_MAC) += ipt_mac.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
diff -r -u --new-file linux-2.6.0-test5.smp/net/ipv4/netfilter/ipt_connlimit.c linux.curr/net/ipv4/netfilter/ipt_connlimit.c
--- linux-2.6.0-test5.smp/net/ipv4/netfilter/ipt_connlimit.c	1969-12-31 17:00:00.000000000 -0700
+++ linux.curr/net/ipv4/netfilter/ipt_connlimit.c	2003-09-22 10:44:21.000000000 -0600
@@ -0,0 +1,235 @@
+/*
+ * netfilter module to limit the number of parallel tcp
+ * connections per IP address.
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *   Sept 1003: Tim Gardner <timg@tpi.com>
+ *		Ported to 2.6.0-test5
+ *
+ * based on ...
+ *
+ * Kernel module to match connection tracking information.
+ * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/list.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_connlimit.h>
+
+#define DEBUG 0
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
+MODULE_DESCRIPTION("IP connection limit match");
+
+/* we'll save the tuples of all connections we care about */
+struct ipt_connlimit_conn
+{
+        struct list_head list;
+	struct ip_conntrack_tuple tuple;
+};
+
+struct ipt_connlimit_data {
+	spinlock_t lock;
+	struct list_head iphash[256];
+};
+
+static int ipt_iphash(u_int32_t addr)
+{
+	int hash;
+
+	hash  =  addr        & 0xff;
+	hash ^= (addr >>  8) & 0xff;
+	hash ^= (addr >> 16) & 0xff;
+	hash ^= (addr >> 24) & 0xff;
+	return hash;
+}
+
+static int count_them(struct ipt_connlimit_data *data,
+		      u_int32_t addr, u_int32_t mask,
+		      struct ip_conntrack *ct)
+{
+#if DEBUG
+	const static char *tcp[] = { "none", "established", "syn_sent", "syn_recv",
+				     "fin_wait", "time_wait", "close", "close_wait",
+				     "last_ack", "listen" };
+#endif
+	int addit = 1, matches = 0;
+	struct ip_conntrack_tuple tuple;
+	struct ip_conntrack_tuple_hash *found;
+	struct ipt_connlimit_conn *conn;
+	struct list_head *hash,*lh;
+
+	spin_lock(&data->lock);
+	tuple = ct->tuplehash[0].tuple;
+	hash = &data->iphash[ipt_iphash(addr & mask)];
+
+	/* check the saved connections */
+	for (lh = hash->next; lh != hash; lh = lh->next) {
+		conn = list_entry(lh,struct ipt_connlimit_conn,list);
+		found = ip_conntrack_find_get(&conn->tuple,ct);
+		if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
+		    found != NULL &&
+		    found->ctrack->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
+			/* Just to be sure we have it only once in the list.
+			   We should'nt see tuples twice unless someone hooks this
+			   into a table without "-p tcp --syn" */
+			addit = 0;
+		}
+#if DEBUG
+		printk("ipt_connlimit [%d]: src=%u.%u.%u.%u:%d dst=%u.%u.%u.%u:%d %s\n",
+		       ipt_iphash(addr & mask),
+		       NIPQUAD(conn->tuple.src.ip), ntohs(conn->tuple.src.u.tcp.port),
+		       NIPQUAD(conn->tuple.dst.ip), ntohs(conn->tuple.dst.u.tcp.port),
+		       (NULL != found) ? tcp[found->ctrack->proto.tcp.state] : "gone");
+#endif
+		if (NULL == found) {
+			/* this one is gone */
+			lh = lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			continue;
+		}
+		if (found->ctrack->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT) {
+			/* we don't care about connections which are
+			   closed already -> ditch it */
+			lh = lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			nf_conntrack_put(&found->ctrack->infos[0]);
+			continue;
+		}
+		if ((addr & mask) == (conn->tuple.src.ip & mask)) {
+			/* same source IP address -> be counted! */
+			matches++;
+		}
+		nf_conntrack_put(&found->ctrack->infos[0]);
+	}
+	if (addit) {
+		/* save the new connection in our list */
+#if DEBUG
+		printk("ipt_connlimit [%d]: src=%u.%u.%u.%u:%d dst=%u.%u.%u.%u:%d new\n",
+		       ipt_iphash(addr & mask),
+		       NIPQUAD(tuple.src.ip), ntohs(tuple.src.u.tcp.port),
+		       NIPQUAD(tuple.dst.ip), ntohs(tuple.dst.u.tcp.port));
+#endif
+		conn = kmalloc(sizeof(*conn),GFP_ATOMIC);
+		if (NULL == conn)
+			return -1;
+		memset(conn,0,sizeof(*conn));
+		INIT_LIST_HEAD(&conn->list);
+		conn->tuple = tuple;
+		list_add(&conn->list,hash);
+		matches++;
+	}
+	spin_unlock(&data->lock);
+	return matches;
+}
+
+static int
+ipt_connlimit_match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_connlimit_info *info = matchinfo;
+	int connections, match;
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	if (NULL == ct) {
+		printk("ipt_connlimit: Oops: invalid ct state ?\n");
+		*hotdrop = 1;
+		return 0;
+	}
+	connections = count_them(info->data,skb->nh.iph->saddr,info->mask,ct);
+	if (-1 == connections) {
+		printk("ipt_connlimit: Hmm, kmalloc failed :-(\n");
+		*hotdrop = 1; /* let's free some memory :-) */
+		return 0;
+	}
+        match = (info->inverse) ? (connections <= info->limit) : (connections > info->limit);
+#if DEBUG
+	printk("ipt_connlimit: src=%u.%u.%u.%u mask=%u.%u.%u.%u "
+	       "connections=%d limit=%d match=%s\n",
+	       NIPQUAD(skb->nh.iph->saddr), NIPQUAD(info->mask),
+	       connections, info->limit, match ? "yes" : "no");
+#endif
+
+	return match;
+}
+
+static int ipt_connlimit_checkentry(const char *tablename,
+		 const struct ipt_ip *ip,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	struct ipt_connlimit_info *info = matchinfo;
+	int i;
+
+	/* verify size */
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_connlimit_info)))
+		return 0;
+
+	/* refuse anything but tcp */
+	if (ip->proto != IPPROTO_TCP)
+		return 0;
+
+	/* init private data */
+	info->data = kmalloc(sizeof(struct ipt_connlimit_data),GFP_KERNEL);
+	spin_lock_init(&(info->data->lock));
+	for (i = 0; i < 256; i++)
+		INIT_LIST_HEAD(&(info->data->iphash[i]));
+	
+	return 1;
+}
+
+static void ipt_connlimit_destroy(void *matchinfo, unsigned int matchinfosize)
+{
+	struct ipt_connlimit_info *info = matchinfo;
+	struct ipt_connlimit_conn *conn;
+	struct list_head *hash;
+	int i;
+
+	/* cleanup */
+	for (i = 0; i < 256; i++) {
+		hash = &(info->data->iphash[i]);
+		while (hash != hash->next) {
+			conn = list_entry(hash->next,struct ipt_connlimit_conn,list);
+			list_del(hash->next);
+			kfree(conn);
+		}
+	}
+	kfree(info->data);
+}
+
+static struct ipt_match connlimit_match = {
+	.name		= "connlimit",
+	.match		= ipt_connlimit_match,
+	.checkentry	= ipt_connlimit_checkentry,
+	.destroy	= ipt_connlimit_destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	/* NULL if ip_conntrack not a module */
+	return ipt_register_match(&connlimit_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&connlimit_match);
+}
+
+module_init(init);
+module_exit(fini);

--------------Boundary-00=_1Q9NYJQXXP518FM82547--
