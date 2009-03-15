From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] netfilter: check for NEXTHDR_NONE before len
Date: Sun, 15 Mar 2009 17:18:00 +0100
Message-ID: <d9edea7497d944fbc1c9ece8ae492e27f60e1350.1237133813.git.christoph.paasch@gmail.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f164.google.com ([209.85.219.164]:44777 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZCOQSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:18:08 -0400
Received: by ewy8 with SMTP id 8so1484360ewy.13
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2009 09:18:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NEXTHDR_NONE doesn't has an IPv6 option header, so the first check for the length
will always fail and results in a confusing message "too short", even if the packet
isn't too short. It just ends with NEXTHDR_NONE.

Signed-off-by: Christoph Paasch <christoph.paasch@gmail.com>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index ed4d79a..058a5e4 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -528,14 +528,14 @@ find_prev_fhdr(struct sk_buff *skb, u8 *prevhdrp, int *prevhoff, int *fhoff)
 		if (!ipv6_ext_hdr(nexthdr)) {
 			return -1;
 		}
-		if (len < (int)sizeof(struct ipv6_opt_hdr)) {
-			pr_debug("too short\n");
-			return -1;
-		}
 		if (nexthdr == NEXTHDR_NONE) {
 			pr_debug("next header is none\n");
 			return -1;
 		}
+		if (len < (int)sizeof(struct ipv6_opt_hdr)) {
+			pr_debug("too short\n");
+			return -1;
+		}
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
 			BUG();
 		if (nexthdr == NEXTHDR_AUTH)
-- 
1.5.6.3

