Return-Path: <SRS0=4QBM=ZU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E64C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 12:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 666092158A
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Nov 2019 12:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfK1MZz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 07:25:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57726 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfK1MZz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 07:25:55 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iaIrp-0001wt-89; Thu, 28 Nov 2019 13:25:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: tell compile to not inline nf_ct_resolve_clash
Date:   Thu, 28 Nov 2019 13:25:48 +0100
Message-Id: <20191128122548.20080-1-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time compiler inlines it, but this code will not be executed
under normal conditions.

Also, no inlining allows to use "nf_ct_resolve_clash%return" perf probe.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0af1898af2b8..739b193970b6 100644
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
2.23.0

