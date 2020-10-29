Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79782C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFACC206F7
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="g7hhB3G1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgJ2Lwb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2Lwa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:52:30 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5858C0613D2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:29 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id 7so3457143ejm.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xLOHENbKoAScru3wgsncii9GyTcw8q82DVzyxBOyPR0=;
        b=g7hhB3G1ZJpe3LwNm/hOLxuNy1E/8fkaW84sHndQ3thPk14vtYb9yKtekMX0ON9H0B
         teMoeWLkNrfnUJuA3DsCcVMDlYQTVCTa3ykw0nPjD8skSRTBdZlWXrAPKYRSM6k3OsUd
         eX2TPqp7sg8nkvqODRibNyEPCgftThZZYm0OzV0k9SJAN/DW0pzk0hDoh9z1wp5XzGKd
         gXgeb+hrqnMXSJ33trBOrvAB6qrDZccO6lvndkWrGXQ9FoSLNG1maip44XwVGdodtOXO
         E8+Qh6gLcFbMyyUNw4kZpzJbsFdkIMQbhXVjEUh+igCR1Roy68pRr0DQsTjmVCJu54f4
         bLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xLOHENbKoAScru3wgsncii9GyTcw8q82DVzyxBOyPR0=;
        b=oAFxQDH7tK9ye51le5EMH+d/sNsj/alIjhImQ9ED2J8rKt5B+D5xZ+vQL5YAwaRCPM
         xtcP9HacBc4Gk79m5h4ADByv4CZtMqKvlUetpSuqfhh05oF0wgJSmAd+Q4evGg7m3UKq
         aySB0WT6KKzH+4qfh6yRA4997MD6k/o/qkg1XS1IeTMaGudTd9fb8S60BrZfUlZvNFDn
         L5Ew5AUqlpBVL+zwl1vwdPweCHtH5ptTXlGsZj3GtVVFNckKP6cvA8TvLU7sYK15gTUo
         Ge6XKam9V0HmHbAvMCSdIoKx8XkmYZVLt96IID2QCwyXURB8uo8PHgV1hCUxRIteSJ7B
         h/ow==
X-Gm-Message-State: AOAM533pGXdewnkvf9iR5Pd1m3jH09u/VDXMQ41M3f3d62Q4jMd4KEPu
        OrWnmX4dC2jTzhusSqnPI8Fqj3oGjOVH3A==
X-Google-Smtp-Source: ABdhPJy4wmNNGPDsjMfG9xjLTKA0cqvADeWqA4RRpi0dsx2wTIq1veHSmZQUQ5iwY5OFWWLefPjljw==
X-Received: by 2002:a17:906:4bc9:: with SMTP id x9mr3600599ejv.37.1603972347756;
        Thu, 29 Oct 2020 04:52:27 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id q19sm1391188ejz.90.2020.10.29.04.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:52:27 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 1/2] conntrack: implement save output format
Date:   Thu, 29 Oct 2020 12:51:55 +0100
Message-Id: <20201029115156.69784-2-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201029115156.69784-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit allows dumping conntrack entries in the format
used by the conntrack parameters, aka "save" output format.
This is useful for saving ct entry data to allow applying
it later on.

To enable the "save" output the "-o save" parameter needs
to be passed to the contnrack tool invocation.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 extensions/libct_proto_dccp.c    |  17 ++
 extensions/libct_proto_gre.c     |   9 +
 extensions/libct_proto_icmp.c    |   8 +
 extensions/libct_proto_icmpv6.c  |   8 +
 extensions/libct_proto_sctp.c    |  12 ++
 extensions/libct_proto_tcp.c     |  10 ++
 extensions/libct_proto_udp.c     |   9 +
 extensions/libct_proto_udplite.c |   9 +
 include/conntrack.h              |  30 ++++
 src/conntrack.c                  | 291 ++++++++++++++++++++++++++++++-
 10 files changed, 399 insertions(+), 4 deletions(-)

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index f6258ad..e9da474 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -198,6 +198,22 @@ static int parse_options(char c,
 	return 1;
 }
 
+
+static const char *dccp_roles[__DCCP_CONNTRACK_ROLE_MAX] = {
+	[DCCP_CONNTRACK_ROLE_CLIENT]	= "client",
+	[DCCP_CONNTRACK_ROLE_SERVER]	= "server",
+};
+
+static const struct ct_print_opts dccp_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--state", ATTR_DCCP_STATE, CT_ATTR_TYPE_U8, DCCP_CONNTRACK_MAX, dccp_states },
+	{ "--role", ATTR_DCCP_ROLE, CT_ATTR_TYPE_U8, __DCCP_CONNTRACK_ROLE_MAX, dccp_roles },
+	{},
+};
+
 #define DCCP_VALID_FLAGS_MAX	2
 static unsigned int dccp_valid_flags[DCCP_VALID_FLAGS_MAX] = {
 	CT_DCCP_ORIG_SPORT | CT_DCCP_ORIG_DPORT,
@@ -235,6 +251,7 @@ static struct ctproto_handler dccp = {
 	.protonum		= IPPROTO_DCCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= dccp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index 2dc63d1..a36d111 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -144,6 +144,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static const struct ct_print_opts gre_print_opts[] = {
+	{ "--srckey", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dstkey", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-key-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-key-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{},
+};
+
 #define GRE_VALID_FLAGS_MAX   2
 static unsigned int gre_valid_flags[GRE_VALID_FLAGS_MAX] = {
        CT_GRE_ORIG_SKEY | CT_GRE_ORIG_DKEY,
@@ -181,6 +189,7 @@ static struct ctproto_handler gre = {
 	.protonum		= IPPROTO_GRE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= gre_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index 7fc82bd..ec52c39 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -102,6 +102,13 @@ static int parse(char c,
 	return 1;
 }
 
+static const struct ct_print_opts icmp_print_opts[] = {
+	{ "--icmp-type", ATTR_ICMP_TYPE, CT_ATTR_TYPE_U8, 0, 0 },
+	{ "--icmp-code", ATTR_ICMP_CODE, CT_ATTR_TYPE_U8, 0, 0 },
+	{ "--icmp-id", ATTR_ICMP_ID, CT_ATTR_TYPE_BE16, 0, 0 },
+	{}
+};
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -117,6 +124,7 @@ static struct ctproto_handler icmp = {
 	.protonum	= IPPROTO_ICMP,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.print_opts	= icmp_print_opts,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index f872c23..fe16a1d 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -105,6 +105,13 @@ static int parse(char c,
 	return 1;
 }
 
+static const struct ct_print_opts icmpv6_print_opts[] = {
+	{"--icmpv6-type", ATTR_ICMP_TYPE, CT_ATTR_TYPE_U8, 0, 0},
+	{"--icmpv6-code", ATTR_ICMP_CODE, CT_ATTR_TYPE_U8, 0, 0},
+	{"--icmpv6-id", ATTR_ICMP_ID, CT_ATTR_TYPE_BE16, 0, 0},
+	{},
+};
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -119,6 +126,7 @@ static struct ctproto_handler icmpv6 = {
 	.protonum	= IPPROTO_ICMPV6,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.print_opts	= icmpv6_print_opts,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index 04828bf..a58ccde 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -198,6 +198,17 @@ parse_options(char c, struct nf_conntrack *ct,
 	return 1;
 }
 
+static const struct ct_print_opts sctp_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--state", ATTR_SCTP_STATE, CT_ATTR_TYPE_U8, SCTP_CONNTRACK_MAX, sctp_states },
+	{ "--orig-vtag", ATTR_SCTP_VTAG_ORIG, CT_ATTR_TYPE_BE32, 0, 0 },
+	{ "--reply-vtag", ATTR_SCTP_VTAG_REPL, CT_ATTR_TYPE_BE32, 0, 0 },
+	{},
+};
+
 #define SCTP_VALID_FLAGS_MAX   2
 static unsigned int dccp_valid_flags[SCTP_VALID_FLAGS_MAX] = {
 	CT_SCTP_ORIG_SPORT | CT_SCTP_ORIG_DPORT,
@@ -235,6 +246,7 @@ static struct ctproto_handler sctp = {
 	.protonum		= IPPROTO_SCTP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= sctp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 8a37a55..2b68b19 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -177,6 +177,15 @@ static int parse_options(char c,
 	return 1;
 }
 
+static const struct ct_print_opts tcp_print_opts[] = {
+	{"--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--state", ATTR_TCP_STATE, CT_ATTR_TYPE_U8, TCP_CONNTRACK_MAX, tcp_states},
+	{},
+};
+
 #define TCP_VALID_FLAGS_MAX   2
 static unsigned int tcp_valid_flags[TCP_VALID_FLAGS_MAX] = {
        CT_TCP_ORIG_SPORT | CT_TCP_ORIG_DPORT,
@@ -228,6 +237,7 @@ static struct ctproto_handler tcp = {
 	.protonum		= IPPROTO_TCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= tcp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index e30637c..fe43548 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -144,6 +144,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static const struct ct_print_opts udp_print_opts[] = {
+	{"--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{},
+};
+
 #define UDP_VALID_FLAGS_MAX   2
 static unsigned int udp_valid_flags[UDP_VALID_FLAGS_MAX] = {
        CT_UDP_ORIG_SPORT | CT_UDP_ORIG_DPORT,
@@ -181,6 +189,7 @@ static struct ctproto_handler udp = {
 	.protonum		= IPPROTO_UDP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= udp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index f46cef0..2bece38 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -148,6 +148,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static const struct ct_print_opts udplite_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{},
+};
+
 #define UDPLITE_VALID_FLAGS_MAX   2
 static unsigned int udplite_valid_flags[UDPLITE_VALID_FLAGS_MAX] = {
        CT_UDPLITE_ORIG_SPORT | CT_UDPLITE_ORIG_DPORT,
@@ -186,6 +194,7 @@ static struct ctproto_handler udplite = {
 	.protonum		= IPPROTO_UDPLITE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= udplite_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/include/conntrack.h b/include/conntrack.h
index 37ccf6e..bc58d3b 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -8,6 +8,9 @@
 
 #include <netinet/in.h>
 
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
 #define NUMBER_OF_CMD   19
 #define NUMBER_OF_OPT   29
 
@@ -32,6 +35,8 @@ struct ctproto_handler {
 			    unsigned int command,
 			    struct nf_conntrack *ct);
 
+	const struct ct_print_opts *print_opts;
+
 	void (*help)(void);
 
 	struct option 		*opts;
@@ -53,6 +58,31 @@ void exit_error(enum exittype status, const char *msg, ...);
 
 extern void register_proto(struct ctproto_handler *h);
 
+enum ct_attr_type {
+	CT_ATTR_TYPE_NONE = 0,
+	CT_ATTR_TYPE_U8,
+	CT_ATTR_TYPE_BE16,
+	CT_ATTR_TYPE_U16,
+	CT_ATTR_TYPE_BE32,
+	CT_ATTR_TYPE_U32,
+	CT_ATTR_TYPE_U64,
+	CT_ATTR_TYPE_U32_BITMAP,
+	CT_ATTR_TYPE_IPV4,
+	CT_ATTR_TYPE_IPV6,
+};
+
+struct ct_print_opts {
+	const char		*name;
+	enum nf_conntrack_attr	type;
+	short			value_type;
+	short			val_mapping_count;
+	const char		**val_mapping;
+};
+
+extern int ct_snprintf_opts(char *buf, unsigned int len,
+			    const struct nf_conntrack *ct,
+			    const struct ct_print_opts *attrs);
+
 extern void register_tcp(void);
 extern void register_udp(void);
 extern void register_udplite(void);
diff --git a/src/conntrack.c b/src/conntrack.c
index a26fa60..fe5ff6c 100644
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
@@ -607,6 +608,250 @@ void register_proto(struct ctproto_handler *h)
 	list_add(&h->head, &proto_list);
 }
 
+#define BUFFER_SIZE(ret, size, len, offset) do {			\
+	if ((int)ret > (int)len)					\
+		ret = len;						\
+	size += ret;							\
+	offset += ret;							\
+	len -= ret;							\
+} while(0)
+
+static int ct_snprintf_u32_bitmap(char *buf, size_t size,
+				  const struct nf_conntrack *ct,
+				  const struct ct_print_opts *attr)
+{
+	unsigned int offset = 0, ret, len = size;
+	bool found = false;
+	uint32_t val;
+	int i;
+
+	val = nfct_get_attr_u32(ct, attr->type);
+
+	for (i = 0; i < attr->val_mapping_count; i++) {
+		if (!(val & (1 << i)))
+			continue;
+		if (!attr->val_mapping[i])
+			continue;
+
+		ret = snprintf(buf + offset, len, "%s,", attr->val_mapping[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+		found = true;
+	}
+
+	if (found) {
+		offset--;
+		ret = snprintf(buf + offset, len, " ");
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int ct_snprintf_attr(char *buf, size_t size,
+			    const struct nf_conntrack *ct,
+			    const struct ct_print_opts *attr)
+{
+	char ipstr[INET6_ADDRSTRLEN] = {};
+	unsigned int offset = 0;
+	int type = attr->type;
+	int len = size;
+	int ret;
+
+	ret = snprintf(buf, len, "%s ", attr->name);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	switch (attr->value_type) {
+	case CT_ATTR_TYPE_U8:
+		if (attr->val_mapping)
+			ret = snprintf(buf + offset, len, "%s ",
+				       attr->val_mapping[nfct_get_attr_u8(ct, type)]);
+		else
+			ret = snprintf(buf + offset, len, "%u ",
+				       nfct_get_attr_u8(ct, type));
+		break;
+	case CT_ATTR_TYPE_BE16:
+		ret = snprintf(buf + offset, len, "%u ",
+			       ntohs(nfct_get_attr_u16(ct, type)));
+		break;
+	case CT_ATTR_TYPE_U16:
+		ret = snprintf(buf + offset, len, "%u ",
+			       nfct_get_attr_u16(ct, type));
+		break;
+	case CT_ATTR_TYPE_BE32:
+		ret = snprintf(buf + offset, len, "%u ",
+			       ntohl(nfct_get_attr_u32(ct, type)));
+		break;
+	case CT_ATTR_TYPE_U32:
+		ret = snprintf(buf + offset, len, "%u ",
+			       nfct_get_attr_u32(ct, type));
+		break;
+	case CT_ATTR_TYPE_U64:
+		ret = snprintf(buf + offset, len, "%lu ",
+			       nfct_get_attr_u64(ct, type));
+		break;
+	case CT_ATTR_TYPE_IPV4:
+		inet_ntop(AF_INET, nfct_get_attr(ct, type),
+			  ipstr, sizeof(ipstr));
+		ret = snprintf(buf + offset, len, "%s ", ipstr);
+		break;
+	case CT_ATTR_TYPE_IPV6:
+		inet_ntop(AF_INET6, nfct_get_attr(ct, type),
+			  ipstr, sizeof(ipstr));
+		ret = snprintf(buf + offset, len, "%s ", ipstr);
+		break;
+	case CT_ATTR_TYPE_U32_BITMAP:
+		ret = ct_snprintf_u32_bitmap(buf + offset, len, ct, attr);
+		break;
+	default:
+		/* Unsupported datatype, should not ever happen */
+		ret = 0;
+		break;
+	}
+	BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+int ct_snprintf_opts(char *buf, unsigned int len, const struct nf_conntrack *ct,
+		     const struct ct_print_opts *attrs)
+{
+	unsigned int size = 0, offset = 0, ret;
+	int i;
+
+	for (i = 0; attrs[i].name; ++i) {
+		if (!nfct_attr_is_set(ct, attrs[i].type))
+			continue;
+
+		ret = ct_snprintf_attr(buf + offset, len, ct, &attrs[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static const struct ct_print_opts attrs_ip_map[] = {
+	[ATTR_ORIG_IPV4_SRC] = {"-s", ATTR_ORIG_IPV4_SRC, CT_ATTR_TYPE_IPV4, 0, 0},
+	[ATTR_ORIG_IPV4_DST] = {"-d", ATTR_ORIG_IPV4_DST, CT_ATTR_TYPE_IPV4, 0, 0},
+	[ATTR_DNAT_IPV4]     = {"-g", ATTR_REPL_IPV4_SRC, CT_ATTR_TYPE_IPV4, 0, 0},
+	[ATTR_SNAT_IPV4]     = {"-n", ATTR_REPL_IPV4_DST, CT_ATTR_TYPE_IPV4, 0, 0},
+	[ATTR_REPL_IPV4_SRC] = {"-r", ATTR_REPL_IPV4_SRC, CT_ATTR_TYPE_IPV4, 0, 0},
+	[ATTR_REPL_IPV4_DST] = {"-q", ATTR_REPL_IPV4_DST, CT_ATTR_TYPE_IPV4, 0, 0},
+
+	[ATTR_ORIG_IPV6_SRC] = {"-s", ATTR_ORIG_IPV6_SRC, CT_ATTR_TYPE_IPV6, 0, 0},
+	[ATTR_ORIG_IPV6_DST] = {"-d", ATTR_ORIG_IPV6_DST, CT_ATTR_TYPE_IPV6, 0, 0},
+	[ATTR_DNAT_IPV6]     = {"-g", ATTR_REPL_IPV6_SRC, CT_ATTR_TYPE_IPV6, 0, 0},
+	[ATTR_SNAT_IPV6]     = {"-n", ATTR_REPL_IPV6_DST, CT_ATTR_TYPE_IPV6, 0, 0},
+	[ATTR_REPL_IPV6_SRC] = {"-r", ATTR_REPL_IPV6_SRC, CT_ATTR_TYPE_IPV6, 0, 0},
+	[ATTR_REPL_IPV6_DST] = {"-q", ATTR_REPL_IPV6_DST, CT_ATTR_TYPE_IPV6, 0, 0},
+};
+
+static const char *conntrack_status_map[] = {
+	[IPS_ASSURED_BIT] = "ASSURED",
+	[IPS_SEEN_REPLY_BIT] = "SEEN_REPLY",
+	[IPS_FIXED_TIMEOUT_BIT] = "FIXED_TIMEOUT",
+	[IPS_EXPECTED_BIT] = "EXPECTED"
+};
+
+static struct ct_print_opts attrs_generic[] = {
+	{"-t", ATTR_TIMEOUT, CT_ATTR_TYPE_U32, 0, 0},
+	{"-u", ATTR_STATUS, CT_ATTR_TYPE_U32_BITMAP,
+		sizeof(conntrack_status_map)/sizeof(conntrack_status_map[0]),
+		conntrack_status_map},
+	{"-c", ATTR_SECMARK, CT_ATTR_TYPE_U32, 0, 0},
+	{"-w", ATTR_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{"--orig-zone", ATTR_ORIG_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{"--reply-zone", ATTR_REPL_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{},
+};
+
+static int ct_save_snprintf(char *buf, size_t len,
+			    const struct nf_conntrack *ct,
+			    struct nfct_labelmap *map,
+			    enum nf_conntrack_msg_type type)
+{
+	unsigned int size = 0, offset = 0;
+	struct ctproto_handler *cur;
+	uint8_t l3proto, l4proto;
+	int attrs_idxes[4] = {};
+	struct ct_print_opts attrs_l3[5] = {};
+	int ret;
+	unsigned i;
+
+	switch (type) {
+	case NFCT_T_NEW:
+		ret = snprintf(buf + offset, len, "-I ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFCT_T_UPDATE:
+		ret = snprintf(buf + offset, len, "-U ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFCT_T_DESTROY:
+		ret = snprintf(buf + offset, len, "-D ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	ret = ct_snprintf_opts(buf + offset, len, ct, attrs_generic);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l3proto = nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO);
+	if (!l3proto)
+		l3proto = nfct_get_attr_u8(ct, ATTR_REPL_L3PROTO);
+	switch (l3proto) {
+	case AF_INET:
+		attrs_idxes[0] = ATTR_ORIG_IPV4_SRC;
+		attrs_idxes[1] = ATTR_ORIG_IPV4_DST;
+		attrs_idxes[2] = nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT)
+					? ATTR_DNAT_IPV4 : ATTR_REPL_IPV4_SRC;
+		attrs_idxes[3] = nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT)
+					? ATTR_SNAT_IPV4 : ATTR_REPL_IPV4_DST;
+		break;
+	case AF_INET6:
+		attrs_idxes[0] = ATTR_ORIG_IPV6_SRC;
+		attrs_idxes[1] = ATTR_ORIG_IPV6_DST;
+		attrs_idxes[2] = nfct_getobjopt(ct, NFCT_GOPT_IS_DNAT)
+					? ATTR_DNAT_IPV6 : ATTR_REPL_IPV6_SRC;
+		attrs_idxes[3] = nfct_getobjopt(ct, NFCT_GOPT_IS_SNAT)
+					? ATTR_SNAT_IPV6 : ATTR_REPL_IPV6_DST;
+		break;
+	default:
+		fprintf(stderr,
+				"WARNING: unknown l3proto %d, skipping..\n", l3proto);
+		return 0;
+	}
+
+	for (i = 0; i < sizeof(attrs_idxes) / sizeof(attrs_idxes[0]); ++i)
+		memcpy(&attrs_l3[i], &attrs_ip_map[attrs_idxes[i]], sizeof(attrs_l3[0]));
+
+	ret = ct_snprintf_opts(buf + offset, len, ct, attrs_l3);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
+
+	/* is it in the list of supported protocol? */
+	list_for_each_entry(cur, &proto_list, head) {
+		if (cur->protonum != l4proto)
+			continue;
+
+		ret = snprintf(buf + offset, len, "-p %s ", cur->name);
+		BUFFER_SIZE(ret, size, len, offset);
+
+		ret = ct_snprintf_opts(buf + offset, len, ct, cur->print_opts);
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
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
@@ -856,6 +1101,7 @@ enum {
 	_O_KTMS	= (1 << 4),
 	_O_CL	= (1 << 5),
 	_O_US	= (1 << 6),
+	_O_SAVE	= (1 << 7),
 };
 
 enum {
@@ -866,7 +1112,7 @@ enum {
 };
 
 static struct parse_parameter {
-	const char	*parameter[7];
+	const char	*parameter[8];
 	size_t  size;
 	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
@@ -874,8 +1120,8 @@ static struct parse_parameter {
 	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD, IPS_HW_OFFLOAD} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
-	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace" }, 7,
-	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US },
+	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace", "save"}, 8,
+	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US, _O_SAVE },
 	},
 };
 
@@ -1458,6 +1704,11 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 	if (nfct_filter(obj, ct))
 		goto out;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, type);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1482,7 +1733,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
-
+done:
 	if (output_mask & _O_US) {
 		if (nlh->nlmsg_pid)
 			userspace = true;
@@ -1511,6 +1762,11 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1527,6 +1783,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1553,6 +1810,11 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_DESTROY);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1561,6 +1823,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1576,6 +1839,11 @@ static int print_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1584,6 +1852,7 @@ static int print_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
@@ -1748,6 +2017,11 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		exit_error(PARAMETER_PROBLEM,
+		   "save output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1779,6 +2053,11 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		exit_error(PARAMETER_PROBLEM,
+		   "save output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -2445,6 +2724,10 @@ int main(int argc, char *argv[])
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
 			if (output_mask & _O_CL)
 				labelmap_init();
+			if ((output_mask & _O_SAVE) &&
+			    (output_mask & _O_XML))
+				exit_error(OTHER_PROBLEM,
+					   "cannot combine XML and save output types");
 			break;
 		case 'z':
 			options |= CT_OPT_ZERO;
-- 
2.25.1

