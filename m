Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3F1C54E94
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 12:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbjAZMYV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Jan 2023 07:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjAZMYV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2023 07:24:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E1D3BDB6
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2023 04:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZSYVVM4VrPa1QBR9pgc0HqCsSJIWszYJi+fjqKchSr4=; b=hcDb3dHbTbRV+yCoA+Ht7VWkiG
        LTZHRuX2dTG/j8qjX3BGoJpcbcWC7ZajgufHXkX7UkIQx9ZAk6hnwi8XSHkZJM7R/rDOBQR+DWpDv
        3joMgfYcCRzYxkvZdXNzs4lUdmRcjw2NmdxFvZtvOaOVchh5+tEUwzHExlnoB+Z4jQaVLun9aPz7z
        /tfxvaxKBUQxaCP6xSsaT3mfzViR/FWFC2kFh/J+w5Ocv0Vv+vnwj8IatAv0iVUJ7Mc1LhZbzNtkH
        9YQkyCPnVdIZe8IeTB4PwV3HakXHlS3ahKHPlFbn9DZg86aKKJuu/AMJPCTjmkBSL8Lb2Cv6Eqhpi
        +ZhHmWKA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pL1Ig-00056z-DG
        for netfilter-devel@vger.kernel.org; Thu, 26 Jan 2023 13:24:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/7] ebtables-translate: Use OPT_* from xshared.h
Date:   Thu, 26 Jan 2023 13:24:03 +0100
Message-Id: <20230126122406.23288-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230126122406.23288-1-phil@nwl.cc>
References: <20230126122406.23288-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as commit db420e268735e ("ebtables: Merge OPT_* flags with xshared
ones") but also introduce 'table_set' as a replacement for OPT_TABLE.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 4db10ae6706a1..49ae6f64a9741 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -68,19 +68,6 @@ static int parse_rule_number(const char *rule)
 /* Checks whether a command has already been specified */
 #define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
 
-#define OPT_COMMAND	0x01
-#define OPT_TABLE	0x02
-#define OPT_IN		0x04
-#define OPT_OUT		0x08
-#define OPT_JUMP	0x10
-#define OPT_PROTOCOL	0x20
-#define OPT_SOURCE	0x40
-#define OPT_DEST	0x80
-#define OPT_ZERO	0x100
-#define OPT_LOGICALIN	0x200
-#define OPT_LOGICALOUT	0x400
-#define OPT_COUNT	0x1000 /* This value is also defined in libebtc.c */
-
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
 extern struct option ebt_original_options[];
@@ -189,6 +176,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 	struct xt_cmd_parse p = {
 		.table          = *table,
         };
+	bool table_set = false;
 
 	/* prevent getopt to spoil our error reporting */
 	opterr = false;
@@ -299,13 +287,16 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Please put the -t option first");
-			ebt_check_option2(&flags, OPT_TABLE);
+			if (table_set)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Multiple use of same option not allowed");
 			if (strlen(optarg) > EBT_TABLE_MAXNAMELEN - 1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Table name length cannot exceed %d characters",
 					      EBT_TABLE_MAXNAMELEN - 1);
 			*table = optarg;
 			p.table = optarg;
+			table_set = true;
 			break;
 		case 'i': /* Input interface */
 		case 2  : /* Logical input interface */
@@ -323,7 +314,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				xtables_error(PARAMETER_PROBLEM,
 					      "Command and option do not match");
 			if (c == 'i') {
-				ebt_check_option2(&flags, OPT_IN);
+				ebt_check_option2(&flags, OPT_VIANAMEIN);
 				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
 						      "Use -i only in INPUT, FORWARD, PREROUTING and BROUTING chains");
@@ -343,7 +334,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				ebtables_parse_interface(optarg, cs.eb.logical_in);
 				break;
 			} else if (c == 'o') {
-				ebt_check_option2(&flags, OPT_OUT);
+				ebt_check_option2(&flags, OPT_VIANAMEOUT);
 				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
 					xtables_error(PARAMETER_PROBLEM,
 						      "Use -o only in OUTPUT, FORWARD and POSTROUTING chains");
@@ -378,7 +369,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				cs.eb.bitmask |= EBT_SOURCEMAC;
 				break;
 			} else if (c == 'd') {
-				ebt_check_option2(&flags, OPT_DEST);
+				ebt_check_option2(&flags, OPT_DESTINATION);
 				if (ebt_check_inverse2(optarg, argc, argv))
 					cs.eb.invflags |= EBT_IDEST;
 
@@ -389,7 +380,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 				cs.eb.bitmask |= EBT_DESTMAC;
 				break;
 			} else if (c == 'c') {
-				ebt_check_option2(&flags, OPT_COUNT);
+				ebt_check_option2(&flags, OPT_COUNTERS);
 				if (ebt_check_inverse2(optarg, argc, argv))
 					xtables_error(PARAMETER_PROBLEM,
 						      "Unexpected '!' after -c");
-- 
2.38.0

