Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAE1C55ABD
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F8312068D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="JRYETfdk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbgKISSD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgKISSD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:18:03 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFC5C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:18:02 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so13644281ejb.7
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2020 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YrIMFHg+dpDQj2+k/+7yLYstfvxQ5eYcJmC+5NWoEgQ=;
        b=JRYETfdkY8jYklWx1j7zxcePEVRMMqwA4sGPjTXrg8aF27492hboeT2mTKw34Dtnb1
         DJK6TIDDOGLRgp/QPXVMTw+NNO/kbVZclEN5mZ2+YY5vihQ5zWFV8NtlArLAxzJlMy5Z
         NypI38gdEPg7FapeeC+BlYZOqQ+vGlKvor3BWh2Llx5sLlaqKBtSKauvPI9TL9VrsVBj
         G26NnOFUri66gMn2mw62JTTmgFJUwWnzN+Af+jiyj0z9EGoLq6wzMfsS+so5I2YVoDmk
         RY4BcohglZ/C4eWGpRtPUEAeYWEWe1ajKsEOKsxloWu+0rYOPDtIsssoJuSlp7yE4CRf
         yqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YrIMFHg+dpDQj2+k/+7yLYstfvxQ5eYcJmC+5NWoEgQ=;
        b=SrOotGYefuVyd0TPwSEc5+BH1HiS+q6zWb3WRBOEFPMOKTmqc0zwLNz3gHNvUp0Pv2
         GZtlG/Ks8niU4/zGnSKlrLPkSxoTyRWINQJdZXxqbn6bimLMPxeS7wpgPuscqGbQw/Dz
         OxfwHX1n7b43R5e8EbHYjNsc4gNyCbSW4GbY3hoPUOKYzqVvx5s7Qy3oAn1bGcRvSSCW
         mHS6QLUeq2rb9hD0m8o0Ehr44U0eynkdAMqlE/Lc2Rstf8YtA7GOsGYbGIW6SRa2nWXa
         mLj5PGuQeEHI/uD0jLIJdtmCsORjBYrJxKWX4UgZE7h914NO6t1WuKnRPY4bIxnZFTXQ
         5xpA==
X-Gm-Message-State: AOAM533YblPVA1naBmm2/obt52ROYqWaKQP9RdvI94rWgWHXswze1hgF
        CNJvBx6uTMy6QwNtJpb3oTtb4cmG9Zs0Ig==
X-Google-Smtp-Source: ABdhPJyHtJQIjtj5N9CiO9gyOdO2GnZS6ikSaBVzot8Zz6SQjFyVRLriiuyH4zZvY00UvO4CVDLOhg==
X-Received: by 2002:a17:906:4116:: with SMTP id j22mr15917023ejk.373.1604945879063;
        Mon, 09 Nov 2020 10:17:59 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id g25sm9056273ejh.61.2020.11.09.10.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:17:58 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 1/4] conntrack: accept commands from file
Date:   Mon,  9 Nov 2020 19:17:38 +0100
Message-Id: <20201109181741.52325-2-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit implements the --load-file option which
allows processing conntrack commands stored in file.
Most often this would be used as a counter-part for the
-o save option, which outputs conntrack entries
in the format of the conntrack tool options.
This could be useful when one needs to add/update/delete a large
set of ct entries with a single conntrack tool invocation.

Expected syntax is "conntrack --load-file file".
If "-" is given as a file name, stdin is used.
No other commands or options are allowed to be specified
in conjunction with the --load-file command.
It is however possible to specify multiple --load-file file pairs.

Example:
Copy all entries from ct zone 11 to ct zone 12:

conntrack -L -w 11 -o save | sed "s/-w 11/-w 12/g" | \
	conntrack --load-file -

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 extensions/libct_proto_dccp.c    |   60 +-
 extensions/libct_proto_gre.c     |   52 +-
 extensions/libct_proto_icmp.c    |   38 +-
 extensions/libct_proto_icmpv6.c  |   38 +-
 extensions/libct_proto_sctp.c    |   56 +-
 extensions/libct_proto_tcp.c     |   68 +-
 extensions/libct_proto_udp.c     |   52 +-
 extensions/libct_proto_udplite.c |   50 +-
 include/conntrack.h              |   63 +-
 src/conntrack.c                  | 1214 ++++++++++++++++++------------
 10 files changed, 988 insertions(+), 703 deletions(-)

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index e9da474..057a817 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -111,11 +111,7 @@ static void help(void)
 	fprintf(stdout, "  --state\t\t\tDCCP state, fe. RESPOND\n");
 }
 
-static int parse_options(char c,
-			 struct nf_conntrack *ct,
-			 struct nf_conntrack *exptuple,
-			 struct nf_conntrack *mask,
-			 unsigned int *flags)
+static int parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	int i;
 	uint16_t port;
@@ -123,73 +119,73 @@ static int parse_options(char c,
 	switch(c) {
 	case 1:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_ORIG_SPORT;
 		break;
 	case 2:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_ORIG_DPORT;
 		break;
 	case 3:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_REPL_SPORT;
 		break;
 	case 4:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_REPL_DPORT;
 		break;
 	case 5:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_MASK_SPORT;
 		break;
 	case 6:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_DCCP);
 		*flags |= CT_DCCP_MASK_DPORT;
 		break;
 	case 7:
 		for (i=0; i<DCCP_CONNTRACK_MAX; i++) {
 			if (strcmp(optarg, dccp_states[i]) == 0) {
-				nfct_set_attr_u8(ct, ATTR_DCCP_STATE, i);
+				nfct_set_attr_u8(cmd->ct, ATTR_DCCP_STATE, i);
 				break;
 			}
 		}
 		if (i == DCCP_CONNTRACK_MAX)
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "Unknown DCCP state `%s'", optarg);
 		*flags |= CT_DCCP_STATE;
 		break;
 	case 8:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_DCCP_EXPTUPLE_SPORT;
 		break;
 	case 9:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port); 
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_DCCP_EXPTUPLE_DPORT;
 		break;
 	case 10:
 		if (strncasecmp(optarg, "client", strlen(optarg)) == 0) {
-			nfct_set_attr_u8(ct, ATTR_DCCP_ROLE,
+			nfct_set_attr_u8(cmd->ct, ATTR_DCCP_ROLE,
 					 DCCP_CONNTRACK_ROLE_CLIENT);
 		} else if (strncasecmp(optarg, "server", strlen(optarg)) == 0) {
-			nfct_set_attr_u8(ct, ATTR_DCCP_ROLE,
+			nfct_set_attr_u8(cmd->ct, ATTR_DCCP_ROLE,
 					 DCCP_CONNTRACK_ROLE_SERVER);
 		} else {
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "Unknown DCCP role `%s'", optarg);
 		}
 		*flags |= CT_DCCP_ROLE;
@@ -221,24 +217,26 @@ static unsigned int dccp_valid_flags[DCCP_VALID_FLAGS_MAX] = {
 };
 
 static void 
-final_check(unsigned int flags, unsigned int cmd, struct nf_conntrack *ct)
+final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, DCCP_OPT_MAX,
-				dccp_commands_v_options[cmd], dccp_optflags,
+	ret = generic_opt_check(cmd, flags, DCCP_OPT_MAX,
+				dccp_commands_v_options[cmd->cmd_bit], dccp_optflags,
 				dccp_valid_flags, DCCP_VALID_FLAGS_MAX,
 				&partial);
 	if (!ret) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--sport' and "
 						      "`--dport'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-port-src' and "
 						      "`--report-port-dst'");
 			break;
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index a36d111..0ec890e 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -84,60 +84,56 @@ static char gre_commands_v_options[NUMBER_OF_CMD][GRE_OPT_MAX] =
 /*EXP_EVENT*/	  {0,0,0,0,0,0,0,0},
 };
 
-static int parse_options(char c,
-			 struct nf_conntrack *ct,
-			 struct nf_conntrack *exptuple,
-			 struct nf_conntrack *mask,
-			 unsigned int *flags)
+static int parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	switch(c) {
 	uint16_t port;
 	case '1':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_ORIG_SKEY;
 		break;
 	case '2':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_ORIG_DKEY;
 		break;
 	case '3':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_REPL_SKEY;
 		break;
 	case '4':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_REPL_DKEY;
 		break;
 	case '5':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_MASK_SKEY;
 		break;
 	case '6':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_MASK_DKEY;
 		break;
 	case '7':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_EXPTUPLE_SKEY;
 		break;
 	case '8':
 		port = htons(strtoul(optarg, NULL, 0));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, IPPROTO_GRE);
 		*flags |= CT_GRE_EXPTUPLE_DKEY;
 		break;
 	}
@@ -158,25 +154,25 @@ static unsigned int gre_valid_flags[GRE_VALID_FLAGS_MAX] = {
        CT_GRE_REPL_SKEY | CT_GRE_REPL_DKEY,
 };
 
-static void final_check(unsigned int flags,
-		        unsigned int cmd,
-		        struct nf_conntrack *ct)
+static void final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, GRE_OPT_MAX,
-				gre_commands_v_options[cmd], gre_optflags,
+	ret = generic_opt_check(cmd, flags, GRE_OPT_MAX,
+				gre_commands_v_options[cmd->cmd_bit], gre_optflags,
 				gre_valid_flags, GRE_VALID_FLAGS_MAX, &partial);
 	if (!ret) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--srckey' and "
 						      "`--dstkey'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-src-key' and "
 						      "`--reply-dst-key'");
 			break;
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index ec52c39..e3ac2cc 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -65,37 +65,33 @@ static void help(void)
 	fprintf(stdout, "  --icmp-id\t\t\ticmp id\n");
 }
 
-static int parse(char c,
-		 struct nf_conntrack *ct,
-		 struct nf_conntrack *exptuple,
-		 struct nf_conntrack *mask,
-		 unsigned int *flags)
+static int parse(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	switch(c) {
 		uint8_t tmp;
 		uint16_t id;
 		case '1':
 			tmp = atoi(optarg);
-			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
+			nfct_set_attr_u8(cmd->ct, ATTR_ICMP_TYPE, tmp);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_TYPE;
 			break;
 		case '2':
 			tmp = atoi(optarg);
-			nfct_set_attr_u8(ct, ATTR_ICMP_CODE, tmp);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
+			nfct_set_attr_u8(cmd->ct, ATTR_ICMP_CODE, tmp);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_CODE;
 			break;
 		case '3':
 			id = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_ICMP_ID, id);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMP);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
+			nfct_set_attr_u16(cmd->ct, ATTR_ICMP_ID, id);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMP);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMP);
 			*flags |= CT_ICMP_ID;
 			break;
 	}
@@ -109,13 +105,11 @@ static const struct ct_print_opts icmp_print_opts[] = {
 	{}
 };
 
-static void final_check(unsigned int flags,
-		        unsigned int cmd,
-		        struct nf_conntrack *ct)
+static void final_check(struct ct_cmd *cmd, unsigned int flags)
 {
-	generic_opt_check(flags,
+	generic_opt_check(cmd, flags,
 			  ICMP_NUMBER_OF_OPT,
-			  icmp_commands_v_options[cmd],
+			  icmp_commands_v_options[cmd->cmd_bit],
 			  icmp_optflags, NULL, 0, NULL);
 }
 
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index fe16a1d..65aa3b5 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -68,37 +68,33 @@ static void help(void)
 	fprintf(stdout, "  --icmpv6-id\t\t\ticmpv6 id\n");
 }
 
-static int parse(char c,
-		 struct nf_conntrack *ct,
-		 struct nf_conntrack *exptuple,
-		 struct nf_conntrack *mask,
-		 unsigned int *flags)
+static int parse(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	switch(c) {
 		uint8_t tmp;
 		uint16_t id;
 		case '1':
 			tmp = atoi(optarg);
-			nfct_set_attr_u8(ct, ATTR_ICMP_TYPE, tmp);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
+			nfct_set_attr_u8(cmd->ct, ATTR_ICMP_TYPE, tmp);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_TYPE;
 			break;
 		case '2':
 			tmp = atoi(optarg);
-			nfct_set_attr_u8(ct, ATTR_ICMP_CODE, tmp);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
+			nfct_set_attr_u8(cmd->ct, ATTR_ICMP_CODE, tmp);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_CODE;
 			break;
 		case '3':
 			id = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_ICMP_ID, id);
-			nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
-			if (nfct_attr_is_set(ct, ATTR_REPL_L3PROTO))
-				nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
+			nfct_set_attr_u16(cmd->ct, ATTR_ICMP_ID, id);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, IPPROTO_ICMPV6);
+			if (nfct_attr_is_set(cmd->ct, ATTR_REPL_L3PROTO))
+				nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_ICMPV6);
 			*flags |= CT_ICMP_ID;
 			break;
 	}
@@ -112,12 +108,10 @@ static const struct ct_print_opts icmpv6_print_opts[] = {
 	{},
 };
 
-static void final_check(unsigned int flags,
-		        unsigned int cmd,
-		        struct nf_conntrack *ct)
+static void final_check(struct ct_cmd *cmd, unsigned int flags)
 {
-	generic_opt_check(flags, ICMPV6_NUMBER_OF_OPT,
-			  icmpv6_commands_v_options[cmd], icmpv6_optflags,
+	generic_opt_check(cmd, flags, ICMPV6_NUMBER_OF_OPT,
+			  icmpv6_commands_v_options[cmd->cmd_bit], icmpv6_optflags,
 			  NULL, 0, NULL);
 }
 
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index a58ccde..5dfe0ff 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -115,9 +115,7 @@ static void help(void)
 }
 
 static int
-parse_options(char c, struct nf_conntrack *ct,
-	      struct nf_conntrack *exptuple, struct nf_conntrack *mask,
-	      unsigned int *flags)
+parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	int i;
 	uint16_t port;
@@ -126,72 +124,72 @@ parse_options(char c, struct nf_conntrack *ct,
 	switch(c) {
 	case 1:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_ORIG_SPORT;
 		break;
 	case 2:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_ORIG_DPORT;
 		break;
 	case 3:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_REPL_SPORT;
 		break;
 	case 4:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_REPL_DPORT;
 		break;
 	case 5:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_MASK_SPORT;
 		break;
 	case 6:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_SCTP);
 		*flags |= CT_SCTP_MASK_DPORT;
 		break;
 	case 7:
 		for (i=0; i<SCTP_CONNTRACK_MAX; i++) {
 			if (strcmp(optarg, sctp_states[i]) == 0) {
-				nfct_set_attr_u8(ct, ATTR_SCTP_STATE, i);
+				nfct_set_attr_u8(cmd->ct, ATTR_SCTP_STATE, i);
 				break;
 			}
 		}
 		if (i == SCTP_CONNTRACK_MAX)
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "unknown SCTP state `%s'", optarg);
 		*flags |= CT_SCTP_STATE;
 		break;
 	case 8:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_SCTP_EXPTUPLE_SPORT;
 		break;
 	case 9:
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port); 
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_SCTP_EXPTUPLE_DPORT;
 		break;
 	case 10:
 		vtag = htonl(atoi(optarg));
-		nfct_set_attr_u32(ct, ATTR_SCTP_VTAG_ORIG, vtag); 
+		nfct_set_attr_u32(cmd->ct, ATTR_SCTP_VTAG_ORIG, vtag);
 		*flags |= CT_SCTP_ORIG_VTAG;
 		break;
 	case 11:
 		vtag = htonl(atoi(optarg));
-		nfct_set_attr_u32(ct, ATTR_SCTP_VTAG_REPL, vtag); 
+		nfct_set_attr_u32(cmd->ct, ATTR_SCTP_VTAG_REPL, vtag);
 		*flags |= CT_SCTP_REPL_VTAG;
 		break;
 	}
@@ -216,24 +214,26 @@ static unsigned int dccp_valid_flags[SCTP_VALID_FLAGS_MAX] = {
 };
 
 static void
-final_check(unsigned int flags, unsigned int cmd, struct nf_conntrack *ct)
+final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, SCTP_OPT_MAX,
-				sctp_commands_v_options[cmd], sctp_optflags,
+	ret = generic_opt_check(cmd, flags, SCTP_OPT_MAX,
+				sctp_commands_v_options[cmd->cmd_bit], sctp_optflags,
 				dccp_valid_flags, SCTP_VALID_FLAGS_MAX,
 				&partial);
 	if (!ret) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--sport' and "
 						      "`--dport'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-src-port' and "
 						      "`--reply-dst-port'");
 			break;
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 3da0dc6..ebb3a98 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -99,11 +99,7 @@ static void help(void)
 	fprintf(stdout, "  --state\t\t\tTCP state, fe. ESTABLISHED\n");
 }
 
-static int parse_options(char c,
-			 struct nf_conntrack *ct,
-			 struct nf_conntrack *exptuple,
-			 struct nf_conntrack *mask,
-			 unsigned int *flags)
+static int parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	int i;
 	uint16_t port;
@@ -111,66 +107,66 @@ static int parse_options(char c,
 	switch(c) {
 	case '1':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_ORIG_SPORT;
 		break;
 	case '2':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_ORIG_DPORT;
 		break;
 	case '3':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_REPL_SPORT;
 		break;
 	case '4':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_REPL_DPORT;
 		break;
 	case '5':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_MASK_SPORT;
 		break;
 	case '6':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_TCP);
 		*flags |= CT_TCP_MASK_DPORT;
 		break;
 	case '7':
 		for (i=0; i<TCP_CONNTRACK_MAX; i++) {
 			if (strcmp(optarg, tcp_states[i]) == 0) {
-				nfct_set_attr_u8(ct, ATTR_TCP_STATE, i);
+				nfct_set_attr_u8(cmd->ct, ATTR_TCP_STATE, i);
 				break;
 			}
 		}
 		/* For backward compatibility with Linux kernel < 2.6.31. */
 		if (strcmp(optarg, "LISTEN") == 0) {
-			nfct_set_attr_u8(ct, ATTR_TCP_STATE,
+			nfct_set_attr_u8(cmd->ct, ATTR_TCP_STATE,
 					 TCP_CONNTRACK_LISTEN);
 		} else if (i == TCP_CONNTRACK_MAX)
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "unknown TCP state `%s'", optarg);
 		*flags |= CT_TCP_STATE;
 		break;
 	case '8':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_TCP_EXPTUPLE_SPORT;
 		break;
 	case '9':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port); 
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, port);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, port);
 		*flags |= CT_TCP_EXPTUPLE_DPORT;
 		break;
 	}
@@ -192,25 +188,25 @@ static unsigned int tcp_valid_flags[TCP_VALID_FLAGS_MAX] = {
        CT_TCP_REPL_SPORT | CT_TCP_REPL_DPORT,
 };
 
-static void final_check(unsigned int flags,
-			unsigned int cmd,
-			struct nf_conntrack *ct)
+static void final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, TCP_NUMBER_OF_OPT,
-				tcp_commands_v_options[cmd], tcp_optflags,
+	ret = generic_opt_check(cmd, flags, TCP_NUMBER_OF_OPT,
+				tcp_commands_v_options[cmd->cmd_bit], tcp_optflags,
 				tcp_valid_flags, TCP_VALID_FLAGS_MAX, &partial);
 	if (!ret) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--sport' and "
 						      "`--dport'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-src-port' and "
 						      "`--reply-dst-port'");
 			break;
@@ -223,13 +219,13 @@ static void final_check(unsigned int flags,
 
 	/* This allows to reopen a new connection directly from TIME-WAIT
 	 * as RFC 1122 states. See nf_conntrack_proto_tcp.c for more info. */
-	if (nfct_get_attr_u8(ct, ATTR_TCP_STATE) >= TCP_CONNTRACK_TIME_WAIT)
+	if (nfct_get_attr_u8(cmd->ct, ATTR_TCP_STATE) >= TCP_CONNTRACK_TIME_WAIT)
 		tcp_flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 
-	nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_ORIG, tcp_flags);
-	nfct_set_attr_u8(ct, ATTR_TCP_MASK_ORIG, tcp_flags);
-	nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_REPL, tcp_flags);
-	nfct_set_attr_u8(ct, ATTR_TCP_MASK_REPL, tcp_flags);
+	nfct_set_attr_u8(cmd->ct, ATTR_TCP_FLAGS_ORIG, tcp_flags);
+	nfct_set_attr_u8(cmd->ct, ATTR_TCP_MASK_ORIG, tcp_flags);
+	nfct_set_attr_u8(cmd->ct, ATTR_TCP_FLAGS_REPL, tcp_flags);
+	nfct_set_attr_u8(cmd->ct, ATTR_TCP_MASK_REPL, tcp_flags);
 }
 
 static struct ctproto_handler tcp = {
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index fe43548..d0450c0 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -80,62 +80,58 @@ static char udp_commands_v_options[NUMBER_OF_CMD][UDP_NUMBER_OF_OPT] =
 /*EXP_EVENT*/     {0,0,0,0,0,0,0,0},
 };
 
-static int parse_options(char c,
-			 struct nf_conntrack *ct,
-			 struct nf_conntrack *exptuple,
-			 struct nf_conntrack *mask,
-			 unsigned int *flags)
+static int parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	switch(c) {
 		uint16_t port;
 		case '1':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-			nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+			nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_ORIG_SPORT;
 			break;
 		case '2':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-			nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+			nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_ORIG_DPORT;
 			break;
 		case '3':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-			nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+			nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_REPL_SPORT;
 			break;
 		case '4':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-			nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+			nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_REPL_DPORT;
 			break;
 		case '5':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-			nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+			nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_MASK_SPORT;
 			break;
 		case '6':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-			nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
+			nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+			nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_UDP);
 			*flags |= CT_UDP_MASK_DPORT;
 			break;
 		case '7':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-			nfct_set_attr_u8(exptuple,
+			nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+			nfct_set_attr_u8(cmd->exptuple,
 					 ATTR_ORIG_L4PROTO,
 					 IPPROTO_UDP);
 			*flags |= CT_UDP_EXPTUPLE_SPORT;
 			break;
 		case '8':
 			port = htons(atoi(optarg));
-			nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port);
-			nfct_set_attr_u8(exptuple,
+			nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+			nfct_set_attr_u8(cmd->exptuple,
 					 ATTR_ORIG_L4PROTO,
 					 IPPROTO_UDP);
 			*flags |= CT_UDP_EXPTUPLE_DPORT;
@@ -158,25 +154,25 @@ static unsigned int udp_valid_flags[UDP_VALID_FLAGS_MAX] = {
        CT_UDP_REPL_SPORT | CT_UDP_REPL_DPORT,
 };
 
-static void final_check(unsigned int flags,
-		        unsigned int cmd,
-		        struct nf_conntrack *ct)
+static void final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, UDP_NUMBER_OF_OPT,
-				udp_commands_v_options[cmd], udp_optflags,
+	ret = generic_opt_check(cmd, flags, UDP_NUMBER_OF_OPT,
+				udp_commands_v_options[cmd->cmd_bit], udp_optflags,
 				udp_valid_flags, UDP_VALID_FLAGS_MAX, &partial);
 	if (!ret) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--sport' and "
 						      "`--dport'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-src-port' and "
 						      "`--reply-dst-port'");
 			break;
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index 2bece38..bd3ec6a 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -88,60 +88,56 @@ static char udplite_commands_v_options[NUMBER_OF_CMD][UDP_OPT_MAX] =
 /*EXP_EVENT*/	  {0,0,0,0,0,0,0,0},
 };
 
-static int parse_options(char c,
-			 struct nf_conntrack *ct,
-			 struct nf_conntrack *exptuple,
-			 struct nf_conntrack *mask,
-			 unsigned int *flags)
+static int parse_options(struct ct_cmd *cmd, char c, unsigned int *flags)
 {
 	switch(c) {
 	uint16_t port;
 	case '1':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_ORIG_SPORT;
 		break;
 	case '2':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->ct, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_ORIG_DPORT;
 		break;
 	case '3':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_SRC, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_REPL_SPORT;
 		break;
 	case '4':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(ct, ATTR_REPL_PORT_DST, port);
-		nfct_set_attr_u8(ct, ATTR_REPL_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->ct, ATTR_REPL_PORT_DST, port);
+		nfct_set_attr_u8(cmd->ct, ATTR_REPL_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_REPL_DPORT;
 		break;
 	case '5':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_MASK_SPORT;
 		break;
 	case '6':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(mask, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(mask, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->mask, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->mask, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_MASK_DPORT;
 		break;
 	case '7':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_SRC, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_SRC, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_EXPTUPLE_SPORT;
 		break;
 	case '8':
 		port = htons(atoi(optarg));
-		nfct_set_attr_u16(exptuple, ATTR_ORIG_PORT_DST, port);
-		nfct_set_attr_u8(exptuple, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
+		nfct_set_attr_u16(cmd->exptuple, ATTR_ORIG_PORT_DST, port);
+		nfct_set_attr_u8(cmd->exptuple, ATTR_ORIG_L4PROTO, IPPROTO_UDPLITE);
 		*flags |= CT_UDPLITE_EXPTUPLE_DPORT;
 		break;
 	}
@@ -163,12 +159,12 @@ static unsigned int udplite_valid_flags[UDPLITE_VALID_FLAGS_MAX] = {
 };
 
 static void
-final_check(unsigned int flags, unsigned int cmd, struct nf_conntrack *ct)
+final_check(struct ct_cmd *cmd, unsigned int flags)
 {
 	int ret, partial;
 
-	ret = generic_opt_check(flags, UDP_OPT_MAX,
-				udplite_commands_v_options[cmd],
+	ret = generic_opt_check(cmd, flags, UDP_OPT_MAX,
+				udplite_commands_v_options[cmd->cmd_bit],
 				udplite_optflags,
 				udplite_valid_flags, UDPLITE_VALID_FLAGS_MAX,
 				&partial);
@@ -176,12 +172,14 @@ final_check(unsigned int flags, unsigned int cmd, struct nf_conntrack *ct)
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--sport' and "
 						      "`--dport'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd,
+						      "you have to specify "
 						      "`--reply-src-port' and "
 						      "`--reply-dst-port'");
 			break;
diff --git a/include/conntrack.h b/include/conntrack.h
index 1c1720e..6126d86 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -16,6 +16,53 @@
 
 struct nf_conntrack;
 
+struct u32_mask {
+	uint32_t value;
+	uint32_t mask;
+};
+
+struct ct_cmd {
+	struct list_head list_entry;
+
+	unsigned int command;
+
+	unsigned int cmd_bit;
+
+	unsigned int options;
+
+	int family;
+
+	unsigned int type;
+
+	unsigned int event_mask;
+
+	int protonum;
+
+	/* these two are used purely for error reporting */
+	unsigned int line_number;
+	const char *file_name;
+
+	size_t socketbuffersize;
+
+	struct nf_conntrack *ct;
+	struct nf_expect *exp;
+	/* Expectations require the expectation tuple and the mask. */
+	struct nf_conntrack *exptuple, *mask;
+
+	/* Allows filtering/setting specific bits in the ctmark */
+	struct u32_mask mark;
+
+	/* Allow to filter by mark from kernel-space. */
+	struct nfct_filter_dump_mark filter_mark_kernel;
+	bool filter_mark_kernel_set;
+
+	/* Allows filtering by ctlabels */
+	struct nfct_bitmask *label;
+
+	/* Allows setting/removing specific ctlabels */
+	struct nfct_bitmask *label_modify;
+};
+
 struct ctproto_handler {
 	struct list_head 	head;
 
@@ -25,15 +72,12 @@ struct ctproto_handler {
 
 	uint32_t		protoinfo_attr;
 
-	int (*parse_opts)(char c,
-			  struct nf_conntrack *ct,
-			  struct nf_conntrack *exptuple,
-			  struct nf_conntrack *mask,
+	int (*parse_opts)(struct ct_cmd *cmd,
+			  char c,
 			  unsigned int *flags);
 
-	void (*final_check)(unsigned int flags,
-			    unsigned int command,
-			    struct nf_conntrack *ct);
+	void (*final_check)(struct ct_cmd *cmd,
+			    unsigned int flags);
 
 	const struct ct_print_opts *print_opts;
 
@@ -50,11 +94,12 @@ enum exittype {
 	VERSION_PROBLEM
 };
 
-int generic_opt_check(int options, int nops,
+int generic_opt_check(struct ct_cmd *cmd, int options, int nops,
 		      char *optset, const char *optflg[],
 		      unsigned int *coupled_flags, int coupled_flags_size,
 		      int *partial);
-void exit_error(enum exittype status, const char *msg, ...);
+void exit_error(enum exittype status, struct ct_cmd *cmd,
+		const char *msg, ...);
 
 extern void register_proto(struct ctproto_handler *h);
 
diff --git a/src/conntrack.c b/src/conntrack.c
index d05a599..81ebece 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -64,6 +64,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <libmnl/libmnl.h>
+#include <linux_list.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
@@ -72,59 +73,71 @@ static struct nfct_mnl_socket {
 	uint32_t		portid;
 } sock;
 
-struct u32_mask {
-	uint32_t value;
-	uint32_t mask;
+struct ct_cmd_list {
+	struct list_head list;
 };
 
-/* These are the template objects that are used to send commands. */
-static struct {
-	struct nf_conntrack *ct;
-	struct nf_expect *exp;
-	/* Expectations require the expectation tuple and the mask. */
-	struct nf_conntrack *exptuple, *mask;
+static void ct_cmd_free(struct ct_cmd *cmd)
+{
+	if (cmd->ct)
+		nfct_destroy(cmd->ct);
+	if (cmd->exptuple)
+		nfct_destroy(cmd->exptuple);
+	if (cmd->mask)
+		nfct_destroy(cmd->mask);
+	if (cmd->exp)
+		nfexp_destroy(cmd->exp);
+	if (cmd->label)
+		nfct_bitmask_destroy(cmd->label);
+	if (cmd->label_modify)
+		nfct_bitmask_destroy(cmd->label_modify);
 
-	/* Allows filtering/setting specific bits in the ctmark */
-	struct u32_mask mark;
+	free(cmd);
+}
 
-	/* Allow to filter by mark from kernel-space. */
-	struct nfct_filter_dump_mark filter_mark_kernel;
-	bool filter_mark_kernel_set;
+static struct ct_cmd* ct_cmd_alloc(void)
+{
+	struct ct_cmd *cmd;
 
-	/* Allows filtering by ctlabels */
-	struct nfct_bitmask *label;
+	cmd = calloc(1, sizeof(*cmd));
+	if (!cmd)
+		exit_error(OTHER_PROBLEM, NULL, "malloc ct_cmd failed!");
 
-	/* Allows setting/removing specific ctlabels */
-	struct nfct_bitmask *label_modify;
-} tmpl;
+	cmd->ct = nfct_new();
+	cmd->exptuple = nfct_new();
+	cmd->mask = nfct_new();
+	cmd->exp = nfexp_new();
 
-static int alloc_tmpl_objects(void)
-{
-	tmpl.ct = nfct_new();
-	tmpl.exptuple = nfct_new();
-	tmpl.mask = nfct_new();
-	tmpl.exp = nfexp_new();
+	if (cmd->ct == NULL || cmd->exptuple == NULL ||
+			cmd->mask == NULL || cmd->exp == NULL) {
+		ct_cmd_free(cmd);
+		exit_error(OTHER_PROBLEM, NULL, "failed to allocate ct objects!");
+	}
+	return cmd;
+}
 
-	memset(&tmpl.mark, 0, sizeof(tmpl.mark));
+static void ct_cmd_list_init(struct ct_cmd_list *list)
+{
+	memset(list, 0, sizeof(*list));
+	INIT_LIST_HEAD(&list->list);
+}
 
-	return tmpl.ct != NULL && tmpl.exptuple != NULL &&
-	       tmpl.mask != NULL && tmpl.exp != NULL;
+static void ct_cmd_list_add(struct ct_cmd_list *list, struct ct_cmd *cmd)
+{
+	list_add_tail(&cmd->list_entry, &list->list);
 }
 
-static void free_tmpl_objects(void)
+void ct_cmd_apply(struct ct_cmd *cmd);
+
+static void ct_cmd_list_apply(struct ct_cmd_list *list)
 {
-	if (tmpl.ct)
-		nfct_destroy(tmpl.ct);
-	if (tmpl.exptuple)
-		nfct_destroy(tmpl.exptuple);
-	if (tmpl.mask)
-		nfct_destroy(tmpl.mask);
-	if (tmpl.exp)
-		nfexp_destroy(tmpl.exp);
-	if (tmpl.label)
-		nfct_bitmask_destroy(tmpl.label);
-	if (tmpl.label_modify)
-		nfct_bitmask_destroy(tmpl.label_modify);
+	struct ct_cmd *cmd, *tmp;
+
+	list_for_each_entry_safe(cmd, tmp, &list->list, list_entry) {
+		list_del(&cmd->list_entry);
+		ct_cmd_apply(cmd);
+		ct_cmd_free(cmd);
+	}
 }
 
 enum ct_command {
@@ -374,6 +387,14 @@ static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
 				"g::c:b:C::Sj::w:l:<:>::(:):";
 
+
+static struct option load_file_opts[] = {
+	{"load-file", 1, 0, 'R'},
+	{0, 0, 0, 0}
+};
+
+static const char *load_file_getopt_str = ":R:";
+
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
  * CMD_LIST and CMD_ZERO only).
@@ -521,6 +542,7 @@ static char exit_msg[NUMBER_OF_CMD][64] = {
 	[CT_DELETE_BIT]		= "%d flow entries have been deleted.\n",
 	[CT_GET_BIT] 		= "%d flow entries have been shown.\n",
 	[CT_EVENT_BIT]		= "%d flow events have been shown.\n",
+	[EXP_EVENT_BIT]		= "%d expectation events have been shown.\n",
 	[EXP_LIST_BIT]		= "%d expectations have been shown.\n",
 	[EXP_DELETE_BIT]	= "%d expectations have been shown.\n",
 };
@@ -535,7 +557,8 @@ static const char usage_commands[] =
 	"  -E [table] [options]\t\tShow events\n"
 	"  -F [table]\t\t\tFlush table\n"
 	"  -C [table]\t\t\tShow counter\n"
-	"  -S\t\t\t\tShow statistics\n";
+	"  -S\t\t\t\tShow statistics\n"
+	"  --load-file file\t\t Load conntrack entries from a file";
 
 static const char usage_tables[] =
 	"Tables: conntrack, expect, dying, unconfirmed\n";
@@ -583,10 +606,61 @@ static const char usage_parameters[] =
 
 #define OPTION_OFFSET 256
 
-static struct nfct_handle *cth, *ith;
+static char *programm;
+static struct nfct_handle *cth, *ith, *exh, *evh;
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
+static unsigned int cmd_executed = 0;
+static const unsigned int cmd_no_entries_ok = 0
+						| CT_LIST
+						| EXP_LIST
+						;
+static const unsigned int cmd_load_file_allowed = 0
+						| CT_CREATE
+						| CT_UPDATE_BIT
+						| CT_DELETE
+						| CT_FLUSH
+						| EXP_CREATE
+						| EXP_DELETE
+						| EXP_FLUSH
+						;
+static unsigned int cmd_counters[NUMBER_OF_CMD];
+
+static int
+print_cmd_counters(void)
+{
+	int i, ret = EXIT_FAILURE;
+
+	if (!cmd_executed)
+		return EXIT_SUCCESS;
+
+	for (i = 0;
+		i < (int)(sizeof(cmd_counters) / sizeof(cmd_counters[0]));
+		++i) {
+		if (cmd_executed & 1 << i) {
+			if (exit_msg[i][0]) {
+				fprintf(stderr, "%s v%s (conntrack-tools): ",
+							PROGNAME, VERSION);
+				fprintf(stderr, exit_msg[i], cmd_counters[i]);
+			}
+			/*
+			 * If there is at least one command which is supposed
+			 * to return success, EXIT_SUCCESS is returned.
+			 * I.e. for the --load-file case this would ensure that
+			 * e.g. -D followed by a series of -I's
+			 * would return success in case there are no entries
+			 * to be deleted with the -D command preceding the -I's
+			 */
+			if (!exit_msg[i][0]
+					|| cmd_counters[i] != 0
+					|| cmd_no_entries_ok & 1 << i)
+				ret &= EXIT_SUCCESS;
+		}
+	}
+	return ret;
+}
+
 #define ADDR_VALID_FLAGS_MAX   2
 static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 	CT_OPT_ORIG_SRC | CT_OPT_ORIG_DST,
@@ -595,7 +669,6 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
 
 static LIST_HEAD(proto_list);
 
-static unsigned int options;
 static struct nfct_labelmap *labelmap;
 static int filter_family;
 
@@ -609,6 +682,51 @@ void register_proto(struct ctproto_handler *h)
 	list_add(&h->head, &proto_list);
 }
 
+static inline struct nfct_handle* glob_cth(void)
+{
+	if (!cth) {
+		cth = nfct_open(CONNTRACK, 0);
+		if (!cth)
+			exit_error(OTHER_PROBLEM, NULL, "Can't open handler");
+	}
+	return cth;
+}
+
+static inline struct nfct_handle* glob_ith(void)
+{
+	if (!ith) {
+		ith = nfct_open(CONNTRACK, 0);
+		if (!ith)
+			exit_error(OTHER_PROBLEM, NULL, "Can't open handler");
+	}
+	return ith;
+}
+
+static inline struct nfct_handle* glob_exh(void)
+{
+	if (!exh) {
+		exh = nfct_open(EXPECT, 0);
+		if (!exh)
+			exit_error(OTHER_PROBLEM, NULL, "Can't open handler");
+	}
+	return exh;
+}
+
+static void glob_cleanup(void)
+{
+	if (ith)
+		nfct_close(ith);
+	if (cth)
+		nfct_close(cth);
+	if (exh)
+		nfct_close(exh);
+	if (evh)
+		nfct_close(evh);
+
+	if (labelmap)
+		nfct_labelmap_destroy(labelmap);
+}
+
 #define BUFFER_SIZE(ret, size, len, offset) do {			\
 	if ((int)ret > (int)len)					\
 		ret = len;						\
@@ -930,21 +1048,35 @@ static void free_options(void)
 	}
 }
 
+static void usage(void);
+
 void __attribute__((noreturn))
-exit_error(enum exittype status, const char *msg, ...)
+exit_error(enum exittype status, struct ct_cmd *cmd, const char *msg, ...)
 {
 	va_list args;
 
+	/* if some operations have been done, print it in any way */
+	print_cmd_counters();
+
 	free_options();
 	va_start(args, msg);
 	fprintf(stderr,"%s v%s (conntrack-tools): ", PROGNAME, VERSION);
 	vfprintf(stderr, msg, args);
-	fprintf(stderr, "\n");
+	fprintf(stderr,"\n");
 	va_end(args);
-	if (status == PARAMETER_PROBLEM)
-		exit_tryhelp(status);
+	if (cmd && cmd->file_name)
+		fprintf(stderr, "file: %s line: %u\n",
+				cmd->file_name, cmd->line_number);
+	else if (status == PARAMETER_PROBLEM) {
+		if (cmd && !cmd->command)
+			/* called w/o arguments? need to print usage */
+			usage();
+		else
+			exit_tryhelp(status);
+	}
+
 	/* release template objects that were allocated in the setup stage. */
-	free_tmpl_objects();
+	glob_cleanup();
 	exit(status);
 }
 
@@ -974,7 +1106,9 @@ static const char *get_long_opt(int opt)
 	return "unknown";
 }
 
-int generic_opt_check(int local_options, int num_opts,
+int generic_opt_check(struct ct_cmd *cmd,
+			  int options,
+			  int num_opts,
 		      char *optset, const char *optflg[],
 		      unsigned int *coupled_flags, int coupled_flags_size,
 		      int *partial)
@@ -982,15 +1116,15 @@ int generic_opt_check(int local_options, int num_opts,
 	int i, matching = -1, special_case = 0;
 
 	for (i = 0; i < num_opts; i++) {
-		if (!(local_options & (1<<i))) {
+		if (!(options & (1<<i))) {
 			if (optset[i] == 1)
-				exit_error(PARAMETER_PROBLEM, 
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "You need to supply the "
 					   "`--%s' option for this "
 					   "command", optflg[i]);
 		} else {
 			if (optset[i] == 0)
-				exit_error(PARAMETER_PROBLEM, "Illegal "
+				exit_error(PARAMETER_PROBLEM, cmd, "Illegal "
 					   "option `--%s' with this "
 					   "command", optflg[i]);
 		}
@@ -1005,12 +1139,12 @@ int generic_opt_check(int local_options, int num_opts,
 	*partial = -1;
 	for (i=0; i<coupled_flags_size; i++) {
 		/* we look for an exact matching to ensure this is correct */
-		if ((local_options & coupled_flags[i]) == coupled_flags[i]) {
+		if ((options & coupled_flags[i]) == coupled_flags[i]) {
 			matching = i;
 			break;
 		}
 		/* ... otherwise look for the first partial matching */
-		if ((local_options & coupled_flags[i]) && *partial < 0) {
+		if ((options & coupled_flags[i]) && *partial < 0) {
 			*partial = i;
 		}
 	}
@@ -1129,7 +1263,7 @@ static struct parse_parameter {
 };
 
 static int
-do_parse_parameter(const char *str, size_t str_length, unsigned int *value, 
+do_parse_parameter(const char *str, size_t str_length, unsigned int *value,
 		   int parse_type)
 {
 	size_t i;
@@ -1159,20 +1293,23 @@ do_parse_parameter(const char *str, size_t str_length, unsigned int *value,
 }
 
 static void
-parse_parameter(const char *arg, unsigned int *status, int parse_type)
+parse_parameter(struct ct_cmd *cmd,
+		const char *arg, unsigned int *status, int parse_type)
 {
 	const char *comma;
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg 
 		    || !do_parse_parameter(arg, comma-arg, status, parse_type))
-			exit_error(PARAMETER_PROBLEM,"Bad parameter `%s'", arg);
+			exit_error(PARAMETER_PROBLEM, cmd,
+					"Bad parameter `%s'", arg);
 		arg = comma+1;
 	}
 
 	if (strlen(arg) == 0
 	    || !do_parse_parameter(arg, strlen(arg), status, parse_type))
-		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
+		exit_error(PARAMETER_PROBLEM, cmd,
+				"Bad parameter `%s'", arg);
 }
 
 static void
@@ -1189,64 +1326,71 @@ parse_u32_mask(const char *arg, struct u32_mask *m)
 }
 
 static int
-get_label(char *name)
+get_label(struct ct_cmd *cmd, char *name)
 {
 	int bit = nfct_labelmap_get_bit(labelmap, name);
 	if (bit < 0)
-		exit_error(PARAMETER_PROBLEM, "unknown label '%s'", name);
+		exit_error(PARAMETER_PROBLEM, cmd, "unknown label '%s'", name);
 	return bit;
 }
 
 static void
-set_label(struct nfct_bitmask *b, char *name)
+set_label(struct ct_cmd *cmd, struct nfct_bitmask *b, char *name)
 {
-	int bit = get_label(name);
+	int bit = get_label(cmd, name);
 	nfct_bitmask_set_bit(b, bit);
 }
 
 static unsigned int
-set_max_label(char *name, unsigned int current_max)
+set_max_label(struct ct_cmd *cmd, char *name, unsigned int current_max)
 {
-	int bit = get_label(name);
+	int bit = get_label(cmd, name);
 	if ((unsigned int) bit > current_max)
 		return (unsigned int) bit;
 	return current_max;
 }
 
 static unsigned int
-parse_label_get_max(char *arg)
+parse_label_get_max(struct ct_cmd *cmd, char *arg)
 {
 	unsigned int max = 0;
 	char *parse;
 
 	while ((parse = strchr(arg, ',')) != NULL) {
 		parse[0] = '\0';
-		max = set_max_label(arg, max);
+		max = set_max_label(cmd, arg, max);
 		arg = &parse[1];
 	}
 
-	max = set_max_label(arg, max);
+	max = set_max_label(cmd, arg, max);
 	return max;
 }
 
 static void
-parse_label(struct nfct_bitmask *b, char *arg)
+parse_label(struct ct_cmd *cmd, struct nfct_bitmask *b, char *arg)
 {
 	char * parse;
 	while ((parse = strchr(arg, ',')) != NULL) {
 		parse[0] = '\0';
-		set_label(b, arg);
+		set_label(cmd, b, arg);
 		arg = &parse[1];
 	}
-	set_label(b, arg);
+	set_label(cmd, b, arg);
 }
 
 static void
-add_command(unsigned int *cmd, const int newcmd)
+add_command(struct ct_cmd *cmd, const int newcmd)
 {
-	if (*cmd)
-		exit_error(PARAMETER_PROBLEM, "Invalid commands combination");
-	*cmd |= newcmd;
+	if (cmd->command)
+		exit_error(PARAMETER_PROBLEM, cmd, "Invalid commands combination");
+	cmd->command |= newcmd;
+	cmd->cmd_bit = bit2cmd(cmd->command);
+	if (cmd->cmd_bit == NUMBER_OF_CMD)
+		exit_error(PARAMETER_PROBLEM, cmd,
+				"Unknown command!");
+	if (cmd->file_name && !(cmd_load_file_allowed & cmd->command))
+		exit_error(PARAMETER_PROBLEM, cmd,
+				"Command not supported with the load-file mode");
 }
 
 static char *get_optional_arg(int argc, char *argv[])
@@ -1272,7 +1416,7 @@ enum {
 	CT_TABLE_UNCONFIRMED,
 };
 
-static unsigned int check_type(int argc, char *argv[])
+static unsigned int check_type(struct ct_cmd *cmd, int argc, char *argv[])
 {
 	const char *table = get_optional_arg(argc, argv);
 
@@ -1289,17 +1433,17 @@ static unsigned int check_type(int argc, char *argv[])
 	else if (strncmp("unconfirmed", table, strlen(table)) == 0)
 		return CT_TABLE_UNCONFIRMED;
 	else
-		exit_error(PARAMETER_PROBLEM, "unknown type `%s'", table);
+		exit_error(PARAMETER_PROBLEM, cmd, "unknown type `%s'", table);
 
 	return 0;
 }
 
-static void set_family(int *family, int new)
+static void set_family(struct ct_cmd *cmd, int new)
 {
-	if (*family == AF_UNSPEC)
-		*family = new;
-	else if (*family != new)
-		exit_error(PARAMETER_PROBLEM, "mismatched address family");
+	if (cmd->family == AF_UNSPEC)
+		cmd->family = new;
+	else if (cmd->family != new)
+		exit_error(PARAMETER_PROBLEM, cmd, "mismatched address family");
 }
 
 struct addr_parse {
@@ -1386,7 +1530,8 @@ valid_port(char *cursor)
 }
 
 static void
-split_address_and_port(const char *arg, char **address, char **port_str)
+split_address_and_port(struct ct_cmd *cmd,
+		const char *arg, char **address, char **port_str)
 {
 	char *cursor = strchr(arg, '[');
 
@@ -1396,10 +1541,10 @@ split_address_and_port(const char *arg, char **address, char **port_str)
 
 		cursor = strchr(start, ']');
 		if (start == cursor) {
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "No IPv6 address specified");
 		} else if (!cursor) {
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "No closing ']' around IPv6 address");
 		}
 		size_t len = cursor - start;
@@ -1423,11 +1568,11 @@ split_address_and_port(const char *arg, char **address, char **port_str)
 		/* Parse port entry */
 		cursor++;
 		if (strlen(cursor) == 0) {
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "No port specified after `:'");
 		}
 		if (!valid_port(cursor)) {
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "Invalid port `%s'", cursor);
 		}
 		*port_str = strdup(cursor);
@@ -1440,11 +1585,11 @@ split_address_and_port(const char *arg, char **address, char **port_str)
 }
 
 static void
-usage(char *prog)
+usage(void)
 {
 	fprintf(stdout, "Command line interface for the connection "
 			"tracking system. Version %s\n", VERSION);
-	fprintf(stdout, "Usage: %s [commands] [options]\n", prog);
+	fprintf(stdout, "Usage: %s [commands] [options]\n", programm);
 
 	fprintf(stdout, "\n%s", usage_commands);
 	fprintf(stdout, "\n%s", usage_tables);
@@ -1457,17 +1602,17 @@ usage(char *prog)
 static unsigned int output_mask;
 
 static int
-filter_label(const struct nf_conntrack *ct)
+filter_label(struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
-	if (tmpl.label == NULL)
+	if (cmd->label == NULL)
 		return 0;
 
 	const struct nfct_bitmask *ctb = nfct_get_attr(ct, ATTR_CONNLABELS);
 	if (ctb == NULL)
 		return 1;
 
-	for (unsigned int i = 0; i <= nfct_bitmask_maxbit(tmpl.label); i++) {
-		if (nfct_bitmask_test_bit(tmpl.label, i) &&
+	for (unsigned int i = 0; i <= nfct_bitmask_maxbit(cmd->label); i++) {
+		if (nfct_bitmask_test_bit(cmd->label, i) &&
 		    !nfct_bitmask_test_bit(ctb, i))
 				return 1;
 	}
@@ -1476,24 +1621,25 @@ filter_label(const struct nf_conntrack *ct)
 }
 
 static int
-filter_mark(const struct nf_conntrack *ct)
+filter_mark(struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
-	if ((options & CT_OPT_MARK) &&
-	     !mark_cmp(&tmpl.mark, ct))
+	if ((cmd->options & CT_OPT_MARK) &&
+	     !mark_cmp(&cmd->mark, ct))
 		return 1;
 	return 0;
 }
 
 static int 
-filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
+filter_nat(struct ct_cmd *cmd,
+		const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 {
-	int check_srcnat = options & CT_OPT_SRC_NAT ? 1 : 0;
-	int check_dstnat = options & CT_OPT_DST_NAT ? 1 : 0;
+	int check_srcnat = cmd->options & CT_OPT_SRC_NAT ? 1 : 0;
+	int check_dstnat = cmd->options & CT_OPT_DST_NAT ? 1 : 0;
 	int has_srcnat = 0, has_dstnat = 0;
 	uint32_t ip;
 	uint16_t port;
 
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		check_srcnat = check_dstnat = 1;
 
 	if (check_srcnat) {
@@ -1556,13 +1702,13 @@ filter_nat(const struct nf_conntrack *obj, const struct nf_conntrack *ct)
 		     nfct_getobjopt(ct, NFCT_GOPT_IS_DPAT)))
 			has_dstnat = 1;
 	}
-	if (options & CT_OPT_ANY_NAT)
+	if (cmd->options & CT_OPT_ANY_NAT)
 		return !(has_srcnat || has_dstnat);
-	else if ((options & CT_OPT_SRC_NAT) && (options & CT_OPT_DST_NAT))
+	else if ((cmd->options & CT_OPT_SRC_NAT) && (cmd->options & CT_OPT_DST_NAT))
 		return !(has_srcnat && has_dstnat);
-	else if (options & CT_OPT_SRC_NAT)
+	else if (cmd->options & CT_OPT_SRC_NAT)
 		return !has_srcnat;
-	else if (options & CT_OPT_DST_NAT)
+	else if (cmd->options & CT_OPT_DST_NAT)
 		return !has_dstnat;
 
 	return 0;
@@ -1610,14 +1756,14 @@ nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_direction d
 }
 
 static int
-filter_network(const struct nf_conntrack *ct)
+filter_network(struct ct_cmd *cmd, const struct nf_conntrack *ct)
 {
-	if (options & CT_OPT_MASK_SRC) {
+	if (cmd->options & CT_OPT_MASK_SRC) {
 		if (nfct_filter_network_direction(ct, DIR_SRC))
 			return 1;
 	}
 
-	if (options & CT_OPT_MASK_DST) {
+	if (cmd->options & CT_OPT_MASK_DST) {
 		if (nfct_filter_network_direction(ct, DIR_DST))
 			return 1;
 	}
@@ -1625,22 +1771,22 @@ filter_network(const struct nf_conntrack *ct)
 }
 
 static int
-nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct)
+nfct_filter(struct ct_cmd *cmd,
+		struct nf_conntrack *obj, struct nf_conntrack *ct)
 {
-	if (filter_nat(obj, ct) ||
-	    filter_mark(ct) ||
-	    filter_label(ct) ||
-	    filter_network(ct))
+	if (filter_nat(cmd, obj, ct) ||
+	    filter_mark(cmd, ct) ||
+	    filter_label(cmd, ct) ||
+	    filter_network(cmd, ct))
 		return 1;
 
-	if (options & CT_COMPARISON &&
+	if (cmd->options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return 1;
 
 	return 0;
 }
 
-static int counter;
 static int dump_xml_header_done = 1;
 
 static void __attribute__((noreturn))
@@ -1651,8 +1797,7 @@ event_sighandler(int s)
 		fflush(stdout);
 	}
 
-	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
-	fprintf(stderr, "%d flow events have been shown.\n", counter);
+	print_cmd_counters();
 	mnl_socket_close(sock.mnl);
 	exit(0);
 }
@@ -1665,9 +1810,8 @@ exp_event_sighandler(int s)
 		fflush(stdout);
 	}
 
-	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
-	fprintf(stderr, "%d expectation events have been shown.\n", counter);
-	nfct_close(cth);
+	print_cmd_counters();
+	nfct_close(evh);
 	exit(0);
 }
 
@@ -1675,7 +1819,8 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
 	unsigned int op_type = NFCT_O_DEFAULT;
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->ct;
 	enum nf_conntrack_msg_type type;
 	unsigned int op_flags = 0;
 	struct nf_conntrack *ct;
@@ -1707,7 +1852,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 
 	if ((filter_family != AF_UNSPEC &&
 	     filter_family != nfh->nfgen_family) ||
-	    nfct_filter(obj, ct))
+	    nfct_filter(cmd, obj, ct))
 		goto out;
 
 	if (output_mask & _O_SAVE) {
@@ -1750,7 +1895,7 @@ done:
 	printf("%s%s\n", buf, userspace ? " [USERSPACE]" : "");
 	fflush(stdout);
 
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 out:
 	nfct_destroy(ct);
 	return MNL_CB_OK;
@@ -1761,11 +1906,12 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		   void *data)
 {
 	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct))
+	if (nfct_filter(cmd, obj, ct))
 		return NFCT_CB_CONTINUE;
 
 	if (output_mask & _O_SAVE) {
@@ -1792,7 +1938,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 done:
 	printf("%s\n", buf);
 
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -1803,16 +1949,17 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 {
 	int res;
 	char buf[1024];
-	struct nf_conntrack *obj = data;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->ct;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
-	if (nfct_filter(obj, ct))
+	if (nfct_filter(cmd, obj, ct))
 		return NFCT_CB_CONTINUE;
 
 	res = nfct_query(ith, NFCT_Q_DESTROY, ct);
 	if (res < 0)
-		exit_error(OTHER_PROBLEM,
+		exit_error(OTHER_PROBLEM, cmd,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
 
@@ -1832,7 +1979,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 done:
 	printf("%s\n", buf);
 
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -1864,20 +2011,22 @@ done:
 	return NFCT_CB_CONTINUE;
 }
 
-static void copy_mark(struct nf_conntrack *tmp,
+static void copy_mark(struct ct_cmd *cmd,
+		      struct nf_conntrack *tmp,
 		      const struct nf_conntrack *ct,
 		      const struct u32_mask *m)
 {
-	if (options & CT_OPT_MARK) {
+	if (cmd->options & CT_OPT_MARK) {
 		uint32_t mark = nfct_get_attr_u32(ct, ATTR_MARK);
 		mark = (mark & ~m->mask) ^ m->value;
 		nfct_set_attr_u32(tmp, ATTR_MARK, mark);
 	}
 }
 
-static void copy_status(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
+static void copy_status(struct ct_cmd *cmd,
+		      struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 {
-	if (options & CT_OPT_STATUS) {
+	if (cmd->options & CT_OPT_STATUS) {
 		/* copy existing flags, we only allow setting them. */
 		uint32_t status = nfct_get_attr_u32(ct, ATTR_STATUS);
 		status |= nfct_get_attr_u32(tmp, ATTR_STATUS);
@@ -1889,25 +2038,26 @@ static struct nfct_bitmask *xnfct_bitmask_clone(const struct nfct_bitmask *a)
 {
 	struct nfct_bitmask *b = nfct_bitmask_clone(a);
 	if (!b)
-		exit_error(OTHER_PROBLEM, "out of memory");
+		exit_error(OTHER_PROBLEM, NULL, "out of memory");
 	return b;
 }
 
-static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
+static void copy_label(struct ct_cmd *cmd,
+		struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 {
 	struct nfct_bitmask *ctb, *newmask;
 	unsigned int i;
 
-	if ((options & (CT_OPT_ADD_LABEL|CT_OPT_DEL_LABEL)) == 0)
+	if ((cmd->options & (CT_OPT_ADD_LABEL|CT_OPT_DEL_LABEL)) == 0)
 		return;
 
 	nfct_copy_attr(tmp, ct, ATTR_CONNLABELS);
 	ctb = (void *) nfct_get_attr(tmp, ATTR_CONNLABELS);
 
-	if (options & CT_OPT_ADD_LABEL) {
+	if (cmd->options & CT_OPT_ADD_LABEL) {
 		if (ctb == NULL) {
 			nfct_set_attr(tmp, ATTR_CONNLABELS,
-					xnfct_bitmask_clone(tmpl.label_modify));
+					xnfct_bitmask_clone(cmd->label_modify));
 			return;
 		}
 		/* If we send a bitmask shorter than the kernel sent to us, the bits we
@@ -1921,7 +2071,7 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		newmask = nfct_bitmask_new(nfct_bitmask_maxbit(ctb));
 
 		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
-			if (nfct_bitmask_test_bit(tmpl.label_modify, i)) {
+			if (nfct_bitmask_test_bit(cmd->label_modify, i)) {
 				nfct_bitmask_set_bit(ctb, i);
 				nfct_bitmask_set_bit(newmask, i);
 			} else if (nfct_bitmask_test_bit(ctb, i)) {
@@ -1934,7 +2084,7 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
 	} else if (ctb != NULL) {
 		/* CT_OPT_DEL_LABEL */
-		if (tmpl.label_modify == NULL) {
+		if (cmd->label_modify == NULL) {
 			newmask = nfct_bitmask_new(0);
 			if (newmask)
 				nfct_set_attr(tmp, ATTR_CONNLABELS, newmask);
@@ -1942,11 +2092,11 @@ static void copy_label(struct nf_conntrack *tmp, const struct nf_conntrack *ct)
 		}
 
 		for (i = 0; i <= nfct_bitmask_maxbit(ctb); i++) {
-			if (nfct_bitmask_test_bit(tmpl.label_modify, i))
+			if (nfct_bitmask_test_bit(cmd->label_modify, i))
 				nfct_bitmask_unset_bit(ctb, i);
 		}
 
-		newmask = xnfct_bitmask_clone(tmpl.label_modify);
+		newmask = xnfct_bitmask_clone(cmd->label_modify);
 		nfct_set_attr(tmp, ATTR_CONNLABELS_MASK, newmask);
 	}
 }
@@ -1956,31 +2106,32 @@ static int update_cb(enum nf_conntrack_msg_type type,
 		     void *data)
 {
 	int res;
-	struct nf_conntrack *obj = data, *tmp;
+	struct ct_cmd *cmd = data;
+	struct nf_conntrack *obj = cmd->ct, *tmp;
 
-	if (filter_nat(obj, ct) ||
-	    filter_label(ct) ||
-	    filter_network(ct))
+	if (filter_nat(cmd, obj, ct) ||
+	    filter_label(cmd, ct) ||
+	    filter_network(cmd, ct))
 		return NFCT_CB_CONTINUE;
 
 	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &&
 	    nfct_get_attr_u32(obj, ATTR_ID) != nfct_get_attr_u32(ct, ATTR_ID))
 	    	return NFCT_CB_CONTINUE;
 
-	if (options & CT_OPT_TUPLE_ORIG && !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
+	if (cmd->options & CT_OPT_TUPLE_ORIG && !nfct_cmp(obj, ct, NFCT_CMP_ORIG))
 		return NFCT_CB_CONTINUE;
-	if (options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
+	if (cmd->options & CT_OPT_TUPLE_REPL && !nfct_cmp(obj, ct, NFCT_CMP_REPL))
 		return NFCT_CB_CONTINUE;
 
 	tmp = nfct_new();
 	if (tmp == NULL)
-		exit_error(OTHER_PROBLEM, "out of memory");
+		exit_error(OTHER_PROBLEM, cmd, "out of memory");
 
 	nfct_copy(tmp, ct, NFCT_CP_ORIG);
 	nfct_copy(tmp, obj, NFCT_CP_META);
-	copy_mark(tmp, ct, &tmpl.mark);
-	copy_status(tmp, ct);
-	copy_label(tmp, ct);
+	copy_mark(cmd, tmp, ct, &cmd->mark);
+	copy_status(cmd, tmp, ct);
+	copy_label(cmd, tmp, ct);
 
 	/* do not send NFCT_Q_UPDATE if ct appears unchanged */
 	if (nfct_cmp(tmp, ct, NFCT_CMP_ALL | NFCT_CMP_MASK)) {
@@ -2003,14 +2154,14 @@ static int update_cb(enum nf_conntrack_msg_type type,
 			nfct_callback_unregister(ith);
 			return NFCT_CB_CONTINUE;
 		}
-		exit_error(OTHER_PROBLEM,
+		exit_error(OTHER_PROBLEM, cmd,
 			   "Operation failed: %s",
 			   err2str(errno, CT_UPDATE));
 	}
 	nfct_destroy(tmp);
 	nfct_callback_unregister(ith);
 
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2020,6 +2171,7 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 		      void *data)
 {
 	char buf[1024];
+	struct ct_cmd *cmd = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
@@ -2042,7 +2194,7 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 
 	nfexp_snprintf(buf,sizeof(buf), exp, NFCT_T_UNKNOWN, op_type, op_flags);
 	printf("%s\n", buf);
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2051,6 +2203,7 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 			struct nf_expect *exp, void *data)
 {
 	char buf[1024];
+	struct ct_cmd *cmd = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
@@ -2074,7 +2227,7 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 	nfexp_snprintf(buf,sizeof(buf), exp, type, op_type, op_flags);
 	printf("%s\n", buf);
 	fflush(stdout);
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return NFCT_CB_CONTINUE;
 }
@@ -2083,7 +2236,9 @@ static int count_exp_cb(enum nf_conntrack_msg_type type,
 			struct nf_expect *exp,
 			void *data)
 {
-	counter++;
+	struct ct_cmd *cmd = data;
+
+	cmd_counters[cmd->cmd_bit]++;
 	return NFCT_CB_CONTINUE;
 }
 
@@ -2196,10 +2351,12 @@ nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
 static void nfct_mnl_socket_close(void)
 {
 	mnl_socket_close(sock.mnl);
+	memset(&sock, 0, sizeof(sock));
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_dump(struct ct_cmd *cmd,
+		uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
@@ -2214,7 +2371,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
 	while (res > 0) {
 		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
-					 cb, NULL);
+					 cb, cmd);
 		if (res <= MNL_CB_STOP)
 			break;
 
@@ -2382,6 +2539,7 @@ static int nfct_global_stats_cb(const struct nlmsghdr *nlh, void *data)
 
 static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 {
+	struct ct_cmd *cmd = data;
 	struct nf_conntrack *ct;
 	char buf[4096];
 
@@ -2396,7 +2554,7 @@ static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 
 	nfct_destroy(ct);
 
-	counter++;
+	cmd_counters[cmd->cmd_bit]++;
 
 	return MNL_CB_OK;
 }
@@ -2413,19 +2571,19 @@ static void labelmap_init(void)
 }
 
 static void
-nfct_network_attr_prepare(const int family, enum ct_direction dir)
+nfct_network_attr_prepare(struct ct_cmd *cmd, enum ct_direction dir)
 {
 	const union ct_address *address, *netmask;
 	enum nf_conntrack_attr attr;
 	int i;
 	struct ct_network *net = &dir2network[dir];
 
-	attr = famdir2attr[family == AF_INET6][dir];
+	attr = famdir2attr[cmd->family == AF_INET6][dir];
 
-	address = nfct_get_attr(tmpl.ct, attr);
-	netmask = nfct_get_attr(tmpl.mask, attr);
+	address = nfct_get_attr(cmd->ct, attr);
+	netmask = nfct_get_attr(cmd->mask, attr);
 
-	switch(family) {
+	switch(cmd->family) {
 	case AF_INET:
 		net->network.v4 = address->v4 & netmask->v4;
 		break;
@@ -2438,27 +2596,34 @@ nfct_network_attr_prepare(const int family, enum ct_direction dir)
 	memcpy(&net->netmask, netmask, sizeof(union ct_address));
 
 	/* avoid exact source matching */
-	nfct_attr_unset(tmpl.ct, attr);
+	nfct_attr_unset(cmd->ct, attr);
+}
+
+static void
+nfct_filter_reset(void)
+{
+	filter_family = 0;
+	memset(dir2network, 0, sizeof(dir2network));
 }
 
 static void
-nfct_filter_init(const int family)
+nfct_filter_init(struct ct_cmd *cmd)
 {
-	filter_family = family;
-	if (options & CT_OPT_MASK_SRC) {
-		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_SRC))
-			exit_error(PARAMETER_PROBLEM,
+	filter_family = cmd->family;
+	if (cmd->options & CT_OPT_MASK_SRC) {
+		assert(cmd->family != AF_UNSPEC);
+		if (!(cmd->options & CT_OPT_ORIG_SRC))
+			exit_error(PARAMETER_PROBLEM, cmd,
 			           "Can't use --mask-src without --src");
-		nfct_network_attr_prepare(family, DIR_SRC);
+		nfct_network_attr_prepare(cmd, DIR_SRC);
 	}
 
-	if (options & CT_OPT_MASK_DST) {
-		assert(family != AF_UNSPEC);
-		if (!(options & CT_OPT_ORIG_DST))
-			exit_error(PARAMETER_PROBLEM,
+	if (cmd->options & CT_OPT_MASK_DST) {
+		assert(cmd->family != AF_UNSPEC);
+		if (!(cmd->options & CT_OPT_ORIG_DST))
+			exit_error(PARAMETER_PROBLEM, cmd,
 			           "Can't use --mask-dst without --dst");
-		nfct_network_attr_prepare(family, DIR_DST);
+		nfct_network_attr_prepare(cmd, DIR_DST);
 	}
 }
 
@@ -2525,39 +2690,41 @@ nfct_set_addr_only(const int opt, struct nf_conntrack *ct, union ct_address *ad,
 }
 
 static void
-nfct_set_addr_opt(const int opt, struct nf_conntrack *ct, union ct_address *ad,
+nfct_set_addr_opt(struct ct_cmd *cmd,
+		  const int opt, struct nf_conntrack *ct, union ct_address *ad,
 		  const int l3protonum)
 {
-	options |= opt2type[opt];
+	cmd->options |= opt2type[opt];
 	nfct_set_addr_only(opt, ct, ad, l3protonum);
 	nfct_set_attr_u8(ct, opt2attr[opt], l3protonum);
 }
 
 static void
-nfct_parse_addr_from_opt(const int opt, const char *arg,
+nfct_parse_addr_from_opt(struct ct_cmd *cmd,
+			 const int opt, const char *arg,
 			 struct nf_conntrack *ct,
 			 struct nf_conntrack *ctmask,
-			 union ct_address *ad, int *family)
+			 union ct_address *ad)
 {
 	int mask, maskopt;
 
 	const int l3protonum = parse_addr(arg, ad, &mask);
 	if (l3protonum == AF_UNSPEC) {
-		exit_error(PARAMETER_PROBLEM,
+		exit_error(PARAMETER_PROBLEM, cmd,
 			   "Invalid IP address `%s'", arg);
 	}
-	set_family(family, l3protonum);
+	set_family(cmd, l3protonum);
 	maskopt = opt2maskopt[opt];
 	if (mask != -1 && !maskopt) {
-		exit_error(PARAMETER_PROBLEM,
+		exit_error(PARAMETER_PROBLEM, cmd,
 		           "CIDR notation unavailable"
 		           " for `--%s'", get_long_opt(opt));
 	} else if (mask == -2) {
-		exit_error(PARAMETER_PROBLEM,
+		exit_error(PARAMETER_PROBLEM, cmd,
 		           "Invalid netmask");
 	}
 
-	nfct_set_addr_opt(opt, ct, ad, l3protonum);
+	nfct_set_addr_opt(cmd, opt, ct, ad, l3protonum);
 
 	/* bail if we don't have a netmask to set*/
 	if (mask == -1 || !maskopt || ctmask == NULL)
@@ -2576,7 +2743,7 @@ nfct_parse_addr_from_opt(const int opt, const char *arg,
 		break;
 	}
 
-	nfct_set_addr_opt(maskopt, ctmask, ad, l3protonum);
+	nfct_set_addr_opt(cmd, maskopt, ctmask, ad, l3protonum);
 }
 
 static void
@@ -2594,50 +2761,80 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 		nfct_set_attr_u16(ct, ATTR_DNAT_PORT,
 				  ntohs((uint16_t)atoi(port_str)));
 	}
+}
+
+static int line_to_argcv(char *line, char ***pargv,
+		size_t *pargv_size)
+{
+	char *arg;
+	int argc;
+	char **argv = *pargv;
+	size_t argv_size = *pargv_size;
+	int argc_max = argv_size / sizeof(*argv);
+
+#define _ARG_ADD(_arg) do { \
+		if (argc == argc_max) { \
+			argc_max += 20; \
+			argv_size = argc_max * sizeof (argv[0]); \
+			argv = realloc(argv, argv_size); \
+			if (!argv) \
+				exit_error(OTHER_PROBLEM, NULL, "out of memory"); \
+		} \
+		argv[argc] = _arg; \
+		++argc; \
+} while (0)
+
+#define _ARG_SEP " \t\n\r"
+	for (argc = 0, arg = strtok (line, _ARG_SEP);
+			arg;
+			arg = strtok (NULL, _ARG_SEP)) {
+		/*
+		 * getopt_long expects argv[0] to be the programm name,
+		 * and would always skip it so we need to include it here
+		 */
+		if (!argc && programm)
+			_ARG_ADD(programm);
+		_ARG_ADD(arg);
+	}
 
+#undef _ARG_ADD
+#undef _ARG_SEP
+
+	*pargv = argv;
+	*pargv_size = argv_size;
+
+	return argc;
 }
 
-int main(int argc, char *argv[])
+static struct ct_cmd* ct_cmd_create(int argc, char *argv[],
+		const char *file_name, unsigned int line_number)
 {
-	int c, cmd;
-	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
+	int c;
+	unsigned int l4flags = 0, status = 0;
 	int res = 0, partial;
-	size_t socketbuffersize = 0;
-	int family = AF_UNSPEC;
-	int protonum = 0;
 	union ct_address ad;
-	unsigned int command = 0;
+	struct ct_cmd *cmd;
 
-	/* we release these objects in the exit_error() path. */
-	if (!alloc_tmpl_objects())
-		exit_error(OTHER_PROBLEM, "out of memory");
+	optind = 0;
 
-	register_tcp();
-	register_udp();
-	register_udplite();
-	register_sctp();
-	register_dccp();
-	register_icmp();
-	register_icmpv6();
-	register_gre();
-	register_unknown();
+	cmd = ct_cmd_alloc();
 
-	/* disable explicit missing arguments error output from getopt_long */
-	opterr = 0;
+	cmd->line_number = line_number;
+	cmd->file_name = file_name;
 
 	while ((c = getopt_long(argc, argv, getopt_str, opts, NULL)) != -1) {
 	switch(c) {
 		/* commands */
 		case 'L':
-			type = check_type(argc, argv);
+			cmd->type = check_type(cmd, argc, argv);
 			/* Special case: dumping dying and unconfirmed list
 			 * are handled like normal conntrack dumps.
 			 */
-			if (type == CT_TABLE_DYING ||
-			    type == CT_TABLE_UNCONFIRMED)
-				add_command(&command, cmd2type[c][0]);
+			if (cmd->type == CT_TABLE_DYING ||
+				cmd->type == CT_TABLE_UNCONFIRMED)
+				add_command(cmd, cmd2type[c][0]);
 			else
-				add_command(&command, cmd2type[c][type]);
+				add_command(cmd, cmd2type[c][cmd->type]);
 			break;
 		case 'I':
 		case 'D':
@@ -2648,26 +2845,26 @@ int main(int argc, char *argv[])
 		case 'h':
 		case 'C':
 		case 'S':
-			type = check_type(argc, argv);
-			if (type == CT_TABLE_DYING ||
-			    type == CT_TABLE_UNCONFIRMED) {
-				exit_error(PARAMETER_PROBLEM,
+			cmd->type = check_type(cmd, argc, argv);
+			if (cmd->type == CT_TABLE_DYING ||
+				cmd->type == CT_TABLE_UNCONFIRMED) {
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "Can't do that command with "
 					   "tables `dying' and `unconfirmed'");
 			}
-			add_command(&command, cmd2type[c][type]);
+			add_command(cmd, cmd2type[c][cmd->type]);
 			break;
 		case 'U':
-			type = check_type(argc, argv);
-			if (type == CT_TABLE_DYING ||
-			    type == CT_TABLE_UNCONFIRMED) {
-				exit_error(PARAMETER_PROBLEM,
+			cmd->type = check_type(cmd, argc, argv);
+			if (cmd->type == CT_TABLE_DYING ||
+				cmd->type == CT_TABLE_UNCONFIRMED) {
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "Can't do that command with "
 					   "tables `dying' and `unconfirmed'");
-			} else if (type == CT_TABLE_CONNTRACK)
-				add_command(&command, CT_UPDATE);
+			} else if (cmd->type == CT_TABLE_CONNTRACK)
+				add_command(cmd, CT_UPDATE);
 			else
-				exit_error(PARAMETER_PROBLEM,
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "Can't update expectations");
 			break;
 		/* options */
@@ -2675,123 +2872,123 @@ int main(int argc, char *argv[])
 		case 'd':
 		case 'r':
 		case 'q':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.ct,
-						 tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(cmd, c, optarg, cmd->ct,
+						 cmd->mask, &ad);
 			break;
 		case '[':
 		case ']':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.exptuple,
-						 tmpl.mask, &ad, &family);
+			nfct_parse_addr_from_opt(cmd, c, optarg, cmd->exptuple,
+					cmd->mask, &ad);
 			break;
 		case '{':
 		case '}':
-			nfct_parse_addr_from_opt(c, optarg, tmpl.mask,
-						 NULL, &ad, &family);
+			nfct_parse_addr_from_opt(cmd, c, optarg, cmd->mask,
+						 NULL, &ad);
 			break;
 		case 'p':
-			options |= CT_OPT_PROTO;
-			h = findproto(optarg, &protonum);
+			cmd->options |= CT_OPT_PROTO;
+			h = findproto(optarg, &cmd->protonum);
 			if (!h)
-				exit_error(PARAMETER_PROBLEM,
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "`%s' unsupported protocol",
 					   optarg);
 
 			opts = merge_options(opts, h->opts, &h->option_offset);
 			if (opts == NULL)
-				exit_error(OTHER_PROBLEM, "out of memory");
+				exit_error(OTHER_PROBLEM, cmd, "out of memory");
 
-			nfct_set_attr_u8(tmpl.ct, ATTR_L4PROTO, protonum);
+			nfct_set_attr_u8(cmd->ct, ATTR_L4PROTO, cmd->protonum);
 			break;
 		case 't':
-			options |= CT_OPT_TIMEOUT;
-			nfct_set_attr_u32(tmpl.ct, ATTR_TIMEOUT, atol(optarg));
-			nfexp_set_attr_u32(tmpl.exp,
+			cmd->options |= CT_OPT_TIMEOUT;
+			nfct_set_attr_u32(cmd->ct, ATTR_TIMEOUT, atol(optarg));
+			nfexp_set_attr_u32(cmd->exp,
 					   ATTR_EXP_TIMEOUT, atol(optarg));
 			break;
 		case 'u':
-			options |= CT_OPT_STATUS;
-			parse_parameter(optarg, &status, PARSE_STATUS);
-			nfct_set_attr_u32(tmpl.ct, ATTR_STATUS, status);
+			cmd->options |= CT_OPT_STATUS;
+			parse_parameter(cmd, optarg, &status, PARSE_STATUS);
+			nfct_set_attr_u32(cmd->ct, ATTR_STATUS, status);
 			break;
 		case 'e':
-			options |= CT_OPT_EVENT_MASK;
-			parse_parameter(optarg, &event_mask, PARSE_EVENT);
+			cmd->options |= CT_OPT_EVENT_MASK;
+			parse_parameter(cmd, optarg, &cmd->event_mask, PARSE_EVENT);
 			break;
 		case 'o':
-			options |= CT_OPT_OUTPUT;
-			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
+			cmd->options |= CT_OPT_OUTPUT;
+			parse_parameter(cmd, optarg, &output_mask, PARSE_OUTPUT);
 			if (output_mask & _O_CL)
 				labelmap_init();
 			if ((output_mask & _O_SAVE) &&
 			    (output_mask & (_O_EXT |_O_TMS |_O_ID | _O_KTMS | _O_CL | _O_XML)))
-				exit_error(OTHER_PROBLEM,
+				exit_error(OTHER_PROBLEM, cmd,
 					   "cannot combine save output with any other output type, use -o save only");
 			break;
 		case 'z':
-			options |= CT_OPT_ZERO;
+			cmd->options |= CT_OPT_ZERO;
 			break;
 		case 'n':
 		case 'g':
 		case 'j':
-			options |= opt2type[c];
+			cmd->options |= opt2type[c];
 			char *optional_arg = get_optional_arg(argc, argv);
 
 			if (optional_arg) {
 				char *port_str = NULL;
 				char *nat_address = NULL;
 
-				split_address_and_port(optional_arg,
+				split_address_and_port(cmd, optional_arg,
 						       &nat_address,
 						       &port_str);
-				nfct_parse_addr_from_opt(c, nat_address,
-							 tmpl.ct, NULL,
-							 &ad, &family);
+				nfct_parse_addr_from_opt(cmd, c, nat_address,
+							 cmd->ct, NULL,
+							 &ad);
 				if (c == 'j') {
 					/* Set details on both src and dst
 					 * with any-nat
 					 */
-					nfct_set_nat_details('g', tmpl.ct, &ad,
-							     port_str, family);
-					nfct_set_nat_details('n', tmpl.ct, &ad,
-							     port_str, family);
+					nfct_set_nat_details('g', cmd->ct, &ad,
+							     port_str, cmd->family);
+					nfct_set_nat_details('n', cmd->ct, &ad,
+							     port_str, cmd->family);
 				} else {
-					nfct_set_nat_details(c, tmpl.ct, &ad,
-							     port_str, family);
+					nfct_set_nat_details(c, cmd->ct, &ad,
+							     port_str, cmd->family);
 				}
 			}
 			break;
 		case 'w':
 		case '(':
 		case ')':
-			options |= opt2type[c];
-			nfct_set_attr_u16(tmpl.ct,
+			cmd->options |= opt2type[c];
+			nfct_set_attr_u16(cmd->ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
 			break;
 		case 'i':
 		case 'c':
-			options |= opt2type[c];
-			nfct_set_attr_u32(tmpl.ct,
+			cmd->options |= opt2type[c];
+			nfct_set_attr_u32(cmd->ct,
 					  opt2attr[c],
 					  strtoul(optarg, NULL, 0));
 			break;
 		case 'm':
-			options |= opt2type[c];
-			parse_u32_mask(optarg, &tmpl.mark);
-			tmpl.filter_mark_kernel.val = tmpl.mark.value;
-			tmpl.filter_mark_kernel.mask = tmpl.mark.mask;
-			tmpl.filter_mark_kernel_set = true;
+			cmd->options |= opt2type[c];
+			parse_u32_mask(optarg, &cmd->mark);
+			cmd->filter_mark_kernel.val = cmd->mark.value;
+			cmd->filter_mark_kernel.mask = cmd->mark.mask;
+			cmd->filter_mark_kernel_set = true;
 			break;
 		case 'l':
 		case '<':
 		case '>':
-			options |= opt2type[c];
+			cmd->options |= opt2type[c];
 
 			labelmap_init();
 
-			if ((options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
+			if ((cmd->options & (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL)) ==
 			    (CT_OPT_DEL_LABEL|CT_OPT_ADD_LABEL))
-				exit_error(OTHER_PROBLEM, "cannot use --label-add and "
+				exit_error(OTHER_PROBLEM, cmd, "cannot use --label-add and "
 							"--label-del at the same time");
 
 			if (c == '>') { /* DELETE */
@@ -2802,18 +2999,18 @@ int main(int argc, char *argv[])
 			}
 
 			char *optarg2 = strdup(optarg);
-			unsigned int max = parse_label_get_max(optarg);
+			unsigned int max = parse_label_get_max(cmd, optarg);
 			struct nfct_bitmask * b = nfct_bitmask_new(max);
 			if (!b)
-				exit_error(OTHER_PROBLEM, "out of memory");
+				exit_error(OTHER_PROBLEM, cmd, "out of memory");
 
-			parse_label(b, optarg2);
+			parse_label(cmd, b, optarg2);
 
 			/* join "-l foo -l bar" into single bitmask object */
 			if (c == 'l') {
-				merge_bitmasks(&tmpl.label, b);
+				merge_bitmasks(&cmd->label, b);
 			} else {
-				merge_bitmasks(&tmpl.label_modify, b);
+				merge_bitmasks(&cmd->label_modify, b);
 			}
 
 			free(optarg2);
@@ -2823,41 +3020,44 @@ int main(int argc, char *argv[])
 					"deprecated option.\n", c);
 			break;
 		case 'f':
-			options |= CT_OPT_FAMILY;
+			cmd->options |= CT_OPT_FAMILY;
 			if (strncmp(optarg, "ipv4", strlen("ipv4")) == 0)
-				set_family(&family, AF_INET);
+				set_family(cmd, AF_INET);
 			else if (strncmp(optarg, "ipv6", strlen("ipv6")) == 0)
-				set_family(&family, AF_INET6);
+				set_family(cmd, AF_INET6);
 			else
-				exit_error(PARAMETER_PROBLEM,
+				exit_error(PARAMETER_PROBLEM, cmd,
 					   "`%s' unsupported protocol",
 					   optarg);
 			break;
 		case 'b':
-			socketbuffersize = atol(optarg);
-			options |= CT_OPT_BUFFERSIZE;
+			cmd->socketbuffersize = atol(optarg);
+			cmd->options |= CT_OPT_BUFFERSIZE;
 			break;
 		case ':':
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "option `%s' requires an "
 				   "argument", argv[optind-1]);
 		case '?':
-			exit_error(PARAMETER_PROBLEM,
+			exit_error(PARAMETER_PROBLEM, cmd,
 				   "unknown option `%s'", argv[optind-1]);
 			break;
 		default:
 			if (h && h->parse_opts 
-			    &&!h->parse_opts(c - h->option_offset, tmpl.ct,
-			    		     tmpl.exptuple, tmpl.mask,
-					     &l4flags))
-				exit_error(PARAMETER_PROBLEM, "parse error");
+			    &&!h->parse_opts(cmd, c - h->option_offset, &l4flags))
+				exit_error(PARAMETER_PROBLEM, cmd, "parse error");
 			break;
 		}
 	}
 
+	if (!cmd->command)
+		/* invalid args */
+		exit_error(PARAMETER_PROBLEM, cmd,
+				   "invalid cmd line syntax");
+
 	/* default family only for the following commands */
-	if (family == AF_UNSPEC) {
-		switch (command) {
+	if (cmd->family == AF_UNSPEC) {
+		switch (cmd->command) {
 		case CT_LIST:
 		case CT_UPDATE:
 		case CT_DELETE:
@@ -2866,97 +3066,104 @@ int main(int argc, char *argv[])
 		case CT_EVENT:
 			break;
 		default:
-			family = AF_INET;
+			cmd->family = AF_INET;
 			break;
 		}
 	}
 
-
 	/* we cannot check this combination with generic_opt_check. */
-	if (options & CT_OPT_ANY_NAT &&
-	   ((options & CT_OPT_SRC_NAT) || (options & CT_OPT_DST_NAT))) {
-		exit_error(PARAMETER_PROBLEM, "cannot specify `--src-nat' or "
+	if (cmd->options & CT_OPT_ANY_NAT &&
+	   ((cmd->options & CT_OPT_SRC_NAT) || (cmd->options & CT_OPT_DST_NAT))) {
+		exit_error(PARAMETER_PROBLEM, cmd, "cannot specify `--src-nat' or "
 					      "`--dst-nat' with `--any-nat'");
 	}
-	cmd = bit2cmd(command);
-	res = generic_opt_check(options, NUMBER_OF_OPT,
-				commands_v_options[cmd], optflags,
+
+	res = generic_opt_check(cmd, cmd->options, NUMBER_OF_OPT,
+				commands_v_options[cmd->cmd_bit], optflags,
 				addr_valid_flags, ADDR_VALID_FLAGS_MAX,
 				&partial);
 	if (!res) {
 		switch(partial) {
 		case -1:
 		case 0:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd, "you have to specify "
 						      "`--src' and `--dst'");
 			break;
 		case 1:
-			exit_error(PARAMETER_PROBLEM, "you have to specify "
+			exit_error(PARAMETER_PROBLEM, cmd, "you have to specify "
 						      "`--reply-src' and "
 						      "`--reply-dst'");
 			break;
 		}
 	}
-	if (!(command & CT_HELP) && h && h->final_check)
-		h->final_check(l4flags, cmd, tmpl.ct);
+	if (!(cmd->command & CT_HELP) && h && h->final_check)
+		h->final_check(cmd, l4flags);
+
+	free_options();
+
+	return cmd;
+}
 
-	switch(command) {
+void ct_cmd_apply(struct ct_cmd *cmd)
+{
+	int res = 0;
+
+	assert(cmd->cmd_bit < sizeof(cmd_counters) / sizeof(cmd_counters[0]));
+	cmd_executed |= cmd->command;
+
+	switch(cmd->command) {
 	struct nfct_filter_dump *filter_dump;
 
 	case CT_LIST:
-		if (type == CT_TABLE_DYING) {
+		if (cmd->type == CT_TABLE_DYING) {
 			if (nfct_mnl_socket_open(0) < 0)
-				exit_error(OTHER_PROBLEM, "Can't open handler");
+				exit_error(OTHER_PROBLEM, cmd, "Can't open handler");
 
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(cmd, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
-					    mnl_nfct_dump_cb, family);
+					    mnl_nfct_dump_cb, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
-		} else if (type == CT_TABLE_UNCONFIRMED) {
+		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
 			if (nfct_mnl_socket_open(0) < 0)
-				exit_error(OTHER_PROBLEM, "Can't open handler");
+				exit_error(OTHER_PROBLEM, cmd, "Can't open handler");
 
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(cmd, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
-					    mnl_nfct_dump_cb, family);
+					    mnl_nfct_dump_cb, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
 		}
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		if (options & CT_COMPARISON && 
-		    options & CT_OPT_ZERO)
-			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
+		if (cmd->options & CT_COMPARISON &&
+			cmd->options & CT_OPT_ZERO)
+			exit_error(PARAMETER_PROBLEM, cmd, "Can't use -z with "
 						      "filtering parameters");
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
+		nfct_callback_register(glob_cth(), NFCT_T_ALL, dump_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
-			exit_error(OTHER_PROBLEM, "OOM");
+			exit_error(OTHER_PROBLEM, cmd, "OOM");
 
-		if (tmpl.filter_mark_kernel_set) {
+		if (cmd->filter_mark_kernel_set) {
 			nfct_filter_dump_set_attr(filter_dump,
 						  NFCT_FILTER_DUMP_MARK,
-						  &tmpl.filter_mark_kernel);
+						  &cmd->filter_mark_kernel);
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+						 cmd->family);
 
-		if (options & CT_OPT_ZERO)
-			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
+		if (cmd->options & CT_OPT_ZERO)
+			res = nfct_query(glob_cth(), NFCT_Q_DUMP_FILTER_RESET,
 					filter_dump);
 		else
-			res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
+			res = nfct_query(glob_cth(), NFCT_Q_DUMP_FILTER, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
 
@@ -2964,18 +3171,11 @@ int main(int argc, char *argv[])
 			printf("</conntrack>\n");
 			fflush(stdout);
 		}
-
-		nfct_close(cth);
 		break;
 
 	case EXP_LIST:
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
-		nfct_close(cth);
+		nfexp_callback_register(glob_exh(), NFCT_T_ALL, dump_exp_cb, cmd);
+		res = nfexp_query(glob_exh(), NFCT_Q_DUMP, &cmd->family);
 
 		if (dump_xml_header_done == 0) {
 			printf("</expect>\n");
@@ -2984,150 +3184,108 @@ int main(int argc, char *argv[])
 		break;
 
 	case CT_CREATE:
-		if ((options & CT_OPT_ORIG) && !(options & CT_OPT_REPL))
-		    	nfct_setobjopt(tmpl.ct, NFCT_SOPT_SETUP_REPLY);
-		else if (!(options & CT_OPT_ORIG) && (options & CT_OPT_REPL))
-			nfct_setobjopt(tmpl.ct, NFCT_SOPT_SETUP_ORIGINAL);
-
-		if (options & CT_OPT_MARK)
-			nfct_set_attr_u32(tmpl.ct, ATTR_MARK, tmpl.mark.value);
+		if ((cmd->options & CT_OPT_ORIG) && !(cmd->options & CT_OPT_REPL))
+			nfct_setobjopt(cmd->ct, NFCT_SOPT_SETUP_REPLY);
+		else if (!(cmd->options & CT_OPT_ORIG) && (cmd->options & CT_OPT_REPL))
+			nfct_setobjopt(cmd->ct, NFCT_SOPT_SETUP_ORIGINAL);
 
-		if (options & CT_OPT_ADD_LABEL)
-			nfct_set_attr(tmpl.ct, ATTR_CONNLABELS,
-					xnfct_bitmask_clone(tmpl.label_modify));
+		if (cmd->options & CT_OPT_MARK)
+			nfct_set_attr_u32(cmd->ct, ATTR_MARK, cmd->mark.value);
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (cmd->options & CT_OPT_ADD_LABEL)
+			nfct_set_attr(cmd->ct, ATTR_CONNLABELS,
+					xnfct_bitmask_clone(cmd->label_modify));
 
-		res = nfct_query(cth, NFCT_Q_CREATE, tmpl.ct);
+		res = nfct_query(glob_cth(), NFCT_Q_CREATE, cmd->ct);
 		if (res != -1)
-			counter++;
-		nfct_close(cth);
+			cmd_counters[cmd->cmd_bit]++;
 		break;
 
 	case EXP_CREATE:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASTER, tmpl.ct);
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.exptuple);
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASK, tmpl.mask);
+		nfexp_set_attr(cmd->exp, ATTR_EXP_MASTER, cmd->ct);
+		nfexp_set_attr(cmd->exp, ATTR_EXP_EXPECTED, cmd->exptuple);
+		nfexp_set_attr(cmd->exp, ATTR_EXP_MASK, cmd->mask);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		res = nfexp_query(cth, NFCT_Q_CREATE, tmpl.exp);
-		nfct_close(cth);
+		res = nfexp_query(glob_exh(), NFCT_Q_CREATE, cmd->exp);
 		break;
 
 	case CT_UPDATE:
-		cth = nfct_open(CONNTRACK, 0);
-		/* internal handler for delete_cb, otherwise we hit EILSEQ */
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		/* make sure ith used in update_cb is initialized */
+		glob_ith();
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, update_cb, tmpl.ct);
+		nfct_callback_register(glob_cth(), NFCT_T_ALL, update_cb, cmd);
 
-		res = nfct_query(cth, NFCT_Q_DUMP, &family);
-		nfct_close(ith);
-		nfct_close(cth);
+		res = nfct_query(glob_cth(), NFCT_Q_DUMP, &cmd->family);
 		break;
 		
 	case CT_DELETE:
-		cth = nfct_open(CONNTRACK, 0);
-		ith = nfct_open(CONNTRACK, 0);
-		if (!cth || !ith)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		/* make sure ith used in delete_cb is initialized */
+		glob_ith();
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd);
 
-		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, tmpl.ct);
+		nfct_callback_register(glob_cth(), NFCT_T_ALL, delete_cb, cmd);
 
 		filter_dump = nfct_filter_dump_create();
 		if (filter_dump == NULL)
-			exit_error(OTHER_PROBLEM, "OOM");
+			exit_error(OTHER_PROBLEM, cmd, "OOM");
 
-		if (tmpl.filter_mark_kernel_set) {
+		if (cmd->filter_mark_kernel_set) {
 			nfct_filter_dump_set_attr(filter_dump,
 						  NFCT_FILTER_DUMP_MARK,
-						  &tmpl.filter_mark_kernel);
+						  &cmd->filter_mark_kernel);
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+						 cmd->family);
 
-		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
+		res = nfct_query(glob_cth(), NFCT_Q_DUMP_FILTER, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_close(ith);
-		nfct_close(cth);
 		break;
 
 	case EXP_DELETE:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_EXPECTED, tmpl.ct);
-
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		nfexp_set_attr(cmd->exp, ATTR_EXP_EXPECTED, cmd->ct);
 
-		res = nfexp_query(cth, NFCT_Q_DESTROY, tmpl.exp);
-		nfct_close(cth);
+		res = nfexp_query(glob_cth(), NFCT_Q_DESTROY, cmd->exp);
 		break;
 
 	case CT_GET:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
-		res = nfct_query(cth, NFCT_Q_GET, tmpl.ct);
-		nfct_close(cth);
+		nfct_callback_register(glob_cth(), NFCT_T_ALL, dump_cb, cmd->ct);
+		res = nfct_query(cth, NFCT_Q_GET, cmd->ct);
 		break;
 
 	case EXP_GET:
-		nfexp_set_attr(tmpl.exp, ATTR_EXP_MASTER, tmpl.ct);
+		nfexp_set_attr(cmd->exp, ATTR_EXP_MASTER, cmd->ct);
 
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_GET, tmpl.exp);
-		nfct_close(cth);
+		nfexp_callback_register(glob_exh(), NFCT_T_ALL, dump_exp_cb, cmd);
+		res = nfexp_query(exh, NFCT_Q_GET, cmd->exp);
 		break;
 
 	case CT_FLUSH:
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &family);
-		nfct_close(cth);
+		res = nfct_query(glob_cth(), NFCT_Q_FLUSH_FILTER, &cmd->family);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
 
 	case EXP_FLUSH:
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfexp_query(cth, NFCT_Q_FLUSH, &family);
-		nfct_close(cth);
+		res = nfexp_query(glob_exh(), NFCT_Q_FLUSH, &cmd->family);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"expectation table has been emptied.\n");
 		break;
 
 	case CT_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
-			if (event_mask & CT_EVENT_F_NEW)
+			if (cmd->event_mask & CT_EVENT_F_NEW)
 				nl_events |= NF_NETLINK_CONNTRACK_NEW;
-			if (event_mask & CT_EVENT_F_UPD)
+			if (cmd->event_mask & CT_EVENT_F_UPD)
 				nl_events |= NF_NETLINK_CONNTRACK_UPDATE;
-			if (event_mask & CT_EVENT_F_DEL)
+			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
 			res = nfct_mnl_socket_open(nl_events);
@@ -3138,29 +3296,29 @@ int main(int argc, char *argv[])
 		}
 
 		if (res < 0)
-			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
+			exit_error(OTHER_PROBLEM, cmd, "Can't open netlink socket");
 
-		if (options & CT_OPT_BUFFERSIZE) {
-			socklen_t socklen = sizeof(socketbuffersize);
+		if (cmd->options & CT_OPT_BUFFERSIZE) {
+			socklen_t socklen = sizeof(cmd->socketbuffersize);
 
 			res = setsockopt(mnl_socket_get_fd(sock.mnl),
 					 SOL_SOCKET, SO_RCVBUFFORCE,
-					 &socketbuffersize,
-					 sizeof(socketbuffersize));
+					 &cmd->socketbuffersize,
+					 sizeof(cmd->socketbuffersize));
 			if (res < 0) {
 				setsockopt(mnl_socket_get_fd(sock.mnl),
 					   SOL_SOCKET, SO_RCVBUF,
-					   &socketbuffersize,
-					   socketbuffersize);
+					   &cmd->socketbuffersize,
+					   cmd->socketbuffersize);
 			}
 			getsockopt(mnl_socket_get_fd(sock.mnl), SOL_SOCKET,
-				   SO_RCVBUF, &socketbuffersize, &socklen);
+				   SO_RCVBUF, &cmd->socketbuffersize, &socklen);
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
 					"has been set to %zu bytes.\n",
-					socketbuffersize);
+					cmd->socketbuffersize);
 		}
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd);
 
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
@@ -3180,42 +3338,43 @@ int main(int argc, char *argv[])
 						"conntrack(8) manpage.\n");
 					continue;
 				}
-				exit_error(OTHER_PROBLEM,
+				exit_error(OTHER_PROBLEM, cmd,
 					   "failed to received netlink event: %s",
 					   strerror(errno));
 				break;
 			}
-			res = mnl_cb_run(buf, res, 0, 0, event_cb, tmpl.ct);
+			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
 		mnl_socket_close(sock.mnl);
 		break;
 
 	case EXP_EVENT:
-		if (options & CT_OPT_EVENT_MASK) {
+		if (cmd->options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
-			if (event_mask & CT_EVENT_F_NEW)
+			if (cmd->event_mask & CT_EVENT_F_NEW)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_NEW;
-			if (event_mask & CT_EVENT_F_UPD)
+			if (cmd->event_mask & CT_EVENT_F_UPD)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_UPDATE;
-			if (event_mask & CT_EVENT_F_DEL)
+			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_DESTROY;
 
-			cth = nfct_open(CONNTRACK, nl_events);
+			evh = nfct_open(CONNTRACK, nl_events);
 		} else {
-			cth = nfct_open(EXPECT,
+			evh = nfct_open(EXPECT,
 					NF_NETLINK_CONNTRACK_EXP_NEW |
 					NF_NETLINK_CONNTRACK_EXP_UPDATE |
 					NF_NETLINK_CONNTRACK_EXP_DESTROY);
 		}
 
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (!evh)
+			exit_error(OTHER_PROBLEM, cmd, "Can't open handler");
 		signal(SIGINT, exp_event_sighandler);
 		signal(SIGTERM, exp_event_sighandler);
-		nfexp_callback_register(cth, NFCT_T_ALL, event_exp_cb, NULL);
-		res = nfexp_catch(cth);
-		nfct_close(cth);
+		nfexp_callback_register(evh, NFCT_T_ALL, event_exp_cb, cmd);
+		res = nfexp_catch(evh);
+		nfct_close(evh);
+		evh = NULL;
 		break;
 	case CT_COUNT:
 		/* If we fail with netlink, fall back to /proc to ensure
@@ -3241,11 +3400,11 @@ try_proc_count:
 		int count;
 		fd = fopen(NF_CONNTRACK_COUNT_PROC, "r");
 		if (fd == NULL) {
-			exit_error(OTHER_PROBLEM, "Can't open %s",
+			exit_error(OTHER_PROBLEM, cmd, "Can't open %s",
 				   NF_CONNTRACK_COUNT_PROC);
 		}
 		if (fscanf(fd, "%d", &count) != 1) {
-			exit_error(OTHER_PROBLEM, "Can't read %s",
+			exit_error(OTHER_PROBLEM, cmd, "Can't read %s",
 				   NF_CONNTRACK_COUNT_PROC);
 		}
 		fclose(fd);
@@ -3253,14 +3412,9 @@ try_proc_count:
 		break;
 	}
 	case EXP_COUNT:
-		cth = nfct_open(EXPECT, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
-		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
-		nfct_close(cth);
-		printf("%d\n", counter);
+		nfexp_callback_register(glob_exh(), NFCT_T_ALL, count_exp_cb, cmd);
+		res = nfexp_query(exh, NFCT_Q_DUMP, &cmd->family);
+		printf("%d\n", cmd_counters[cmd->cmd_bit]);
 		break;
 	case CT_STATS:
 		/* If we fail with netlink, fall back to /proc to ensure
@@ -3269,7 +3423,7 @@ try_proc_count:
 		if (nfct_mnl_socket_open(0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_dump(cmd, NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
 				    nfct_stats_cb, AF_UNSPEC);
 
@@ -3288,7 +3442,7 @@ try_proc_count:
 		if (nfct_mnl_socket_open(0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
+		res = nfct_mnl_dump(cmd, NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
 				    nfexp_stats_cb, AF_UNSPEC);
 
@@ -3299,36 +3453,150 @@ try_proc_count:
 			break;
 try_proc:
 		if (display_proc_conntrack_stats() < 0)
-			exit_error(OTHER_PROBLEM, "Can't open /proc interface");
+			exit_error(OTHER_PROBLEM, cmd, "Can't open /proc interface");
 		break;
 	case CT_VERSION:
 		printf("%s v%s (conntrack-tools)\n", PROGNAME, VERSION);
 		break;
 	case CT_HELP:
-		usage(argv[0]);
-		if (options & CT_OPT_PROTO)
-			extension_help(h, protonum);
+		usage();
+		if (cmd->options & CT_OPT_PROTO)
+			extension_help(h, cmd->protonum);
 		break;
 	default:
-		usage(argv[0]);
+		usage();
 		break;
 	}
 
 	if (res < 0)
-		exit_error(OTHER_PROBLEM, "Operation failed: %s",
-			   err2str(errno, command));
+		exit_error(OTHER_PROBLEM, cmd, "Operation failed: %s",
+			   err2str(errno, cmd->command));
 
-	free_tmpl_objects();
-	free_options();
-	if (labelmap)
-		nfct_labelmap_destroy(labelmap);
+	/* reset globals */
+	nfct_filter_reset();
+}
 
-	if (command && exit_msg[cmd][0]) {
-		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
-		fprintf(stderr, exit_msg[cmd], counter);
-		if (counter == 0 && !(command & (CT_LIST | EXP_LIST)))
-			return EXIT_FAILURE;
+static void ct_cmd_list_gen_command(struct ct_cmd_list *list,
+		int argc, char *argv[],
+		const char *file_name, unsigned int line_number)
+{
+	ct_cmd_list_add(list, ct_cmd_create(argc, argv,
+			file_name, line_number));
+}
+
+static void ct_cmd_list_process_file(struct ct_cmd_list *list,
+		const char *file_name)
+{
+	int res, argc;
+	char **argv;
+	int orig_optind;
+	FILE *opts_file = NULL;
+	unsigned int line_number;
+	char **argv_buf = NULL, *getline_buf = NULL;
+	size_t argv_buf_size = 0, getline_buf_size = 0;
+
+	/*
+	 * we need to preserve the optind, because
+	 * nested argument processing will change it
+	 * while we need to be sure the caller is not affected
+	 */
+	orig_optind = optind;
+
+	if (!strcmp(file_name, "-"))
+		file_name = "/dev/stdin";
+
+	opts_file = fopen(file_name,"r");
+	if (!opts_file)
+		exit_error(PARAMETER_PROBLEM, NULL,
+					   "Failed to open file %s for reading", file_name);
+
+	for (line_number = 1;
+		(res = getline(&getline_buf, &getline_buf_size, opts_file)) >= 0;
+		line_number++) {
+		if (!res)
+			continue;
+		argc = line_to_argcv(getline_buf, &argv_buf, &argv_buf_size);
+		if (!argc)
+			continue;
+		argv = argv_buf;
+
+		ct_cmd_list_gen_command(list, argc, argv,
+				file_name, line_number);
+	}
+
+	fclose(opts_file);
+
+	free(argv_buf);
+	free(getline_buf);
+
+	optind = orig_optind;
+}
+
+static bool try_load_file_mode(struct ct_cmd_list *list, int argc, char *argv[])
+{
+	int c, load_file_mode = 0;
+
+	optind = 0;
+
+	while ((c = getopt_long(argc, argv,
+			load_file_getopt_str, load_file_opts, NULL)) != -1) {
+		switch(c) {
+		case 'R':
+			load_file_mode = 1;
+			ct_cmd_list_process_file(list, optarg);
+			break;
+		case ':':
+			exit_error(PARAMETER_PROBLEM, NULL,
+					   "option `%s' requires an "
+					   "argument", argv[optind-1]);
+		case '?':
+			if (!load_file_mode)
+				return false;
+			exit_error(PARAMETER_PROBLEM, NULL,
+			   "unknown option `%s' for load-file arg number %d",
+			   argv[optind-1], optind-1);
+		default:
+			exit_error(PARAMETER_PROBLEM, NULL,
+			   "unexpected behavior `%d' %d", c, optind);
+		}
 	}
+	return load_file_mode;
+}
+
+static void ct_cmd_list_gen_commands(struct ct_cmd_list *list,
+		int argc, char *argv[])
+{
+	if (try_load_file_mode(list, argc, argv))
+		return;
+	ct_cmd_list_gen_command(list, argc, argv, NULL, 0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ct_cmd_list cmds;
+
+	register_tcp();
+	register_udp();
+	register_udplite();
+	register_sctp();
+	register_dccp();
+	register_icmp();
+	register_icmpv6();
+	register_gre();
+	register_unknown();
+
+	ct_cmd_list_init(&cmds);
+
+	/* disable explicit missing arguments error output from getopt_long */
+	opterr = 0;
+
+	programm = argv[0];
+
+	ct_cmd_list_gen_commands(&cmds, argc, argv);
+
+	ct_cmd_list_apply(&cmds);
+
+	glob_cleanup();
 
-	return EXIT_SUCCESS;
+	return print_cmd_counters();
 }
-- 
2.25.1

