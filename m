From: Eric Leblond <eric@regit.org>
Subject: [PATCH 3/4] base: fix warning on pointer handling
Date: Sat, 19 Jan 2013 10:53:50 +0100
Message-ID: <1358589231-1358-4-git-send-email-eric@regit.org>
References: <1358589231-1358-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37681 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3ASJyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:54:37 -0500
In-Reply-To: <1358589231-1358-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 8a6b4da..8dfe38e 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -895,10 +895,10 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 	okey_set_u16(&ret[KEY_ARP_PTYPE], ntohs(arph->arp_pro));
 	okey_set_u16(&ret[KEY_ARP_OPCODE], ntohs(arph->arp_op));
 
-	okey_set_ptr(&ret[KEY_ARP_SHA], &arph->arp_sha);
-	okey_set_ptr(&ret[KEY_ARP_SPA], &arph->arp_spa),
-	okey_set_ptr(&ret[KEY_ARP_THA], &arph->arp_tha);
-	okey_set_ptr(&ret[KEY_ARP_TPA], &arph->arp_tpa);
+	okey_set_ptr(&ret[KEY_ARP_SHA], (void *)&arph->arp_sha);
+	okey_set_ptr(&ret[KEY_ARP_SPA], (void *)&arph->arp_spa),
+	okey_set_ptr(&ret[KEY_ARP_THA], (void *)&arph->arp_tha);
+	okey_set_ptr(&ret[KEY_ARP_TPA], (void *)&arph->arp_tpa);
 
 	return ULOGD_IRET_OK;
 }
-- 
1.7.10.4

