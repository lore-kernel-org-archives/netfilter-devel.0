Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B02C04AA6
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7F5205ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfD3MIC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 08:08:02 -0400
Received: from mail.us.es ([193.147.175.20]:36976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfD3MIB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 08:08:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DC26B11FBE3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:07:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE216DA703
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:07:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C3C26DA708; Tue, 30 Apr 2019 14:07:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A2BFDA705
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:07:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 14:07:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5DB1C4265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:07:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2] xshared: check for maximum buffer length in add_param_to_argv()
Date:   Tue, 30 Apr 2019 14:07:54 +0200
Message-Id: <20190430120754.17453-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if we go over the boundary, based on patch from Sebastian.

Reported-by: Sebastian Neef <contact@0day.work>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use xt_param_buf instead of xt_param, there's already a xt_params
    object.

 iptables/xshared.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index fb186fb1ac65..36a2ec5f193d 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -433,10 +433,24 @@ void save_argv(void)
 	}
 }
 
+struct xt_param_buf {
+	char	buffer[1024];
+	int 	len;
+};
+
+static void add_param(struct xt_param_buf *param, const char *curchar)
+{
+	param->buffer[param->len++] = *curchar;
+	if (param->len >= sizeof(param->buffer))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Parameter too long!");
+}
+
 void add_param_to_argv(char *parsestart, int line)
 {
-	int quote_open = 0, escaped = 0, param_len = 0;
-	char param_buffer[1024], *curchar;
+	int quote_open = 0, escaped = 0;
+	struct xt_param_buf param = {};
+	char *curchar;
 
 	/* After fighting with strtok enough, here's now
 	 * a 'real' parser. According to Rusty I'm now no
@@ -445,7 +459,7 @@ void add_param_to_argv(char *parsestart, int line)
 	for (curchar = parsestart; *curchar; curchar++) {
 		if (quote_open) {
 			if (escaped) {
-				param_buffer[param_len++] = *curchar;
+				add_param(&param, curchar);
 				escaped = 0;
 				continue;
 			} else if (*curchar == '\\') {
@@ -455,7 +469,7 @@ void add_param_to_argv(char *parsestart, int line)
 				quote_open = 0;
 				*curchar = '"';
 			} else {
-				param_buffer[param_len++] = *curchar;
+				add_param(&param, curchar);
 				continue;
 			}
 		} else {
@@ -471,36 +485,32 @@ void add_param_to_argv(char *parsestart, int line)
 		case ' ':
 		case '\t':
 		case '\n':
-			if (!param_len) {
+			if (!param.len) {
 				/* two spaces? */
 				continue;
 			}
 			break;
 		default:
 			/* regular character, copy to buffer */
-			param_buffer[param_len++] = *curchar;
-
-			if (param_len >= sizeof(param_buffer))
-				xtables_error(PARAMETER_PROBLEM,
-					      "Parameter too long!");
+			add_param(&param, curchar);
 			continue;
 		}
 
-		param_buffer[param_len] = '\0';
+		param.buffer[param.len] = '\0';
 
 		/* check if table name specified */
-		if ((param_buffer[0] == '-' &&
-		     param_buffer[1] != '-' &&
-		     strchr(param_buffer, 't')) ||
-		    (!strncmp(param_buffer, "--t", 3) &&
-		     !strncmp(param_buffer, "--table", strlen(param_buffer)))) {
+		if ((param.buffer[0] == '-' &&
+		     param.buffer[1] != '-' &&
+		     strchr(param.buffer, 't')) ||
+		    (!strncmp(param.buffer, "--t", 3) &&
+		     !strncmp(param.buffer, "--table", strlen(param.buffer)))) {
 			xtables_error(PARAMETER_PROBLEM,
 				      "The -t option (seen in line %u) cannot be used in %s.\n",
 				      line, xt_params->program_name);
 		}
 
-		add_argv(param_buffer, 0);
-		param_len = 0;
+		add_argv(param.buffer, 0);
+		param.len = 0;
 	}
 }
 
-- 
2.11.0

