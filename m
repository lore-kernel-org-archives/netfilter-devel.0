From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/64]: arp_tables: move entry and target checks to seperate functions
Date: Tue, 18 Dec 2007 00:46:51 +0100 (MET)
Message-ID: <20071217234651.23601.80483.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38965 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXLQXqw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:52 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: move entry and target checks to seperate functions

Resync with ip_tables.c as preparation for compat support.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d0ccbefbca69eff49883e5ad964a5f13172aef0d
tree 2d3a2747325bc8b92b4e670031aef881bc056424
parent 23afc470858634c807b97379e0a7e8447463be27
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:11 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:55 +0100

 net/ipv4/netfilter/arp_tables.c |   58 ++++++++++++++++++++++++++++-----------
 1 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index cafb35a..b0f4331 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -435,12 +435,9 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int check_entry(struct arpt_entry *e, const char *name, unsigned int size,
-			      unsigned int *i)
+static inline int check_entry(struct arpt_entry *e, const char *name)
 {
 	struct arpt_entry_target *t;
-	struct arpt_target *target;
-	int ret;
 
 	if (!arp_checkentry(&e->arp)) {
 		duprintf("arp_tables: arp check failed %p %s.\n", e, name);
@@ -454,30 +451,57 @@ static inline int check_entry(struct arpt_entry *e, const char *name, unsigned i
 	if (e->target_offset + t->u.target_size > e->next_offset)
 		return -EINVAL;
 
+	return 0;
+}
+
+static inline int check_target(struct arpt_entry *e, const char *name)
+{
+	struct arpt_entry_target *t;
+	struct arpt_target *target;
+	int ret;
+
+	t = arpt_get_target(e);
+	target = t->u.kernel.target;
+
+	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, 0, 0);
+	if (!ret && t->u.kernel.target->checkentry
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
+		duprintf("arp_tables: check failed for `%s'.\n",
+			 t->u.kernel.target->name);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static inline int
+find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
+		 unsigned int *i)
+{
+	struct arpt_entry_target *t;
+	struct arpt_target *target;
+	int ret;
+
+	ret = check_entry(e, name);
+	if (ret)
+		return ret;
+
+	t = arpt_get_target(e);
 	target = try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
 							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto out;
 	}
 	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, NF_ARP, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, 0, 0);
+	ret = check_target(e, name);
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target->checkentry
-	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
-					       e->comefrom)) {
-		duprintf("arp_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
-		ret = -EINVAL;
-		goto err;
-	}
-
 	(*i)++;
 	return 0;
 err:
@@ -611,7 +635,7 @@ static int translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				 check_entry, name, size, &i);
+				 find_check_entry, name, size, &i);
 
 	if (ret != 0) {
 		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
