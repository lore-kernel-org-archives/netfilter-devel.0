From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH] netfilter: xt_conntrack: fix inverted conntrack direction test
Date: Mon,  4 Apr 2011 16:19:00 +0200
Message-ID: <1301926740-22216-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-101.dex002.intermedia.net ([64.78.19.88]:15274 "EHLO
	DHOST002-101.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401Ab1DDOcn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:32:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--ctdir ORIGINAL matches REPLY packets, and vv:

userspace sets "invert_flags &= ~XT_CONNTRACK_DIRECTION" in ORIGINAL
case.

Thus: (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) ^
      !!(info->invert_flags & XT_CONNTRACK_DIRECTION))

yields "1 ^ 0", which is true -> returns false.

Reproducer:
iptables -I OUTPUT 1 -p tcp --syn -m conntrack --ctdir ORIGINAL

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 net/netfilter/xt_conntrack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 2c0086a..481a86f 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -195,7 +195,7 @@ conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par,
 		return info->match_flags & XT_CONNTRACK_STATE;
 	if ((info->match_flags & XT_CONNTRACK_DIRECTION) &&
 	    (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) ^
-	    !!(info->invert_flags & XT_CONNTRACK_DIRECTION))
+	    !(info->invert_flags & XT_CONNTRACK_DIRECTION))
 		return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
-- 
1.7.3.4

