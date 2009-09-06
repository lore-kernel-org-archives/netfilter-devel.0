From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH] xt_u32.c - make negative offsets work near / at the end of packet
Date: Sun,  6 Sep 2009 02:36:38 +0200
Message-ID: <1252197398-23863-2-git-send-email-soltys@ziu.info>
References: <1252197398-23863-1-git-send-email-soltys@ziu.info>
Cc: netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ppgk.com.pl ([80.53.243.36]:30222 "EHLO relay.ppgk.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZIFAr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Sep 2009 20:47:26 -0400
In-Reply-To: <1252197398-23863-1-git-send-email-soltys@ziu.info>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current sanity checks in xt_u32.c inhibit successful use of negative
offets when the current position is near or at the end of a packet.

The following patch changes the sanity checks to be a bit more
flexible - values read from the packet and specified as @ offsets
can be interpreted both as positive and negative.

Signed-off-by: Michal Soltys <soltys@ziu.info>
---
 net/netfilter/xt_u32.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 24a5276..bb3a63d 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -58,15 +58,11 @@ static bool u32_match_it(const struct xt_u32 *data,
 				val >>= number;
 				break;
 			case XT_U32_AT:
-				if (at + val < at)
-					return false;
 				at += val;
-				pos = number;
-				if (at + 4 < at || skb->len < at + 4 ||
-				    pos > skb->len - at - 4)
+				if (at + number + 4 < 4 || skb->len < at + number + 4)
 					return false;
 
-				if (skb_copy_bits(skb, at + pos, &n,
+				if (skb_copy_bits(skb, at + number, &n,
 						    sizeof(n)) < 0)
 					BUG();
 				val = ntohl(n);
-- 
1.6.4

