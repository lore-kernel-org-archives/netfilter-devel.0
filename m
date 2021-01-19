Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B10AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 15:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E9923121
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 15:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390723AbhASPcQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 10:32:16 -0500
Received: from ma1-aaemail-dr-lapp03.apple.com ([17.171.2.72]:39210 "EHLO
        ma1-aaemail-dr-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390820AbhASPL1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 10:11:27 -0500
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 10JF8GXi064056;
        Tue, 19 Jan 2021 07:10:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=date : subject : from
 : to : cc : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=20180706;
 bh=pCXcINayXbyQwq7ib9jnV/lVsU5f5Umq5rqdRxtLgKM=;
 b=HH/6XlBB+tgyFo1C2QWIXq1JLyPAxzpb+9W3OBvxeUzi47V8zCYrveh6RFRxA21JaUps
 XN/3b5xxJIVcqEUrr3gGiu7Ib78t9F9gBPzxT+umdSNOrxroJTOXX8l+kEbi6gvzM7GM
 Hw4QoHM6NTUNkjr1jkuFBgn5FNfoHMoZdufTgL4sr6VRI7O3zkDy+kmoRrV4oJ+jar+e
 U7Ttv9gUaqkhnI8S8ETXnykFESM+lojZ5A7Bi/fIRH7yJlCedB8qjmVnp0+6qQ12l0yp
 SbRvtnzBgQlq83B96MgpoORCT5NmbOWzF1vYsQ+C7yqiwpOJ9cKLNecLCexE18kyMnnN Jw== 
Received: from crk-mailsvcp-mta-lapp03.euro.apple.com (crk-mailsvcp-mta-lapp03.euro.apple.com [17.66.55.16])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 36400yhhkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 19 Jan 2021 07:10:39 -0800
Received: from crk-mailsvcp-mmp-lapp02.euro.apple.com
 (crk-mailsvcp-mmp-lapp02.euro.apple.com [17.72.136.16])
 by crk-mailsvcp-mta-lapp03.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.7.20201203 64bit (built Dec  3
 2020))
 with ESMTPS id <0QN6006HOSTQRT00@crk-mailsvcp-mta-lapp03.euro.apple.com>; Tue,
 19 Jan 2021 15:10:38 +0000 (GMT)
Received: from process_milters-daemon.crk-mailsvcp-mmp-lapp02.euro.apple.com by
 crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020)) id <0QN600A00S01LV00@crk-mailsvcp-mmp-lapp02.euro.apple.com>; Tue,
 19 Jan 2021 15:10:38 +0000 (GMT)
X-Va-A: 
X-Va-T-CD: ee775fe296fae01696e403bd65ae1163
X-Va-E-CD: 05c635055d51c425e80d5b4b6baa240a
X-Va-R-CD: 04d20a26b01efeff662a196593a2241e
X-Va-CD: 0
X-Va-ID: 175a09a6-a447-4f20-80da-812f008154e2
X-V-A:  
X-V-T-CD: ee775fe296fae01696e403bd65ae1163
X-V-E-CD: 05c635055d51c425e80d5b4b6baa240a
X-V-R-CD: 04d20a26b01efeff662a196593a2241e
X-V-CD: 0
X-V-ID: 49af9a1b-68a8-4476-ac9c-b7ba1a6cca43
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
Received: from [192.168.1.127] (unknown [17.235.218.21])
 by crk-mailsvcp-mmp-lapp02.euro.apple.com
 (Oracle Communications Messaging Server 8.1.0.6.20200729 64bit (built Jul 29
 2020))
 with ESMTPSA id <0QN600UAKSTPPZ00@crk-mailsvcp-mmp-lapp02.euro.apple.com>;
 Tue, 19 Jan 2021 15:10:38 +0000 (GMT)
User-Agent: Microsoft-MacOutlook/16.45.21011103
Date:   Tue, 19 Jan 2021 16:05:39 +0100
Subject: [PATCH libnetfilter_queue] src: add pkt_buff function for ICMP
From:   Etan Kissling <etan_kissling@apple.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Message-id: <F380D43B-7B1E-4FB4-9E83-BAD37E062C13@apple.com>
Thread-topic: [PATCH libnetfilter_queue] src: add pkt_buff function for ICMP
References: <57E75703-5B8A-4E88-810C-E5F0963BF6E7@apple.com>
In-reply-to: <57E75703-5B8A-4E88-810C-E5F0963BF6E7@apple.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for processing ICMP packets using pkt_buff, similar to
existing library support for TCP and UDP.

Signed-off-by: Etan Kissling <etan_kissling@apple.com>
---
 include/libnetfilter_queue/Makefile.am        |  1 +
 .../libnetfilter_queue_icmp.h                 |  8 ++++
 src/Makefile.am                               |  1 +
 src/extra/icmp.c                              | 48 +++++++++++++++++++
 4 files changed, 58 insertions(+)
 create mode 100644 include/libnetfilter_queue/libnetfilter_queue_icmp.h
 create mode 100644 src/extra/icmp.c

diff --git a/include/libnetfilter_queue/Makefile.am b/include/libnetfilter_queue/Makefile.am
index 902fbf9..e436bab 100644
--- a/include/libnetfilter_queue/Makefile.am
+++ b/include/libnetfilter_queue/Makefile.am
@@ -1,5 +1,6 @@
 pkginclude_HEADERS = libnetfilter_queue.h	\
 		     linux_nfnetlink_queue.h	\
+		     libnetfilter_queue_icmp.h	\
 		     libnetfilter_queue_ipv4.h	\
 		     libnetfilter_queue_ipv6.h	\
 		     libnetfilter_queue_tcp.h	\
diff --git a/include/libnetfilter_queue/libnetfilter_queue_icmp.h b/include/libnetfilter_queue/libnetfilter_queue_icmp.h
new file mode 100644
index 0000000..9a8bd52
--- /dev/null
+++ b/include/libnetfilter_queue/libnetfilter_queue_icmp.h
@@ -0,0 +1,8 @@
+#ifndef _LIBNFQUEUE_ICMP_H_
+#define _LIBNFQUEUE_ICMP_H_
+
+struct pkt_buff;
+
+struct icmphdr *nfq_icmp_get_hdr(struct pkt_buff *pktb);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 8cede12..079853e 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -31,6 +31,7 @@ libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles \
 libnetfilter_queue_la_SOURCES = libnetfilter_queue.c	\
 				nlmsg.c			\
 				extra/checksum.c	\
+				extra/icmp.c		\
 				extra/ipv6.c		\
 				extra/tcp.c		\
 				extra/ipv4.c		\
diff --git a/src/extra/icmp.c b/src/extra/icmp.c
new file mode 100644
index 0000000..a97979b
--- /dev/null
+++ b/src/extra/icmp.c
@@ -0,0 +1,48 @@
+/*
+ * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This code has been sponsored by Vyatta Inc. <http://www.vyatta.com>
+ */
+
+#include <stdio.h>
+#define _GNU_SOURCE
+#include <netinet/ip_icmp.h>
+
+#include <libnetfilter_queue/libnetfilter_queue_icmp.h>
+
+#include "internal.h"
+
+/**
+ * \defgroup icmp ICMP helper functions
+ * @{
+ */
+
+/**
+ * nfq_icmp_get_hdr - get the ICMP header.
+ * \param pktb: pointer to user-space network packet buffer
+ * \returns validated pointer to the ICMP header or NULL if the ICMP header was
+ * not set or if a minimal length check fails.
+ * \note You have to call nfq_ip_set_transport_header() or
+ * nfq_ip6_set_transport_header() first to set the ICMP header.
+ */
+EXPORT_SYMBOL
+struct icmphdr *nfq_icmp_get_hdr(struct pkt_buff *pktb)
+{
+	if (pktb->transport_header == NULL)
+		return NULL;
+
+	/* No room for the ICMP header. */
+	if (pktb_tail(pktb) - pktb->transport_header < sizeof(struct icmphdr))
+		return NULL;
+
+	return (struct icmphdr *)pktb->transport_header;
+}
+
+/**
+ * @}
+ */
-- 
2.21.1 (Apple Git-122.3)



