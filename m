From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/64]: arp_tables: move ARPT_SO_GET_INFO handling to seperate function
Date: Tue, 18 Dec 2007 00:46:54 +0100 (MET)
Message-ID: <20071217234653.23601.8856.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38969 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbXLQXqz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:55 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: move ARPT_SO_GET_INFO handling to seperate function

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e6ccb061713d8286be8f9c885268d8c4cdbfb07e
tree 98ea964ea959e134a83e14d6c7a816d335a34781
parent f858d36b5f774655b3dd9a08a6502a8e2df1bb63
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:13 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 net/ipv4/netfilter/arp_tables.c |   88 ++++++++++++++++++++-------------------
 1 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index eaca06e..33e8d53 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -782,6 +782,49 @@ static int copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
+static int get_info(void __user *user, int *len)
+{
+	char name[ARPT_TABLE_MAXNAMELEN];
+	struct arpt_table *t;
+	int ret;
+
+	if (*len != sizeof(struct arpt_getinfo)) {
+		duprintf("length %u != %Zu\n", *len,
+			 sizeof(struct arpt_getinfo));
+		return -EINVAL;
+	}
+
+	if (copy_from_user(name, user, sizeof(name)) != 0)
+		return -EFAULT;
+
+	name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
+
+	t = try_then_request_module(xt_find_table_lock(NF_ARP, name),
+				    "arptable_%s", name);
+	if (t && !IS_ERR(t)) {
+		struct arpt_getinfo info;
+		struct xt_table_info *private = t->private;
+
+		info.valid_hooks = t->valid_hooks;
+		memcpy(info.hook_entry, private->hook_entry,
+		       sizeof(info.hook_entry));
+		memcpy(info.underflow, private->underflow,
+		       sizeof(info.underflow));
+		info.num_entries = private->number;
+		info.size = private->size;
+		strcpy(info.name, name);
+
+		if (copy_to_user(user, &info, *len) != 0)
+			ret = -EFAULT;
+		else
+			ret = 0;
+		xt_table_unlock(t);
+		module_put(t->me);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
+	return ret;
+}
+
 static int get_entries(const struct arpt_get_entries *entries,
 		       struct arpt_get_entries __user *uptr)
 {
@@ -1008,48 +1051,9 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 		return -EPERM;
 
 	switch (cmd) {
-	case ARPT_SO_GET_INFO: {
-		char name[ARPT_TABLE_MAXNAMELEN];
-		struct arpt_table *t;
-
-		if (*len != sizeof(struct arpt_getinfo)) {
-			duprintf("length %u != %Zu\n", *len,
-				 sizeof(struct arpt_getinfo));
-			ret = -EINVAL;
-			break;
-		}
-
-		if (copy_from_user(name, user, sizeof(name)) != 0) {
-			ret = -EFAULT;
-			break;
-		}
-		name[ARPT_TABLE_MAXNAMELEN-1] = '\0';
-
-		t = try_then_request_module(xt_find_table_lock(NF_ARP, name),
-					    "arptable_%s", name);
-		if (t && !IS_ERR(t)) {
-			struct arpt_getinfo info;
-			struct xt_table_info *private = t->private;
-
-			info.valid_hooks = t->valid_hooks;
-			memcpy(info.hook_entry, private->hook_entry,
-			       sizeof(info.hook_entry));
-			memcpy(info.underflow, private->underflow,
-			       sizeof(info.underflow));
-			info.num_entries = private->number;
-			info.size = private->size;
-			strcpy(info.name, name);
-
-			if (copy_to_user(user, &info, *len) != 0)
-				ret = -EFAULT;
-			else
-				ret = 0;
-			xt_table_unlock(t);
-			module_put(t->me);
-		} else
-			ret = t ? PTR_ERR(t) : -ENOENT;
-	}
-	break;
+	case ARPT_SO_GET_INFO:
+		ret = get_info(user, len);
+		break;
 
 	case ARPT_SO_GET_ENTRIES: {
 		struct arpt_get_entries get;
