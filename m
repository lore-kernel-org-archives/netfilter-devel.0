Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA827C04E30
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C894205ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLIT0y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:26:54 -0500
Received: from correo.us.es ([193.147.175.20]:58482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfLIT0v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13CF6120854
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 056F2DA711
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 20:26:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF403DA70F; Mon,  9 Dec 2019 20:26:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3A09DA710;
        Mon,  9 Dec 2019 20:26:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B7C7A41E4800;
        Mon,  9 Dec 2019 20:26:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/17] netfilter: conntrack: tell compiler to not inline nf_ct_resolve_clash
Date:   Mon,  9 Dec 2019 20:26:26 +0100
Message-Id: <20191209192638.71184-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

At this time compiler inlines it, but this code will not be executed
under normal conditions.

Also, no inlining allows to use "nf_ct_resolve_clash%return" perf probe.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0af1898af2b8..f475fec84536 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -895,9 +895,10 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 }
 
 /* Resolve race on insertion if this protocol allows this. */
-static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
-			       enum ip_conntrack_info ctinfo,
-			       struct nf_conntrack_tuple_hash *h)
+static __cold noinline int
+nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
+		    enum ip_conntrack_info ctinfo,
+		    struct nf_conntrack_tuple_hash *h)
 {
 	/* This is the conntrack entry already in hashes that won race. */
 	struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
-- 
2.11.0

