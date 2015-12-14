From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable] netfilter: ctnetlink: put back references to master ct and expect objects
Date: Mon, 14 Dec 2015 20:49:58 +0100
Message-ID: <1450122598-24145-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[ upstream commit 95dd8653de658143770cb0e55a58d2aab97c79d2 ]

We have to put back the references to the master conntrack and the expectation
that we just created, otherwise we'll leak them.

Fixes: 0ef71ee1a5b9 ("netfilter: ctnetlink: refactor ctnetlink_create_expect")
Cc: <stable@vger.kernel.org> # 3.12.x
Cc: <stable@vger.kernel.org> # 3.14.x
Cc: <stable@vger.kernel.org> # 3.18.x
Cc: <stable@vger.kernel.org> # 4.1.x
Reported-by: Tim Wiess <Tim.Wiess@watchguard.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d1c2394..6b8b0ab 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2995,11 +2995,6 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	}
 
 	err = nf_ct_expect_related_report(exp, portid, report);
-	if (err < 0)
-		goto err_exp;
-
-	return 0;
-err_exp:
 	nf_ct_expect_put(exp);
 err_ct:
 	nf_ct_put(ct);
-- 
1.7.10.4
