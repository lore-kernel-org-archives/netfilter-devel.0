Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E5FC4360F
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B5220838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfCBSgs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:48 -0500
Received: from mail.us.es ([193.147.175.20]:36098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfCBSg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A7321361B7
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18A87DA85D
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E275DA7F4; Sat,  2 Mar 2019 19:36:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16D89DA856;
        Sat,  2 Mar 2019 19:36:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BC8BD4265A2F;
        Sat,  2 Mar 2019 19:36:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/29] netfilter: conntrack: avoid same-timeout update
Date:   Sat,  2 Mar 2019 19:35:57 +0100
Message-Id: <20190302183613.3159-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need to dirty a cache line if timeout is unchanged.
Also, WARN() is useless here: we crash on 'skb->len' access
if skb is NULL.

Last, ct->timeout is u32, not 'unsigned long' so adapt the
function prototype accordingly.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 10 +++++-----
 net/netfilter/nf_conntrack_core.c    |  9 ++++-----
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b5aac5ae5129..5ee7b30b4917 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -190,23 +190,23 @@ bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 
 void __nf_ct_refresh_acct(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
-			  unsigned long extra_jiffies, int do_acct);
+			  u32 extra_jiffies, bool do_acct);
 
 /* Refresh conntrack for this many jiffies and do accounting */
 static inline void nf_ct_refresh_acct(struct nf_conn *ct,
 				      enum ip_conntrack_info ctinfo,
 				      const struct sk_buff *skb,
-				      unsigned long extra_jiffies)
+				      u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, 1);
+	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, true);
 }
 
 /* Refresh conntrack for this many jiffies */
 static inline void nf_ct_refresh(struct nf_conn *ct,
 				 const struct sk_buff *skb,
-				 unsigned long extra_jiffies)
+				 u32 extra_jiffies)
 {
-	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
+	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, false);
 }
 
 /* kill conntrack and do accounting */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 4a9107e4a69c..ff9313c579b4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1751,11 +1751,9 @@ EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 void __nf_ct_refresh_acct(struct nf_conn *ct,
 			  enum ip_conntrack_info ctinfo,
 			  const struct sk_buff *skb,
-			  unsigned long extra_jiffies,
-			  int do_acct)
+			  u32 extra_jiffies,
+			  bool do_acct)
 {
-	WARN_ON(!skb);
-
 	/* Only update if this is not a fixed timeout */
 	if (test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
 		goto acct;
@@ -1764,7 +1762,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		extra_jiffies += nfct_time_stamp;
 
-	ct->timeout = extra_jiffies;
+	if (ct->timeout != extra_jiffies)
+		ct->timeout = extra_jiffies;
 acct:
 	if (do_acct)
 		nf_ct_acct_update(ct, ctinfo, skb->len);
-- 
2.11.0


