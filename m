From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/64]: ip6_tables: resync get_entries() with ip_tables
Date: Tue, 18 Dec 2007 00:46:30 +0100 (MET)
Message-ID: <20071217234630.23601.36747.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38917 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbXLQXqb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:31 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: resync get_entries() with ip_tables

Resync get_entries() with ip_tables.c by moving the checks from the
setsockopt handler to the function itself.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 740665f37ee927ca922fc0d978c3b3ba354ee220
tree b9bdc111631299d98599c096053423206f7936a0
parent 979e9b44e40aa3a26a174d3ccbdac4941e100287
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:49 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:21 +0100

 net/ipv6/netfilter/ip6_tables.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 681316e..6fcc0d5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1082,17 +1082,29 @@ static int get_info(void __user *user, int *len)
 }
 
 static int
-get_entries(const struct ip6t_get_entries *entries,
-	    struct ip6t_get_entries __user *uptr)
+get_entries(struct ip6t_get_entries __user *uptr, int *len)
 {
 	int ret;
+	struct ip6t_get_entries get;
 	struct xt_table *t;
 
-	t = xt_find_table_lock(AF_INET6, entries->name);
+	if (*len < sizeof(get)) {
+		duprintf("get_entries: %u < %u\n", *len, sizeof(get));
+		return -EINVAL;
+	}
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+	if (*len != sizeof(struct ip6t_get_entries) + get.size) {
+		duprintf("get_entries: %u != %u\n", *len,
+			 sizeof(struct ip6t_get_entries) + get.size);
+		return -EINVAL;
+	}
+
+	t = xt_find_table_lock(AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n", private->number);
-		if (entries->size == private->size)
+		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
@@ -1322,22 +1334,9 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		ret = get_info(user, len);
 		break;
 
-	case IP6T_SO_GET_ENTRIES: {
-		struct ip6t_get_entries get;
-
-		if (*len < sizeof(get)) {
-			duprintf("get_entries: %u < %u\n", *len, sizeof(get));
-			ret = -EINVAL;
-		} else if (copy_from_user(&get, user, sizeof(get)) != 0) {
-			ret = -EFAULT;
-		} else if (*len != sizeof(struct ip6t_get_entries) + get.size) {
-			duprintf("get_entries: %u != %u\n", *len,
-				 sizeof(struct ip6t_get_entries) + get.size);
-			ret = -EINVAL;
-		} else
-			ret = get_entries(&get, user);
+	case IP6T_SO_GET_ENTRIES:
+		ret = get_entries(user, len);
 		break;
-	}
 
 	case IP6T_SO_GET_REVISION_MATCH:
 	case IP6T_SO_GET_REVISION_TARGET: {
