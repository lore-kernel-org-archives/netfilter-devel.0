From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 2/3] netfilter: nfnetlink: relax strict multicast group from netlink_bind
Date: Mon,  5 Jan 2015 12:06:26 +0100
Message-ID: <1420455986-5800-2-git-send-email-pablo@netfilter.org>
References: <1420455986-5800-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52241 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbbAELDw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:03:52 -0500
In-Reply-To: <1420455986-5800-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Relax the checking that was introduced in 97840cb ("netfilter:
nfnetlink: fix insufficient validation in nfnetlink_bind") when the
subscription bitmask is used. Existing userspace code code may request
to listen to all of the existing netlink groups by setting an all to one
subscription group bitmask. Netlink already validates subscription via
setsockopt() for us.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c6619d4..5082d81 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -469,8 +469,11 @@ static int nfnetlink_bind(int group)
 	const struct nfnetlink_subsystem *ss;
 	int type;
 
+	/* No strict check for groups when subscription bitmask is used, group
+	 * binding via setsockopt() already rejects this from netlink.
+	 */
 	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
-		return -EINVAL;
+		return 0;
 
 	type = nfnl_group2type[group];
 
-- 
1.7.10.4

