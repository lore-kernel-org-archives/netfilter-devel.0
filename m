From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/9] netfilter: nfnetlink_queue: fix memory leak when attach expectation successfully
Date: Wed, 10 Aug 2016 20:56:31 +0200
Message-ID: <1470855394-7234-7-git-send-email-pablo@netfilter.org>
References: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54960 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938876AbcHJS4t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:56:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6841A1F18CF
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 585C0100A69
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 77790100A63
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:56:43 +0200 (CEST)
In-Reply-To: <1470855394-7234-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

User can use NFQA_EXP to attach expectations to conntracks, but we
forget to put back nf_conntrack_expect when it is inserted successfully,
i.e. in this normal case, expect's use refcnt will be 3. So even we
unlink it and put it back later, the use refcnt is still 1, then the
memory will be leaked forever.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 050bb34..b9bfe64 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2362,12 +2362,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 		return PTR_ERR(exp);
 
 	err = nf_ct_expect_related_report(exp, portid, report);
-	if (err < 0) {
-		nf_ct_expect_put(exp);
-		return err;
-	}
-
-	return 0;
+	nf_ct_expect_put(exp);
+	return err;
 }
 
 static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
-- 
2.1.4

