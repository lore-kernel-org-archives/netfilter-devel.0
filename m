From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/64]: x_tables: make xt_compat_match_from_user usable in iterator macros
Date: Tue, 18 Dec 2007 00:46:16 +0100 (MET)
Message-ID: <20071217234616.23601.85860.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38887 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXLQXqR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:17 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: make xt_compat_match_from_user usable in iterator macros

Make xt_compat_match_from_user return an int to make it usable in the
*tables iterator macros and kill a now unnecessary wrapper function.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 38d8a2e416379a76ad9feb3757b1c60e9573f675
tree afb49e3cc317698b9e51b982b5da239d06a39e15
parent 4cf89c9646b142291b7623c94daa8e61ab1b4766
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:36 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:57:36 +0100

 include/linux/netfilter/x_tables.h |    4 ++--
 net/ipv4/netfilter/ip_tables.c     |   13 +------------
 net/netfilter/x_tables.c           |    5 +++--
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index e305f2d..616e6f4 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -382,8 +382,8 @@ extern void xt_compat_lock(int af);
 extern void xt_compat_unlock(int af);
 
 extern int xt_compat_match_offset(struct xt_match *match);
-extern void xt_compat_match_from_user(struct xt_entry_match *m,
-				      void **dstptr, int *size);
+extern int xt_compat_match_from_user(struct xt_entry_match *m,
+				     void **dstptr, int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
 				   void __user **dstptr, int *size);
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7d24262..4586af3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1654,16 +1654,6 @@ release_matches:
 	return ret;
 }
 
-static inline int
-compat_copy_match_from_user(struct ipt_entry_match *m,
-			    void **dstptr, compat_uint_t *size,
-			    const char *name, const struct ipt_ip *ip,
-			    unsigned int hookmask)
-{
-	xt_compat_match_from_user(m, dstptr, size);
-	return 0;
-}
-
 static int
 compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 			    unsigned int *size, const char *name,
@@ -1681,8 +1671,7 @@ compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 	memcpy(de, e, sizeof(struct ipt_entry));
 
 	*dstptr += sizeof(struct compat_ipt_entry);
-	ret = IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
-				name, &de->ip, de->comefrom);
+	ret = IPT_MATCH_ITERATE(e, xt_compat_match_from_user, dstptr, size);
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 07bb465..b95284e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -342,8 +342,8 @@ int xt_compat_match_offset(struct xt_match *match)
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_offset);
 
-void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
-			       int *size)
+int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
+			      int *size)
 {
 	struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
@@ -365,6 +365,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 
 	*size += off;
 	*dstptr += msize;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 
