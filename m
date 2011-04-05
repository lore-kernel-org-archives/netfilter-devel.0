From: kaber@trash.net
Subject: [PATCH 8/8] netfilter: xt_conntrack: fix inverted conntrack direction test
Date: Tue,  5 Apr 2011 15:04:19 +0200
Message-ID: <1302008659-21141-9-git-send-email-kaber@trash.net>
References: <1302008659-21141-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1302008659-21141-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

--ctdir ORIGINAL matches REPLY packets, and vv:

userspace sets "invert_flags &= ~XT_CONNTRACK_DIRECTION" in ORIGINAL
case.

Thus: (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) ^
      !!(info->invert_flags & XT_CONNTRACK_DIRECTION))

yields "1 ^ 0", which is true -> returns false.

Reproducer:
iptables -I OUTPUT 1 -p tcp --syn -m conntrack --ctdir ORIGINAL

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
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
1.7.2.3

