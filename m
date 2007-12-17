From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/64]: ip_tables: kill useless wrapper
Date: Tue, 18 Dec 2007 00:46:13 +0100 (MET)
Message-ID: <20071217234613.23601.32413.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38881 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXLQXqP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:15 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: kill useless wrapper

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6a19ffcd0ec70582290ae8277c9f1ef8acdb3c0e
tree bfa458d13babacd4906f10e9deea4947af2fea02
parent e75bf3477c0d63cdd1f49f91a90816e4360ffc23
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:33 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:33 +0100

 net/ipv4/netfilter/ip_tables.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 64ffe57..a8f1a2a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1479,12 +1479,6 @@ struct compat_ipt_replace {
 	struct compat_ipt_entry	entries[0];
 };
 
-static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
-		void __user **dstptr, compat_uint_t *size)
-{
-	return xt_compat_match_to_user(m, dstptr, size);
-}
-
 static int
 compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 			  compat_uint_t *size, struct xt_counters *counters,
@@ -1506,7 +1500,7 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 		goto out;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
-	ret = IPT_MATCH_ITERATE(e, compat_copy_match_to_user, dstptr, size);
+	ret = IPT_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
 		goto out;
