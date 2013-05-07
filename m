From: Boris Figovsky <boris.figovsky@ravellosystems.com>
Subject: [xtables-addons][PATCH 1/1] xt_DHCPMAC: correct mac setting and comparing
Date: Tue,  7 May 2013 07:21:55 +0300
Message-ID: <1367900515-13101-2-git-send-email-boris.figovsky@ravellosystems.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:37497 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932706Ab3EGE2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 May 2013 00:28:36 -0400
Received: by mail-ea0-f171.google.com with SMTP id b10so51042eae.2
        for <netfilter-devel@vger.kernel.org>; Mon, 06 May 2013 21:28:34 -0700 (PDT)
Received: from borf.ravello.local ([207.232.28.189])
        by mx.google.com with ESMTPSA id e2sm25689888eem.16.2013.05.06.21.22.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 06 May 2013 21:22:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Boris Figovsky <boris.figovsky@ravellosystems.com>
---
 extensions/xt_DHCPMAC.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/extensions/xt_DHCPMAC.c b/extensions/xt_DHCPMAC.c
index 45f1972..bedf75d 100644
--- a/extensions/xt_DHCPMAC.c
+++ b/extensions/xt_DHCPMAC.c
@@ -34,9 +34,9 @@ static void ether_set(unsigned char *addr, const unsigned char *op,
 	unsigned int i;
 
 	for (i = 0; i < ETH_ALEN && mask > 0; ++i) {
-		lo_mask = mask % 8;
+		lo_mask = (mask >= 8) ? 8 : mask;
 		/* FF << 4 >> 4 = 0F */
-		lo_mask = ~(uint8_t)0U << lo_mask >> lo_mask;
+		lo_mask = (uint8_t)(~0U << lo_mask) >> lo_mask;
 		addr[i] &= lo_mask;
 		addr[i] |= op[i] & ~lo_mask;
 		if (mask >= 8)
@@ -55,9 +55,9 @@ static bool ether_cmp(const unsigned char *lh, const unsigned char *rh,
 #define ZMACHEX(s) s[0], s[1], s[2], s[3], s[4], s[5]
 
 	for (i = 0; i < ETH_ALEN && mask > 0; ++i) {
-		lo_mask = mask % 8;
+		lo_mask = (mask >= 8) ? 8 : mask;
 		/* ~(0xFF << 4 >> 4) = ~0x0F = 0xF0 */
-		lo_mask = ~(~(uint8_t)0U << lo_mask >> lo_mask);
+		lo_mask = ~((uint8_t)(~0U << lo_mask) >> lo_mask);
 		if ((lh[i] ^ rh[i]) & lo_mask)
 			return false;
 		if (mask >= 8)
@@ -111,13 +111,12 @@ dhcpmac_tg(struct sk_buff **pskb, const struct xt_action_param *par)
 		return NF_DROP;
 
 	for (i = 0; i < sizeof(dh->chaddr); i += 2)
-		csum_replace2(&udph->check, *(const __be16 *)dh->chaddr, 0);
+		csum_replace2(&udph->check, *(const __be16 *)(dh->chaddr+i), 0);
 
-	memset(dh->chaddr, 0, sizeof(dh->chaddr));
 	ether_set(dh->chaddr, info->addr, info->mask);
 
 	for (i = 0; i < sizeof(dh->chaddr); i += 2)
-		csum_replace2(&udph->check, 0, *(const __be16 *)dh->chaddr);
+		csum_replace2(&udph->check, 0, *(const __be16 *)(dh->chaddr+i));
 
 	return XT_CONTINUE;
 }
-- 
1.7.9.5

