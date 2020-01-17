Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5BFC33CB1
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 11:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6F922073A
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 11:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgAQLcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 06:32:19 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60799 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726371AbgAQLcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 06:32:19 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id B687F3A2396
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jan 2020 22:32:03 +1100 (AEDT)
Received: (qmail 17355 invoked by uid 501); 17 Jan 2020 11:32:03 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Simplify struct pkt_buff: remove head
Date:   Fri, 17 Jan 2020 22:32:03 +1100
Message-Id: <20200117113203.17313-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200110111218.rd5c7basrv24jxqg@salvia>
References: <20200110111218.rd5c7basrv24jxqg@salvia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=Jdjhy38mL1oA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=tBBvX9OYbxBujXjgtnUA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

head and data always had the same value.
head was in the minority, so replace with data where it was used.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/pktbuff.c | 5 ++---
 src/internal.h      | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index f013cfe..c95384f 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -66,9 +66,8 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 	pktb->len = len;
 	pktb->data_len = len + extra;
 
-	pktb->head = pkt_data;
 	pktb->data = pkt_data;
-	pktb->tail = pktb->head + len;
+	pktb->tail = pktb->data + len;
 
 	switch(family) {
 	case AF_INET:
@@ -204,7 +203,7 @@ EXPORT_SYMBOL
 void pktb_trim(struct pkt_buff *pktb, unsigned int len)
 {
 	pktb->len = len;
-	pktb->tail = pktb->head + len;
+	pktb->tail = pktb->data + len;
 }
 
 /**
diff --git a/src/internal.h b/src/internal.h
index d968325..0cfa425 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -23,7 +23,6 @@ struct pkt_buff {
 	uint8_t *network_header;
 	uint8_t *transport_header;
 
-	uint8_t *head;
 	uint8_t *data;
 	uint8_t *tail;
 
-- 
2.14.5

