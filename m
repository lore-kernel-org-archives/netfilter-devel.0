Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B53C3524D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572032082E
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgBCQh1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:37:27 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59388 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731066AbgBCQhY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 11:37:24 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iyeiw-0005YR-Dl; Mon, 03 Feb 2020 17:37:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/4] netfilter: conntrack: place confirm-bit setting in a helper
Date:   Mon,  3 Feb 2020 17:37:05 +0100
Message-Id: <20200203163707.27254-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203163707.27254-1-fw@strlen.de>
References: <20200203163707.27254-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... so it can be re-used from clash resolution in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5e332b01f3c0..5fda5bd10160 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -894,6 +894,19 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	}
 }
 
+static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
+{
+	struct nf_conn_tstamp *tstamp;
+
+	atomic_inc(&ct->ct_general.use);
+	ct->status |= IPS_CONFIRMED;
+
+	/* set conntrack timestamp, if enabled. */
+	tstamp = nf_conn_tstamp_find(ct);
+	if (tstamp)
+		tstamp->start = ktime_get_real_ns();
+}
+
 /**
  * nf_ct_resolve_clash - attempt to handle clash without packet drop
  *
@@ -965,7 +978,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
-	struct nf_conn_tstamp *tstamp;
 	struct hlist_nulls_node *n;
 	enum ip_conntrack_info ctinfo;
 	struct net *net;
@@ -1042,13 +1054,8 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
 	ct->timeout += nfct_time_stamp;
-	atomic_inc(&ct->ct_general.use);
-	ct->status |= IPS_CONFIRMED;
 
-	/* set conntrack timestamp, if enabled. */
-	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp)
-		tstamp->start = ktime_get_real_ns();
+	__nf_conntrack_insert_prepare(ct);
 
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
-- 
2.24.1

