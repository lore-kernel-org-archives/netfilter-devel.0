Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEFDC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9764420838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfCBShd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:37:33 -0500
Received: from mail.us.es ([193.147.175.20]:36382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbfCBSha (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:37:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E46B1361B4
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45730DA84C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:37:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3AC89DA7FC; Sat,  2 Mar 2019 19:37:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45B48DA846;
        Sat,  2 Mar 2019 19:37:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:37:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EB03A4265A2F;
        Sat,  2 Mar 2019 19:37:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 21/29] netfilter: convert the proto argument from u8 to u16
Date:   Sat,  2 Mar 2019 19:37:12 +0100
Message-Id: <20190302183720.3220-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183720.3220-1-pablo@netfilter.org>
References: <20190302183720.3220-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

The proto in struct xt_match and struct xt_target is u16, when
calling xt_check_target/match, their proto argument is u8,
and will cause truncation, it is harmless to ip packet, since
ip proto is u8

if a etable's match/target has proto that is u16, will cause
the check failure.

and convert be16 to short in bridge/netfilter/ebtables.c

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h | 4 ++--
 net/bridge/netfilter/ebtables.c    | 6 +++---
 net/netfilter/x_tables.c           | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 9077b3ebea08..bf384b3eedb8 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -289,9 +289,9 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 
 int xt_check_proc_name(const char *name, unsigned int size);
 
-int xt_check_match(struct xt_mtchk_param *, unsigned int size, u_int8_t proto,
+int xt_check_match(struct xt_mtchk_param *, unsigned int size, u16 proto,
 		   bool inv_proto);
-int xt_check_target(struct xt_tgchk_param *, unsigned int size, u_int8_t proto,
+int xt_check_target(struct xt_tgchk_param *, unsigned int size, u16 proto,
 		    bool inv_proto);
 
 int xt_match_to_user(const struct xt_entry_match *m,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f77888ec93f1..eb15891f8b9f 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -381,7 +381,7 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	par->match     = match;
 	par->matchinfo = m->data;
 	ret = xt_check_match(par, m->match_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
@@ -418,7 +418,7 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 	par->target   = watcher;
 	par->targinfo = w->data;
 	ret = xt_check_target(par, w->watcher_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -744,7 +744,7 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
 	ret = xt_check_target(&tgpar, t->target_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
+	      ntohs(e->ethproto), e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 13e1ac333fa4..e5e5c64df8d1 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -461,7 +461,7 @@ int xt_check_proc_name(const char *name, unsigned int size)
 EXPORT_SYMBOL(xt_check_proc_name);
 
 int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u_int8_t proto, bool inv_proto)
+		   unsigned int size, u16 proto, bool inv_proto)
 {
 	int ret;
 
@@ -984,7 +984,7 @@ bool xt_find_jump_offset(const unsigned int *offsets,
 EXPORT_SYMBOL(xt_find_jump_offset);
 
 int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u_int8_t proto, bool inv_proto)
+		    unsigned int size, u16 proto, bool inv_proto)
 {
 	int ret;
 
-- 
2.11.0


