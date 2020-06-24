Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB9EC433E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6070220738
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403941AbgFXNaN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403936AbgFXNaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:12 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45347C061573
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:12 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:10 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 7/9] Move icmp request>reply type mapping to common file
Date:   Wed, 24 Jun 2020 15:30:03 +0200
Message-Id: <20200624133005.22046-7-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently the invmap_icmp* arrays are duplicated in setter.c and
grp_setter.c. This moves them to a new module 'proto'.

Instead of having the code access the arrays directly we provide new
wrapper functions __icmp{,v6}_reply_type.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 include/internal/internal.h |  1 +
 include/internal/proto.h    | 19 +++++++++++++++++++
 src/conntrack/Makefile.am   |  3 ++-
 src/conntrack/grp_setter.c  | 34 ++--------------------------------
 src/conntrack/proto.c       | 36 ++++++++++++++++++++++++++++++++++++
 src/conntrack/setter.c      | 34 ++--------------------------------
 6 files changed, 62 insertions(+), 65 deletions(-)
 create mode 100644 include/internal/proto.h
 create mode 100644 src/conntrack/proto.c

diff --git a/include/internal/internal.h b/include/internal/internal.h
index 0f59f1a..2ef8a90 100644
--- a/include/internal/internal.h
+++ b/include/internal/internal.h
@@ -27,6 +27,7 @@
 #include "internal/types.h"
 #include "internal/extern.h"
 #include "internal/bitops.h"
+#include "internal/proto.h"
 
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
diff --git a/include/internal/proto.h b/include/internal/proto.h
new file mode 100644
index 0000000..40e7bfe
--- /dev/null
+++ b/include/internal/proto.h
@@ -0,0 +1,19 @@
+#ifndef _NFCT_PROTO_H_
+#define _NFCT_PROTO_H_
+
+#include <stdint.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+
+#ifndef ICMPV6_NI_QUERY
+#define ICMPV6_NI_QUERY 139
+#endif
+
+#ifndef ICMPV6_NI_REPLY
+#define ICMPV6_NI_REPLY 140
+#endif
+
+uint8_t __icmp_reply_type(uint8_t type);
+uint8_t __icmpv6_reply_type(uint8_t type);
+
+#endif
diff --git a/src/conntrack/Makefile.am b/src/conntrack/Makefile.am
index 602ed33..1fbf176 100644
--- a/src/conntrack/Makefile.am
+++ b/src/conntrack/Makefile.am
@@ -14,4 +14,5 @@ libnfconntrack_la_SOURCES = api.c \
 			    copy.c \
 			    filter.c bsf.c filter_dump.c \
 			    grp.c grp_getter.c grp_setter.c \
-			    stack.c
+			    stack.c \
+			    proto.c
diff --git a/src/conntrack/grp_setter.c b/src/conntrack/grp_setter.c
index 49dc033..82a6139 100644
--- a/src/conntrack/grp_setter.c
+++ b/src/conntrack/grp_setter.c
@@ -8,34 +8,6 @@
  */
 
 #include "internal/internal.h"
-#include <linux/icmp.h>
-#include <linux/icmpv6.h>
-
-static const uint8_t invmap_icmp[] = {
-	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
-	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
-	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
-	[ICMP_TIMESTAMPREPLY]	= ICMP_TIMESTAMP + 1,
-	[ICMP_INFO_REQUEST]	= ICMP_INFO_REPLY + 1,
-	[ICMP_INFO_REPLY]	= ICMP_INFO_REQUEST + 1,
-	[ICMP_ADDRESS]		= ICMP_ADDRESSREPLY + 1,
-	[ICMP_ADDRESSREPLY]	= ICMP_ADDRESS + 1
-};
-
-#ifndef ICMPV6_NI_QUERY
-#define ICMPV6_NI_QUERY 139
-#endif
-
-#ifndef ICMPV6_NI_REPLY
-#define ICMPV6_NI_REPLY 140
-#endif
-
-static const uint8_t invmap_icmpv6[] = {
-	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
-	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
-	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
-	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY + 1
-};
 
 static void set_attr_grp_orig_ipv4(struct nf_conntrack *ct, const void *value)
 {
@@ -92,13 +64,11 @@ static void set_attr_grp_icmp(struct nf_conntrack *ct, const void *value)
 
 	switch(ct->head.orig.l3protonum) {
 		case AF_INET:
-			if (this->type < ARRAY_SIZE(invmap_icmp))
-				rtype = invmap_icmp[this->type];
+			rtype = __icmp_reply_type(this->type);
 			break;
 
 		case AF_INET6:
-			if (this->type - 128 < ARRAY_SIZE(invmap_icmp))
-				rtype = invmap_icmpv6[this->type - 128];
+			rtype = __icmpv6_reply_type(this->type);
 			break;
 
 		default:
diff --git a/src/conntrack/proto.c b/src/conntrack/proto.c
new file mode 100644
index 0000000..ba79b9b
--- /dev/null
+++ b/src/conntrack/proto.c
@@ -0,0 +1,36 @@
+#include <internal/proto.h>
+#include <internal/internal.h>
+
+static const uint8_t invmap_icmp[] = {
+	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
+	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
+	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
+	[ICMP_TIMESTAMPREPLY]	= ICMP_TIMESTAMP + 1,
+	[ICMP_INFO_REQUEST]	= ICMP_INFO_REPLY + 1,
+	[ICMP_INFO_REPLY]	= ICMP_INFO_REQUEST + 1,
+	[ICMP_ADDRESS]		= ICMP_ADDRESSREPLY + 1,
+	[ICMP_ADDRESSREPLY]	= ICMP_ADDRESS + 1
+};
+
+static const uint8_t invmap_icmpv6[] = {
+	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
+	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
+	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
+	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY + 1
+};
+
+uint8_t __icmp_reply_type(uint8_t type)
+{
+	if (type < ARRAY_SIZE(invmap_icmp))
+		return invmap_icmp[type];
+
+	return 0;
+}
+
+uint8_t __icmpv6_reply_type(uint8_t type)
+{
+	if (type - 128 < ARRAY_SIZE(invmap_icmpv6))
+		return invmap_icmpv6[type - 128];
+
+	return 0;
+}
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 1d3b971..cee81f1 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -8,34 +8,6 @@
  */
 
 #include "internal/internal.h"
-#include <linux/icmp.h>
-#include <linux/icmpv6.h>
-
-static const uint8_t invmap_icmp[] = {
-	[ICMP_ECHO]		= ICMP_ECHOREPLY + 1,
-	[ICMP_ECHOREPLY]	= ICMP_ECHO + 1,
-	[ICMP_TIMESTAMP]	= ICMP_TIMESTAMPREPLY + 1,
-	[ICMP_TIMESTAMPREPLY]	= ICMP_TIMESTAMP + 1,
-	[ICMP_INFO_REQUEST]	= ICMP_INFO_REPLY + 1,
-	[ICMP_INFO_REPLY]	= ICMP_INFO_REQUEST + 1,
-	[ICMP_ADDRESS]		= ICMP_ADDRESSREPLY + 1,
-	[ICMP_ADDRESSREPLY]	= ICMP_ADDRESS + 1
-};
-
-#ifndef ICMPV6_NI_QUERY
-#define ICMPV6_NI_QUERY 139
-#endif
-
-#ifndef ICMPV6_NI_REPLY
-#define ICMPV6_NI_REPLY 140
-#endif
-
-static const uint8_t invmap_icmpv6[] = {
-	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
-	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
-	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
-	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY + 1
-};
 
 static void
 set_attr_orig_ipv4_src(struct nf_conntrack *ct, const void *value, size_t len)
@@ -131,13 +103,11 @@ set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
 
 	switch(ct->head.orig.l3protonum) {
 		case AF_INET:
-			if (type < ARRAY_SIZE(invmap_icmp))
-				rtype = invmap_icmp[type];
+			rtype = __icmp_reply_type(type);
 			break;
 
 		case AF_INET6:
-			if (type - 128 < ARRAY_SIZE(invmap_icmpv6))
-				rtype = invmap_icmpv6[type - 128];
+			rtype = __icmpv6_reply_type(type);
 			break;
 
 		default:
-- 
2.20.1

