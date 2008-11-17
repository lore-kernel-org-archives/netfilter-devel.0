From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8] [PATCH] use EOPNOTSUPP instead of EINVAL if the conntrack
	has no helper
Date: Mon, 17 Nov 2008 09:39:49 +0100
Message-ID: <20081117083949.11368.37228.stgit@Decadence>
References: <20081117083924.11368.38741.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55752 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752558AbYKQIjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:39:55 -0500
In-Reply-To: <20081117083924.11368.38741.stgit@Decadence>
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
index 80a3f13..d87a939 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1652,7 +1652,7 @@ ctnetlink_create_expect(struct nlattr *cda[], u_int8_t u3)
 
 	if (!help || !help->helper) {
 		/* such conntrack hasn't got any helper, abort */
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 		goto out;
 	}
 

