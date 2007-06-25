From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Mon, 25 Jun 2007 14:19:10 +0200
Message-ID: <467FB2BE.6080509@trash.net>
References: <466FB176.7040306@netfilter.org>	<twig.1181752139.4605@bugmachine.ca>
	<467020F6.2050906@trash.net>	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>	<46713EE8.6060906@trash.net>	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>	<46714F7D.4010309@trash.net>	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>	<467BDA90.7090802@trash.net>	<Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
	<467E844C.6030600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070805010704020009040105"
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467E844C.6030600@trash.net>
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

This is a multi-part message in MIME format.
--------------070805010704020009040105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Thanks Jozsef, applied. I've also added the missing ip6t_TRACE alias
> to xt_TRACE.c.
>   

And missing copying of the nf_trace bit.

This is really cool:

RACE: raw:PREROUTING:policy:2 IN=eth0 OUT= 
MAC=00:15:f2:24:91:f8:00:0d:60:ca:60:12:08:00 SRC=192.168.0.102 
DST=192.168.0.100 LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=47932 DF PROTO=TCP 
SPT=58555 DPT=12345 SEQ=3478324482 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 
OPT (020405B40402080A0C78BE3E0000000001030305)
TRACE: filter:INPUT:rule:1 IN=eth0 OUT= 
MAC=00:15:f2:24:91:f8:00:0d:60:ca:60:12:08:00 SRC=192.168.0.102 
DST=192.168.0.100 LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=47932 DF PROTO=TCP 
SPT=58555 DPT=12345 SEQ=3478324482 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 
OPT (020405B40402080A0C78BE3E0000000001030305)
TRACE: filter:INPUT:rule:2 IN=eth0 OUT= 
MAC=00:15:f2:24:91:f8:00:0d:60:ca:60:12:08:00 SRC=192.168.0.102 
DST=192.168.0.100 LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=47932 DF PROTO=TCP 
SPT=58555 DPT=12345 SEQ=3478324482 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 
OPT (020405B40402080A0C78BE3E0000000001030305)

:)


--------------070805010704020009040105
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: x_tables: add TRACE target

The TRACE target can be used to follow IP and IPv6 packets through
the ruleset.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick NcHardy <kaber@trash.net>

---
commit b8a85c673f041bd0acc1346150512eab5aa93b08
tree 62240ddb32f7a480a34b78b7e0deb09d84f88489
parent 69c897e7476fb6aa1adae6a57863e2c2eb278588
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Mon, 25 Jun 2007 14:17:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 25 Jun 2007 14:17:16 +0200

 include/linux/skbuff.h          |    4 +
 net/core/skbuff.c               |    8 ++
 net/ipv4/ip_output.c            |    4 +
 net/ipv4/netfilter/ip_tables.c  |  127 +++++++++++++++++++++++++++++++++++----
 net/ipv6/ip6_output.c           |    4 +
 net/ipv6/netfilter/ip6_tables.c |  128 +++++++++++++++++++++++++++++++++++----
 net/netfilter/Kconfig           |   12 ++++
 net/netfilter/Makefile          |    1 
 net/netfilter/xt_TRACE.c        |   53 ++++++++++++++++
 9 files changed, 314 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6f0b2f7..52bba8c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -227,6 +227,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@mark: Generic packet mark
  *	@nfct: Associated connection, if any
  *	@ipvs_property: skbuff is owned by ipvs
+ *	@nf_trace: netfilter packet trace flag
  *	@nfctinfo: Relationship of this skb to the connection
  *	@nfct_reasm: netfilter conntrack re-assembly pointer
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
@@ -277,7 +278,8 @@ struct sk_buff {
 				nfctinfo:3;
 	__u8			pkt_type:3,
 				fclone:2,
-				ipvs_property:1;
+				ipvs_property:1,
+				nf_trace:1;
 	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 27cfe5f..d2878a3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -426,6 +426,10 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 	n->destructor = NULL;
 	C(mark);
 	__nf_copy(n, skb);
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+	C(nf_trace);
+#endif
 #ifdef CONFIG_NET_SCHED
 	C(tc_index);
 #ifdef CONFIG_NET_CLS_ACT
@@ -482,6 +486,10 @@ static void copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	new->destructor = NULL;
 	new->mark	= old->mark;
 	__nf_copy(new, old);
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+	new->nf_trace	= old->nf_trace;
+#endif
 #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
 	new->ipvs_property = old->ipvs_property;
 #endif
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 34ea454..7ea6144 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -399,6 +399,10 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->tc_index = from->tc_index;
 #endif
 	nf_copy(to, from);
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+	to->nf_trace = from->nf_trace;
+#endif
 #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
 	to->ipvs_property = from->ipvs_property;
 #endif
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7962306..cdfdf88 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -204,6 +204,112 @@ get_entry(void *base, unsigned int offset)
 	return (struct ipt_entry *)(base + offset);
 }
 
+/* All zeroes == unconditional rule. */
+static inline int
+unconditional(const struct ipt_ip *ip)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(*ip)/sizeof(__u32); i++)
+		if (((__u32 *)ip)[i])
+			return 0;
+
+	return 1;
+}
+
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+static const char *hooknames[] = {
+	[NF_IP_PRE_ROUTING] = "PREROUTING",
+	[NF_IP_LOCAL_IN] = "INPUT",
+	[NF_IP_FORWARD] = "FORWARD",
+	[NF_IP_LOCAL_OUT] = "OUTPUT",
+	[NF_IP_POST_ROUTING] = "POSTROUTING",
+};
+
+enum nf_ip_trace_comments {
+	NF_IP_TRACE_COMMENT_RULE,
+	NF_IP_TRACE_COMMENT_RETURN,
+	NF_IP_TRACE_COMMENT_POLICY,
+};
+
+static const char *comments[] = {
+	[NF_IP_TRACE_COMMENT_RULE] = "rule",
+	[NF_IP_TRACE_COMMENT_RETURN] = "return",
+	[NF_IP_TRACE_COMMENT_POLICY] = "policy",
+};
+
+static struct nf_loginfo trace_loginfo = {
+	.type = NF_LOG_TYPE_LOG,
+	.u = {
+		.log = {
+			.level = 4,
+			.logflags = NF_LOG_MASK,
+		},
+	},
+};
+
+static inline int
+get_chainname_rulenum(struct ipt_entry *s, struct ipt_entry *e,
+		      char *hookname, char **chainname,
+		      char **comment, unsigned int *rulenum)
+{
+	struct ipt_standard_target *t = (void *)ipt_get_target(s);
+
+	if (strcmp(t->target.u.kernel.target->name, IPT_ERROR_TARGET) == 0) {
+		/* Head of user chain: ERROR target with chainname */
+		*chainname = t->target.data;
+		(*rulenum) = 0;
+	} else if (s == e) {
+		(*rulenum)++;
+
+		if (s->target_offset == sizeof(struct ipt_entry)
+		   && strcmp(t->target.u.kernel.target->name,
+		   	     IPT_STANDARD_TARGET) == 0
+		   && t->verdict < 0
+	           && unconditional(&s->ip)) {
+	           	/* Tail of chains: STANDARD target (return/policy) */
+	           	*comment = *chainname == hookname
+	           		? (char *)comments[NF_IP_TRACE_COMMENT_POLICY]
+	           		: (char *)comments[NF_IP_TRACE_COMMENT_RETURN];
+		}
+		return 1;
+	} else
+		(*rulenum)++;
+
+	return 0;
+}
+
+static void trace_packet(struct sk_buff *skb,
+			 unsigned int hook,
+			 const struct net_device *in,
+			 const struct net_device *out,
+			 char *tablename,
+			 struct xt_table_info *private,
+			 struct ipt_entry *e)
+{
+	void *table_base;
+	struct ipt_entry *root;
+	char *hookname, *chainname, *comment;
+	unsigned int rulenum = 0;
+
+	table_base = (void *)private->entries[smp_processor_id()];
+	root = get_entry(table_base, private->hook_entry[hook]);
+
+	hookname = chainname = (char *)hooknames[hook];
+	comment = (char *)comments[NF_IP_TRACE_COMMENT_RULE];
+
+	IPT_ENTRY_ITERATE(root,
+			  private->size - private->hook_entry[hook],
+			  get_chainname_rulenum,
+			  e, hookname, &chainname, &comment, &rulenum);
+
+	nf_log_packet(AF_INET, hook, skb, in, out, &trace_loginfo,
+		      "TRACE: %s:%s:%s:%u ",
+		      tablename, chainname, comment, rulenum);
+}
+#endif
+
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
 ipt_do_table(struct sk_buff **pskb,
@@ -261,6 +367,14 @@ ipt_do_table(struct sk_buff **pskb,
 
 			t = ipt_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
+
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+			/* The packet is traced: log it */
+			if (unlikely((*pskb)->nf_trace))
+				trace_packet(*pskb, hook, in, out,
+					     table->name, private, e);
+#endif
 			/* Standard target? */
 			if (!t->u.kernel.target->target) {
 				int v;
@@ -341,19 +455,6 @@ ipt_do_table(struct sk_buff **pskb,
 #endif
 }
 
-/* All zeroes == unconditional rule. */
-static inline int
-unconditional(const struct ipt_ip *ip)
-{
-	unsigned int i;
-
-	for (i = 0; i < sizeof(*ip)/sizeof(__u32); i++)
-		if (((__u32 *)ip)[i])
-			return 0;
-
-	return 1;
-}
-
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4704b5f..db47321 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -521,6 +521,10 @@ static void ip6_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->tc_index = from->tc_index;
 #endif
 	nf_copy(to, from);
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+	to->nf_trace = from->nf_trace;
+#endif
 	skb_copy_secmark(to, from);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7fe4d29..a67cec8 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -241,6 +241,113 @@ get_entry(void *base, unsigned int offset)
 	return (struct ip6t_entry *)(base + offset);
 }
 
+/* All zeroes == unconditional rule. */
+static inline int
+unconditional(const struct ip6t_ip6 *ipv6)
+{
+	unsigned int i;
+
+	for (i = 0; i < sizeof(*ipv6); i++)
+		if (((char *)ipv6)[i])
+			break;
+
+	return (i == sizeof(*ipv6));
+}
+
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+/* This cries for unification! */
+static const char *hooknames[] = {
+	[NF_IP6_PRE_ROUTING] = "PREROUTING",
+	[NF_IP6_LOCAL_IN] = "INPUT",
+	[NF_IP6_FORWARD] = "FORWARD",
+	[NF_IP6_LOCAL_OUT] = "OUTPUT",
+	[NF_IP6_POST_ROUTING] = "POSTROUTING",
+};
+
+enum nf_ip_trace_comments {
+	NF_IP6_TRACE_COMMENT_RULE,
+	NF_IP6_TRACE_COMMENT_RETURN,
+	NF_IP6_TRACE_COMMENT_POLICY,
+};
+
+static const char *comments[] = {
+	[NF_IP6_TRACE_COMMENT_RULE] = "rule",
+	[NF_IP6_TRACE_COMMENT_RETURN] = "return",
+	[NF_IP6_TRACE_COMMENT_POLICY] = "policy",
+};
+
+static struct nf_loginfo trace_loginfo = {
+	.type = NF_LOG_TYPE_LOG,
+	.u = {
+		.log = {
+			.level = 4,
+			.logflags = NF_LOG_MASK,
+		},
+	},
+};
+
+static inline int
+get_chainname_rulenum(struct ip6t_entry *s, struct ip6t_entry *e,
+		      char *hookname, char **chainname,
+		      char **comment, unsigned int *rulenum)
+{
+	struct ip6t_standard_target *t = (void *)ip6t_get_target(s);
+
+	if (strcmp(t->target.u.kernel.target->name, IP6T_ERROR_TARGET) == 0) {
+		/* Head of user chain: ERROR target with chainname */
+		*chainname = t->target.data;
+		(*rulenum) = 0;
+	} else if (s == e) {
+		(*rulenum)++;
+
+		if (s->target_offset == sizeof(struct ip6t_entry)
+		   && strcmp(t->target.u.kernel.target->name, 
+		   	     IP6T_STANDARD_TARGET) == 0
+		   && t->verdict < 0
+	           && unconditional(&s->ipv6)) {
+	           	/* Tail of chains: STANDARD target (return/policy) */
+	           	*comment = *chainname == hookname 
+	           		? (char *)comments[NF_IP6_TRACE_COMMENT_POLICY]
+	           		: (char *)comments[NF_IP6_TRACE_COMMENT_RETURN];
+		}
+		return 1;
+	} else
+		(*rulenum)++;
+
+	return 0;
+}
+
+static void trace_packet(struct sk_buff *skb,
+			 unsigned int hook,
+			 const struct net_device *in,
+			 const struct net_device *out,
+			 char *tablename,
+			 struct xt_table_info *private,
+			 struct ip6t_entry *e)
+{
+	void *table_base;
+	struct ip6t_entry *root;
+	char *hookname, *chainname, *comment;
+	unsigned int rulenum = 0;
+
+	table_base = (void *)private->entries[smp_processor_id()];
+	root = get_entry(table_base, private->hook_entry[hook]);
+
+	hookname = chainname = (char *)hooknames[hook];
+	comment = (char *)comments[NF_IP6_TRACE_COMMENT_RULE];
+
+	IP6T_ENTRY_ITERATE(root,
+			   private->size - private->hook_entry[hook],
+			   get_chainname_rulenum,
+			   e, hookname, &chainname, &comment, &rulenum);
+
+	nf_log_packet(AF_INET6, hook, skb, in, out, &trace_loginfo,
+		      "TRACE: %s:%s:%s:%u ",
+		      tablename, chainname, comment, rulenum);
+}
+#endif
+
 /* Returns one of the generic firewall policies, like NF_ACCEPT. */
 unsigned int
 ip6t_do_table(struct sk_buff **pskb,
@@ -298,6 +405,14 @@ ip6t_do_table(struct sk_buff **pskb,
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
+
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+			/* The packet is traced: log it */
+			if (unlikely((*pskb)->nf_trace))
+				trace_packet(*pskb, hook, in, out,
+					     table->name, private, e);
+#endif
 			/* Standard target? */
 			if (!t->u.kernel.target->target) {
 				int v;
@@ -377,19 +492,6 @@ ip6t_do_table(struct sk_buff **pskb,
 #endif
 }
 
-/* All zeroes == unconditional rule. */
-static inline int
-unconditional(const struct ip6t_ip6 *ipv6)
-{
-	unsigned int i;
-
-	for (i = 0; i < sizeof(*ipv6); i++)
-		if (((char *)ipv6)[i])
-			break;
-
-	return (i == sizeof(*ipv6));
-}
-
 /* Figures out from what hook each rule can be called: returns 0 if
    there are loops.  Puts hook bitmask in comefrom. */
 static int
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index aa567fa..df5e8da 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -343,6 +343,18 @@ config NETFILTER_XT_TARGET_NOTRACK
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_TRACE
+	tristate  '"TRACE" target support'
+	depends on NETFILTER_XTABLES
+	depends on IP_NF_RAW || IP6_NF_RAW
+	help
+	  The TRACE target allows you to mark packets so that the kernel
+	  will log every rule which match the packets as those traverse
+	  the tables, chains, rules.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
 	depends on NETFILTER_XTABLES && NETWORK_SECMARK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3cf5b9c..3b79268 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) += xt_MARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
new file mode 100644
index 0000000..b82fc46
--- /dev/null
+++ b/net/netfilter/xt_TRACE.c
@@ -0,0 +1,53 @@
+/* This is a module which is used to mark packets for tracing.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_TRACE");
+MODULE_ALIAS("ip6t_TRACE");
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo)
+{
+	(*pskb)->nf_trace = 1;
+	return XT_CONTINUE;
+}
+
+static struct xt_target xt_trace_target[] = {
+	{
+		.name		= "TRACE",
+		.family		= AF_INET,
+		.target		= target,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TRACE",
+		.family		= AF_INET6,
+		.target		= target,
+		.table		= "raw",
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init xt_trace_init(void)
+{
+	return xt_register_targets(xt_trace_target,
+				   ARRAY_SIZE(xt_trace_target));
+}
+
+static void __exit xt_trace_fini(void)
+{
+	xt_unregister_targets(xt_trace_target, ARRAY_SIZE(xt_trace_target));
+}
+
+module_init(xt_trace_init);
+module_exit(xt_trace_fini);

--------------070805010704020009040105--
