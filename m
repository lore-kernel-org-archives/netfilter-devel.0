From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/64]: arp_tables: resync get_entries() with ip_tables
Date: Tue, 18 Dec 2007 00:46:55 +0100 (MET)
Message-ID: <20071217234655.23601.37992.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38972 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbXLQXq4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:56 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: resync get_entries() with ip_tables

Resync get_entries() with ip_tables.c by moving the checks from the
setsockopt handler to the function itself.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 283dfad814dcb078afba8a6048feb4701d78bdfc
tree 9da46687ff88924c0b1afb8eae6802f3579f2644
parent e6ccb061713d8286be8f9c885268d8c4cdbfb07e
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:15 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 net/ipv4/netfilter/arp_tables.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 33e8d53..029df76 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -825,23 +825,35 @@ static int get_info(void __user *user, int *len)
 	return ret;
 }
 
-static int get_entries(const struct arpt_get_entries *entries,
-		       struct arpt_get_entries __user *uptr)
+static int get_entries(struct arpt_get_entries __user *uptr, int *len)
 {
 	int ret;
+	struct arpt_get_entries get;
 	struct arpt_table *t;
 
-	t = xt_find_table_lock(NF_ARP, entries->name);
+	if (*len < sizeof(get)) {
+		duprintf("get_entries: %u < %Zu\n", *len, sizeof(get));
+		return -EINVAL;
+	}
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+	if (*len != sizeof(struct arpt_get_entries) + get.size) {
+		duprintf("get_entries: %u != %Zu\n", *len,
+			 sizeof(struct arpt_get_entries) + get.size);
+		return -EINVAL;
+	}
+
+	t = xt_find_table_lock(NF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n",
 			 private->number);
-		if (entries->size == private->size)
+		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, entries->size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		module_put(t->me);
@@ -1055,22 +1067,9 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 		ret = get_info(user, len);
 		break;
 
-	case ARPT_SO_GET_ENTRIES: {
-		struct arpt_get_entries get;
-
-		if (*len < sizeof(get)) {
-			duprintf("get_entries: %u < %Zu\n", *len, sizeof(get));
-			ret = -EINVAL;
-		} else if (copy_from_user(&get, user, sizeof(get)) != 0) {
-			ret = -EFAULT;
-		} else if (*len != sizeof(struct arpt_get_entries) + get.size) {
-			duprintf("get_entries: %u != %Zu\n", *len,
-				 sizeof(struct arpt_get_entries) + get.size);
-			ret = -EINVAL;
-		} else
-			ret = get_entries(&get, user);
+	case ARPT_SO_GET_ENTRIES:
+		ret = get_entries(user, len);
 		break;
-	}
 
 	case ARPT_SO_GET_REVISION_TARGET: {
 		struct xt_get_revision rev;
