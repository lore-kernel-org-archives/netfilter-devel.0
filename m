From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/64]: ip6_tables: move IP6T_SO_GET_INFO handling to seperate function
Date: Tue, 18 Dec 2007 00:46:29 +0100 (MET)
Message-ID: <20071217234628.23601.44956.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbXLQXqa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:30 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: move IP6T_SO_GET_INFO handling to seperate function

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 979e9b44e40aa3a26a174d3ccbdac4941e100287
tree 79544ffd7f1159026d47b9a32b2760e7735cd198
parent 0d3ec012848cbfbdce1903f38af6991c81651ba8
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:47 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:20 +0100

 net/ipv6/netfilter/ip6_tables.c |   89 +++++++++++++++++++++------------------
 1 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 02be4fc..681316e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1037,6 +1037,50 @@ copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
+static int get_info(void __user *user, int *len)
+{
+	char name[IP6T_TABLE_MAXNAMELEN];
+	struct xt_table *t;
+	int ret;
+
+	if (*len != sizeof(struct ip6t_getinfo)) {
+		duprintf("length %u != %u\n", *len,
+			 sizeof(struct ip6t_getinfo));
+		return -EINVAL;
+	}
+
+	if (copy_from_user(name, user, sizeof(name)) != 0)
+		return -EFAULT;
+
+	name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
+
+	t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
+				    "ip6table_%s", name);
+	if (t && !IS_ERR(t)) {
+		struct ip6t_getinfo info;
+		struct xt_table_info *private = t->private;
+
+		info.valid_hooks = t->valid_hooks;
+		memcpy(info.hook_entry, private->hook_entry,
+		       sizeof(info.hook_entry));
+		memcpy(info.underflow, private->underflow,
+		       sizeof(info.underflow));
+		info.num_entries = private->number;
+		info.size = private->size;
+		memcpy(info.name, name, sizeof(info.name));
+
+		if (copy_to_user(user, &info, *len) != 0)
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		xt_table_unlock(t);
+		module_put(t->me);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
+	return ret;
+}
+
 static int
 get_entries(const struct ip6t_get_entries *entries,
 	    struct ip6t_get_entries __user *uptr)
@@ -1274,48 +1318,9 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		return -EPERM;
 
 	switch (cmd) {
-	case IP6T_SO_GET_INFO: {
-		char name[IP6T_TABLE_MAXNAMELEN];
-		struct xt_table *t;
-
-		if (*len != sizeof(struct ip6t_getinfo)) {
-			duprintf("length %u != %u\n", *len,
-				 sizeof(struct ip6t_getinfo));
-			ret = -EINVAL;
-			break;
-		}
-
-		if (copy_from_user(name, user, sizeof(name)) != 0) {
-			ret = -EFAULT;
-			break;
-		}
-		name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
-
-		t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
-					    "ip6table_%s", name);
-		if (t && !IS_ERR(t)) {
-			struct ip6t_getinfo info;
-			struct xt_table_info *private = t->private;
-
-			info.valid_hooks = t->valid_hooks;
-			memcpy(info.hook_entry, private->hook_entry,
-			       sizeof(info.hook_entry));
-			memcpy(info.underflow, private->underflow,
-			       sizeof(info.underflow));
-			info.num_entries = private->number;
-			info.size = private->size;
-			memcpy(info.name, name, sizeof(info.name));
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
+	case IP6T_SO_GET_INFO:
+		ret = get_info(user, len);
+		break;
 
 	case IP6T_SO_GET_ENTRIES: {
 		struct ip6t_get_entries get;
