Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2EBC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jan 2022 15:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiAQPnA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 10:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240599AbiAQPm7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 10:42:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E27C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jan 2022 07:42:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n9U9p-0007GE-IN; Mon, 17 Jan 2022 16:42:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: fix compiler warnings
Date:   Mon, 17 Jan 2022 16:42:52 +0100
Message-Id: <20220117154252.13420-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

.... those do not indicate bugs, but they are distracting.

'exp_filter_add' at filter.c:513:2:
__builtin_strncpy specified bound 16 equals destination size [-Wstringop-truncation]
read_config_yy.y:1625: warning: '__builtin_snprintf' output may be truncated before the last format character [-Wformat-truncation=]
 1625 |         snprintf(policy->name, CTD_HELPER_NAME_LEN, "%s", $2);
read_config_yy.y:1399: warning: '__builtin_snprintf' output may be ...
 1399 |         snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%s", $2);
read_config_yy.y:707: warning: '__builtin_snprintf' output may be ...
  707 |         snprintf(conf.local.path, UNIX_PATH_MAX, "%s", $2);
read_config_yy.y:179: warning: '__builtin_snprintf' output may be ...
  179 |         snprintf(conf.lockfile, FILENAME_MAXLEN, "%s", $2);
read_config_yy.y:124: warning: '__builtin_snprintf' output may be ...
  124 |         snprintf(conf.logfile, FILENAME_MAXLEN, "%s", $2);

... its because the _MAXLEN constants are one less than the output
buffer size, i.e. could use either .._MAXLEN + 1 or sizeof, this uses
sizeof().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/filter.c         |  2 +-
 src/read_config_yy.y | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/filter.c b/src/filter.c
index 65771025308f..41f9bd793f03 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -510,7 +510,7 @@ int exp_filter_add(struct exp_filter *f, const char *helper_name)
 	if (item == NULL)
 		return -1;
 
-	strncpy(item->helper_name, helper_name, NFCT_HELPER_NAME_MAX);
+	strncpy(item->helper_name, helper_name, NFCT_HELPER_NAME_MAX - 1);
 	list_add(&item->head, &f->list);
 	return 0;
 }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 95845a19e768..070b349c5949 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -121,7 +121,7 @@ logfile_path : T_LOG T_PATH_VAL
 		     FILENAME_MAXLEN);
 		exit(EXIT_FAILURE);
 	}
-	snprintf(conf.logfile, FILENAME_MAXLEN, "%s", $2);
+	snprintf(conf.logfile, sizeof(conf.logfile), "%s", $2);
 	free($2);
 };
 
@@ -176,7 +176,7 @@ lock : T_LOCK T_PATH_VAL
 		     FILENAME_MAXLEN);
 		exit(EXIT_FAILURE);
 	}
-	snprintf(conf.lockfile, FILENAME_MAXLEN, "%s", $2);
+	snprintf(conf.lockfile, sizeof(conf.lockfile), "%s", $2);
 	free($2);
 };
 
@@ -704,7 +704,7 @@ unix_option : T_PATH T_PATH_VAL
 		     UNIX_PATH_MAX);
 		exit(EXIT_FAILURE);
 	}
-	snprintf(conf.local.path, UNIX_PATH_MAX, "%s", $2);
+	snprintf(conf.local.path, sizeof(conf.local.path), "%s", $2);
 	free($2);
 };
 
@@ -1396,7 +1396,7 @@ stat_logfile_path : T_LOG T_PATH_VAL
 		     FILENAME_MAXLEN);
 		exit(EXIT_FAILURE);
 	}
-	snprintf(conf.stats.logfile, FILENAME_MAXLEN, "%s", $2);
+	snprintf(conf.stats.logfile, sizeof(conf.stats.logfile), "%s", $2);
 	free($2);
 };
 
@@ -1622,7 +1622,7 @@ helper_type: T_HELPER_POLICY T_STRING '{' helper_policy_list '}'
 	}
 
 	policy = (struct ctd_helper_policy *) &e->data;
-	snprintf(policy->name, CTD_HELPER_NAME_LEN, "%s", $2);
+	snprintf(policy->name, sizeof(policy->name), "%s", $2);
 	free($2);
 	/* Now object is complete. */
 	e->type = SYMBOL_HELPER_POLICY_EXPECT_ROOT;
-- 
2.34.1

