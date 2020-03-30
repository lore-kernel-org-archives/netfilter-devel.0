Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEE1C2D0E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CF1B206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgC3Ahd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:37:33 -0400
Received: from correo.us.es ([193.147.175.20]:57178 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgC3Ah2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DE0DEF432
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B3B9100A5A
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80D3C100A52; Mon, 30 Mar 2020 02:37:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DA41100A45;
        Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67F4842EF42A;
        Mon, 30 Mar 2020 02:37:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 25/26] netfilter: conntrack: add nf_ct_acct_add()
Date:   Mon, 30 Mar 2020 02:37:07 +0200
Message-Id: <20200330003708.54017-26-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_ct_acct_add function to update the conntrack counter
with packets and bytes.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_acct.h | 11 ++++++++++-
 net/netfilter/nf_conntrack_core.c         |  7 ++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index df198c51244a..7f44a771530e 100644
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
index 7ded6d287f87..c4582eb71766 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -865,7 +865,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
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
2.11.0

