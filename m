From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter:ipset: fix checking the type revision at create command
Date: Sat, 19 Mar 2011 10:00:18 +0100
Message-ID: <1300525218-18471-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1300525218-18471-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1300525218-18471-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50592 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab1CSJAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:00:20 -0400
In-Reply-To: <1300525218-18471-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The revision of the set type was not checked at the create command: if the
userspace sent a valid set type but with not supported revision number,
it'd create a loop.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 618a615..b11cc5e 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -94,16 +94,28 @@ static int
 find_set_type_get(const char *name, u8 family, u8 revision,
 		  struct ip_set_type **found)
 {
+	struct ip_set_type *type;
+	int err;
+
 	rcu_read_lock();
 	*found = find_set_type(name, family, revision);
 	if (*found) {
-		int err = !try_module_get((*found)->me);
-		rcu_read_unlock();
-		return err ? -EFAULT : 0;
+		err = !try_module_get((*found)->me) ? -EFAULT : 0;
+		goto unlock;
 	}
+	/* Make sure the type is loaded but we don't support the revision */
+	list_for_each_entry_rcu(type, &ip_set_type_list, list)
+		if (STREQ(type->name, name)) {
+			err = -IPSET_ERR_FIND_TYPE;
+			goto unlock;
+		}
 	rcu_read_unlock();
 
 	return try_to_load_type(name);
+
+unlock:
+	rcu_read_unlock();
+	return err;
 }
 
 /* Find a given set type by name and family.
@@ -116,7 +128,7 @@ find_set_type_minmax(const char *name, u8 family, u8 *min, u8 *max)
 	struct ip_set_type *type;
 	bool found = false;
 
-	*min = *max = 0;
+	*min = 255; *max = 0;
 	rcu_read_lock();
 	list_for_each_entry_rcu(type, &ip_set_type_list, list)
 		if (STREQ(type->name, name) &&
-- 
1.7.0.4

