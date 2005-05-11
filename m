From: James Morris <jmorris@redhat.com>
Subject: Re: Netfilter socket hooks (was: Re: Status of owner-socketlookup)
Date: Wed, 11 May 2005 19:57:42 -0400 (EDT)
Message-ID: <Xine.LNX.4.44.0505111955060.15673-100000@thoron.boston.redhat.com>
References: <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4280DA51.8090201@trash.net>
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

What about adding an output hook to the table?  This would make it much 
easier to manage rules.

Something like:

diff -purN -X dontdiff linux-2.6.12-rc4-sk.o/net/ipv4/netfilter/iptable_skfilter.c linux-2.6.12-rc4-sk.w/net/ipv4/netfilter/iptable_skfilter.c
--- linux-2.6.12-rc4-sk.o/net/ipv4/netfilter/iptable_skfilter.c	2005-05-11 18:57:17.000000000 -0400
+++ linux-2.6.12-rc4-sk.w/net/ipv4/netfilter/iptable_skfilter.c	2005-05-11 19:30:44.000000000 -0400
@@ -11,24 +11,26 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 
-#define SKFILTER_VALID_HOOKS ((1 << NF_IP_LOCAL_IN))
+#define SKFILTER_VALID_HOOKS ((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_LOCAL_OUT))
 
 static struct
 {
 	struct ipt_replace repl;
-	struct ipt_standard entries[1];
+	struct ipt_standard entries[2];
 	struct ipt_error term;
 } initial_table __initdata = {
 	.repl = {
 		.name = "skfilter", 
 		.valid_hooks = SKFILTER_VALID_HOOKS, 
-		.num_entries = 2,
-		.size = sizeof(struct ipt_standard) * 1 + sizeof(struct ipt_error),
+		.num_entries = 3,
+		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
 		.hook_entry = { 
-			[NF_IP_LOCAL_IN] = 0,
+			[NF_IP_LOCAL_IN]	= 0,
+			[NF_IP_LOCAL_OUT]	= sizeof(struct ipt_standard),
 		},
 		.underflow = { 
-			[NF_IP_LOCAL_IN] = 0,
+			[NF_IP_LOCAL_IN]	= 0,
+			[NF_IP_LOCAL_OUT]       = sizeof(struct ipt_standard),
 		},
 	},
 	.entries = {
@@ -47,6 +49,21 @@ static struct
 			  .verdict = -NF_ACCEPT - 1,
 		     },
 	     },
+	     /* LOCAL_OUT */
+	     { 
+		     .entry = { 
+			     .target_offset = sizeof(struct ipt_entry),
+			     .next_offset = sizeof(struct ipt_standard),
+		     },
+		     .target = { 
+			  .target = { 
+				  .u = {
+					  .target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
+				  },
+			  },
+			  .verdict = -NF_ACCEPT - 1,
+		     },
+	     },
 	},
 	/* ERROR */
 	.term = {
@@ -77,12 +94,12 @@ static struct ipt_table skfilter = { 
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ipt_hook(unsigned int hook,
-         struct sock *sk,
-	 struct sk_buff **pskb,
-	 const struct net_device *in,
-	 const struct net_device *out,
-	 int (*okfn)(struct sock *, struct sk_buff *))
+ipt_sk_hook(unsigned int hook,
+            struct sock *sk,
+            struct sk_buff **pskb,
+            const struct net_device *in,
+            const struct net_device *out,
+            int (*okfn)(struct sock *, struct sk_buff *))
 {
 	unsigned int ret;
 	int pull = 0;
@@ -97,9 +114,19 @@ ipt_hook(unsigned int hook,
 	return ret;
 }
 
-static struct nf_sk_hook_ops ipt_ops[] = {
+static unsigned int
+ipt_hook(unsigned int hook,
+         struct sk_buff **pskb,
+         const struct net_device *in,
+         const struct net_device *out,
+         int (*okfn)(struct sk_buff *))
+{
+	return ipt_do_table(NULL, pskb, hook, in, out, &skfilter, NULL);
+}
+
+static struct nf_sk_hook_ops ipt_sk_ops[] = {
 	{
-		.hook		= ipt_hook,
+		.hook		= ipt_sk_hook,
 		.owner		= THIS_MODULE,
 		.pf		= PF_INET, 
 		.hooknum	= NF_IP_LOCAL_IN,
@@ -107,6 +134,16 @@ static struct nf_sk_hook_ops ipt_ops[] =
 	},
 };
 
+static struct nf_hook_ops ipt_ops[] = {
+	{
+		.hook		= ipt_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET, 
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_FILTER,
+	},
+};
+
 static int __init init(void)
 {
 	int ret;
@@ -117,12 +154,18 @@ static int __init init(void)
 		return ret;
 
 	/* Register hooks */
-	ret = nf_register_sk_hook(&ipt_ops[0]);
+	ret = nf_register_sk_hook(&ipt_sk_ops[0]);
 	if (ret < 0)
 		goto cleanup_table;
 
+	ret = nf_register_hook(&ipt_ops[0]);
+	if (ret < 0)
+		goto cleanup_hook0;
+
 	return ret;
 
+ cleanup_hook0:
+	nf_unregister_sk_hook(&ipt_sk_ops[0]);
  cleanup_table:
 	ipt_unregister_table(&skfilter);
 
@@ -131,7 +174,8 @@ static int __init init(void)
 
 static void __exit fini(void)
 {
-	nf_unregister_sk_hook(&ipt_ops[0]);
+	nf_unregister_hook(&ipt_ops[0]);
+	nf_unregister_sk_hook(&ipt_sk_ops[0]);
 	ipt_unregister_table(&skfilter);
 }
 
