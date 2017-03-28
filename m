From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: ctlink: Return error directly when create expect without help
Date: Tue, 28 Mar 2017 09:52:52 +0800
Message-ID: <1490665972-10967-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:35228 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753757AbdC1BxP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 21:53:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The expect check func "__nf_ct_expect_check" asks the master_help is
necessary. So it is unnecessary to go ahead in ctnetlink_alloc_expect
when there is no help.

Actually the commit bc01befdcf3e ("netfilter: ctnetlink: add support
for user-space expectation helpers") permits ctlink create one expect
even though there is no master help. But the latter commit 3d058d7bc2c5
("netfilter: rework user-space expectation helper support") disables
it again.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_netlink.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d49cc1e..c9af545 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3049,18 +3049,8 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 
 	help = nfct_help(ct);
 	if (!help) {
-		if (!cda[CTA_EXPECT_TIMEOUT]) {
-			err = -EINVAL;
-			goto err_out;
-		}
-		exp->timeout.expires =
-		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
-
-		exp->flags = NF_CT_EXPECT_USERSPACE;
-		if (cda[CTA_EXPECT_FLAGS]) {
-			exp->flags |=
-				ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-		}
+		err = -EOPNOTSUPP;
+		goto err_out;
 	} else {
 		if (cda[CTA_EXPECT_FLAGS]) {
 			exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
-- 
1.9.1




