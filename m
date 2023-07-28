Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B17C0015E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 12:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbjG1McK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbjG1McJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 08:32:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4BB211D
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 05:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Em0uHW4Ldk3cLoNwOZczfccqkMMqkVW/ybpDJFo9fLA=; b=fZ8GbN/C5fpryY6IWV8/jFemae
        gO7S44UfrOQwcd219J6gXAzFKa6wmJ9NjtcXvdDyejFQX8hwGbxOws6yZlApP995gYq6qaLMtKx55
        PA+fMi0Kc9VE2b20O4Oj7kTlO7hRUk303bqidEOKWf573qz6xZ6MOwLu9Op7ohf4sQzUjt3wgrm2n
        tF70lgYVBNLTF+7m2EEO4jYJuVKTjnj5TYq3wxvN95u4UbjmVNKoQlnMgD4r6/w9BgmZ70O/TXlJf
        5Vq4F6KK+pp9AC9f0YT7TMqoYpbkUwyfDTJabm/ike5BJYnqkMEjSMduaZScaI7WVky74NAggLv+6
        VN5UVxdg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qPMdV-0006Bs-VX
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 14:32:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] *tables-restore: Enforce correct counters syntax if present
Date:   Fri, 28 Jul 2023 14:31:44 +0200
Message-Id: <20230728123147.15750-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If '--counters' option was not given, restore parsers would ignore
anything following the policy word. Make them more strict, rejecting
anything in that spot which does not look like counter values even if
not restoring counters.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.c                   | 20 +++++++++----------
 .../ipt-restore/0008-restore-counters_0       |  7 +++++++
 iptables/xtables-restore.c                    | 18 ++++++++---------
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 6f7ddf93b01bb..f11b2dc2fd316 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -283,23 +283,21 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 					      xt_params->program_name, line);
 
 			if (strcmp(policy, "-") != 0) {
+				char *ctrs = strtok(NULL, " \t\n");
 				struct xt_counters count = {};
 
-				if (counters) {
-					char *ctrs;
-					ctrs = strtok(NULL, " \t\n");
-
-					if (!ctrs || !parse_counters(ctrs, &count))
-						xtables_error(PARAMETER_PROBLEM,
-							      "invalid policy counters for chain '%s'",
-							      chain);
-				}
+				if ((!ctrs && counters) ||
+				    (ctrs && !parse_counters(ctrs, &count)))
+					xtables_error(PARAMETER_PROBLEM,
+						      "invalid policy counters for chain '%s'",
+						      chain);
 
 				DEBUGP("Setting policy of chain %s to %s\n",
 					chain, policy);
 
-				if (!cb->ops->set_policy(chain, policy, &count,
-						     handle))
+				if (!cb->ops->set_policy(chain, policy,
+							 counters ? &count : NULL,
+							 handle))
 					xtables_error(OTHER_PROBLEM,
 						      "Can't set policy `%s' on `%s' line %u: %s",
 						      policy, chain, line,
diff --git a/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0 b/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0
index 5ac70682b76bf..854768c96e0da 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0008-restore-counters_0
@@ -20,3 +20,10 @@ EXPECT=":foo - [0:0]
 
 $XT_MULTI iptables-restore --counters <<< "$DUMP"
 diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save --counters | grep foo)
+
+# if present, counters must be in proper format
+! $XT_MULTI iptables-restore <<EOF
+*filter
+:FORWARD ACCEPT bar
+COMMIT
+EOF
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index abe56374289f4..23cd349819f4f 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -166,19 +166,17 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 				      xt_params->program_name, line);
 
 		if (nft_chain_builtin_find(state->curtable, chain)) {
-			if (counters) {
-				char *ctrs;
-				ctrs = strtok(NULL, " \t\n");
+			char *ctrs = strtok(NULL, " \t\n");
 
-				if (!ctrs || !parse_counters(ctrs, &count))
-					xtables_error(PARAMETER_PROBLEM,
-						      "invalid policy counters for chain '%s'",
-						      chain);
-
-			}
+			if ((!ctrs && counters) ||
+			    (ctrs && !parse_counters(ctrs, &count)))
+				xtables_error(PARAMETER_PROBLEM,
+					      "invalid policy counters for chain '%s'",
+					      chain);
 			if (cb->chain_set &&
 			    cb->chain_set(h, state->curtable->name,
-					  chain, policy, &count) < 0) {
+					  chain, policy,
+					  counters ? &count : NULL) < 0) {
 				xtables_error(OTHER_PROBLEM,
 					      "Can't set policy `%s' on `%s' line %u: %s",
 					      policy, chain, line,
-- 
2.40.0

