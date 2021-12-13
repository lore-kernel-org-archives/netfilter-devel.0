Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1DD5C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Dec 2021 18:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhLMSIA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 13:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbhLMSH7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 13:07:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF1EC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Dec 2021 10:07:59 -0800 (PST)
Received: from localhost ([::1]:58954 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mwpjw-0004HX-5Z; Mon, 13 Dec 2021 19:07:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 6/6] iptables-*-restore: Drop pointless line reference
Date:   Mon, 13 Dec 2021 19:07:47 +0100
Message-Id: <20211213180747.20707-7-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213180747.20707-1-phil@nwl.cc>
References: <20211213180747.20707-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There's no need to mention the offending line number in error message
when calling xtables_error() with a status of PARAMETER_PROBLEM as that
will cause a call to xtables_exit_tryhelp() which in turn prints "Error
occurred at line: N".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c  | 4 ++--
 iptables/iptables.c   | 4 ++--
 iptables/xtables-eb.c | 4 ++--
 iptables/xtables.c    | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c7d2377906e0c..80b3e86accb43 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1013,8 +1013,8 @@ int do_command6(int argc, char *argv[], char **table,
 					   "unexpected ! flag before --table");
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option (seen in line %u) cannot be used in %s.\n",
-					      line, xt_params->program_name);
+					      "The -t option cannot be used in %s.\n",
+					      xt_params->program_name);
 			*table = optarg;
 			table_set = true;
 			break;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index cc17f8d4e5ce7..eabd35e278025 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -995,8 +995,8 @@ int do_command4(int argc, char *argv[], char **table,
 					   "unexpected ! flag before --table");
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option (seen in line %u) cannot be used in %s.\n",
-					      line, xt_params->program_name);
+					      "The -t option cannot be used in %s.\n",
+					      xt_params->program_name);
 			*table = optarg;
 			table_set = true;
 			break;
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 5ac122971c644..382b108ed0fc7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -895,8 +895,8 @@ print_zero:
 			ebt_check_option2(&flags, OPT_TABLE);
 			if (restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option (seen in line %u) cannot be used in %s.\n",
-					      line, xt_params->program_name);
+					      "The -t option cannot be used in %s.\n",
+					      xt_params->program_name);
 			if (!nft_table_builtin_find(h, optarg))
 				xtables_error(VERSION_PROBLEM,
 					      "table '%s' does not exist",
diff --git a/iptables/xtables.c b/iptables/xtables.c
index adf03b9348bd3..85f7664d7ac1c 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -513,8 +513,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					   "unexpected ! flag before --table");
 			if (p->restore && table_set)
 				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option (seen in line %u) cannot be used in %s.\n",
-					      line, xt_params->program_name);
+					      "The -t option cannot be used in %s.\n",
+					      xt_params->program_name);
 			if (!nft_table_builtin_find(h, optarg))
 				xtables_error(VERSION_PROBLEM,
 					      "table '%s' does not exist",
-- 
2.33.0

