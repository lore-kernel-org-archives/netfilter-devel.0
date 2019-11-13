Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5512C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9245C206E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfKMXFu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:05:50 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46183 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbfKMXFu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 18:05:50 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 7AAF23A2308
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 10:05:33 +1100 (AEDT)
Received: (qmail 25277 invoked by uid 501); 13 Nov 2019 23:05:32 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Make sure pktb_alloc() works for IPv6 over AF_BRIDGE
Date:   Thu, 14 Nov 2019 10:05:32 +1100
Message-Id: <20191113230532.25178-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=MeAgGD-zjQ4A:10 a=RSmzAf-M6YYA:10 a=PO7r1zJSAAAA:8
        a=VfUROxyQj7xs2I-BVEMA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At least on the local interface, the MAC header of an IPv6 packet specifies
IPv6 protocol (rather than IP). This surprised me, since the first octet of
the IP datagram is the IP version, but I guess it's an efficiency thing.

Without this patch, pktb_alloc() returns NULL when an IPv6 packet is
encountered.

Updated:

 src/extra/pktbuff.c: - Treat ETH_P_IPV6 the same as ETH_P_IP.
                      - Fix indenting around the affected code.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/pktbuff.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index c52b674..c99a872 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -67,21 +67,22 @@ struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra)
 		pktb->network_header = pktb->data;
 		break;
 	case AF_BRIDGE: {
-		struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
-
-		pktb->mac_header = pktb->data;
-
-		switch(ethhdr->h_proto) {
-		case ETH_P_IP:
-			pktb->network_header = pktb->data + ETH_HLEN;
+			struct ethhdr *ethhdr = (struct ethhdr *)pktb->data;
+
+			pktb->mac_header = pktb->data;
+
+			switch(ethhdr->h_proto) {
+			case ETH_P_IP:
+			case ETH_P_IPV6:
+				pktb->network_header = pktb->data + ETH_HLEN;
+				break;
+			default:
+				/* This protocol is unsupported. */
+				free(pktb);
+				return NULL;
+			}
 			break;
-		default:
-			/* This protocol is unsupported. */
-			free(pktb);
-			return NULL;
 		}
-		break;
-	}
 	}
 	return pktb;
 }
-- 
2.14.5

