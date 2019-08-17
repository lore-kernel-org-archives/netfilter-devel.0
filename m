Return-Path: <SRS0=n2xU=WN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64D2C3A59B
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 10:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B046E20880
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Aug 2019 10:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfHQKQn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Aug 2019 06:16:43 -0400
Received: from correo.us.es ([193.147.175.20]:39754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfHQKQm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Aug 2019 06:16:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44B04EA467
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 12:16:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30A49D2CAD
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 12:16:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 26445DA72F; Sat, 17 Aug 2019 12:16:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B61C8DA4D0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 12:16:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 17 Aug 2019 12:16:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 952C6411FE81
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Aug 2019 12:16:33 +0200 (CEST)
Date:   Sat, 17 Aug 2019 12:16:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] src: fix strncpy -Wstringop-truncation
 warnings
Message-ID: <20190817101633.vb4tnautw5zffcru@salvia>
References: <20190816092511.830-1-guigom@riseup.net>
 <20190817010451.GA4911@dimstar.local.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jbephub7soi4ldjg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190817010451.GA4911@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jbephub7soi4ldjg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 17, 2019 at 11:04:51AM +1000, Duncan Roe wrote:
> On Fri, Aug 16, 2019 at 11:25:11AM +0200, Jose M. Guisado Gomez wrote:
[...]
> There is absolutely no need to change code to eliminate GCC warnings.
> 
> If you are satisfied that the code is good, put these lines near the start, e.g.
> before any #include lines:
> 
> > #pragma GCC diagnostic ignored "-Wpragmas"
> > #pragma GCC diagnostic ignored "-Wstringop-truncation"
> 
> The first pragma stops old GCC compilers warning about the unrecognised second
> pragma
> 
> The second pragma suppresses the new warning.

Thanks for the hint.

I like this patch because it makes configuration parser slightly more
robust, ie. it bails out in case path is too long rather than silent
truncation.

Probably this approach that I'm attaching is more simple, by adding
one extra byte to ensure there's room for the nul-termination.

--jbephub7soi4ldjg
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-src-fix-strncpy-Wstringop-truncation-warnings.patch"
Content-Transfer-Encoding: 8bit

From f196de88cdd9764ddc2e4de737a960972d82fe9d Mon Sep 17 00:00:00 2001
From: "Jose M. Guisado Gomez" <guigom@riseup.net>
Date: Fri, 16 Aug 2019 11:25:11 +0200
Subject: [PATCH] src: fix strncpy -Wstringop-truncation warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/conntrackd.h |  6 +++---
 include/helper.h     |  2 +-
 include/local.h      |  4 ++--
 src/main.c           |  7 +++----
 src/read_config_yy.y | 39 +++++++++++++++++++++++++++++----------
 5 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/include/conntrackd.h b/include/conntrackd.h
index 81dff221e96d..fe9ec1854a7d 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -85,9 +85,9 @@ union inet_address {
 #define CONFIG(x) conf.x
 
 struct ct_conf {
-	char logfile[FILENAME_MAXLEN];
+	char logfile[FILENAME_MAXLEN + 1];
 	int syslog_facility;
-	char lockfile[FILENAME_MAXLEN];
+	char lockfile[FILENAME_MAXLEN + 1];
 	int hashsize;			/* hashtable size */
 	int channel_num;
 	int channel_default;
@@ -132,7 +132,7 @@ struct ct_conf {
 		int prio;
 	} sched;
 	struct {
-		char logfile[FILENAME_MAXLEN];
+		char logfile[FILENAME_MAXLEN + 1];
 		int syslog_facility;
 		size_t buffer_size;
 	} stats;
diff --git a/include/helper.h b/include/helper.h
index d15c1c62c053..d5406674cb13 100644
--- a/include/helper.h
+++ b/include/helper.h
@@ -13,7 +13,7 @@ struct pkt_buff;
 #define CTD_HELPER_POLICY_MAX	4
 
 struct ctd_helper_policy {
-	char		name[CTD_HELPER_NAME_LEN];
+	char		name[CTD_HELPER_NAME_LEN + 1];
 	uint32_t	expect_timeout;
 	uint32_t	expect_max;
 };
diff --git a/include/local.h b/include/local.h
index 22859d7ab60a..9379446732ee 100644
--- a/include/local.h
+++ b/include/local.h
@@ -7,12 +7,12 @@
 
 struct local_conf {
 	int reuseaddr;
-	char path[UNIX_PATH_MAX];
+	char path[UNIX_PATH_MAX + 1];
 };
 
 struct local_server {
 	int fd;
-	char path[UNIX_PATH_MAX];
+	char path[UNIX_PATH_MAX + 1];
 };
 
 /* callback return values */
diff --git a/src/main.c b/src/main.c
index 7062e12085f1..31e0eed950b4 100644
--- a/src/main.c
+++ b/src/main.c
@@ -120,8 +120,8 @@ do_chdir(const char *d)
 
 int main(int argc, char *argv[])
 {
+	char config_file[PATH_MAX + 1] = {};
 	int ret, i, action = -1;
-	char config_file[PATH_MAX] = {};
 	int type = 0;
 	struct utsname u;
 	int version, major, minor;
@@ -165,13 +165,12 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			if (++i < argc) {
-				strncpy(config_file, argv[i], PATH_MAX);
-				if (strlen(argv[i]) >= PATH_MAX){
-					config_file[PATH_MAX-1]='\0';
+				if (strlen(argv[i]) > PATH_MAX) {
 					dlog(LOG_WARNING, "Path to config file"
 					     " to long. Cutting it down to %d"
 					     " characters", PATH_MAX);
 				}
+				snprintf(config_file, PATH_MAX, "%s", argv[i]);
 				break;
 			}
 			show_usage(argv[0]);
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 4311cd6c9a2f..a4aa7f57bdef 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -116,7 +116,12 @@ logfile_bool : T_LOG T_OFF
 
 logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.logfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) > FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "LogFile path is longer than %u characters",
+		     FILENAME_MAXLEN);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.logfile, FILENAME_MAXLEN, "%s", $2);
 	free($2);
 };
 
@@ -166,7 +171,12 @@ syslog_facility : T_SYSLOG T_STRING
 
 lock : T_LOCK T_PATH_VAL
 {
-	strncpy(conf.lockfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) > FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "LockFile path is longer than %u characters",
+		     FILENAME_MAXLEN);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.lockfile, FILENAME_MAXLEN, "%s", $2);
 	free($2);
 };
 
@@ -689,13 +699,13 @@ unix_options:
 
 unix_option : T_PATH T_PATH_VAL
 {
-	strncpy(conf.local.path, $2, UNIX_PATH_MAX);
-	free($2);
-	if (conf.local.path[UNIX_PATH_MAX - 1]) {
-		dlog(LOG_ERR, "UNIX Path is longer than %u characters",
-		     UNIX_PATH_MAX - 1);
+	if (strlen($2) > UNIX_PATH_MAX) {
+		dlog(LOG_ERR, "Path is longer than %u characters",
+		     UNIX_PATH_MAX);
 		exit(EXIT_FAILURE);
 	}
+	snprintf(conf.local.path, UNIX_PATH_MAX, "%s", $2);
+	free($2);
 };
 
 unix_option : T_BACKLOG T_NUMBER
@@ -1381,7 +1391,12 @@ stat_logfile_bool : T_LOG T_OFF
 
 stat_logfile_path : T_LOG T_PATH_VAL
 {
-	strncpy(conf.stats.logfile, $2, FILENAME_MAXLEN);
+	if (strlen($2) > FILENAME_MAXLEN) {
+		dlog(LOG_ERR, "stats LogFile path is longer than %u characters",
+		     FILENAME_MAXLEN);
+		exit(EXIT_FAILURE);
+	}
+	snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%s", $2);
 	free($2);
 };
 
@@ -1589,11 +1604,15 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 		exit(EXIT_FAILURE);
 		break;
 	}
+	if (strlen($2) > CTD_HELPER_NAME_LEN) {
+		dlog(LOG_ERR, "Helper Policy is longer than %u characters",
+		     CTD_HELPER_NAME_LEN);
+		exit(EXIT_FAILURE);
+	}
 
 	policy = (struct ctd_helper_policy *) &e->data;
-	strncpy(policy->name, $2, CTD_HELPER_NAME_LEN);
+	snprintf(policy->name, CTD_HELPER_NAME_LEN, "%s", $2);
 	free($2);
-	policy->name[CTD_HELPER_NAME_LEN-1] = '\0';
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
 	stack_item_push(&symbol_stack, e);
-- 
2.11.0


--jbephub7soi4ldjg--
