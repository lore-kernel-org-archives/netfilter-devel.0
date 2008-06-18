From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/3] Backport of bugzilla 535
Date: Wed, 18 Jun 2008 17:30:13 +0200
Message-ID: <1213803013-19433-4-git-send-email-eric@inl.fr>
References: <1213803013-19433-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44489 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYFRPaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:17 -0400
In-Reply-To: <1213803013-19433-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a backport of Jaap Keuter fix for PCAP output module.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/pcap/ulogd_output_PCAP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index 0a714e6..ce4393c 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -135,7 +135,7 @@ static int interp_pcap(struct ulogd_pluginstance *upi)
 	struct ulogd_key *res = upi->input.keys;
 	struct pcap_sf_pkthdr pchdr;
 
-	pchdr.caplen = GET_VALUE(res, 1).ui32;
+	pchdr.caplen = GET_VALUE(res, 2).ui32;
 	pchdr.len = GET_VALUE(res, 2).ui32;
 
 	if (GET_FLAGS(res, 3) & ULOGD_RETF_VALID
-- 
1.5.5.3

