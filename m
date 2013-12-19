From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next 2/2] netfilter: ctnetlink: honor CTA_MARK_MASK when setting ctmark
Date: Thu, 19 Dec 2013 18:25:15 +0100
Message-ID: <1387473915-26753-2-git-send-email-fw@strlen.de>
References: <1387473915-26753-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34811 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab3LSR2R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:28:17 -0500
In-Reply-To: <1387473915-26753-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Useful to only set a particular range of the conntrack mark while
leaving exisiting parts of the value alone, e.g. when setting
conntrack marks via NFQUEUE.

Follows same scheme as MARK/CONNMARK targets, i.e. the mask defines
those bits that should be altered.  No mask is equal to '~0', ie.
the old value is replaced by new one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 08870b8..bb322d0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2118,8 +2118,16 @@ ctnetlink_nfqueue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 			return err;
 	}
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (cda[CTA_MARK])
-		ct->mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+	if (cda[CTA_MARK]) {
+		u32 mask = 0, mark, newmark;
+		if (cda[CTA_MARK_MASK])
+			mask = ~ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+
+		mark = ntohl(nla_get_be32(cda[CTA_MARK]));
+		newmark = (ct->mark & mask) ^ mark;
+		if (newmark != ct->mark)
+			ct->mark = newmark;
+	}
 #endif
 	return 0;
 }
-- 
1.8.1.5

