Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3E2C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Dec 2021 18:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhL3Sfq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Dec 2021 13:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhL3Sfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Dec 2021 13:35:45 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39000C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Dec 2021 10:35:45 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 196so22002082pfw.10
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Dec 2021 10:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=x67/ZdDdNzkB8AawUk4hIqKWiXKSMa/fLmMAUtyXRSU=;
        b=gZi6QCC5+tUyGq1Y9x4PqatqQYzqV9FJGpBWPxNw6amTn2xLKVFo+M2+vOCpZBMjIV
         VFRVyfd/4qLM7PE2GmrroaYYpQUKBc3QuHxX/NHJi/Y5tTT8LkVo0QoQotr0gqx7GV+u
         2twyPxRxJkSnPmQ1mZ+7eC7eOOBAQcqD4rRID371524b1H/HmVsvYjBuWtjNCTeLov5I
         vkYrFd/gy0gT3tuPeVzAGaht4QtF/E89Vx52rS7Jr3oRYvsAfiDfmWjjhPtMlUsPlhBF
         x7fiWkb2NIUMRQjfC8D4fcEoG/s8ZjJh4KI83I31gG7b8KoEw2tgi33jxIKpSWDXVDC8
         Ig7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x67/ZdDdNzkB8AawUk4hIqKWiXKSMa/fLmMAUtyXRSU=;
        b=3RE0ps+HbfpmnZO1fa/0cMlVupMY21EkW3SweiXCFdACTq3kKzJabdOk1EzVnIk/8A
         oEFnkbePUlWceWMKAeysMui9VGPovjt6LvVpMNreeC3c+uiRVzd0Lk0ToxlAR4gWQFqG
         M2aRJjycMZsMpKSmnPgZpqBvtQYrtdY86ZQq8/Gzo1y72v4mvFFO0v4wqAxIL9FIUUYl
         Sa2xLCnGJ2mkwlHbjtOuaMPVIbBzSxalfPKIcaAODXs2r+3/anD9clLwyGCuYiszF2vS
         u39aJBZi/syozC/4Jj3gugPWy2sptjam6gSKesY4zs5rFuG4+wlQlzfSpnW/Yl0dn1Kf
         oBiA==
X-Gm-Message-State: AOAM531IdQhx/ImXubEf8VF6djwVsO0d2bPaUVysuEL3huB6wuBH/8aE
        fqd6vsNIFSXnvnofiYpKxlgI4RdaQx0aKtgUqdA=
X-Google-Smtp-Source: ABdhPJyotl0UkHnuwsUctEdpFhlDG4hUpUA+PTZjzWm8ig+ujMmrgbv6TyHO9d67vX4pDVmE/Y786g==
X-Received: by 2002:a05:6a00:18a9:b0:4ba:d14d:88 with SMTP id x41-20020a056a0018a900b004bad14d0088mr32445879pfh.59.1640889344658;
        Thu, 30 Dec 2021 10:35:44 -0800 (PST)
Received: from k8s03.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id k6sm30242012pjt.14.2021.12.30.10.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 10:35:44 -0800 (PST)
From:   Quan Tian <tianquan23@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Quan Tian <tianquan23@gmail.com>
Subject: [PATCH] ipset: SCTP, UDPLITE support added to the bitmap:port type
Date:   Thu, 30 Dec 2021 18:35:28 +0000
Message-Id: <20211230183528.16370-1-tianquan23@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently hash:*port* types support SCTP and UDPLITE while bitmap:port
doesn't.

ip_set_get_ip4_port() and ip_set_get_ip6_port() can get SCTP and TCPLITE
port. This patch adds SCTP and UDPLITE support to bitmap:port type by
making ip_set_get_ip_port() return true for the two protocols.

Signed-off-by: Quan Tian <tianquan23@gmail.com>
---
 .../net/netfilter/ipset/ip_set_bitmap_port.c  |  5 +-
 lib/ipset_bitmap_port.c                       | 74 +++++++++++++++++++
 src/ipset.8                                   |  2 +-
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
index 2a570d8..5a43d9c 100644
--- a/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/kernel/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -20,7 +20,8 @@
 #define IPSET_TYPE_REV_MIN	0
 /*				1	   Counter support added */
 /*				2	   Comment support added */
-#define IPSET_TYPE_REV_MAX	3	/* skbinfo support added */
+/*				3	   skbinfo support added */
+#define IPSET_TYPE_REV_MAX	4	/* SCTP and UDPLITE support added */
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@netfilter.org>");
@@ -119,7 +120,9 @@ ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
 		return ret;
 	switch (proto) {
 	case IPPROTO_TCP:
+	case IPPROTO_SCTP:
 	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
 		return true;
 	default:
 		return false;
diff --git a/lib/ipset_bitmap_port.c b/lib/ipset_bitmap_port.c
index 33f8e6c..016712d 100644
--- a/lib/ipset_bitmap_port.c
+++ b/lib/ipset_bitmap_port.c
@@ -282,6 +282,79 @@ static struct ipset_type ipset_bitmap_port3 = {
 	.description = "skbinfo support",
 };
 
+/* SCTP and UDPLITE support */
+static struct ipset_type ipset_bitmap_port4 = {
+	.name = "bitmap:port",
+	.alias = { "portmap", NULL },
+	.revision = 4,
+	.family = NFPROTO_UNSPEC,
+	.dimension = IPSET_DIM_ONE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_tcp_udp_port,
+			.print = ipset_print_port,
+			.opt = IPSET_OPT_PORT
+		},
+	},
+	.cmd = {
+		[IPSET_CREATE] = {
+			.args = {
+				IPSET_ARG_PORTRANGE,
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_COUNTERS,
+				IPSET_ARG_COMMENT,
+				IPSET_ARG_SKBINFO,
+				/* Backward compatibility */
+				IPSET_ARG_FROM_PORT,
+				IPSET_ARG_TO_PORT,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.full = IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.help = "range [PROTO:]FROM-TO",
+		},
+		[IPSET_ADD] = {
+			.args = {
+				IPSET_ARG_TIMEOUT,
+				IPSET_ARG_PACKETS,
+				IPSET_ARG_BYTES,
+				IPSET_ARG_ADT_COMMENT,
+				IPSET_ARG_SKBMARK,
+				IPSET_ARG_SKBPRIO,
+				IPSET_ARG_SKBQUEUE,
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.help = "[PROTO:]PORT|FROM-TO",
+		},
+		[IPSET_DEL] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_PORT)
+				| IPSET_FLAG(IPSET_OPT_PORT_TO),
+			.help = "[PROTO:]PORT|FROM-TO",
+		},
+		[IPSET_TEST] = {
+			.args = {
+				IPSET_ARG_NONE,
+			},
+			.need = IPSET_FLAG(IPSET_OPT_PORT),
+			.full = IPSET_FLAG(IPSET_OPT_PORT),
+			.help = "[PROTO:]PORT",
+		},
+	},
+	.usage = "where PORT, FROM and TO are port numbers or port names from /etc/services.\n"
+		 "      PROTO is only needed if a service name is used and it does not exist\n"
+		 "      as a TCP service; just the resolved service numer is stored in the set.",
+	.description = "SCTP and UDPLITE support",
+};
+
 void _init(void);
 void _init(void)
 {
@@ -289,4 +362,5 @@ void _init(void)
 	ipset_type_add(&ipset_bitmap_port1);
 	ipset_type_add(&ipset_bitmap_port2);
 	ipset_type_add(&ipset_bitmap_port3);
+	ipset_type_add(&ipset_bitmap_port4);
 }
diff --git a/src/ipset.8 b/src/ipset.8
index 269b9b5..5fa4577 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -504,7 +504,7 @@ Mandatory options to use when creating a \fBbitmap:port\fR type of set:
 Create the set from the specified inclusive port range.
 .PP
 The \fBset\fR match and \fBSET\fR target netfilter kernel modules interpret
-the stored numbers as TCP or UDP port numbers.
+the stored numbers as TCP, SCTP, UDP or UDPLITE port numbers.
 .PP
 \fBproto\fR only needs to be specified if a service name is used
 and that name does not exist as a TCP service. The protocol is never stored
-- 
2.21.1 (Apple Git-122.3)

