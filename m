Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1ACC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8996225AA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgLIRu4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:56 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623D8C0617A6
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3b4-0004RA-06; Wed, 09 Dec 2020 18:49:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 05/10] src: add auto-dependencies for ipv6 icmp6
Date:   Wed,  9 Dec 2020 18:49:19 +0100
Message-Id: <20201209174924.27720-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the earlier commit to also cover icmpv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/proto.h |  4 ++++
 src/evaluate.c  |  2 +-
 src/payload.c   | 33 +++++++++++++++++++++++++++++++++
 src/proto.c     | 26 +++++++++++++++-----------
 4 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index f383291b5a79..b9217588f3e3 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -30,6 +30,10 @@ enum icmp_hdr_field_type {
 	PROTO_ICMP_ECHO,	/* echo and reply */
 	PROTO_ICMP_MTU,		/* destination unreachable */
 	PROTO_ICMP_ADDRESS,	/* redirect */
+	PROTO_ICMP6_MTU,
+	PROTO_ICMP6_PPTR,
+	PROTO_ICMP6_ECHO,
+	PROTO_ICMP6_MGMQ,
 };
 
 /**
diff --git a/src/evaluate.c b/src/evaluate.c
index 3eb8e1bfc2c5..e776cd018051 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -729,7 +729,7 @@ static int __expr_evaluate_payload(struct eval_ctx *ctx, struct expr *expr)
 
 		payload->payload.offset += ctx->pctx.protocol[base].offset;
 check_icmp:
-		if (desc != &proto_icmp)
+		if (desc != &proto_icmp && desc != &proto_icmp6)
 			return 0;
 
 		tmpl = expr->payload.tmpl;
diff --git a/src/payload.c b/src/payload.c
index 54b08f051dc0..7cfa530c06c6 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
 #include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 
 #include <rule.h>
 #include <expression.h>
@@ -677,8 +678,12 @@ static uint8_t icmp_dep_to_type(enum icmp_hdr_field_type t)
 	case PROTO_ICMP_ANY:
 		BUG("Invalid map for simple dependency");
 	case PROTO_ICMP_ECHO: return ICMP_ECHO;
+	case PROTO_ICMP6_ECHO: return ICMP6_ECHO_REQUEST;
 	case PROTO_ICMP_MTU: return ICMP_DEST_UNREACH;
 	case PROTO_ICMP_ADDRESS: return ICMP_REDIRECT;
+	case PROTO_ICMP6_MTU: return ICMP6_PACKET_TOO_BIG;
+	case PROTO_ICMP6_MGMQ: return MLD_LISTENER_QUERY;
+	case PROTO_ICMP6_PPTR: return ICMP6_PARAM_PROB;
 	}
 
 	BUG("Missing icmp type mapping");
@@ -1023,6 +1028,34 @@ int payload_gen_icmp_dependency(struct eval_ctx *ctx, const struct expr *expr,
 							    &icmp_type_type,
 							    desc, type);
 		break;
+	case PROTO_ICMP6_ECHO:
+		if (ctx->pctx.th_dep.icmp.type == ICMP6_ECHO_REQUEST ||
+		    ctx->pctx.th_dep.icmp.type == ICMP6_ECHO_REPLY)
+			goto done;
+
+		type = ICMP6_ECHO_REQUEST;
+		if (ctx->pctx.th_dep.icmp.type)
+			goto bad_proto;
+
+		stmt = __payload_gen_icmp_echo_dependency(ctx, expr,
+							  ICMP6_ECHO_REQUEST,
+							  ICMP6_ECHO_REPLY,
+							  &icmp6_type_type,
+							  desc);
+		break;
+	case PROTO_ICMP6_MTU:
+	case PROTO_ICMP6_MGMQ:
+	case PROTO_ICMP6_PPTR:
+		type = icmp_dep_to_type(tmpl->icmp_dep);
+		if (ctx->pctx.th_dep.icmp.type == type)
+			goto done;
+		if (ctx->pctx.th_dep.icmp.type)
+			goto bad_proto;
+		stmt = __payload_gen_icmp_simple_dependency(ctx, expr,
+							    &icmp6_type_type,
+							    desc, type);
+		break;
+		break;
 	default:
 		BUG("Unhandled icmp dependency code");
 	}
diff --git a/src/proto.c b/src/proto.c
index d3371ac65975..b75626df2861 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -396,16 +396,19 @@ const struct datatype icmp_type_type = {
 	.sym_tbl	= &icmp_type_tbl,
 };
 
-#define ICMPHDR_FIELD(__token, __member, __dep)					\
+#define ICMP46HDR_FIELD(__token, __struct, __member, __dep)			\
 	{									\
 		.token		= (__token),					\
 		.dtype		= &integer_type,				\
 		.byteorder	= BYTEORDER_BIG_ENDIAN,				\
-		.offset		= offsetof(struct icmphdr, __member) * 8,	\
-		.len		= field_sizeof(struct icmphdr, __member) * 8,	\
+		.offset		= offsetof(__struct, __member) * 8,		\
+		.len		= field_sizeof(__struct, __member) * 8,		\
 		.icmp_dep	= (__dep),					\
 	}
 
+#define ICMPHDR_FIELD(__token, __member, __dep) \
+	ICMP46HDR_FIELD(__token, struct icmphdr, __member, __dep)
+
 #define ICMPHDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name,  __type, struct icmphdr, __member)
 
@@ -822,8 +825,8 @@ const struct datatype icmp6_type_type = {
 	.sym_tbl	= &icmp6_type_tbl,
 };
 
-#define ICMP6HDR_FIELD(__name, __member) \
-	HDR_FIELD(__name, struct icmp6_hdr, __member)
+#define ICMP6HDR_FIELD(__token, __member, __dep) \
+	ICMP46HDR_FIELD(__token, struct icmp6_hdr, __member, __dep)
 #define ICMP6HDR_TYPE(__name, __type, __member) \
 	HDR_TYPE(__name, __type, struct icmp6_hdr, __member)
 
@@ -831,17 +834,18 @@ const struct proto_desc proto_icmp6 = {
 	.name		= "icmpv6",
 	.id		= PROTO_DESC_ICMPV6,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.protocol_key	= ICMP6HDR_TYPE,
 	.checksum_key	= ICMP6HDR_CHECKSUM,
 	.checksum_type  = NFT_PAYLOAD_CSUM_INET,
 	.templates	= {
 		[ICMP6HDR_TYPE]		= ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6_type),
 		[ICMP6HDR_CODE]		= ICMP6HDR_TYPE("code", &icmpv6_code_type, icmp6_code),
-		[ICMP6HDR_CHECKSUM]	= ICMP6HDR_FIELD("checksum", icmp6_cksum),
-		[ICMP6HDR_PPTR]		= ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
-		[ICMP6HDR_MTU]		= ICMP6HDR_FIELD("mtu", icmp6_mtu),
-		[ICMP6HDR_ID]		= ICMP6HDR_FIELD("id", icmp6_id),
-		[ICMP6HDR_SEQ]		= ICMP6HDR_FIELD("sequence", icmp6_seq),
-		[ICMP6HDR_MAXDELAY]	= ICMP6HDR_FIELD("max-delay", icmp6_maxdelay),
+		[ICMP6HDR_CHECKSUM]	= ICMP6HDR_FIELD("checksum", icmp6_cksum, PROTO_ICMP_ANY),
+		[ICMP6HDR_PPTR]		= ICMP6HDR_FIELD("parameter-problem", icmp6_pptr, PROTO_ICMP6_PPTR),
+		[ICMP6HDR_MTU]		= ICMP6HDR_FIELD("mtu", icmp6_mtu, PROTO_ICMP6_MTU),
+		[ICMP6HDR_ID]		= ICMP6HDR_FIELD("id", icmp6_id, PROTO_ICMP6_ECHO),
+		[ICMP6HDR_SEQ]		= ICMP6HDR_FIELD("sequence", icmp6_seq, PROTO_ICMP6_ECHO),
+		[ICMP6HDR_MAXDELAY]	= ICMP6HDR_FIELD("max-delay", icmp6_maxdelay, PROTO_ICMP6_MGMQ),
 	},
 };
 
-- 
2.26.2

