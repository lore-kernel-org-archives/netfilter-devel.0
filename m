Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377FBC4727C
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEF75206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 12:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JgEg+Ay2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgIYM6G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgIYMtt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:49 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83AAC0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:48 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p15so2874864ejm.7
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E0dmc2pklOk2HMRRZNWan9GmdWl+0xRqwT7hZ0ltRCQ=;
        b=JgEg+Ay2uKxUv1ENfsqruSveoWActElUwhud4U0SaTJN3FwhsVwPOkMZMJwm+W+JwY
         aOQmP+W0Y/tnr3z9oRlc20LCc6GESEDQRU+kCumyIIHNd2dR7YIk3xZ+3GzK201nwkbU
         /iLulTOiBo/JnYTdDxHLXUgJnc2ortKWMdI2znzEfG+OlzyR/81D/TqcaPZc0HaJQQBu
         CcqTwFnZZcPudHjHBfkDsIsK/VReyLbPsWaq1TBpVppOYjq+EGgG4DotLeX3uGhoJjYQ
         RubTjpEdskVERBDziKC2GO8gJBa35By0SCXTOwpzkplbXaWm9iBJhc1rafL31Jz5QAKi
         GmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0dmc2pklOk2HMRRZNWan9GmdWl+0xRqwT7hZ0ltRCQ=;
        b=oIFhOnX6t2d1uV0aeEoChP7jDtgXXd5/8Lfqt4RFjyad32pXxYKunEV8MHIc8WcelL
         sDAMuvc19ZBhdseW7HpY95ZRmXNElYApdCAo4cYDwkWCgxDn01nhP3lbonn467VnDAhH
         PoDVv5UhAgxXbLwDbt37th0+x6avtJqtYEx/54iC3aVpQFCqZ3WWjl8XTVK6CRcDv2Oi
         4DGGzallMc6EtUnXjJ3YkJ0GH/GokF0pCwlRmrqC0IOaYd5RFoYNYJQAGUjpvD/9Hcmx
         tHEMNxiAd/3cPLF5dYUy73omABoJmyJhFMGKBQpM04l0BX5uTR0iRbyExVZrGaFfx5H4
         G9GA==
X-Gm-Message-State: AOAM5310JYmDsnEWYi+4p5R6M75u5Jm9LCSU9LPopHYAqYJUlU7qMKXE
        X6ZYiBglfn6s1R5IOIN+H0uKVsCTnzrwqA==
X-Google-Smtp-Source: ABdhPJxjVGaMlJn2bM/e2AbqhYA4DYIqos3Kw1/GsPjvuteC3EJReh8fcg7X6Q+NAQuMUafPvfvQBQ==
X-Received: by 2002:a17:906:bcfc:: with SMTP id op28mr2621038ejb.248.1601038186750;
        Fri, 25 Sep 2020 05:49:46 -0700 (PDT)
Received: from localhost.localdomain (dynamic-046-114-037-141.46.114.pool.telefonica.de. [46.114.37.141])
        by smtp.gmail.com with ESMTPSA id t3sm1761642edv.59.2020.09.25.05.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 05:49:46 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 6/8] conntrack: implement options output format
Date:   Fri, 25 Sep 2020 14:49:17 +0200
Message-Id: <20200925124919.9389-7-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As a counterpart to the "conntrack: accept parameters from stdin"
commit, this commit allows dumping conntrack entries in the format
used by the conntrack parameters.
This is useful for transfering a large set of ct entries between
hosts or between different ct zones in an efficient way.

To enable the "options" output the "-o opts" parameter needs to be
passed to the "contnrack -L" tool invocation.

To demonstrate the overall idea of the options output format works
in conjunction with the "stdin parameter"s mode,
the following command will copy all ct entries from one ct zone
to another.

conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 extensions/libct_proto_dccp.c    |  24 +++
 extensions/libct_proto_gre.c     |  16 ++
 extensions/libct_proto_icmp.c    |  15 ++
 extensions/libct_proto_icmpv6.c  |  15 ++
 extensions/libct_proto_sctp.c    |  19 +++
 extensions/libct_proto_tcp.c     |  17 ++
 extensions/libct_proto_udp.c     |  16 ++
 extensions/libct_proto_udplite.c |  16 ++
 include/conntrack.h              |  38 +++++
 src/conntrack.c                  | 261 ++++++++++++++++++++++++++++++-
 10 files changed, 433 insertions(+), 4 deletions(-)

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index f6258ad..cfe1313 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -198,6 +198,29 @@ static int parse_options(char c,
 	return 1;
 }
 
+
+static const char *dccp_roles[__DCCP_CONNTRACK_ROLE_MAX] = {
+	[DCCP_CONNTRACK_ROLE_CLIENT]	= "client",
+	[DCCP_CONNTRACK_ROLE_SERVER]	= "server",
+};
+
+static struct ctproto_attr attrs[] = {
+		{"--sport", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dport", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--state", ATTR_DCCP_STATE, CTPROTO_ATTR_U8, DCCP_CONNTRACK_MAX, dccp_states},
+		{"--role", ATTR_DCCP_ROLE, CTPROTO_ATTR_U8, __DCCP_CONNTRACK_ROLE_MAX, dccp_roles},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define DCCP_VALID_FLAGS_MAX	2
 static unsigned int dccp_valid_flags[DCCP_VALID_FLAGS_MAX] = {
 	CT_DCCP_ORIG_SPORT | CT_DCCP_ORIG_DPORT,
@@ -235,6 +258,7 @@ static struct ctproto_handler dccp = {
 	.protonum		= IPPROTO_DCCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index 2dc63d1..b03887b 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -144,6 +144,21 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--srckey", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dstkey", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-key-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-key-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define GRE_VALID_FLAGS_MAX   2
 static unsigned int gre_valid_flags[GRE_VALID_FLAGS_MAX] = {
        CT_GRE_ORIG_SKEY | CT_GRE_ORIG_DKEY,
@@ -181,6 +196,7 @@ static struct ctproto_handler gre = {
 	.protonum		= IPPROTO_GRE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index 16c2e2e..e1af53f 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -114,6 +114,20 @@ static int parse(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--icmp-type", ATTR_ICMP_TYPE, CTPROTO_ATTR_U8, 0, 0},
+		{"--icmp-code", ATTR_ICMP_CODE, CTPROTO_ATTR_U8, 0, 0},
+		{"--icmp-id", ATTR_ICMP_ID, CTPROTO_ATTR_U16_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -129,6 +143,7 @@ static struct ctproto_handler icmp = {
 	.protonum	= IPPROTO_ICMP,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.snprintf_options	= snprintf_options,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index 7f5e637..cb2178e 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -117,6 +117,20 @@ static int parse(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--icmpv6-type", ATTR_ICMP_TYPE, CTPROTO_ATTR_U8, 0, 0},
+		{"--icmpv6-code", ATTR_ICMP_CODE, CTPROTO_ATTR_U8, 0, 0},
+		{"--icmpv6-id", ATTR_ICMP_ID, CTPROTO_ATTR_U16_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -131,6 +145,7 @@ static struct ctproto_handler icmpv6 = {
 	.protonum	= IPPROTO_ICMPV6,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.snprintf_options	= snprintf_options,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index 04828bf..5b7a43b 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -198,6 +198,24 @@ parse_options(char c, struct nf_conntrack *ct,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--sport", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dport", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--state", ATTR_SCTP_STATE, CTPROTO_ATTR_U8, SCTP_CONNTRACK_MAX, sctp_states},
+		{"--orig-vtag", ATTR_SCTP_VTAG_ORIG, CTPROTO_ATTR_U32_N, 0, 0},
+		{"--reply-vtag", ATTR_SCTP_VTAG_REPL, CTPROTO_ATTR_U32_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define SCTP_VALID_FLAGS_MAX   2
 static unsigned int dccp_valid_flags[SCTP_VALID_FLAGS_MAX] = {
 	CT_SCTP_ORIG_SPORT | CT_SCTP_ORIG_DPORT,
@@ -235,6 +253,7 @@ static struct ctproto_handler sctp = {
 	.protonum		= IPPROTO_SCTP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 8a37a55..90fecf6 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -177,6 +177,22 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--sport", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dport", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--state", ATTR_TCP_STATE, CTPROTO_ATTR_U8, TCP_CONNTRACK_MAX, tcp_states},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define TCP_VALID_FLAGS_MAX   2
 static unsigned int tcp_valid_flags[TCP_VALID_FLAGS_MAX] = {
        CT_TCP_ORIG_SPORT | CT_TCP_ORIG_DPORT,
@@ -228,6 +244,7 @@ static struct ctproto_handler tcp = {
 	.protonum		= IPPROTO_TCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index e30637c..a70cee0 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -144,6 +144,21 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--sport", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dport", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define UDP_VALID_FLAGS_MAX   2
 static unsigned int udp_valid_flags[UDP_VALID_FLAGS_MAX] = {
        CT_UDP_ORIG_SPORT | CT_UDP_ORIG_DPORT,
@@ -181,6 +196,7 @@ static struct ctproto_handler udp = {
 	.protonum		= IPPROTO_UDP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index f46cef0..382d990 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -148,6 +148,21 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ctproto_attr attrs[] = {
+		{"--sport", ATTR_ORIG_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--dport", ATTR_ORIG_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-src", ATTR_REPL_PORT_SRC, CTPROTO_ATTR_U16_N, 0, 0},
+		{"--reply-port-dst", ATTR_REPL_PORT_DST, CTPROTO_ATTR_U16_N, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int snprintf_options(char *buf,
+			 unsigned int len,
+			 const struct nf_conntrack *ct)
+{
+	return snprintf_attrs(buf, len, ct, attrs);
+}
+
 #define UDPLITE_VALID_FLAGS_MAX   2
 static unsigned int udplite_valid_flags[UDPLITE_VALID_FLAGS_MAX] = {
        CT_UDPLITE_ORIG_SPORT | CT_UDPLITE_ORIG_DPORT,
@@ -186,6 +201,7 @@ static struct ctproto_handler udplite = {
 	.protonum		= IPPROTO_UDPLITE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.snprintf_options	= snprintf_options,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/include/conntrack.h b/include/conntrack.h
index 37ccf6e..b518096 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -8,6 +8,9 @@
 
 #include <netinet/in.h>
 
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
 #define NUMBER_OF_CMD   19
 #define NUMBER_OF_OPT   29
 
@@ -32,6 +35,10 @@ struct ctproto_handler {
 			    unsigned int command,
 			    struct nf_conntrack *ct);
 
+	int (*snprintf_options)(char *buf,
+				 unsigned int len,
+				 const struct nf_conntrack *ct);
+
 	void (*help)(void);
 
 	struct option 		*opts;
@@ -53,6 +60,37 @@ void exit_error(enum exittype status, const char *msg, ...);
 
 extern void register_proto(struct ctproto_handler *h);
 
+enum ctproto_attr_value_type {
+	CTPROTO_ATTR_U8 = 1,
+	CTPROTO_ATTR_U16_N,
+	CTPROTO_ATTR_U16_H,
+	CTPROTO_ATTR_U32_N,
+	CTPROTO_ATTR_U32_H,
+	CTPROTO_ATTR_U64_H,
+	CTPROTO_ATTR_U32_BITMAP,
+	CTPROTO_ATTR_IPV4,
+	CTPROTO_ATTR_IPV6,
+};
+
+struct ctproto_attr {
+	const char *name;
+	enum nf_conntrack_attr type;
+	short value_type;
+	short val_mapping_count;
+	const char **val_mapping;
+};
+
+extern int snprintf_attr(char *buf,
+				unsigned int len,
+				const struct nf_conntrack *ct,
+				const struct ctproto_attr *attr);
+
+extern int snprintf_attrs(char *buf,
+				unsigned int len,
+				const struct nf_conntrack *ct,
+				const struct ctproto_attr *attrs);
+
+
 extern void register_tcp(void);
 extern void register_udp(void);
 extern void register_udplite(void);
diff --git a/src/conntrack.c b/src/conntrack.c
index 5834f2d..a11958b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -53,6 +53,7 @@
 #include <sys/socket.h>
 #include <sys/time.h>
 #include <time.h>
+#include <inttypes.h>
 #ifdef HAVE_ARPA_INET_H
 #include <arpa/inet.h>
 #endif
@@ -610,6 +611,222 @@ void register_proto(struct ctproto_handler *h)
 	list_add(&h->head, &proto_list);
 }
 
+#define BUFFER_SIZE(ret, size, len, offset)		do {\
+	size += ret;					\
+	if ((int)ret > (int)len)					\
+		ret = len;				\
+	offset += ret;					\
+	len -= ret;	\
+} while(0)
+
+int snprintf_attr(char *buf,
+				unsigned int len,
+				const struct nf_conntrack *ct,
+				const struct ctproto_attr *attr
+				)
+{
+	uint16_t u16;
+	uint32_t u32;
+	uint64_t u64_val = 0;
+	char ipstr[INET6_ADDRSTRLEN];
+
+	if (!nfct_attr_is_set(ct, attr->type))
+		return 0;
+
+	switch (attr->value_type) {
+	case CTPROTO_ATTR_U8:
+		u64_val = nfct_get_attr_u8(ct, attr->type);
+		break;
+	case CTPROTO_ATTR_U16_N:
+		u16 = nfct_get_attr_u16(ct, attr->type);
+		u64_val = ntohs(u16);
+		break;
+	case CTPROTO_ATTR_U16_H:
+		u64_val = nfct_get_attr_u16(ct, attr->type);
+		break;
+	case CTPROTO_ATTR_U32_N:
+		u32 = nfct_get_attr_u32(ct, attr->type);
+		u64_val = ntohl(u32);
+		break;
+	case CTPROTO_ATTR_U32_H:
+		u64_val = nfct_get_attr_u32(ct, attr->type);
+		break;
+	case CTPROTO_ATTR_U64_H:
+		u64_val = nfct_get_attr_u64(ct, attr->type);
+		break;
+	case CTPROTO_ATTR_IPV4:
+		inet_ntop(AF_INET, nfct_get_attr(ct, attr->type), ipstr, sizeof(ipstr));
+		break;
+	case CTPROTO_ATTR_IPV6:
+		inet_ntop(AF_INET6, nfct_get_attr(ct, attr->type), ipstr, sizeof(ipstr));
+		break;
+	case CTPROTO_ATTR_U32_BITMAP:
+		u64_val = nfct_get_attr_u32(ct, attr->type);
+		break;
+	default:
+		fprintf(stderr, "unsupported type %u\n", attr->value_type);
+		return 0;
+	}
+
+	if (attr->value_type == CTPROTO_ATTR_IPV4
+			|| attr->value_type == CTPROTO_ATTR_IPV6) {
+	    return snprintf(buf, len, "%s %s ", attr->name, ipstr);
+	}
+
+	if (attr->val_mapping) {
+		if (attr->value_type == CTPROTO_ATTR_U32_BITMAP) {
+			unsigned int size = 0, offset = 0, ret, i, imax, found = 0;
+
+			if (!u64_val)
+				return 0;
+
+			imax = 31 < attr->val_mapping_count ? 31 : attr->val_mapping_count;
+			for (i = 0; i < imax; ++i) {
+				if (!(u64_val & (1 << i)))
+					continue;
+				if (!attr->val_mapping[i])
+					continue;
+
+				if (!found) {
+					ret = snprintf(buf + offset, len, "%s %s", attr->name, attr->val_mapping[i]);
+					found = 1;
+				} else
+					ret = snprintf(buf + offset, len, ",%s", attr->val_mapping[i]);
+				BUFFER_SIZE(ret, size, len, offset);
+			}
+
+			if (found) {
+				ret = snprintf(buf + offset, len, " ");
+				BUFFER_SIZE(ret, size, len, offset);
+			}
+			return size;
+		}
+
+		if (u64_val >= (uint64_t)attr->val_mapping_count) {
+			fprintf(stderr, "too big value for mapping %s %" PRIu64 "\n",
+					attr->name, u64_val);
+			return 0;
+		}
+		if (!attr->val_mapping[u64_val]) {
+			fprintf(stderr, "no mapping for %s %" PRIu64 "\n",
+					attr->name, u64_val);
+			return 0;
+		}
+		return snprintf(buf, len, "%s %s ", attr->name, attr->val_mapping[u64_val]);
+	}
+
+	return snprintf(buf, len, "%s %" PRIu64 " ", attr->name, u64_val);
+}
+
+int snprintf_attrs(char *buf,
+				unsigned int len,
+				const struct nf_conntrack *ct,
+				const struct ctproto_attr *attrs)
+{
+	int i;
+	unsigned int size = 0, offset = 0, ret;
+
+	for (i = 0; attrs[i].name; ++i) {
+		ret = snprintf_attr(buf + offset, len, ct, &attrs[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return size;
+}
+
+static struct ctproto_attr attrs_ipv4[] = {
+		{"-s", ATTR_ORIG_IPV4_SRC, CTPROTO_ATTR_IPV4, 0, 0},
+		{"-d", ATTR_ORIG_IPV4_DST, CTPROTO_ATTR_IPV4, 0, 0},
+		{"-g", ATTR_DNAT_IPV4, CTPROTO_ATTR_IPV4, 0, 0},
+		{"-n", ATTR_SNAT_IPV4, CTPROTO_ATTR_IPV4, 0, 0},
+		{"-r", ATTR_REPL_IPV4_SRC, CTPROTO_ATTR_IPV4, 0, 0},
+		{"-q", ATTR_REPL_IPV4_DST, CTPROTO_ATTR_IPV4, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static struct ctproto_attr attrs_ipv6[] = {
+		{"-s", ATTR_ORIG_IPV6_SRC, CTPROTO_ATTR_IPV6, 0, 0},
+		{"-d", ATTR_ORIG_IPV6_DST, CTPROTO_ATTR_IPV6, 0, 0},
+		{"-g", ATTR_DNAT_IPV6, CTPROTO_ATTR_IPV6, 0, 0},
+		{"-n", ATTR_SNAT_IPV6, CTPROTO_ATTR_IPV6, 0, 0},
+		{"-r", ATTR_REPL_IPV6_SRC, CTPROTO_ATTR_IPV6, 0, 0},
+		{"-q", ATTR_REPL_IPV6_DST, CTPROTO_ATTR_IPV6, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static const char *conntrack_status_map[] = {
+		[IPS_ASSURED_BIT] = "ASSURED",
+		[IPS_SEEN_REPLY_BIT] = "SEEN_REPLY",
+		[IPS_FIXED_TIMEOUT_BIT] = "FIXED_TIMEOUT",
+		[IPS_EXPECTED_BIT] = "EXPECTED"
+};
+
+static struct ctproto_attr attrs_generic[] = {
+		{"-t", ATTR_TIMEOUT, CTPROTO_ATTR_U32_H, 0, 0},
+		{"-u", ATTR_STATUS, CTPROTO_ATTR_U32_BITMAP,
+				sizeof(conntrack_status_map)/sizeof(conntrack_status_map[0]),
+				conntrack_status_map},
+		{"-c", ATTR_SECMARK, CTPROTO_ATTR_U32_H, 0, 0},
+/*		{"-i", ATTR_ID, CTPROTO_ATTR_U32_H, 0, 0}, */
+		{"-w", ATTR_ZONE, CTPROTO_ATTR_U16_H, 0, 0},
+		{"--orig-zone", ATTR_ORIG_ZONE, CTPROTO_ATTR_U16_H, 0, 0},
+		{"--reply-zone", ATTR_REPL_ZONE, CTPROTO_ATTR_U16_H, 0, 0},
+		{0, 0, 0, 0, 0},
+};
+
+static int nfct_snprintf_labels_opts(char *buf,
+				unsigned int len,
+				const struct nf_conntrack *ct,
+				struct nfct_labelmap *map)
+{
+	int ret = 0;
+	unsigned int size = 0, offset = 0;
+	uint8_t l3proto, l4proto;
+	static struct ctproto_attr *attrs_l3;
+	struct ctproto_handler *cur;
+
+	ret = snprintf_attrs(buf + offset, len, ct, attrs_generic);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l3proto = nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO);
+	if (!l3proto)
+		l3proto = nfct_get_attr_u8(ct, ATTR_REPL_L3PROTO);
+	switch (l3proto) {
+	case AF_INET:
+		attrs_l3 = attrs_ipv4;
+		break;
+	case AF_INET6:
+		attrs_l3 = attrs_ipv6;
+		break;
+	default:
+		fprintf(stderr,
+				"WARNING: unknown l3proto %d, skipping..\n", l3proto);
+		return 0;
+	}
+
+	ret = snprintf_attrs(buf + offset, len, ct, attrs_l3);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
+
+	/* is it in the list of supported protocol? */
+	list_for_each_entry(cur, &proto_list, head) {
+		if (cur->protonum == l4proto) {
+			ret = snprintf(buf + offset, len, "-p %s ", cur->name);
+			BUFFER_SIZE(ret, size, len, offset);
+			ret = cur->snprintf_options(buf + offset, len, ct);
+			BUFFER_SIZE(ret, size, len, offset);
+			break;
+		}
+	}
+
+	/* skip trailing space, if any */
+	for (;size && buf[size-1] == ' '; --size)
+		buf[size-1] = '\0';
+
+	return size;
+}
+
 extern struct ctproto_handler ct_proto_unknown;
 
 static struct ctproto_handler *findproto(char *name, int *pnum)
@@ -865,6 +1082,7 @@ enum {
 	_O_KTMS	= (1 << 4),
 	_O_CL	= (1 << 5),
 	_O_US	= (1 << 6),
+	_O_OPTS	= (1 << 7),
 };
 
 enum {
@@ -875,7 +1093,7 @@ enum {
 };
 
 static struct parse_parameter {
-	const char	*parameter[7];
+	const char	*parameter[8];
 	size_t  size;
 	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
@@ -883,8 +1101,8 @@ static struct parse_parameter {
 	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD, IPS_HW_OFFLOAD} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
-	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace" }, 7,
-	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US },
+	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace", "opts"}, 8,
+	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US, _O_OPTS },
 	},
 };
 
@@ -1467,6 +1685,11 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 	if (nfct_filter(obj, ct))
 		goto out;
 
+	if (output_mask & _O_OPTS) {
+		nfct_snprintf_labels_opts(buf, sizeof(buf), ct, labelmap);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1491,7 +1714,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
-
+done:
 	if (output_mask & _O_US) {
 		if (nlh->nlmsg_pid)
 			userspace = true;
@@ -1520,6 +1743,11 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (output_mask & _O_OPTS) {
+		nfct_snprintf_labels_opts(buf, sizeof(buf), ct, labelmap);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1536,6 +1764,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1562,6 +1791,11 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
 
+	if (output_mask & _O_OPTS) {
+		nfct_snprintf_labels_opts(buf, sizeof(buf), ct, labelmap);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1570,6 +1804,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1585,6 +1820,11 @@ static int print_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_OPTS) {
+		nfct_snprintf_labels_opts(buf, sizeof(buf), ct, labelmap);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1593,6 +1833,7 @@ static int print_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
@@ -1757,6 +1998,12 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_OPTS) {
+		/* not implemented at the moment */
+		exit_error(PARAMETER_PROBLEM,
+		   "opts output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1788,6 +2035,12 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_OPTS) {
+		/* not implemented at the moment */
+		exit_error(PARAMETER_PROBLEM,
+		   "opts output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
-- 
2.25.1

