From: pablo@netfilter.org
Subject: [PATCH] netfilter: xt_connbytes: handle negation correctly
Date: Fri, 23 Dec 2011 15:04:43 +0100
Message-ID: <1324649083-6548-2-git-send-email-pablo@netfilter.org>
References: <1324649083-6548-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44742 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1LWOFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:05:00 -0500
In-Reply-To: <1324649083-6548-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

"! --connbytes 23:42" should match if the packet/byte count is not in range.

As there is no explict "invert match" toggle in the match structure,
userspace swaps the from and to arguments
(i.e., as if "--connbytes 42:23" were given).

However, "what <= 23 && what >= 42" will always be false.

Change things so we use "||" in case "from" is larger than "to".

This change may look like it breaks backwards compatibility when "to" is 0.
However, older iptables binaries will refuse "connbytes 42:0",
and current releases treat it to mean "! --connbytes 0:42",
so we should be fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connbytes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 5b13850..9ddf1c3 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -87,10 +87,10 @@ connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		break;
 	}
 
-	if (sinfo->count.to)
+	if (sinfo->count.to >= sinfo->count.from)
 		return what <= sinfo->count.to && what >= sinfo->count.from;
-	else
-		return what >= sinfo->count.from;
+	else /* inverted */
+		return what < sinfo->count.to || what > sinfo->count.from;
 }
 
 static int connbytes_mt_check(const struct xt_mtchk_param *par)
-- 
1.7.2.5

