Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD261C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C55B613C4
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhEDRDp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 May 2021 13:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhEDRDp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 May 2021 13:03:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AE8C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  4 May 2021 10:02:50 -0700 (PDT)
Received: from localhost ([::1]:42910 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1ldyRc-0008DQ-SE; Tue, 04 May 2021 19:02:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] extensions: sctp: Translate --chunk-types option
Date:   Tue,  4 May 2021 19:02:34 +0200
Message-Id: <20210504170234.25400-2-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210504170234.25400-1-phil@nwl.cc>
References: <20210504170234.25400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The translation is not fully complete as it is not possible to map 'any'
match type into nft syntax with a single rule. Also, 'only' match type
translation is a bit poor as it explicitly lists all chunk types that
are supposed to be missing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_sctp.c      | 91 ++++++++++++++++++++++++++++--------
 extensions/libxt_sctp.txlate |  6 +++
 2 files changed, 78 insertions(+), 19 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index ee4e99ebf11bf..5d8ab85cacf42 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -92,28 +92,29 @@ struct sctp_chunk_names {
 	const char *name;
 	unsigned int chunk_type;
 	const char *valid_flags;
+	const char *nftname;
 };
 
 /*'ALL' and 'NONE' will be treated specially. */
 static const struct sctp_chunk_names sctp_chunk_names[]
-= { { .name = "DATA", 		.chunk_type = 0,   .valid_flags = "----IUBE"},
-    { .name = "INIT", 		.chunk_type = 1,   .valid_flags = "--------"},
-    { .name = "INIT_ACK", 	.chunk_type = 2,   .valid_flags = "--------"},
-    { .name = "SACK",		.chunk_type = 3,   .valid_flags = "--------"},
-    { .name = "HEARTBEAT",	.chunk_type = 4,   .valid_flags = "--------"},
-    { .name = "HEARTBEAT_ACK",	.chunk_type = 5,   .valid_flags = "--------"},
-    { .name = "ABORT",		.chunk_type = 6,   .valid_flags = "-------T"},
-    { .name = "SHUTDOWN",	.chunk_type = 7,   .valid_flags = "--------"},
-    { .name = "SHUTDOWN_ACK",	.chunk_type = 8,   .valid_flags = "--------"},
-    { .name = "ERROR",		.chunk_type = 9,   .valid_flags = "--------"},
-    { .name = "COOKIE_ECHO",	.chunk_type = 10,  .valid_flags = "--------"},
-    { .name = "COOKIE_ACK",	.chunk_type = 11,  .valid_flags = "--------"},
-    { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------"},
-    { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------"},
-    { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T"},
-    { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------"},
-    { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------"},
-    { .name = "FORWARD_TSN",	.chunk_type = 192,  .valid_flags = "--------"},
+= { { .name = "DATA", 		.chunk_type = 0,   .valid_flags = "----IUBE", .nftname = "data" },
+    { .name = "INIT", 		.chunk_type = 1,   .valid_flags = "--------", .nftname = "init" },
+    { .name = "INIT_ACK", 	.chunk_type = 2,   .valid_flags = "--------", .nftname = "init-ack" },
+    { .name = "SACK",		.chunk_type = 3,   .valid_flags = "--------", .nftname = "sack" },
+    { .name = "HEARTBEAT",	.chunk_type = 4,   .valid_flags = "--------", .nftname = "heartbeat" },
+    { .name = "HEARTBEAT_ACK",	.chunk_type = 5,   .valid_flags = "--------", .nftname = "heartbeat-ack" },
+    { .name = "ABORT",		.chunk_type = 6,   .valid_flags = "-------T", .nftname = "abort" },
+    { .name = "SHUTDOWN",	.chunk_type = 7,   .valid_flags = "--------", .nftname = "shutdown" },
+    { .name = "SHUTDOWN_ACK",	.chunk_type = 8,   .valid_flags = "--------", .nftname = "shutdown-ack" },
+    { .name = "ERROR",		.chunk_type = 9,   .valid_flags = "--------", .nftname = "error" },
+    { .name = "COOKIE_ECHO",	.chunk_type = 10,  .valid_flags = "--------", .nftname = "cookie-echo" },
+    { .name = "COOKIE_ACK",	.chunk_type = 11,  .valid_flags = "--------", .nftname = "cookie-ack" },
+    { .name = "ECN_ECNE",	.chunk_type = 12,  .valid_flags = "--------", .nftname = "ecne" },
+    { .name = "ECN_CWR",	.chunk_type = 13,  .valid_flags = "--------", .nftname = "cwr" },
+    { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T", .nftname = "shutdown-complete" },
+    { .name = "ASCONF",		.chunk_type = 193,  .valid_flags = "--------", .nftname = "asconf" },
+    { .name = "ASCONF_ACK",	.chunk_type = 128,  .valid_flags = "--------", .nftname = "asconf-ack" },
+    { .name = "FORWARD_TSN",	.chunk_type = 192,  .valid_flags = "--------", .nftname = "forward-tsn" },
 };
 
 static void
@@ -485,12 +486,52 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static const char *sctp_xlate_chunk(struct xt_xlate *xl, const char *space,
+				    const struct xt_sctp_info *einfo,
+				    const struct sctp_chunk_names *scn)
+{
+	bool inv = einfo->invflags & XT_SCTP_CHUNK_TYPES;
+	const struct xt_sctp_flag_info *flag_info = NULL;
+	int i;
+
+	if (!scn->nftname)
+		return space;
+
+	if (!SCTP_CHUNKMAP_IS_SET(einfo->chunkmap, scn->chunk_type)) {
+		if (einfo->chunk_match_type != SCTP_CHUNK_MATCH_ONLY)
+			return space;
+
+		xt_xlate_add(xl, "%ssctp chunk %s %s", space,
+			     scn->nftname, inv ? "exists" : "missing");
+		return " ";
+	}
+
+	for (i = 0; i < einfo->flag_count; i++) {
+		if (einfo->flag_info[i].chunktype == scn->chunk_type) {
+			flag_info = &einfo->flag_info[i];
+			break;
+		}
+	}
+
+	if (!flag_info) {
+		xt_xlate_add(xl, "%ssctp chunk %s %s", space,
+			     scn->nftname, inv ? "missing" : "exists");
+		return " ";
+	}
+
+	xt_xlate_add(xl, "%ssctp chunk %s flags & 0x%x %s 0x%x", space,
+		     scn->nftname, flag_info->flag_mask,
+		     inv ? "!=" : "==", flag_info->flag);
+
+	return " ";
+}
+
 static int sctp_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_mt_params *params)
 {
 	const struct xt_sctp_info *einfo =
 		(const struct xt_sctp_info *)params->match->data;
-	char *space = "";
+	const char *space = "";
 
 	if (!einfo->flags)
 		return 0;
@@ -516,6 +557,18 @@ static int sctp_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, "%ssctp dport%s %u", space,
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0]);
+		space = " ";
+	}
+
+	if (einfo->flags & XT_SCTP_CHUNK_TYPES) {
+		int i;
+
+		if (einfo->chunk_match_type == SCTP_CHUNK_MATCH_ANY)
+			return 0;
+
+		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); i++)
+			space = sctp_xlate_chunk(xl, space, einfo,
+						 &sctp_chunk_names[i]);
 	}
 
 	return 1;
diff --git a/extensions/libxt_sctp.txlate b/extensions/libxt_sctp.txlate
index 0d6c59e183675..bb817525db8d8 100644
--- a/extensions/libxt_sctp.txlate
+++ b/extensions/libxt_sctp.txlate
@@ -36,3 +36,9 @@ nft add rule ip filter INPUT sctp sport 50 sctp dport != 80-100 counter accept
 
 iptables-translate -A INPUT -p sctp --dport 80 ! --sport 50:55 -j ACCEPT
 nft add rule ip filter INPUT sctp sport != 50-55 sctp dport 80 counter accept
+
+iptables-translate -A INPUT -p sctp --chunk-types all INIT,DATA:iUbE,SACK,ABORT:T -j ACCEPT
+nft add rule ip filter INPUT sctp chunk data flags & 0xf == 0x5 sctp chunk init exists sctp chunk sack exists sctp chunk abort flags & 0x1 == 0x1 counter accept
+
+iptables-translate -A INPUT -p sctp --chunk-types only SHUTDOWN_COMPLETE -j ACCEPT
+nft add rule ip filter INPUT sctp chunk data missing sctp chunk init missing sctp chunk init-ack missing sctp chunk sack missing sctp chunk heartbeat missing sctp chunk heartbeat-ack missing sctp chunk abort missing sctp chunk shutdown missing sctp chunk shutdown-ack missing sctp chunk error missing sctp chunk cookie-echo missing sctp chunk cookie-ack missing sctp chunk ecne missing sctp chunk cwr missing sctp chunk shutdown-complete exists sctp chunk asconf missing sctp chunk asconf-ack missing sctp chunk forward-tsn missing counter accept
-- 
2.31.0

