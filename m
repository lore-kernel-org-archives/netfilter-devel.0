Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E928C3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 09:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D832064A
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 09:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="rhb3+3+Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfHPJZ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 05:25:29 -0400
Received: from mx1.riseup.net ([198.252.153.129]:34350 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfHPJZ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 05:25:28 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 264611A0D11
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 02:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1565947528; bh=xVG8uwG6vghyosVIHhD2SAWXad6H4OPILXJbX2cPOF4=;
        h=From:To:Subject:Date:From;
        b=rhb3+3+Z+E861hxGMgEHazY9u0YOgO0Dqrjycfbi3HTdSkUW7/RM3Qy3JtIWI7t6h
         95D8iSPq1y/mtpnlepR6VxbAdVfapTsmhRiFUKBU1KoCHXp4feaROaNUGlCBGE03Tq
         ORyhLGnq8CXciSpAPq+JL8sN6H+6WRNRXtZ5hPzY=
X-Riseup-User-ID: 31604DCD94E9A518CFA0542E0053F3D65F7F4DA7A214CCE987E4EBDCDB0DA1D6
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 50790120390
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 02:25:27 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools] src: fix strncpy -Wstringop-truncation warnings
Date:   Fri, 16 Aug 2019 11:25:11 +0200
Message-Id: <20190816092511.830-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

-Wstringop-truncation warning was introduced in GCC-8 as truncation
checker for strncpy and strncat.

Systems using gcc version >= 8 would receive the following warnings:

read_config_yy.c: In function ‘yyparse’:
read_config_yy.y:1594:2: warning: ‘strncpy’ specified bound 16 equals destination size [-Wstringop-truncation]
 1594 |  strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_config_yy.y:1384:2: warning: ‘strncpy’ specified bound 256 equals destination size [-Wstringop-truncation]
 1384 |  strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_config_yy.y:692:2: warning: ‘strncpy’ specified bound 108 equals destination size [-Wstringop-truncation]
  692 |  strncpy(conf.local.path, $2, UNIX_PATH_MAX);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_config_yy.y:169:2: warning: ‘strncpy’ specified bound 256 equals destination size [-Wstringop-truncation]
  169 |  strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
read_config_yy.y:119:2: warning: ‘strncpy’ specified bound 256 equals destination size [-Wstringop-truncation]
  119 |  strncpy(conf.logfile, $2, FILENAME_MAXLEN);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

main.c: In function ‘main’:
main.c:168:5: warning: ‘strncpy’ specified bound 4096 equals destination size [-Wstringop-truncation]
  168 |     strncpy(config_file, argv[i], PATH_MAX);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix the issue by checking for string length first. Also using
snprintf instead.

In addition, correct an off-by-one when warning about maximum config
file path length.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 src/main.c           |  4 ++--
 src/read_config_yy.y | 35 +++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/src/main.c b/src/main.c
index 7062e12..d4fbbfa 100644
--- a/src/main.c
+++ b/src/main.c
@@ -165,13 +165,13 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			if (++i < argc) {
-				strncpy(config_file, argv[i], PATH_MAX);
 				if (strlen(argv[i]) >= PATH_MAX){
 					config_file[PATH_MAX-1]='\0';
 					dlog(LOG_WARNING, "Path to config file"
 					     " to long. Cutting it down to %d"
-					     " characters", PATH_MAX);
+					     " characters", PATH_MAX - 1);
 				}
+				snprintf(config_file, PATH_MAX, "%.*s", PATH_MAX - 1, argv[i]);
 				break;
 			}
 			show_usage(argv[0]);
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 4311cd6..696a86d 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -116,7 +116,12 @@ logfile_bool : T_LOG T_OFF
 
 logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) >= FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "Filename is longer than %u characters",
+		     FILENAME_MAXLEN - 1);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.logfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
 	free($2);
 };
 
@@ -166,7 +171,12 @@ syslog_facility : T_SYSLOG T_STRING
 
 lock : T_LOCK T_PATH_VAL
 {
-	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) >= FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "Filename is longer than %u characters",
+		     FILENAME_MAXLEN - 1);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.lockfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
 	free($2);
 };
 
@@ -689,13 +699,13 @@ unix_options:
 
 unix_option : T_PATH T_PATH_VAL
 {
-	strncpy(conf.local.path, $2, UNIX_PATH_MAX);
-	free($2);
-	if (conf.local.path[UNIX_PATH_MAX - 1]) {
+	if (strlen($2) >= UNIX_PATH_MAX) {
 		dlog(LOG_ERR, "UNIX Path is longer than %u characters",
 		     UNIX_PATH_MAX - 1);
 		exit(EXIT_FAILURE);
 	}
+	snprintf(conf.local.path, UNIX_PATH_MAX, "%.*s", UNIX_PATH_MAX - 1, $2);
+	free($2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
@@ -1381,7 +1391,12 @@ stat_logfile_bool : T_LOG T_OFF
 
 stat_logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) >= FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "Log file path is longer than %u characters",
+		     FILENAME_MAXLEN - 1);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%.*s", FILENAME_MAXLEN - 1, $2);
 	free($2);
 };
 
@@ -1589,11 +1604,15 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 		exit(EXIT_FAILURE);
 		break;
 	}
+	if (strlen($2) >= CTD_HELPER_NAME_LEN) {
+		dlog(LOG_ERR, "CTD helper name is longer than %u characters",
+		     CTD_HELPER_NAME_LEN - 1);
+		exit(EXIT_FAILURE);
+	}
 
 	policy = (struct ctd_helper_policy *) &e->data;
-	strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
+	snprintf(policy->name, CTD_HELPER_NAME_LEN, "%.*s", CTD_HELPER_NAME_LEN - 1, $2);
 	free($2);
-	policy->name[CTD_HELPER_NAME_LEN-1] = '\0';
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
 	stack_item_push(&symbol_stack, e);
-- 
2.23.0.rc1

