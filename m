Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB0AC47254
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 09:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 334D42495C
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 09:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgEIJLw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 05:11:52 -0400
Received: from correo.us.es ([193.147.175.20]:52050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgEIJLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 05:11:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66CC94DE727
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:11:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 591503353
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:11:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E9F0DA7B2; Sat,  9 May 2020 11:11:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AFA720C5D
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:11:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 09 May 2020 11:11:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 36EA642EF4E1
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:11:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/2] pktbuff: add __pktb_setup()
Date:   Sat,  9 May 2020 11:11:40 +0200
Message-Id: <20200509091141.10619-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add private helper function to set up the pkt_buff object.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/extra/pktbuff.c | 54 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca98aff2..118ad898f63b 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -29,6 +29,34 @@
  * @{
  */
 
+static int __pktb_setup(int family, struct pkt_buff *pktb)
+{
+	struct ethhdr *ethhdr;
+
+	switch (family) {
+	case AF_INET:
+	case AF_INET6:
+		pktb->network_header = pktb->data;
+		break;
+	case AF_BRIDGE:
+		ethhdr = (struct ethhdr *)pktb->data;
+		pktb->mac_header = pktb->data;
+
+		switch(ethhdr->h_proto) {
+		case ETH_P_IP:
+		case ETH_P_IPV6:
+			pktb->network_header = pktb->data + ETH_HLEN;
+			break;
+		default:
+			/* This protocol is unsupported. */
+			return -1;
+		}
+		break;
+	}
+
+	return 0;
+}
+
 /**
  * pktb_alloc - allocate a new packet buffer
  * \param family Indicate what family. Currently supported families are
@@ -52,7 +80,6 @@ EXPORT_SYMBOL
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 {
 	struct pkt_buff *pktb;
-	struct ethhdr *ethhdr;
 	void *pkt_data;
 
 	pktb = calloc(1, sizeof(struct pkt_buff) + len + extra);
@@ -68,28 +95,11 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 
 	pktb->data = pkt_data;
 
-	switch(family) {
-	case AF_INET:
-	case AF_INET6:
-		pktb->network_header = pktb->data;
-		break;
-	case AF_BRIDGE:
-		ethhdr = (struct ethhdr *)pktb->data;
-		pktb->mac_header = pktb->data;
-
-		switch(ethhdr->h_proto) {
-		case ETH_P_IP:
-		case ETH_P_IPV6:
-			pktb->network_header = pktb->data + ETH_HLEN;
-			break;
-		default:
-			/* This protocol is unsupported. */
-			errno = EPROTONOSUPPORT;
-			free(pktb);
-			return NULL;
-		}
-		break;
+	if (__pktb_setup(family, pktb) < 0) {
+		errno = EPROTONOSUPPORT;
+		free(pktb);
 	}
+
 	return pktb;
 }
 
-- 
2.20.1

