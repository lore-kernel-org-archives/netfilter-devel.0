From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD1 PATCH] Fix PCAP len (Jaap Keuter)
Date: Wed, 18 Jun 2008 16:58:11 +0200
Message-ID: <1213801091-25885-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:51813 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYFRO6O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:58:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a application of patch provided by Jaap Keuter. Application will close
bugzilla 535. pcap len was set to value of the pointer to raw data.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 pcap/ulogd_PCAP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/pcap/ulogd_PCAP.c b/pcap/ulogd_PCAP.c
index 686fe47..7d67c28 100644
--- a/pcap/ulogd_PCAP.c
+++ b/pcap/ulogd_PCAP.c
@@ -131,7 +131,7 @@ static int pcap_output(ulog_iret_t *res)
 {
 	struct pcap_sf_pkthdr pchdr;
 
-	pchdr.caplen = GET_VALUE(1).ui32;
+	pchdr.caplen = GET_VALUE(2).ui32;
 	pchdr.len = GET_VALUE(2).ui32;
 
 	if (GET_FLAGS(3) & ULOGD_RETF_VALID
-- 
1.5.5.3

