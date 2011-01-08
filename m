From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/13] libipt_CLUSTERIP: const annotations
Date: Sat,  8 Jan 2011 16:20:12 +0100
Message-ID: <1294500015-10691-12-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32913 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab1AHPU2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:28 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_CLUSTERIP.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index b89baa8..9f4c992 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -163,9 +163,9 @@ static void CLUSTERIP_check(unsigned int flags)
 	xtables_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
 }
 
-static char *hashmode2str(enum clusterip_hashmode mode)
+static const char *hashmode2str(enum clusterip_hashmode mode)
 {
-	char *retstr;
+	const char *retstr;
 	switch (mode) {
 		case CLUSTERIP_HASHMODE_SIP:
 			retstr = "sourceip";
@@ -183,7 +183,7 @@ static char *hashmode2str(enum clusterip_hashmode mode)
 	return retstr;
 }
 
-static char *mac2str(const uint8_t mac[ETH_ALEN])
+static const char *mac2str(const uint8_t mac[ETH_ALEN])
 {
 	static char buf[ETH_ALEN*3];
 	sprintf(buf, "%02X:%02X:%02X:%02X:%02X:%02X",
-- 
1.7.1

