From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: xtables: Remove unused variable in compat_copy_entry_from_user()
Date: Sat, 29 Jul 2017 20:31:00 +0900
Message-ID: <20170729113100.17554-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34342 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753788AbdG2LbH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jul 2017 07:31:07 -0400
Received: by mail-pg0-f66.google.com with SMTP id v190so25995527pgv.1
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jul 2017 04:31:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The target variable is not used in the compat_copy_entry_from_user().
So It can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv4/netfilter/arp_tables.c | 2 --
 net/ipv4/netfilter/ip_tables.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 0bc3c3d..cf520d3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1117,7 +1117,6 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
 			    struct xt_table_info *newinfo, unsigned char *base)
 {
 	struct xt_entry_target *t;
-	struct xt_target *target;
 	struct arpt_entry *de;
 	unsigned int origsize;
 	int h;
@@ -1132,7 +1131,6 @@ compat_copy_entry_from_user(struct compat_arpt_entry *e, void **dstptr,
 
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = compat_arpt_get_target(e);
-	target = t->u.kernel.target;
 	xt_compat_target_from_user(t, dstptr, size);
 
 	de->next_offset = e->next_offset - (origsize - *size);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2a55a40..f47e8da 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1355,7 +1355,6 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 			    struct xt_table_info *newinfo, unsigned char *base)
 {
 	struct xt_entry_target *t;
-	struct xt_target *target;
 	struct ipt_entry *de;
 	unsigned int origsize;
 	int h;
@@ -1374,7 +1373,6 @@ compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
 
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = compat_ipt_get_target(e);
-	target = t->u.kernel.target;
 	xt_compat_target_from_user(t, dstptr, size);
 
 	de->next_offset = e->next_offset - (origsize - *size);
-- 
2.9.3

