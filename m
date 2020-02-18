Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F91C3404C
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8419A2067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 22:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBRWVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 17:21:15 -0500
Received: from correo.us.es ([193.147.175.20]:57516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgBRWVM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5186C303D16
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42C51DA3A9
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2020 23:21:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38065DA3A5; Tue, 18 Feb 2020 23:21:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A475DA38D;
        Tue, 18 Feb 2020 23:21:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 28E9F42EE38E;
        Tue, 18 Feb 2020 23:21:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/9] netfilter: conntrack: split resolve_clash function
Date:   Tue, 18 Feb 2020 23:20:58 +0100
Message-Id: <20200218222101.635808-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Followup patch will need a helper function with the 'clashing entries
refer to the identical tuple in both directions' resolution logic.

This patch will add another resolve_clash helper where loser_ct must
not be added to the dying list because it will be inserted into the
table.

Therefore this also moves the stat counters and dying-list insertion
of the losing ct.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 58 +++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5fda5bd10160..3f069eb0f0fc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -907,6 +907,39 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 		tstamp->start = ktime_get_real_ns();
 }
 
+static int __nf_ct_resolve_clash(struct sk_buff *skb,
+				 struct nf_conntrack_tuple_hash *h)
+{
+	/* This is the conntrack entry already in hashes that won race. */
+	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *loser_ct;
+
+	loser_ct = nf_ct_get(skb, &ctinfo);
+
+	if (nf_ct_is_dying(ct))
+		return NF_DROP;
+
+	if (!atomic_inc_not_zero(&ct->ct_general.use))
+		return NF_DROP;
+
+	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
+	    nf_ct_match(ct, loser_ct)) {
+		struct net *net = nf_ct_net(ct);
+
+		nf_ct_acct_merge(ct, ctinfo, loser_ct);
+		nf_ct_add_to_dying_list(loser_ct);
+		nf_conntrack_put(&loser_ct->ct_general);
+		nf_ct_set(skb, ct, ctinfo);
+
+		NF_CT_STAT_INC(net, insert_failed);
+		return NF_ACCEPT;
+	}
+
+	nf_ct_put(ct);
+	return NF_DROP;
+}
+
 /**
  * nf_ct_resolve_clash - attempt to handle clash without packet drop
  *
@@ -941,31 +974,23 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h)
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *loser_ct;
 	struct net *net;
+	int ret;
 
 	loser_ct = nf_ct_get(skb, &ctinfo);
+	net = nf_ct_net(loser_ct);
 
 	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
 	if (!l4proto->allow_clash)
 		goto drop;
 
-	if (nf_ct_is_dying(ct))
-		goto drop;
-
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
-		goto drop;
-
-	if (((ct->status & IPS_NAT_DONE_MASK) == 0) ||
-	    nf_ct_match(ct, loser_ct)) {
-		nf_ct_acct_merge(ct, ctinfo, loser_ct);
-		nf_conntrack_put(&loser_ct->ct_general);
-		nf_ct_set(skb, ct, ctinfo);
-		return NF_ACCEPT;
-	}
+	ret = __nf_ct_resolve_clash(skb, h);
+	if (ret == NF_ACCEPT)
+		return ret;
 
-	nf_ct_put(ct);
 drop:
-	net = nf_ct_net(loser_ct);
+	nf_ct_add_to_dying_list(loser_ct);
 	NF_CT_STAT_INC(net, drop);
+	NF_CT_STAT_INC(net, insert_failed);
 	return NF_DROP;
 }
 
@@ -1034,6 +1059,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 	if (unlikely(nf_ct_is_dying(ct))) {
 		nf_ct_add_to_dying_list(ct);
+		NF_CT_STAT_INC(net, insert_failed);
 		goto dying;
 	}
 
@@ -1075,11 +1101,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	return NF_ACCEPT;
 
 out:
-	nf_ct_add_to_dying_list(ct);
 	ret = nf_ct_resolve_clash(skb, h);
 dying:
 	nf_conntrack_double_unlock(hash, reply_hash);
-	NF_CT_STAT_INC(net, insert_failed);
 	local_bh_enable();
 	return ret;
 }
-- 
2.11.0

