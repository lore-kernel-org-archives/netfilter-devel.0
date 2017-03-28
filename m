From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 1/3] ebtables: extensions: Constify option struct
Date: Tue, 28 Mar 2017 16:57:49 +0530
Message-ID: <b962c022d3f076c8625b076aa31038341c122369.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35027 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755471AbdC1L2Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 07:28:16 -0400
Received: by mail-pg0-f68.google.com with SMTP id g2so20605334pge.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 04:28:15 -0700 (PDT)
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct  of the type option is only used to initialise a field
inside the ebt_u_watcher struct and is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/ebt_log.c   | 2 +-
 extensions/ebt_nflog.c | 2 +-
 extensions/ebt_ulog.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/ebt_log.c b/extensions/ebt_log.c
index 1cf831a..97d5091 100644
--- a/extensions/ebt_log.c
+++ b/extensions/ebt_log.c
@@ -61,7 +61,7 @@ static int name_to_loglevel(char* arg)
 #define LOG_IP     '4'
 #define LOG_LOG    '5'
 #define LOG_IP6    '6'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "log-prefix", required_argument, 0, LOG_PREFIX },
 	{ "log-level" , required_argument, 0, LOG_LEVEL  },
diff --git a/extensions/ebt_nflog.c b/extensions/ebt_nflog.c
index 0cd10e0..405673a 100644
--- a/extensions/ebt_nflog.c
+++ b/extensions/ebt_nflog.c
@@ -25,7 +25,7 @@ enum {
 	NFLOG_NFLOG = 0x16,
 };
 
-static struct option nflog_opts[] = {
+static const struct option nflog_opts[] = {
 	{"nflog-group", required_argument, NULL, NFLOG_GROUP},
 	{"nflog-prefix", required_argument, NULL, NFLOG_PREFIX},
 	{"nflog-range", required_argument, NULL, NFLOG_RANGE},
diff --git a/extensions/ebt_ulog.c b/extensions/ebt_ulog.c
index 162586d..54eec53 100644
--- a/extensions/ebt_ulog.c
+++ b/extensions/ebt_ulog.c
@@ -24,7 +24,7 @@
 #define ULOG_CPRANGE    '3'
 #define ULOG_QTHRESHOLD '4'
 #define ULOG_ULOG       '5'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "ulog-prefix"    , required_argument, 0, ULOG_PREFIX     },
 	{ "ulog-nlgroup"   , required_argument, 0, ULOG_NLGROUP    },
-- 
2.7.4

