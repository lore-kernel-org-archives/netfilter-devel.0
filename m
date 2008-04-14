From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/41]: remove arpt_table indirection macro
Date: Mon, 14 Apr 2008 12:16:33 +0200 (MEST)
Message-ID: <20080414101630.32717.25983.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36263 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDNKQe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:34 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove arpt_table indirection macro

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9c710d1a92fd88a1070eb9a2cf972257e05c5540
tree 0923b90f18025b6963e8fed597b9f47fab0ee898
parent b22e516e34d3a19cab251b4e10b332fa1d0d9244
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:45 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:45 +0200

 include/linux/netfilter_arp/arp_tables.h |   11 +++++------
 net/ipv4/netfilter/arp_tables.c          |   27 +++++++++++++--------------
 net/ipv4/netfilter/arptable_filter.c     |    2 +-
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index db223ca..102c413 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -24,7 +24,6 @@
 #define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
 #define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
 #define arpt_target xt_target
-#define arpt_table xt_table
 
 #define ARPT_DEV_ADDR_LEN_MAX 16
 
@@ -271,15 +270,15 @@ struct arpt_error
  	xt_register_target(tgt); })
 #define arpt_unregister_target(tgt) xt_unregister_target(tgt)
 
-extern struct arpt_table *arpt_register_table(struct net *net,
-					      struct arpt_table *table,
-					      const struct arpt_replace *repl);
-extern void arpt_unregister_table(struct arpt_table *table);
+extern struct xt_table *arpt_register_table(struct net *net,
+					    struct xt_table *table,
+					    const struct arpt_replace *repl);
+extern void arpt_unregister_table(struct xt_table *table);
 extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  unsigned int hook,
 				  const struct net_device *in,
 				  const struct net_device *out,
-				  struct arpt_table *table);
+				  struct xt_table *table);
 
 #define ARPT_ALIGN(s) XT_ALIGN(s)
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 10cc442..34c42c8 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -222,7 +222,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			   unsigned int hook,
 			   const struct net_device *in,
 			   const struct net_device *out,
-			   struct arpt_table *table)
+			   struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ];
 	unsigned int verdict = NF_DROP;
@@ -706,7 +706,7 @@ static void get_counters(const struct xt_table_info *t,
 	}
 }
 
-static inline struct xt_counters *alloc_counters(struct arpt_table *table)
+static inline struct xt_counters *alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
@@ -731,13 +731,13 @@ static inline struct xt_counters *alloc_counters(struct arpt_table *table)
 }
 
 static int copy_entries_to_user(unsigned int total_size,
-				struct arpt_table *table,
+				struct xt_table *table,
 				void __user *userptr)
 {
 	unsigned int off, num;
 	struct arpt_entry *e;
 	struct xt_counters *counters;
-	const struct xt_table_info *private = table->private;
+	struct xt_table_info *private = table->private;
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -851,7 +851,7 @@ static int compat_table_info(const struct xt_table_info *info,
 static int get_info(struct net *net, void __user *user, int *len, int compat)
 {
 	char name[ARPT_TABLE_MAXNAMELEN];
-	struct arpt_table *t;
+	struct xt_table *t;
 	int ret;
 
 	if (*len != sizeof(struct arpt_getinfo)) {
@@ -911,7 +911,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 {
 	int ret;
 	struct arpt_get_entries get;
-	struct arpt_table *t;
+	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
 		duprintf("get_entries: %u < %Zu\n", *len, sizeof(get));
@@ -954,7 +954,7 @@ static int __do_replace(struct net *net, const char *name,
 			void __user *counters_ptr)
 {
 	int ret;
-	struct arpt_table *t;
+	struct xt_table *t;
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
 	void *loc_cpu_old_entry;
@@ -1091,7 +1091,7 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 	const char *name;
 	int size;
 	void *ptmp;
-	struct arpt_table *t;
+	struct xt_table *t;
 	const struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
@@ -1555,7 +1555,7 @@ out:
 }
 
 static int compat_copy_entries_to_user(unsigned int total_size,
-				       struct arpt_table *table,
+				       struct xt_table *table,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
@@ -1593,7 +1593,7 @@ static int compat_get_entries(struct net *net,
 {
 	int ret;
 	struct compat_arpt_get_entries get;
-	struct arpt_table *t;
+	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
 		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
@@ -1723,9 +1723,8 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 	return ret;
 }
 
-struct arpt_table *arpt_register_table(struct net *net,
-				       struct arpt_table *table,
-				       const struct arpt_replace *repl)
+struct xt_table *arpt_register_table(struct net *net, struct xt_table *table,
+				     const struct arpt_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -1767,7 +1766,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-void arpt_unregister_table(struct arpt_table *table)
+void arpt_unregister_table(struct xt_table *table)
 {
 	struct xt_table_info *private;
 	void *loc_cpu_entry;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 629e495..9f6526c 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -45,7 +45,7 @@ static struct
 	.term = ARPT_ERROR_INIT,
 };
 
-static struct arpt_table packet_filter = {
+static struct xt_table packet_filter = {
 	.name		= "filter",
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.lock		= __RW_LOCK_UNLOCKED(packet_filter.lock),
