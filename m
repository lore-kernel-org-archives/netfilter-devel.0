From: kaber@trash.net
Subject: [PATCH 2/2] netfilter: ip6t_LOG: fix a flaw in printing the MAC
Date: Sat, 19 Feb 2011 16:41:05 +0100
Message-ID: <1298130065-14205-3-git-send-email-kaber@trash.net>
References: <1298130065-14205-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33902 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1BSPlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:41:08 -0500
In-Reply-To: <1298130065-14205-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Joerg Marx <joerg.marx@secunet.com>

The flaw was in skipping the second byte in MAC header due to increasing
the pointer AND indexed access starting at '1'.

Signed-off-by: Joerg Marx <joerg.marx@secunet.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv6/netfilter/ip6t_LOG.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 09c8889..de33803 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -410,7 +410,7 @@ fallback:
 		if (p != NULL) {
 			sb_add(m, "%02x", *p++);
 			for (i = 1; i < len; i++)
-				sb_add(m, ":%02x", p[i]);
+				sb_add(m, ":%02x", *p++);
 		}
 		sb_add(m, " ");
 
-- 
1.7.2.3

