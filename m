From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 26/27] Unknot xt_ah IPv6 logic
Date: Wed, 2 Jan 2008 21:34:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022134170.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45551 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYABUe3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:34:29 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a892e62a4c5b0dcc41c2b9fda666db81334af64b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 20:33:00 2008 +0100

    [NETFILTER]: Unknot xt_ah IPv6 logic
    
    Split up the big return statement in ah_mt6() into smaller ones.
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

 net/netfilter/xt_ah.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_ah.c b/net/netfilter/xt_ah.c
index c18cc70..2aed8c4 100644
--- a/net/netfilter/xt_ah.c
+++ b/net/netfilter/xt_ah.c
@@ -89,6 +89,7 @@ ah_mt6(const struct sk_buff *skb, const struct net_device *in,
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 	int err;
+	bool m;
 
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);
 	if (err < 0) {
@@ -122,17 +123,18 @@ ah_mt6(const struct sk_buff *skb, const struct net_device *in,
 		 ahinfo->hdrres, ah->reserved,
 		 !(ahinfo->hdrres && ah->reserved));
 
-	return (ah != NULL)
-	       &&
-	       spi_match(ahinfo->spis[0], ahinfo->spis[1],
-			 ntohl(ah->spi),
-			 !!(ahinfo->invflags & IP6T_AH_INV_SPI))
-	       &&
-	       (!ahinfo->hdrlen ||
-		(ahinfo->hdrlen == hdrlen) ^
-		!!(ahinfo->invflags & IP6T_AH_INV_LEN))
-	       &&
-	       !(ahinfo->hdrres && ah->reserved);
+	m = spi_match(ahinfo->spis[0], ahinfo->spis[1], ntohl(ah->spi),
+	    ahinfo->invflags & IP6T_AH_INV_SPI);
+	if (!m)
+		return false;
+
+	m  = ahinfo->hdrlen == 0;
+	m |= ahinfo->hdrlen == hdrlen;
+	m ^= !!(ahinfo->invflags & IP6T_AH_INV_LEN);
+	if (!m)
+		return false;
+
+	return ahinfo->hdrres == 0 || ah->reserved == 0;
 }
 
 static bool
