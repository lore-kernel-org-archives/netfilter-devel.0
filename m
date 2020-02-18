Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07942C3404C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D921E2067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgBRWV0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:21:26 -0500
Received: from correo.us.es ([193.147.175.20]:57504 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726749AbgBRWVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 003A2303D12
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4205DA3A8
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9A01DA3A4; Tue, 18 Feb 2020 23:21:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 054A7DA3A1;
        Tue, 18 Feb 2020 23:21:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D437242EE38E;
        Tue, 18 Feb 2020 23:21:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/9] netfilter: conntrack: place confirm-bit setting in a helper
Date:   Tue, 18 Feb 2020 23:20:57 +0100
Message-Id: <20200218222101.635808-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

... so it can be re-used from clash resolution in followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

