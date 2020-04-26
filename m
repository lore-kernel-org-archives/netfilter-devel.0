Return-Path: <SRS0=Hoda=6K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AC2C55199
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A91206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Apr 2020 13:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgDZNYq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Apr 2020 09:24:46 -0400
Received: from correo.us.es ([193.147.175.20]:42932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgDZNYQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Apr 2020 09:24:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CD5F1BFA87
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82D49B8015
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2020 15:24:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D57FB8006; Sun, 26 Apr 2020 15:24:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5487E50F3D;
        Sun, 26 Apr 2020 15:24:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 26 Apr 2020 15:24:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 374FF42EF4E2;
        Sun, 26 Apr 2020 15:24:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     duncan_roe@optusnet.com.au
Subject: [PATCH libnetfilter_queue 1/3] pktbuff: add pktb_alloc_head() and pktb_build_data()
Date:   Sun, 26 Apr 2020 15:23:54 +0200
Message-Id: <20200426132356.8346-2-pablo@netfilter.org>
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

Add two new helper functions to skip memcpy()'ing the payload from the
netlink message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_queue/pktbuff.h |  3 +++
 src/extra/pktbuff.c                  | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 42bc153ec337..f9bddaf072fb 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -4,8 +4,11 @@
 struct pkt_buff;
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
+struct pkt_buff *pktb_alloc_head(void);
 void pktb_free(struct pkt_buff *pktb);
 
+void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t len);
+
 uint8_t *pktb_data(struct pkt_buff *pktb);
 uint32_t pktb_len(struct pkt_buff *pktb);
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 6dd0ca98aff2..a93e72ac7795 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -93,6 +93,26 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	return pktb;
 }
 
+EXPORT_SYMBOL
+struct pkt_buff *pktb_alloc_head(void)
+{
+	struct pkt_buff *pktb;
+
+	pktb = calloc(1, sizeof(struct pkt_buff));
+	if (pktb == NULL)
+		return NULL;
+
+	return pktb;
+}
+
+EXPORT_SYMBOL
+void pktb_build_data(struct pkt_buff *pktb, uint8_t *payload, uint32_t len)
+{
+	pktb->len = len;
+	pktb->data_len = len;
+	pktb->data = payload;
+}
+
 /**
  * pktb_data - get pointer to network packet
  * \param pktb Pointer to userspace packet buffer
-- 
2.20.1

