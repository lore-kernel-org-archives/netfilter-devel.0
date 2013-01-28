From: pablo@netfilter.org
Subject: [stable-3.7 14/14] netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
Date: Mon, 28 Jan 2013 20:31:33 +0100
Message-ID: <1359401493-6196-15-git-send-email-pablo@netfilter.org>
References: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50546 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3A1TcH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:32:07 -0500
In-Reply-To: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jesper Juhl <jj@chaosbits.net>

This patch fixes a leak in one of the error paths of
ctnetlink_create_expect if no helper and no timeout is specified.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7bbfb3d..ef9e86e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2514,7 +2514,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (!help) {
 		if (!cda[CTA_EXPECT_TIMEOUT]) {
 			err = -EINVAL;
-			goto out;
+			goto err_out;
 		}
 		exp->timeout.expires =
 		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
-- 
1.7.10.4

