From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/09]: Clean up table initialization
Date: Thu, 10 May 2007 15:41:11 +0200 (MEST)
Message-ID: <20070510134028.8559.53451.sendpatchset@localhost.localdomain>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Clean up table initialization

- move arp_tables initial table structure definitions to arp_tables.h
  similar to ip_tables and ip6_tables

- use C99 initializers

- use initializer macros where possible

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit acf2e14c5f3ff9b9ad1500c135a8d9be98d66436
tree c3d814e7e64652f2ec2541e174b9a210ac1f2459
parent a989705c4cf6e6c1a339c95f9daf658b4ba88ca8
author Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:17 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:17 +0200

 include/linux/netfilter/x_tables.h        |    8 ++
 include/linux/netfilter_arp/arp_tables.h  |   41 ++++++++
 include/linux/netfilter_ipv4/ip_tables.h  |   22 +++++
 include/linux/netfilter_ipv6/ip6_tables.h |   22 +++++
 net/ipv4/netfilter/arptable_filter.c      |  140 +++++------------------------
 net/ipv4/netfilter/iptable_filter.c       |   70 +++++----------
 net/ipv4/netfilter/iptable_mangle.c       |   96 ++++++--------------
 net/ipv4/netfilter/iptable_raw.c          |   58 +-----------
 net/ipv4/netfilter/nf_nat_rule.c          |   73 ++-------------
 net/ipv6/netfilter/ip6table_filter.c      |   70 +++++----------
 net/ipv6/netfilter/ip6table_mangle.c      |   96 ++++++--------------
 net/ipv6/netfilter/ip6table_raw.c         |   52 +----------
 12 files changed, 238 insertions(+), 510 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 022edfa..7e733a6 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -54,6 +54,14 @@ struct xt_entry_target
 	unsigned char data[0];
 };
 
+#define XT_TARGET_INIT(__name, __size)					       \
+{									       \
+	.target.u.user = {						       \
+		.target_size	= XT_ALIGN(__size),			       \
+		.name		= __name,				       \
+	},								       \
+}
+
 struct xt_standard_target
 {
 	struct xt_entry_target target;
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 24c8786..584cd1b 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -238,6 +238,47 @@ static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e
  */
 #ifdef __KERNEL__
 
+/* Standard entry. */
+struct arpt_standard
+{
+	struct arpt_entry entry;
+	struct arpt_standard_target target;
+};
+
+struct arpt_error_target
+{
+	struct arpt_entry_target target;
+	char errorname[ARPT_FUNCTION_MAXNAMELEN];
+};
+
+struct arpt_error
+{
+	struct arpt_entry entry;
+	struct arpt_error_target target;
+};
+
+#define ARPT_ENTRY_INIT(__size)						       \
+{									       \
+	.target_offset	= sizeof(struct arpt_entry),			       \
+	.next_offset	= (__size),					       \
+}
+
+#define ARPT_STANDARD_INIT(__verdict)					       \
+{									       \
+	.entry		= ARPT_ENTRY_INIT(sizeof(struct arpt_standard)),       \
+	.target		= XT_TARGET_INIT(ARPT_STANDARD_TARGET,		       \
+					 sizeof(struct arpt_standard_target)), \
+	.target.verdict	= -(__verdict) - 1,				       \
+}
+
+#define ARPT_ERROR_INIT							       \
+{									       \
+	.entry		= ARPT_ENTRY_INIT(sizeof(struct arpt_error)),	       \
+	.target		= XT_TARGET_INIT(ARPT_ERROR_TARGET,		       \
+					 sizeof(struct arpt_error_target)),    \
+	.target.errorname = "ERROR",					       \
+}
+
 #define arpt_register_target(tgt) 	\
 ({	(tgt)->family = NF_ARP;		\
  	xt_register_target(tgt); })
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 9527296..2f46dd7 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -295,6 +295,28 @@ struct ipt_error
 	struct ipt_error_target target;
 };
 
+#define IPT_ENTRY_INIT(__size)						       \
+{									       \
+	.target_offset	= sizeof(struct ipt_entry),			       \
+	.next_offset	= (__size),					       \
+}
+
+#define IPT_STANDARD_INIT(__verdict)					       \
+{									       \
+	.entry		= IPT_ENTRY_INIT(sizeof(struct ipt_standard)),	       \
+	.target		= XT_TARGET_INIT(IPT_STANDARD_TARGET,		       \
+					 sizeof(struct xt_standard_target)),   \
+	.target.verdict	= -(__verdict) - 1,				       \
+}
+
+#define IPT_ERROR_INIT							       \
+{									       \
+	.entry		= IPT_ENTRY_INIT(sizeof(struct ipt_error)),	       \
+	.target		= XT_TARGET_INIT(IPT_ERROR_TARGET,		       \
+					 sizeof(struct ipt_error_target)),     \
+	.target.errorname = "ERROR",					       \
+}
+
 extern unsigned int ipt_do_table(struct sk_buff **pskb,
 				 unsigned int hook,
 				 const struct net_device *in,
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 61aa104..4686f83 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -123,6 +123,28 @@ struct ip6t_error
 	struct ip6t_error_target target;
 };
 
+#define IP6T_ENTRY_INIT(__size)						       \
+{									       \
+	.target_offset	= sizeof(struct ip6t_entry),			       \
+	.next_offset	= (__size),					       \
+}
+
+#define IP6T_STANDARD_INIT(__verdict)					       \
+{									       \
+	.entry		= IP6T_ENTRY_INIT(sizeof(struct ip6t_standard)),       \
+	.target		= XT_TARGET_INIT(IP6T_STANDARD_TARGET,		       \
+					 sizeof(struct ip6t_standard_target)), \
+	.target.verdict	= -(__verdict) - 1,				       \
+}
+
+#define IP6T_ERROR_INIT							       \
+{									       \
+	.entry		= IP6T_ENTRY_INIT(sizeof(struct ip6t_error)),	       \
+	.target		= XT_TARGET_INIT(IP6T_ERROR_TARGET,		       \
+					 sizeof(struct ip6t_error_target)),    \
+	.target.errorname = "ERROR",					       \
+}
+
 /*
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 7edea2a..75c0230 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -15,128 +15,34 @@ MODULE_DESCRIPTION("arptables filter table");
 #define FILTER_VALID_HOOKS ((1 << NF_ARP_IN) | (1 << NF_ARP_OUT) | \
 			   (1 << NF_ARP_FORWARD))
 
-/* Standard entry. */
-struct arpt_standard
-{
-	struct arpt_entry entry;
-	struct arpt_standard_target target;
-};
-
-struct arpt_error_target
-{
-	struct arpt_entry_target target;
-	char errorname[ARPT_FUNCTION_MAXNAMELEN];
-};
-
-struct arpt_error
-{
-	struct arpt_entry entry;
-	struct arpt_error_target target;
-};
-
 static struct
 {
 	struct arpt_replace repl;
 	struct arpt_standard entries[3];
 	struct arpt_error term;
-} initial_table __initdata
-= { { "filter", FILTER_VALID_HOOKS, 4,
-      sizeof(struct arpt_standard) * 3 + sizeof(struct arpt_error),
-      { [NF_ARP_IN] = 0,
-	[NF_ARP_OUT] = sizeof(struct arpt_standard),
-	[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard), },
-      { [NF_ARP_IN] = 0,
-	[NF_ARP_OUT] = sizeof(struct arpt_standard),
-	[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard), },
-      0, NULL, { } },
-    {
-	    /* ARP_IN */
-	    {
-		    {
-			    {
-				    { 0 }, { 0 }, { 0 }, { 0 },
-				    0, 0,
-				    { { 0, }, { 0, } },
-				    { { 0, }, { 0, } },
-				    0, 0,
-				    0, 0,
-				    0, 0,
-				    "", "", { 0 }, { 0 },
-				    0, 0
-			    },
-			    sizeof(struct arpt_entry),
-			    sizeof(struct arpt_standard),
-			    0,
-			    { 0, 0 }, { } },
-		    { { { { ARPT_ALIGN(sizeof(struct arpt_standard_target)), "" } }, { } },
-		      -NF_ACCEPT - 1 }
-	    },
-	    /* ARP_OUT */
-	    {
-		    {
-			    {
-				    { 0 }, { 0 }, { 0 }, { 0 },
-				    0, 0,
-				    { { 0, }, { 0, } },
-				    { { 0, }, { 0, } },
-				    0, 0,
-				    0, 0,
-				    0, 0,
-				    "", "", { 0 }, { 0 },
-				    0, 0
-			    },
-			    sizeof(struct arpt_entry),
-			    sizeof(struct arpt_standard),
-			    0,
-			    { 0, 0 }, { } },
-		    { { { { ARPT_ALIGN(sizeof(struct arpt_standard_target)), "" } }, { } },
-		      -NF_ACCEPT - 1 }
-	    },
-	    /* ARP_FORWARD */
-	    {
-		    {
-			    {
-				    { 0 }, { 0 }, { 0 }, { 0 },
-				    0, 0,
-				    { { 0, }, { 0, } },
-				    { { 0, }, { 0, } },
-				    0, 0,
-				    0, 0,
-				    0, 0,
-				    "", "", { 0 }, { 0 },
-				    0, 0
-			    },
-			    sizeof(struct arpt_entry),
-			    sizeof(struct arpt_standard),
-			    0,
-			    { 0, 0 }, { } },
-		    { { { { ARPT_ALIGN(sizeof(struct arpt_standard_target)), "" } }, { } },
-		      -NF_ACCEPT - 1 }
-	    }
-    },
-    /* ERROR */
-    {
-	    {
-		    {
-			    { 0 }, { 0 }, { 0 }, { 0 },
-			    0, 0,
-			    { { 0, }, { 0, } },
-			    { { 0, }, { 0, } },
-			    0, 0,
-			    0, 0,
-			    0, 0,
-			    "", "", { 0 }, { 0 },
-			    0, 0
-		    },
-		    sizeof(struct arpt_entry),
-		    sizeof(struct arpt_error),
-		    0,
-		    { 0, 0 }, { } },
-	    { { { { ARPT_ALIGN(sizeof(struct arpt_error_target)), ARPT_ERROR_TARGET } },
-		{ } },
-	      "ERROR"
-	    }
-    }
+} initial_table __initdata = {
+	.repl = {
+		.name = "filter",
+		.valid_hooks = FILTER_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct arpt_standard) * 3 + sizeof(struct arpt_error),
+		.hook_entry = {
+			[NF_ARP_IN] = 0,
+			[NF_ARP_OUT] = sizeof(struct arpt_standard),
+			[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard),
+		},
+		.underflow = {
+			[NF_ARP_IN] = 0,
+			[NF_ARP_OUT] = sizeof(struct arpt_standard),
+			[NF_ARP_FORWARD] = 2 * sizeof(struct arpt_standard),
+		},
+	},
+	.entries = {
+		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_IN */
+		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_OUT */
+		ARPT_STANDARD_INIT(NF_ACCEPT),	/* ARP_FORWARD */
+	},
+	.term = ARPT_ERROR_INIT,
 };
 
 static struct arpt_table packet_filter = {
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 4272890..ea14979 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -26,53 +26,29 @@ static struct
 	struct ipt_replace repl;
 	struct ipt_standard entries[3];
 	struct ipt_error term;
-} initial_table __initdata
-= { { "filter", FILTER_VALID_HOOKS, 4,
-      sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
-      { [NF_IP_LOCAL_IN] = 0,
-	[NF_IP_FORWARD] = sizeof(struct ipt_standard),
-	[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
-      { [NF_IP_LOCAL_IN] = 0,
-	[NF_IP_FORWARD] = sizeof(struct ipt_standard),
-	[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
-      0, NULL, { } },
-    {
-	    /* LOCAL_IN */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* FORWARD */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_OUT */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } }
-    },
-    /* ERROR */
-    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-	0,
-	sizeof(struct ipt_entry),
-	sizeof(struct ipt_error),
-	0, { 0, 0 }, { } },
-      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET } },
-	  { } },
-	"ERROR"
-      }
-    }
+} initial_table __initdata = {
+	.repl = {
+		.name = "filter",
+		.valid_hooks = FILTER_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
+		.hook_entry = {
+			[NF_IP_LOCAL_IN] = 0,
+			[NF_IP_FORWARD] = sizeof(struct ipt_standard),
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2,
+		},
+		.underflow = {
+			[NF_IP_LOCAL_IN] = 0,
+			[NF_IP_FORWARD] = sizeof(struct ipt_standard),
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2,
+		},
+	},
+	.entries = {
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+	},
+	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
 static struct xt_table packet_filter = {
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 9278802..c3827ba 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -33,73 +33,35 @@ static struct
 	struct ipt_replace repl;
 	struct ipt_standard entries[5];
 	struct ipt_error term;
-} initial_table __initdata
-= { { "mangle", MANGLE_VALID_HOOKS, 6,
-      sizeof(struct ipt_standard) * 5 + sizeof(struct ipt_error),
-      { [NF_IP_PRE_ROUTING] 	= 0,
-	[NF_IP_LOCAL_IN] 	= sizeof(struct ipt_standard),
-	[NF_IP_FORWARD] 	= sizeof(struct ipt_standard) * 2,
-	[NF_IP_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
-	[NF_IP_POST_ROUTING] 	= sizeof(struct ipt_standard) * 4 },
-      { [NF_IP_PRE_ROUTING] 	= 0,
-	[NF_IP_LOCAL_IN] 	= sizeof(struct ipt_standard),
-	[NF_IP_FORWARD] 	= sizeof(struct ipt_standard) * 2,
-	[NF_IP_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
-	[NF_IP_POST_ROUTING]	= sizeof(struct ipt_standard) * 4 },
-      0, NULL, { } },
-    {
-	    /* PRE_ROUTING */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_IN */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* FORWARD */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_OUT */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* POST_ROUTING */
-	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ipt_entry),
-		sizeof(struct ipt_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-    },
-    /* ERROR */
-    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-	0,
-	sizeof(struct ipt_entry),
-	sizeof(struct ipt_error),
-	0, { 0, 0 }, { } },
-      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET } },
-	  { } },
-	"ERROR"
-      }
-    }
+} initial_table __initdata = {
+	.repl = {
+		.name = "mangle",
+		.valid_hooks = MANGLE_VALID_HOOKS,
+		.num_entries = 6,
+		.size = sizeof(struct ipt_standard) * 5 + sizeof(struct ipt_error),
+		.hook_entry = {
+			[NF_IP_PRE_ROUTING] 	= 0,
+			[NF_IP_LOCAL_IN] 	= sizeof(struct ipt_standard),
+			[NF_IP_FORWARD] 	= sizeof(struct ipt_standard) * 2,
+			[NF_IP_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
+			[NF_IP_POST_ROUTING] 	= sizeof(struct ipt_standard) * 4,
+		},
+		.underflow = {
+			[NF_IP_PRE_ROUTING] 	= 0,
+			[NF_IP_LOCAL_IN] 	= sizeof(struct ipt_standard),
+			[NF_IP_FORWARD] 	= sizeof(struct ipt_standard) * 2,
+			[NF_IP_LOCAL_OUT] 	= sizeof(struct ipt_standard) * 3,
+			[NF_IP_POST_ROUTING]	= sizeof(struct ipt_standard) * 4,
+		},
+	},
+	.entries = {
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
+	},
+	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
 static struct xt_table packet_mangler = {
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 18c3d4c..f7d28fd 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -21,62 +21,18 @@ static struct
 		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
 		.hook_entry = {
 			[NF_IP_PRE_ROUTING] = 0,
-			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) },
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard)
+		},
 		.underflow = {
 			[NF_IP_PRE_ROUTING] = 0,
-			[NF_IP_LOCAL_OUT]  = sizeof(struct ipt_standard) },
+			[NF_IP_LOCAL_OUT]  = sizeof(struct ipt_standard)
+		},
 	},
 	.entries = {
-	     /* PRE_ROUTING */
-	     {
-		     .entry = {
-			     .target_offset = sizeof(struct ipt_entry),
-			     .next_offset = sizeof(struct ipt_standard),
-		     },
-		     .target = {
-			  .target = {
-				  .u = {
-					  .target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
-				  },
-			  },
-			  .verdict = -NF_ACCEPT - 1,
-		     },
-	     },
-
-	     /* LOCAL_OUT */
-	     {
-		     .entry = {
-			     .target_offset = sizeof(struct ipt_entry),
-			     .next_offset = sizeof(struct ipt_standard),
-		     },
-		     .target = {
-			     .target = {
-				     .u = {
-					     .target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
-				     },
-			     },
-			     .verdict = -NF_ACCEPT - 1,
-		     },
-	     },
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
 	},
-	/* ERROR */
-	.term = {
-		.entry = {
-			.target_offset = sizeof(struct ipt_entry),
-			.next_offset = sizeof(struct ipt_error),
-		},
-		.target = {
-			.target = {
-				.u = {
-					.user = {
-						.target_size = IPT_ALIGN(sizeof(struct ipt_error_target)),
-						.name = IPT_ERROR_TARGET,
-					},
-				},
-			},
-			.errorname = "ERROR",
-		},
-	}
+	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
 static struct xt_table packet_raw = {
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 2534f71..07e99e3 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -46,77 +46,20 @@ static struct
 		.hook_entry = {
 			[NF_IP_PRE_ROUTING] = 0,
 			[NF_IP_POST_ROUTING] = sizeof(struct ipt_standard),
-			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2
+		},
 		.underflow = {
 			[NF_IP_PRE_ROUTING] = 0,
 			[NF_IP_POST_ROUTING] = sizeof(struct ipt_standard),
-			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2 },
+			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) * 2
+		},
 	},
 	.entries = {
-		/* PRE_ROUTING */
-		{
-			.entry = {
-				.target_offset = sizeof(struct ipt_entry),
-				.next_offset = sizeof(struct ipt_standard),
-			},
-			.target = {
-				.target = {
-					.u = {
-						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
-					},
-				},
-				.verdict = -NF_ACCEPT - 1,
-			},
-		},
-		/* POST_ROUTING */
-		{
-			.entry = {
-				.target_offset = sizeof(struct ipt_entry),
-				.next_offset = sizeof(struct ipt_standard),
-			},
-			.target = {
-				.target = {
-					.u = {
-						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
-					},
-				},
-				.verdict = -NF_ACCEPT - 1,
-			},
-		},
-		/* LOCAL_OUT */
-		{
-			.entry = {
-				.target_offset = sizeof(struct ipt_entry),
-				.next_offset = sizeof(struct ipt_standard),
-			},
-			.target = {
-				.target = {
-					.u = {
-						.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
-					},
-				},
-				.verdict = -NF_ACCEPT - 1,
-			},
-		},
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
 	},
-	/* ERROR */
-	.term = {
-		.entry = {
-			.target_offset = sizeof(struct ipt_entry),
-			.next_offset = sizeof(struct ipt_error),
-		},
-		.target = {
-			.target = {
-				.u = {
-					.user = {
-						.target_size = IPT_ALIGN(sizeof(struct ipt_error_target)),
-						.name = IPT_ERROR_TARGET,
-					},
-				},
-			},
-			.errorname = "ERROR",
-		},
-	}
+	.term = IPT_ERROR_INIT,			/* ERROR */
 };
 
 static struct xt_table nat_table = {
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 76f0cf6..7e32e2a 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -24,53 +24,29 @@ static struct
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[3];
 	struct ip6t_error term;
-} initial_table __initdata
-= { { "filter", FILTER_VALID_HOOKS, 4,
-      sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
-      { [NF_IP6_LOCAL_IN] = 0,
-	[NF_IP6_FORWARD] = sizeof(struct ip6t_standard),
-	[NF_IP6_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2 },
-      { [NF_IP6_LOCAL_IN] = 0,
-	[NF_IP6_FORWARD] = sizeof(struct ip6t_standard),
-	[NF_IP6_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2 },
-      0, NULL, { } },
-    {
-	    /* LOCAL_IN */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* FORWARD */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_OUT */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } }
-    },
-    /* ERROR */
-    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-	0,
-	sizeof(struct ip6t_entry),
-	sizeof(struct ip6t_error),
-	0, { 0, 0 }, { } },
-      { { { { IP6T_ALIGN(sizeof(struct ip6t_error_target)), IP6T_ERROR_TARGET } },
-	  { } },
-	"ERROR"
-      }
-    }
+} initial_table __initdata = {
+	.repl = {
+		.name = "filter",
+		.valid_hooks = FILTER_VALID_HOOKS,
+		.num_entries = 4,
+		.size = sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
+		.hook_entry = {
+			[NF_IP6_LOCAL_IN] = 0,
+			[NF_IP6_FORWARD] = sizeof(struct ip6t_standard),
+			[NF_IP6_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2
+		},
+		.underflow = {
+			[NF_IP6_LOCAL_IN] = 0,
+			[NF_IP6_FORWARD] = sizeof(struct ip6t_standard),
+			[NF_IP6_LOCAL_OUT] = sizeof(struct ip6t_standard) * 2
+		},
+	},
+	.entries = {
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+	},
+	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
 static struct xt_table packet_filter = {
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index a9f10e3..f2d2649 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -32,73 +32,35 @@ static struct
 	struct ip6t_replace repl;
 	struct ip6t_standard entries[5];
 	struct ip6t_error term;
-} initial_table __initdata
-= { { "mangle", MANGLE_VALID_HOOKS, 6,
-      sizeof(struct ip6t_standard) * 5 + sizeof(struct ip6t_error),
-      { [NF_IP6_PRE_ROUTING] 	= 0,
-	[NF_IP6_LOCAL_IN]	= sizeof(struct ip6t_standard),
-	[NF_IP6_FORWARD]	= sizeof(struct ip6t_standard) * 2,
-	[NF_IP6_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
-	[NF_IP6_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4},
-      { [NF_IP6_PRE_ROUTING] 	= 0,
-	[NF_IP6_LOCAL_IN]	= sizeof(struct ip6t_standard),
-	[NF_IP6_FORWARD]	= sizeof(struct ip6t_standard) * 2,
-	[NF_IP6_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
-	[NF_IP6_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4},
-      0, NULL, { } },
-    {
-	    /* PRE_ROUTING */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_IN */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* FORWARD */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* LOCAL_OUT */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } },
-	    /* POST_ROUTING */
-	    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-		0,
-		sizeof(struct ip6t_entry),
-		sizeof(struct ip6t_standard),
-		0, { 0, 0 }, { } },
-	      { { { { IP6T_ALIGN(sizeof(struct ip6t_standard_target)), "" } }, { } },
-		-NF_ACCEPT - 1 } }
-    },
-    /* ERROR */
-    { { { { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, { { { 0 } } }, "", "", { 0 }, { 0 }, 0, 0, 0 },
-	0,
-	sizeof(struct ip6t_entry),
-	sizeof(struct ip6t_error),
-	0, { 0, 0 }, { } },
-      { { { { IP6T_ALIGN(sizeof(struct ip6t_error_target)), IP6T_ERROR_TARGET } },
-	  { } },
-	"ERROR"
-      }
-    }
+} initial_table __initdata = {
+	.repl = {
+		.name = "mangle",
+		.valid_hooks = MANGLE_VALID_HOOKS,
+		.num_entries = 6,
+		.size = sizeof(struct ip6t_standard) * 5 + sizeof(struct ip6t_error),
+		.hook_entry = {
+			[NF_IP6_PRE_ROUTING] 	= 0,
+			[NF_IP6_LOCAL_IN]	= sizeof(struct ip6t_standard),
+			[NF_IP6_FORWARD]	= sizeof(struct ip6t_standard) * 2,
+			[NF_IP6_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
+			[NF_IP6_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4,
+		},
+		.underflow = {
+			[NF_IP6_PRE_ROUTING] 	= 0,
+			[NF_IP6_LOCAL_IN]	= sizeof(struct ip6t_standard),
+			[NF_IP6_FORWARD]	= sizeof(struct ip6t_standard) * 2,
+			[NF_IP6_LOCAL_OUT] 	= sizeof(struct ip6t_standard) * 3,
+			[NF_IP6_POST_ROUTING]	= sizeof(struct ip6t_standard) * 4,
+		},
+	},
+	.entries = {
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_IN */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* FORWARD */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
+	},
+	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
 static struct xt_table packet_mangler = {
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index a3eb5b8..0acda45 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -35,56 +35,10 @@ static struct
 		},
 	},
 	.entries = {
-		/* PRE_ROUTING */
-		{
-			.entry = {
-				.target_offset = sizeof(struct ip6t_entry),
-				.next_offset = sizeof(struct ip6t_standard),
-			},
-			.target = {
-				.target = {
-					.u = {
-						.target_size = IP6T_ALIGN(sizeof(struct ip6t_standard_target)),
-					},
-				},
-				.verdict = -NF_ACCEPT - 1,
-			},
-		},
-
-		/* LOCAL_OUT */
-		{
-			.entry = {
-				.target_offset = sizeof(struct ip6t_entry),
-				.next_offset = sizeof(struct ip6t_standard),
-			},
-			.target = {
-				.target = {
-					.u = {
-						.target_size = IP6T_ALIGN(sizeof(struct ip6t_standard_target)),
-					},
-				},
-				.verdict = -NF_ACCEPT - 1,
-			},
-		},
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
 	},
-	/* ERROR */
-	.term = {
-		.entry = {
-			.target_offset = sizeof(struct ip6t_entry),
-			.next_offset = sizeof(struct ip6t_error),
-		},
-		.target = {
-			.target = {
-				.u = {
-					.user = {
-						.target_size = IP6T_ALIGN(sizeof(struct ip6t_error_target)),
-						.name = IP6T_ERROR_TARGET,
-					},
-				},
-			},
-			.errorname = "ERROR",
-		},
-	}
+	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
 
 static struct xt_table packet_raw = {
