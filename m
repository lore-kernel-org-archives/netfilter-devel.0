From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH] iptables: Constify option struct
Date: Tue, 28 Mar 2017 00:40:15 +0530
Message-ID: <1490641815-12741-1-git-send-email-gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34789 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdC0TLC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 15:11:02 -0400
Received: by mail-pg0-f68.google.com with SMTP id o123so12446550pga.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 12:10:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct  of the type option is only used to initialise a field
inside the xtables_match struct and is not modified anywhere.
Done using Coccinelle:

@r1 disable optional_qualifier@
identifier s,i;
position p;
@@

static struct option i@p[] ={...};

@ok1@
identifier r1.i;
expression e;
position p;
@@
e = i@p

@bad@
position p != {r1.p,ok1.p};
identifier r1.i;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
static
+const
struct option i[] = { ... };

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/libebt_limit.c  | 2 +-
 extensions/libebt_mark.c   | 2 +-
 extensions/libebt_mark_m.c | 2 +-
 extensions/libebt_nflog.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libebt_limit.c b/extensions/libebt_limit.c
index 6b9bb16..988f678 100644
--- a/extensions/libebt_limit.c
+++ b/extensions/libebt_limit.c
@@ -29,7 +29,7 @@
 #define ARG_LIMIT		'1'
 #define ARG_LIMIT_BURST		'2'
 
-static struct option brlimit_opts[] =
+static const struct option brlimit_opts[] =
 {
 	{ .name = "limit",	.has_arg = true,	.val = ARG_LIMIT },
 	{ .name = "limit-burst",.has_arg = true,	.val = ARG_LIMIT_BURST },
diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index a1a208c..7b80b22 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -25,7 +25,7 @@ static int mark_supplied;
 #define MARK_ORMARK  '3'
 #define MARK_ANDMARK '4'
 #define MARK_XORMARK '5'
-static struct option brmark_opts[] = {
+static const struct option brmark_opts[] = {
 	{ .name = "mark-target",.has_arg = true,	.val = MARK_TARGET },
 	/* an oldtime messup, we should have always used the scheme
 	 * <extension-name>-<option> */
diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index ab9d234..eb08dba 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -18,7 +18,7 @@
 
 #define MARK '1'
 
-static struct option brmark_m_opts[] = {
+static const struct option brmark_m_opts[] = {
 	{ .name = "mark",	.has_arg = true, .val = MARK },
 	XT_GETOPT_TABLEEND,
 };
diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
index fef7196..5f1d13b 100644
--- a/extensions/libebt_nflog.c
+++ b/extensions/libebt_nflog.c
@@ -30,7 +30,7 @@ enum {
 	NFLOG_NFLOG	= 0x16,
 };
 
-static struct option brnflog_opts[] = {
+static const struct option brnflog_opts[] = {
 	{ .name = "nflog-group",     .has_arg = true,  .val = NFLOG_GROUP},
 	{ .name = "nflog-prefix",    .has_arg = true,  .val = NFLOG_PREFIX},
 	{ .name = "nflog-range",     .has_arg = true,  .val = NFLOG_RANGE},
-- 
2.7.4

