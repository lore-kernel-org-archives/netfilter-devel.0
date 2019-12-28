Return-Path: <SRS0=8lzl=2S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1429C2D0C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 01:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E39207E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 01:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfL1BYL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Dec 2019 20:24:11 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55485 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfL1BYL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Dec 2019 20:24:11 -0500
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id AF99C3A2FBE
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Dec 2019 12:23:58 +1100 (AEDT)
Received: (qmail 2526 invoked by uid 501); 28 Dec 2019 01:23:57 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] src: doc: tcp.c: fix remaining doxygen warnings
Date:   Sat, 28 Dec 2019 12:23:57 +1100
Message-Id: <20191228012357.2474-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191228012357.2474-1-duncan_roe@optusnet.com.au>
References: <20191228012357.2474-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=pxVhFHJ0LMsA:10 a=RSmzAf-M6YYA:10
        a=PO7r1zJSAAAA:8 a=EW8Owy90DVCjsj2gOxYA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/tcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 2296bef..0f83500 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -87,7 +87,7 @@ unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
 }
 
 /**
- * nfq_tcp_set_checksum_ipv4 - computes IPv4/TCP packet checksum
+ * nfq_tcp_compute_checksum_ipv4 - computes IPv4/TCP packet checksum
  * \param tcph: pointer to the TCP header
  * \param iph: pointer to the IPv4 header
  */
@@ -100,9 +100,9 @@ void nfq_tcp_compute_checksum_ipv4(struct tcphdr *tcph, struct iphdr *iph)
 }
 
 /**
- * nfq_tcp_set_checksum_ipv6 - computes IPv6/TCP packet checksum
+ * nfq_tcp_compute_checksum_ipv6 - computes IPv6/TCP packet checksum
  * \param tcph: pointer to the TCP header
- * \param iph: pointer to the IPv6 header
+ * \param ip6h: pointer to the IPv6 header
  */
 EXPORT_SYMBOL
 void nfq_tcp_compute_checksum_ipv6(struct tcphdr *tcph, struct ip6_hdr *ip6h)
@@ -129,7 +129,7 @@ union tcp_word_hdr {
  * readable way
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
- * \param tcp: pointer to a valid tcp header.
+ * \param tcph: pointer to a valid tcp header.
  *
  */
 EXPORT_SYMBOL
-- 
2.14.5

