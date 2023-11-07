Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B97BC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 18:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjKGSZK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 13:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbjKGSZJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 13:25:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C08120
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 10:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fxC3bYvSLztNu65ApIpxEBZ+ZRHoDRXCgkijvI/Og68=; b=GnkLFVEZWEATSZ5bf5GR9bR2o5
        QVM/tGdYIfShpGCDGw1sbtUYQDNu5RiXaaGE4WhrPTLsZUe0MHWD//lnWnYPJiKdcSmp75MV+zqse
        JgnxrpPAgeNpUm13hgiWMbF5yVBYh08pr/ujMYSgWTMUUva0m1IwdsTf2mxPeGoh3xi1DtsTfCq94
        ep1QjDHugta3h8tUhnd1coC9ccwvoA8bDBJhzt534sgrFp7wOv21sPsj68mx4ZozJ5klKkm2Ae+pG
        DRe/BiHDXBFmYjPyCGKj5p61zOmhZUrthOVx4OpBHxVtRVOXxb92ZYfoBIPtknIV+ilcv72b2Zjx3
        4Bquq5AA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r0Ql6-00060F-6D; Tue, 07 Nov 2023 19:25:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Garver <eric@garver.life>
Subject: [iptables PATCH] ebtables: Fix corner-case noflush restore bug
Date:   Tue,  7 Nov 2023 19:25:00 +0100
Message-ID: <20231107182500.29432-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Report came from firwalld, but this is actually rather hard to trigger.
Since a regular chain line prevents it, typical dump/restore use-cases
are unaffected.

Fixes: 73611d5582e72 ("ebtables-nft: add broute table emulation")
Cc: Eric Garver <eric@garver.life>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/ebtables/0009-broute-bug_0      | 25 +++++++++++++++++++
 iptables/xtables-eb.c                         |  2 ++
 2 files changed, 27 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0009-broute-bug_0

diff --git a/iptables/tests/shell/testcases/ebtables/0009-broute-bug_0 b/iptables/tests/shell/testcases/ebtables/0009-broute-bug_0
new file mode 100755
index 0000000000000..0def0ac58e7be
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0009-broute-bug_0
@@ -0,0 +1,25 @@
+#!/bin/sh
+#
+# Missing BROUTING-awareness in ebt_get_current_chain() caused an odd caching bug when restoring:
+# - with --noflush
+# - a second table after the broute one
+# - A policy command but no chain line for BROUTING chain
+
+set -e
+
+case "$XT_MULTI" in
+*xtables-nft-multi)
+	;;
+*)
+	echo "skip $XT_MULTI"
+	exit 0
+	;;
+esac
+
+$XT_MULTI ebtables-restore --noflush <<EOF
+*broute
+-P BROUTING ACCEPT
+*nat
+-P PREROUTING ACCEPT
+COMMIT
+EOF
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 08eec79d80400..a8ad57c735cc5 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -169,6 +169,8 @@ int ebt_get_current_chain(const char *chain)
 		return NF_BR_LOCAL_OUT;
 	else if (strcmp(chain, "POSTROUTING") == 0)
 		return NF_BR_POST_ROUTING;
+	else if (strcmp(chain, "BROUTING") == 0)
+		return NF_BR_BROUTING;
 
 	/* placeholder for user defined chain */
 	return NF_BR_NUMHOOKS;
-- 
2.41.0

