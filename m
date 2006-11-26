From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: nf_conntrack: move extern declaration to header
	files
Date: Sun, 26 Nov 2006 15:44:49 +0100 (MET)
Message-ID: <20061126144448.4215.56421.sendpatchset@localhost.localdomain>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: move extern declaration to header files

Using extern in a C file is a bad idea because the compiler can't
catch type errors.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 45df81e6d97daa98b77ef71b2488c167af1f6c80
tree 28d8d6c4da0ede0a6d43a844a8745349a8bdba81
parent b5b8962c41e0f59e1c98ae8b6671c6210517a6a9
author Patrick McHardy <kaber@trash.net> Fri, 24 Nov 2006 19:20:04 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 24 Nov 2006 19:20:04 +0100

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    4 ++++
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |   25 ++++++++++++++++++++++++
 include/net/netfilter/nf_conntrack.h           |    5 +++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 ------
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   18 -----------------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    3 ---
 net/netfilter/nf_conntrack_expect.c            |    1 -
 net/netfilter/nf_conntrack_l3proto_generic.c   |    2 --
 net/netfilter/nf_conntrack_standalone.c        |    3 ---
 9 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 9168443..8c4f7e8 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -37,4 +37,8 @@ #endif
 struct sk_buff *
 nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
new file mode 100644
index 0000000..b4b6049
--- /dev/null
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -0,0 +1,25 @@
+#ifndef _NF_CONNTRACK_IPV6_H
+#define _NF_CONNTRACK_IPV6_H
+
+extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
+
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
+
+extern int nf_ct_ipv6_skip_exthdr(struct sk_buff *skb, int start,
+				  u8 *nexthdrp, int len);
+
+extern int nf_ct_frag6_init(void);
+extern void nf_ct_frag6_cleanup(void);
+extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
+extern void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
+			       struct net_device *in,
+			       struct net_device *out,
+			       int (*okfn)(struct sk_buff *));
+
+extern unsigned int nf_ct_frag6_timeout;
+extern unsigned int nf_ct_frag6_low_thresh;
+extern unsigned int nf_ct_frag6_high_thresh;
+
+#endif /* _NF_CONNTRACK_IPV6_H*/
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9a29505..d0d0e64 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -79,6 +79,8 @@ struct nf_conn_help {
 
 
 #include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
+
 struct nf_conn
 {
 	/* Usage count in here is 1 for hash table/destruct timer, 1 per skb,
@@ -241,7 +243,10 @@ static inline int nf_ct_is_dying(struct 
 
 extern unsigned int nf_conntrack_htable_size;
 extern int nf_conntrack_checksum;
+extern atomic_t nf_conntrack_count;
+extern int nf_conntrack_max;
 
+DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
 /* no helper, no nat */
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 370df0f..d190708 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -38,8 +38,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
-
 static int ipv4_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -429,10 +427,6 @@ #endif
 	.me		 = THIS_MODULE,
 };
 
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
-
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
 MODULE_LICENSE("GPL");
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index cdbba44..9108ecc 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -43,8 +43,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
-
 static int ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			     struct nf_conntrack_tuple *tuple)
 {
@@ -211,11 +209,6 @@ out:
 	return nf_conntrack_confirm(pskb);
 }
 
-extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
-extern void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
-			       struct net_device *in,
-			       struct net_device *out,
-			       int (*okfn)(struct sk_buff *));
 static unsigned int ipv6_defrag(unsigned int hooknum,
 				struct sk_buff **pskb,
 				const struct net_device *in,
@@ -335,11 +328,6 @@ #ifdef CONFIG_SYSCTL
 /* From nf_conntrack_proto_icmpv6.c */
 extern unsigned int nf_ct_icmpv6_timeout;
 
-/* From nf_conntrack_reasm.c */
-extern unsigned int nf_ct_frag6_timeout;
-extern unsigned int nf_ct_frag6_low_thresh;
-extern unsigned int nf_ct_frag6_high_thresh;
-
 static struct ctl_table_header *nf_ct_ipv6_sysctl_header;
 
 static ctl_table nf_ct_sysctl_table[] = {
@@ -458,12 +446,6 @@ #endif
 	.me			= THIS_MODULE,
 };
 
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
-extern int nf_ct_frag6_init(void);
-extern void nf_ct_frag6_cleanup(void);
-
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 2cdf225..b3b468c 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -142,9 +142,6 @@ static int icmpv6_new(struct nf_conn *co
 	return 1;
 }
 
-extern int
-nf_ct_ipv6_skip_exthdr(struct sk_buff *skb, int start, u8 *nexthdrp, int len);
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 static int
 icmpv6_error_message(struct sk_buff *skb,
 		     unsigned int icmp6off,
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 5ef7024..301e22d 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -28,7 +28,6 @@ #include <net/netfilter/nf_conntrack_tup
 
 LIST_HEAD(nf_conntrack_expect_list);
 kmem_cache_t *nf_conntrack_expect_cachep __read_mostly;
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 static unsigned int nf_conntrack_expect_next_id;
 
 /* nf_conntrack_expect helper functions */
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 1852c9d..3124b3a 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -37,8 +37,6 @@ #else
 #define DEBUGP(format, args...)
 #endif
 
-DECLARE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
-
 static int generic_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 				struct nf_conntrack_tuple *tuple)
 {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f87d333..6ab95b0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -44,9 +44,6 @@ #endif
 
 MODULE_LICENSE("GPL");
 
-extern atomic_t nf_conntrack_count;
-DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
-
 #ifdef CONFIG_PROC_FS
 int
 print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
