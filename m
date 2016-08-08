From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nfnetlink_queue: fix memory leak when attach expectation successfully
Date: Mon,  8 Aug 2016 22:03:40 +0800
Message-ID: <1470665020-19882-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:50095 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcHHOEH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:04:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

User can use NFQA_EXP to attach expectations to conntracks, but we
forget to put back nf_conntrack_expect when it is inserted successfully,
i.e. in this normal case, expect's use refcnt will be 3. So even we
unlink it and put it back later, the use refcnt is still 1, then the
memory will be leaked forever.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
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
2.5.5


