Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09712C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 08:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F3F2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 08:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfBVI7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:59:45 -0500
Received: from mx139-tc.baidu.com ([61.135.168.139]:28294 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbfBVI7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 03:59:45 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id EC0681EBA003;
        Fri, 22 Feb 2019 16:51:11 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH][nf-next] netfilter: convert the proto argument from u8 to u16
Date:   Fri, 22 Feb 2019 16:51:11 +0800
Message-Id: <1550825471-32071-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The proto in struct xt_match and struct xt_target is u16, when
calling xt_check_target/match, their proto argument is u8,
and will cause truncation, it is harmless to ip packet, since
ip proto is u8

if a L2 match/target has proto that is u16, will cause the check
failure.

and convert be16 to short in bridge/netfilter/ebtables.c

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netfilter/x_tables.h | 4 ++--
 net/bridge/netfilter/ebtables.c    | 6 +++---
 net/netfilter/x_tables.c           | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9077b3ebea08..8ba6a6227542 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -289,9 +289,9 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 
 int xt_check_proc_name(const char *name, unsigned int size);
 
-int xt_check_match(struct xt_mtchk_param *, unsigned int size, u_int8_t proto,
+int xt_check_match(struct xt_mtchk_param *, unsigned int size, u_int16_t proto,
 		   bool inv_proto);
-int xt_check_target(struct xt_tgchk_param *, unsigned int size, u_int8_t proto,
+int xt_check_target(struct xt_tgchk_param *, unsigned int size, u_int16_t proto,
 		    bool inv_proto);
 
 int xt_match_to_user(const struct xt_entry_match *m,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 6693e209efe8..7bbb9b189752 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -385,7 +385,7 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	par->match     = match;
 	par->matchinfo = m->data;
 	ret = xt_check_match(par, m->match_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
@@ -422,7 +422,7 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 	par->target   = watcher;
 	par->targinfo = w->data;
 	ret = xt_check_target(par, w->watcher_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -767,7 +767,7 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
 	ret = xt_check_target(&tgpar, t->target_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 13e1ac333fa4..5b61146443ad 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -461,7 +461,7 @@ int xt_check_proc_name(const char *name, unsigned int size)
 EXPORT_SYMBOL(xt_check_proc_name);
 
 int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u_int8_t proto, bool inv_proto)
+		   unsigned int size, u_int16_t proto, bool inv_proto)
 {
 	int ret;
 
@@ -984,7 +984,7 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 EXPORT_SYMBOL(xt_find_jump_offset);
 
 int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u_int8_t proto, bool inv_proto)
+		    unsigned int size, u_int16_t proto, bool inv_proto)
 {
 	int ret;
 
-- 
2.16.2

