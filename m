Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B4C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E5EC604AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhHBJNA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJNA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 05:13:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BE0C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 02:12:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mAU09-0002dO-9I; Mon, 02 Aug 2021 11:12:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools 3/4] conntrack: enable kernel-based status filtering with -L -u STATUS
Date:   Mon,  2 Aug 2021 11:12:30 +0200
Message-Id: <20210802091231.1486-4-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802091231.1486-1-fw@strlen.de>
References: <20210802091231.1486-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This change is backwards compatible:

Old kernels do not recognize CTA_STATUS_MASK attribute and will
ignore it (no filtering in kernel).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 59 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 987a52140633..cc564a2b4b1b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -92,6 +92,10 @@ struct ct_tmpl {
 	struct nfct_filter_dump_mark filter_mark_kernel;
 	bool filter_mark_kernel_set;
 
+	/* Allow to filter by status from kernel-space. */
+	struct nfct_filter_dump_mark filter_status_kernel;
+	bool filter_status_kernel_set;
+
 	/* Allows filtering by ctlabels */
 	struct nfct_bitmask *label;
 
@@ -1146,7 +1150,7 @@ static struct parse_parameter {
 };
 
 static int
-do_parse_parameter(const char *str, size_t str_length, unsigned int *value, 
+do_parse_parameter(const char *str, size_t str_length, unsigned int *value,
 		   int parse_type)
 {
 	size_t i;
@@ -1171,7 +1175,7 @@ do_parse_parameter(const char *str, size_t str_length, unsigned int *value,
 			ret = 1;
 			break;
 		}
-	
+
 	return ret;
 }
 
@@ -1192,6 +1196,41 @@ parse_parameter(const char *arg, unsigned int *status, int parse_type)
 		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
 }
 
+static void
+parse_parameter_mask(const char *arg, unsigned int *status, unsigned int *mask, int parse_type)
+{
+	unsigned int *value;
+	const char *comma;
+	bool negated;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg)
+			exit_error(PARAMETER_PROBLEM,"Bad parameter `%s'", arg);
+
+		negated = *arg == '!';
+		if (negated)
+			arg++;
+		if (comma == arg)
+			exit_error(PARAMETER_PROBLEM,"Bad parameter `%s'", arg);
+
+		value = negated ? mask : status;
+
+		if (!do_parse_parameter(arg, comma-arg, value, parse_type))
+			exit_error(PARAMETER_PROBLEM,"Bad parameter `%s'", arg);
+		arg = comma+1;
+	}
+
+	negated = *arg == '!';
+	if (negated)
+		arg++;
+	value = negated ? mask : status;
+
+	if (strlen(arg) == 0
+	    || !do_parse_parameter(arg, strlen(arg),
+		    value, parse_type))
+		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
+}
+
 static void
 parse_u32_mask(const char *arg, struct u32_mask *m)
 {
@@ -2914,8 +2953,16 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 			break;
 		case 'u':
 			options |= CT_OPT_STATUS;
-			parse_parameter(optarg, &status, PARSE_STATUS);
+			parse_parameter_mask(optarg, &status,
+					    &tmpl->filter_status_kernel.mask,
+					    PARSE_STATUS);
 			nfct_set_attr_u32(tmpl->ct, ATTR_STATUS, status);
+			if (tmpl->filter_status_kernel.mask == 0)
+				tmpl->filter_status_kernel.mask = status;
+
+			tmpl->mark.value = status;
+			tmpl->filter_status_kernel.val = tmpl->mark.value;
+			tmpl->filter_status_kernel_set = true;
 			break;
 		case 'e':
 			options |= CT_OPT_EVENT_MASK;
@@ -3171,7 +3218,11 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
 					     cmd->family);
-
+		if (cmd->tmpl.filter_status_kernel_set) {
+			nfct_filter_dump_set_attr(filter_dump,
+						  NFCT_FILTER_DUMP_STATUS,
+						  &cmd->tmpl.filter_status_kernel);
+		}
 		if (cmd->options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
 					filter_dump);
-- 
2.31.1

