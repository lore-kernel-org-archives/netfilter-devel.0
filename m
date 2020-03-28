Return-Path: <SRS0=EmoZ=5N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57102C43331
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Mar 2020 00:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBB420717
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Mar 2020 00:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgC1A6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Mar 2020 20:58:02 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32748 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1A6C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Mar 2020 20:58:02 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id F1F654117A;
        Sat, 28 Mar 2020 08:57:54 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/2] netfilter: conntrack: add nf_ct_acct_add()
Date:   Sat, 28 Mar 2020 08:57:53 +0800
Message-Id: <1585357074-13162-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOSk5CQkJMQk9LS01ITllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6Qjo*Kjg*TxA8KEgXGhJN
        TQtPCkJVSlVKTkNOSE5MS0xOS0hIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlNQk83Bg++
X-HM-Tid: 0a711ea532382086kuqyf1f654117a
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_ct_acct_add function to update the conntrack counter
with packets and bytes.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_conntrack_acct.h | 11 ++++++++++-
 net/netfilter/nf_conntrack_core.c         |  7 ++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index df198c5..7f44a77 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -65,7 +65,16 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
 #endif
 }
 
-void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes);
+void nf_ct_acct_add(struct nf_conn *ct, u32 dir, unsigned int packets,
+		    unsigned int bytes);
+
+static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
+				     unsigned int bytes)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	nf_ct_acct_add(ct, dir, 1, bytes);
+#endif
+}
 
 void nf_conntrack_acct_pernet_init(struct net *net);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7ded6d2..c4582eb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -865,7 +865,8 @@ static void __nf_conntrack_hash_insert(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
-void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes)
+void nf_ct_acct_add(struct nf_conn *ct, u32 dir, unsigned int packets,
+		    unsigned int bytes)
 {
 	struct nf_conn_acct *acct;
 
@@ -873,11 +874,11 @@ void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes)
 	if (acct) {
 		struct nf_conn_counter *counter = acct->counter;
 
-		atomic64_inc(&counter[dir].packets);
+		atomic64_add(packets, &counter[dir].packets);
 		atomic64_add(bytes, &counter[dir].bytes);
 	}
 }
-EXPORT_SYMBOL_GPL(nf_ct_acct_update);
+EXPORT_SYMBOL_GPL(nf_ct_acct_add);
 
 static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			     const struct nf_conn *loser_ct)
-- 
1.8.3.1

