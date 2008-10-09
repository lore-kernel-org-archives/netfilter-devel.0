From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] [PATCH] use EOPNOTSUPP instead of EINVAL if the conntrack
	has no helper
Date: Thu, 09 Oct 2008 10:34:44 +0200
Message-ID: <20081009083444.9824.95893.stgit@Decadence>
References: <20081009083339.9824.24056.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35473 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753672AbYJIIrg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:47:36 -0400
In-Reply-To: <20081009083339.9824.24056.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch changes the return value if the conntrack has no helper assigned.
Instead of EINVAL, which is reserved for malformed messages, it returns
EOPNOTSUPP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a649f7b..da2437c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1729,7 +1729,7 @@ ctnetlink_create_expect(struct nlattr *cda[], u_int8_t u3)
 
 	if (!help || !help->helper) {
 		/* such conntrack hasn't got any helper, abort */
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 		goto out;
 	}
 

