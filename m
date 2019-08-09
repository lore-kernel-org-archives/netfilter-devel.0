Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B1BC31E40
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4218C2084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHIK66 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:58:58 -0400
Received: from correo.us.es ([193.147.175.20]:40182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHIK65 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 06:58:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51A72C3289
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 433101150B9
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:58:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38E97DA72F; Fri,  9 Aug 2019 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19D6F1150CB
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:58:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 12:58:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AB5584265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:58:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] libnetfilter_conntrack: support for IPS_OFFLOAD
Date:   Fri,  9 Aug 2019 12:58:23 +0200
Message-Id: <20190809105823.4216-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print [OFFLOAD] tag when listing entries via snprintf() interface.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../linux_nf_conntrack_common.h                    | 24 ++++++++++++++++++++--
 src/conntrack/snprintf_default.c                   |  6 ++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_conntrack/linux_nf_conntrack_common.h b/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
index 21015c7ff857..32efa357c8db 100644
--- a/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
+++ b/include/libnetfilter_conntrack/linux_nf_conntrack_common.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
@@ -33,12 +34,14 @@ enum ip_conntrack_info {
 	/* only for userspace compatibility */
 #ifndef __KERNEL__
 	IP_CT_NEW_REPLY = IP_CT_NUMBER,
+#else
+	IP_CT_UNTRACKED = 7,
 #endif
 };
 
 #define NF_CT_STATE_INVALID_BIT			(1 << 0)
 #define NF_CT_STATE_BIT(ctinfo)			(1 << ((ctinfo) % IP_CT_IS_REPLY + 1))
-#define NF_CT_STATE_UNTRACKED_BIT		(1 << (IP_CT_NUMBER + 1))
+#define NF_CT_STATE_UNTRACKED_BIT		(1 << 6)
 
 /* Bitset representing status of connection. */
 enum ip_conntrack_status {
@@ -95,13 +98,26 @@ enum ip_conntrack_status {
 	IPS_TEMPLATE_BIT = 11,
 	IPS_TEMPLATE = (1 << IPS_TEMPLATE_BIT),
 
-	/* Conntrack is a fake untracked entry */
+	/* Conntrack is a fake untracked entry.  Obsolete and not used anymore */
 	IPS_UNTRACKED_BIT = 12,
 	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
 
 	/* Conntrack got a helper explicitly attached via CT target. */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
+
+	/* Conntrack has been offloaded to flow table. */
+	IPS_OFFLOAD_BIT = 14,
+	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
+
+	/* Be careful here, modifying these bits can make things messy,
+	 * so don't let users modify them directly.
+	 */
+	IPS_UNCHANGEABLE_MASK = (IPS_NAT_DONE_MASK | IPS_NAT_MASK |
+				 IPS_EXPECTED | IPS_CONFIRMED | IPS_DYING |
+				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_OFFLOAD),
+
+	__IPS_MAX_BIT = 15,
 };
 
 /* Connection tracking event types */
@@ -118,6 +134,10 @@ enum ip_conntrack_events {
 	IPCT_NATSEQADJ = IPCT_SEQADJ,
 	IPCT_SECMARK,		/* new security mark has been set */
 	IPCT_LABEL,		/* new connlabel has been set */
+	IPCT_SYNPROXY,		/* synproxy has been set */
+#ifdef __KERNEL__
+	__IPCT_MAX
+#endif
 };
 
 enum ip_conntrack_expect_events {
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 06466b115870..765ce726ea7d 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -183,8 +183,10 @@ static int __snprintf_status_assured(char *buf,
 				     const struct nf_conntrack *ct)
 {
 	int size = 0;
-	
-	if (ct->status & IPS_ASSURED)
+
+	if (ct->status & IPS_OFFLOAD)
+		size = snprintf(buf, len, "[OFFLOAD] ");
+	else if (ct->status & IPS_ASSURED)
 		size = snprintf(buf, len, "[ASSURED] ");
 
 	return size;
-- 
2.11.0

