Return-Path: <SRS0=Hoda=6K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527ADC5519C
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F14F206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDZNYr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Apr 2020 09:24:47 -0400
Received: from correo.us.es ([193.147.175.20]:42938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgDZNYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Apr 2020 09:24:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B535A1BFA8C
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B161B8006
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3D57B8010; Sun, 26 Apr 2020 15:24:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4FF6B7FF4;
        Sun, 26 Apr 2020 15:24:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 15:24:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 95BE642EF4E1;
        Sun, 26 Apr 2020 15:24:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue 3/3] pktbuff: add pktb_reset_network_header() and pktb_set_network_header()
Date:   Sun, 26 Apr 2020 15:23:56 +0200
Message-Id: <20200426132356.8346-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200426132356.8346-1-pablo@netfilter.org>
References: <20200426132356.8346-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_queue/pktbuff.h |  3 +++
 src/extra/pktbuff.c                  | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index f9bddaf072fb..875157922c81 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -9,6 +9,9 @@ void pktb_free(struct pkt_buff *pktb);
 
 void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t len);
 
+void pktb_reset_network_header(struct pkt_buff *pktb);
+void pktb_set_network_header(struct pkt_buff *pktb, const int offset);
+
 uint8_t *pktb_data(struct pkt_buff *pktb);
 uint32_t pktb_len(struct pkt_buff *pktb);
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index a93e72ac7795..3ff287e57315 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -267,6 +267,19 @@ uint8_t *pktb_network_header(struct pkt_buff *pktb)
 	return pktb->network_header;
 }
 
+EXPORT_SYMBOL
+void pktb_reset_network_header(struct pkt_buff *pktb)
+{
+	pktb->network_header = pktb->data;
+}
+
+EXPORT_SYMBOL
+void pktb_set_network_header(struct pkt_buff *pktb, const int offset)
+{
+	pktb_reset_network_header(pktb);
+	pktb->network_header += offset;
+}
+
 /**
  * pktb_transport_header - get address of layer 4 header (if known)
  * \param pktb Pointer to userspace packet buffer
-- 
2.20.1

