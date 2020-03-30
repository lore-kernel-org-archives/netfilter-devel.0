Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FEAC2D0E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D539A206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgC3AiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:38:08 -0400
Received: from correo.us.es ([193.147.175.20]:57126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgC3AhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54C7CEF438
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 466D9100A55
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39D05100A4E; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B24A100A55;
        Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2422442EF42A;
        Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/26] netfilter: conntrack: export nf_ct_acct_update()
Date:   Mon, 30 Mar 2020 02:36:52 +0200
Message-Id: <20200330003708.54017-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function allows you to update the conntrack counters.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_acct.h |  2 ++
 net/netfilter/nf_conntrack_core.c         | 15 +++++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index f7a060c6eb28..df198c51244a 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -65,6 +65,8 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
 #endif
 }
 
+void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes);
+
 void nf_conntrack_acct_pernet_init(struct net *net);
 
 int nf_conntrack_acct_init(void);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f82d4a802acc..7ded6d287f87 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -865,9 +865,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
 
-static inline void nf_ct_acct_update(struct nf_conn *ct,
-				     enum ip_conntrack_info ctinfo,
-				     unsigned int len)
+void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes)
 {
 	struct nf_conn_acct *acct;
 
@@ -875,10 +873,11 @@ static inline void nf_ct_acct_update(struct nf_conn *ct,
 	if (acct) {
 		struct nf_conn_counter *counter = acct->counter;
 
-		atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
-		atomic64_add(len, &counter[CTINFO2DIR(ctinfo)].bytes);
+		atomic64_inc(&counter[dir].packets);
+		atomic64_add(bytes, &counter[dir].bytes);
 	}
 }
+EXPORT_SYMBOL_GPL(nf_ct_acct_update);
 
 static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			     const struct nf_conn *loser_ct)
@@ -892,7 +891,7 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 
 		/* u32 should be fine since we must have seen one packet. */
 		bytes = atomic64_read(&counter[CTINFO2DIR(ctinfo)].bytes);
-		nf_ct_acct_update(ct, ctinfo, bytes);
+		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), bytes);
 	}
 }
 
@@ -1933,7 +1932,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 		WRITE_ONCE(ct->timeout, extra_jiffies);
 acct:
 	if (do_acct)
-		nf_ct_acct_update(ct, ctinfo, skb->len);
+		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
@@ -1941,7 +1940,7 @@ bool nf_ct_kill_acct(struct nf_conn *ct,
 		     enum ip_conntrack_info ctinfo,
 		     const struct sk_buff *skb)
 {
-	nf_ct_acct_update(ct, ctinfo, skb->len);
+	nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
 
 	return nf_ct_delete(ct, 0, 0);
 }
-- 
2.11.0

