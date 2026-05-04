Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F253DE44C
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 18:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919014; cv=none; b=U4bHLHe6wx91LYUv+r/2zc8GMxt4LAeW5LUpOAY5AA0vXQulhE4ivoPSyELD3echmFIinbARgJjSHJkLlssq6w2EBthYSiU5S/NrLAlIxaeKToQuZiL5YyjkLtMXVM2x+63t2fTODmHguUKeCUvorP/xh6jFrwUUyhDnHzIZYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919014; c=relaxed/simple;
	bh=hE9nGnbpmOh3tZv1vOb1NSHrYiDUBr2mbMC/G9Ijvvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCbLfj6vLemfwddSJxkGqpoJFgYa4riLAvFlbueT9SGVzE748YaEWkHa/PI1saPu2HsUg+Y+2KejsSgWp7D8D+2PVwOlXX7ZVoh8sCjtcNbDgQYni7cXNYZeByoMxJsJYQKHP9s7bVKtJW/IG2oVy6wQ/Kz3pBTtFMXOHRbLD2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5D0A260908; Mon, 04 May 2026 20:23:30 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 3/8] netfilter: x_tables: add and use xt_unregister_table_pre_exit
Date: Mon,  4 May 2026 20:22:15 +0200
Message-ID: <20260504182310.1916-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504182310.1916-1-fw@strlen.de>
References: <20260504182310.1916-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the copypasted variants of _pre_exit and add one single
function in the xtables core.  ebtables is not compatible with
x_tables and therefore unchanged.

This is a preparation patch to reduce noise in the followup
bug fixes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: no changes.

 include/linux/netfilter/x_tables.h        |  1 +
 include/linux/netfilter_arp/arp_tables.h  |  1 -
 include/linux/netfilter_ipv4/ip_tables.h  |  1 -
 include/linux/netfilter_ipv6/ip6_tables.h |  1 -
 net/ipv4/netfilter/arp_tables.c           |  9 -------
 net/ipv4/netfilter/arptable_filter.c      |  2 +-
 net/ipv4/netfilter/ip_tables.c            |  9 -------
 net/ipv4/netfilter/iptable_filter.c       |  2 +-
 net/ipv4/netfilter/iptable_mangle.c       |  2 +-
 net/ipv4/netfilter/iptable_nat.c          |  1 +
 net/ipv4/netfilter/iptable_raw.c          |  2 +-
 net/ipv4/netfilter/iptable_security.c     |  2 +-
 net/ipv6/netfilter/ip6_tables.c           |  9 -------
 net/ipv6/netfilter/ip6table_filter.c      |  2 +-
 net/ipv6/netfilter/ip6table_mangle.c      |  2 +-
 net/ipv6/netfilter/ip6table_nat.c         |  1 +
 net/ipv6/netfilter/ip6table_raw.c         |  2 +-
 net/ipv6/netfilter/ip6table_security.c    |  2 +-
 net/netfilter/x_tables.c                  | 29 +++++++++++++++++++++++
 19 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index cb4b694dd9e4..74486714ae20 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -309,6 +309,7 @@ struct xt_table *xt_register_table(struct net *net,
 				   struct xt_table_info *bootstrap,
 				   struct xt_table_info *newinfo);
 void *xt_unregister_table(struct xt_table *table);
+void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name);
 
 struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       unsigned int num_counters,
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index a40aaf645fa4..05631a25e622 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -53,7 +53,6 @@ int arpt_register_table(struct net *net, const struct xt_table *table,
 			const struct arpt_replace *repl,
 			const struct nf_hook_ops *ops);
 void arpt_unregister_table(struct net *net, const char *name);
-void arpt_unregister_table_pre_exit(struct net *net, const char *name);
 extern unsigned int arpt_do_table(void *priv, struct sk_buff *skb,
 				  const struct nf_hook_state *state);
 
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 132b0e4a6d4d..13593391d605 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -26,7 +26,6 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops);
 
-void ipt_unregister_table_pre_exit(struct net *net, const char *name);
 void ipt_unregister_table_exit(struct net *net, const char *name);
 
 /* Standard entry. */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 8b8885a73c76..c6d5b927830d 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -27,7 +27,6 @@ extern void *ip6t_alloc_initial_table(const struct xt_table *);
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops);
-void ip6t_unregister_table_pre_exit(struct net *net, const char *name);
 void ip6t_unregister_table_exit(struct net *net, const char *name);
 extern unsigned int ip6t_do_table(void *priv, struct sk_buff *skb,
 				  const struct nf_hook_state *state);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c02e46a0271a..bd348b7bad2c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1554,15 +1554,6 @@ int arpt_register_table(struct net *net,
 	return ret;
 }
 
-void arpt_unregister_table_pre_exit(struct net *net, const char *name)
-{
-	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
-
-	if (table)
-		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
-}
-EXPORT_SYMBOL(arpt_unregister_table_pre_exit);
-
 void arpt_unregister_table(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_ARP, name);
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 78cd5ee24448..393d9a8c7739 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -43,7 +43,7 @@ static int arptable_filter_table_init(struct net *net)
 
 static void __net_exit arptable_filter_net_pre_exit(struct net *net)
 {
-	arpt_unregister_table_pre_exit(net, "filter");
+	xt_unregister_table_pre_exit(net, NFPROTO_ARP, "filter");
 }
 
 static void __net_exit arptable_filter_net_exit(struct net *net)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 488c5945ebb2..864489928fb5 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1756,14 +1756,6 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
-void ipt_unregister_table_pre_exit(struct net *net, const char *name)
-{
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);
-
-	if (table)
-		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
-}
-
 void ipt_unregister_table_exit(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_IPV4, name);
@@ -1854,7 +1846,6 @@ static void __exit ip_tables_fini(void)
 }
 
 EXPORT_SYMBOL(ipt_register_table);
-EXPORT_SYMBOL(ipt_unregister_table_pre_exit);
 EXPORT_SYMBOL(ipt_unregister_table_exit);
 EXPORT_SYMBOL(ipt_do_table);
 module_init(ip_tables_init);
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 3ab908b74795..b2fbd9651d61 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -61,7 +61,7 @@ static int __net_init iptable_filter_net_init(struct net *net)
 
 static void __net_exit iptable_filter_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "filter");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "filter");
 }
 
 static void __net_exit iptable_filter_net_exit(struct net *net)
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 385d945d8ebe..a99e61996197 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -96,7 +96,7 @@ static int iptable_mangle_table_init(struct net *net)
 
 static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "mangle");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "mangle");
 }
 
 static void __net_exit iptable_mangle_net_exit(struct net *net)
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 625a1ca13b1b..8fc4912e790d 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -129,6 +129,7 @@ static int iptable_nat_table_init(struct net *net)
 static void __net_exit iptable_nat_net_pre_exit(struct net *net)
 {
 	ipt_nat_unregister_lookups(net);
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "nat");
 }
 
 static void __net_exit iptable_nat_net_exit(struct net *net)
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 0e7f53964d0a..42511721e538 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -53,7 +53,7 @@ static int iptable_raw_table_init(struct net *net)
 
 static void __net_exit iptable_raw_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "raw");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "raw");
 }
 
 static void __net_exit iptable_raw_net_exit(struct net *net)
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index d885443cb267..4646bf6d7d2b 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -50,7 +50,7 @@ static int iptable_security_table_init(struct net *net)
 
 static void __net_exit iptable_security_net_pre_exit(struct net *net)
 {
-	ipt_unregister_table_pre_exit(net, "security");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV4, "security");
 }
 
 static void __net_exit iptable_security_net_exit(struct net *net)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dbe7c7acd702..edf50bc7787e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1765,14 +1765,6 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 	return ret;
 }
 
-void ip6t_unregister_table_pre_exit(struct net *net, const char *name)
-{
-	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
-
-	if (table)
-		nf_unregister_net_hooks(net, table->ops, hweight32(table->valid_hooks));
-}
-
 void ip6t_unregister_table_exit(struct net *net, const char *name)
 {
 	struct xt_table *table = xt_find_table(net, NFPROTO_IPV6, name);
@@ -1864,7 +1856,6 @@ static void __exit ip6_tables_fini(void)
 }
 
 EXPORT_SYMBOL(ip6t_register_table);
-EXPORT_SYMBOL(ip6t_unregister_table_pre_exit);
 EXPORT_SYMBOL(ip6t_unregister_table_exit);
 EXPORT_SYMBOL(ip6t_do_table);
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index e8992693e14a..f05a9e4b2c67 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -60,7 +60,7 @@ static int __net_init ip6table_filter_net_init(struct net *net)
 
 static void __net_exit ip6table_filter_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "filter");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "filter");
 }
 
 static void __net_exit ip6table_filter_net_exit(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 8dd4cd0c47bd..afa4a5703e43 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -89,7 +89,7 @@ static int ip6table_mangle_table_init(struct net *net)
 
 static void __net_exit ip6table_mangle_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "mangle");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "mangle");
 }
 
 static void __net_exit ip6table_mangle_net_exit(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 5be723232df8..bb8aa3fc42b4 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -131,6 +131,7 @@ static int ip6table_nat_table_init(struct net *net)
 static void __net_exit ip6table_nat_net_pre_exit(struct net *net)
 {
 	ip6t_nat_unregister_lookups(net);
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "nat");
 }
 
 static void __net_exit ip6table_nat_net_exit(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index fc9f6754028f..32d2da81c52a 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -52,7 +52,7 @@ static int ip6table_raw_table_init(struct net *net)
 
 static void __net_exit ip6table_raw_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "raw");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "raw");
 }
 
 static void __net_exit ip6table_raw_net_exit(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 4df14a9bae78..3dfd8d6ea4b9 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -49,7 +49,7 @@ static int ip6table_security_table_init(struct net *net)
 
 static void __net_exit ip6table_security_net_pre_exit(struct net *net)
 {
-	ip6t_unregister_table_pre_exit(net, "security");
+	xt_unregister_table_pre_exit(net, NFPROTO_IPV6, "security");
 }
 
 static void __net_exit ip6table_security_net_exit(struct net *net)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 06f27bea9eed..9c1e896c7b03 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1650,6 +1650,35 @@ void *xt_unregister_table(struct xt_table *table)
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_unregister_table);
+
+/**
+ * xt_unregister_table_pre_exit - pre-shutdown unregister of a table
+ * @net: network namespace
+ * @af: address family (e.g., NFPROTO_IPV4, NFPROTO_IPV6)
+ * @name: name of the table to unregister
+ *
+ * Unregisters the specified netfilter table from the given network namespace
+ * and also unregisters the hooks from netfilter core: no new packets will be
+ * processed.
+ */
+void xt_unregister_table_pre_exit(struct net *net, u8 af, const char *name)
+{
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *t;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(t, &xt_net->tables[af], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&xt[af].mutex);
+
+			if (t->ops) /* nat table registers with nat core, t->ops is NULL. */
+				nf_unregister_net_hooks(net, t->ops, hweight32(t->valid_hooks));
+			return;
+		}
+	}
+	mutex_unlock(&xt[af].mutex);
+}
+EXPORT_SYMBOL(xt_unregister_table_pre_exit);
 #endif
 
 #ifdef CONFIG_PROC_FS
-- 
2.53.0

