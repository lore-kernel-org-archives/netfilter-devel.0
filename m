Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A389C31E40
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D962086D
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405954AbfHIK4M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:56:12 -0400
Received: from correo.us.es ([193.147.175.20]:39580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405928AbfHIK4L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 06:56:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DFDEC3288
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:56:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E145DA704
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:56:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 339E1DA72F; Fri,  9 Aug 2019 12:56:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21D6DDA730
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:56:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 12:56:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8C6004265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:56:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] conntrack: support for IPS_OFFLOAD
Date:   Fri,  9 Aug 2019 12:55:39 +0200
Message-Id: <20190809105539.4115-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # conntrack -L -u OFFLOAD
 tcp      6 431984 ESTABLISHED src=192.168.10.2 dst=10.0.1.2 sport=32824 dport=5201 src=10.0.1.2 dst=10.0.1.1 sport=5201 dport=32824 [OFFLOAD] mark=0 secctx=null use=2
 tcp      6 431984 ESTABLISHED src=192.168.10.2 dst=10.0.1.2 sport=32826 dport=5201 src=10.0.1.2 dst=10.0.1.1 sport=5201 dport=32826 [OFFLOAD] mark=0 secctx=null use=2

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 conntrack.8                                   |  4 ++--
 include/conntrack.h                           |  7 ++++---
 include/linux/netfilter/nf_conntrack_common.h | 24 ++++++++++++++++++++++--
 src/conntrack.c                               |  7 ++++---
 4 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 3c1e960e910e..1174c6cec73c 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -1,4 +1,4 @@
-.TH CONNTRACK 8 "Sep 26, 2017" "" ""
+.TH CONNTRACK 8 "Aug 9, 2019" "" ""
 
 .\" Man page written by Harald Welte <laforge@netfilter.org (Jun 2005)
 .\" Maintained by Pablo Neira Ayuso <pablo@netfilter.org (May 2007)
@@ -193,7 +193,7 @@ This option is only available in conjunction with "\-U, \-\-update".
 .BI "-c, --secmark " "SECMARK"
 Specify the conntrack selinux security mark.
 .TP
-.BI "-u, --status " "[ASSURED|SEEN_REPLY|FIXED_TIMEOUT|EXPECTED|UNSET][,...]"
+.BI "-u, --status " "[ASSURED|SEEN_REPLY|FIXED_TIMEOUT|EXPECTED|OFFLOAD|UNSET][,...]"
 Specify the conntrack status.
 .TP
 .BI "-n, --src-nat "
diff --git a/include/conntrack.h b/include/conntrack.h
index 6659a6454bc0..37ccf6e9a87e 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -3,7 +3,6 @@
 
 #include "linux_list.h"
 #include <stdint.h>
-#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 #define PROGNAME "conntrack"
 
@@ -12,6 +11,8 @@
 #define NUMBER_OF_CMD   19
 #define NUMBER_OF_OPT   29
 
+struct nf_conntrack;
+
 struct ctproto_handler {
 	struct list_head 	head;
 
@@ -19,8 +20,8 @@ struct ctproto_handler {
 	uint16_t 		protonum;
 	const char		*version;
 
-	enum ctattr_protoinfo	protoinfo_attr;
-	
+	uint32_t		protoinfo_attr;
+
 	int (*parse_opts)(char c,
 			  struct nf_conntrack *ct,
 			  struct nf_conntrack *exptuple,
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 4cf003f43076..8023e5b6572f 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 /* Connection state tracking for netfilter.  This is separated from,
@@ -28,12 +29,14 @@ enum ip_conntrack_info {
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
@@ -90,13 +93,26 @@ enum ip_conntrack_status {
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
@@ -113,6 +129,10 @@ enum ip_conntrack_events {
 	IPCT_NATSEQADJ = IPCT_SEQADJ,
 	IPCT_SECMARK,		/* new security mark has been set */
 	IPCT_LABEL,		/* new connlabel has been set */
+	IPCT_SYNPROXY,		/* synproxy has been set */
+#ifdef __KERNEL__
+	__IPCT_MAX
+#endif
 };
 
 enum ip_conntrack_expect_events {
diff --git a/src/conntrack.c b/src/conntrack.c
index 97132a977221..c980a13f33d2 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -62,6 +62,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <libmnl/libmnl.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 static struct nfct_mnl_socket {
@@ -867,10 +868,10 @@ enum {
 static struct parse_parameter {
 	const char	*parameter[7];
 	size_t  size;
-	unsigned int value[7];
+	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
-	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED"}, 5,
-	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED} },
+	{ {"ASSURED", "SEEN_REPLY", "UNSET", "FIXED_TIMEOUT", "EXPECTED", "OFFLOAD"}, 6,
+	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
 	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace" }, 7,
-- 
2.11.0

