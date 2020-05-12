Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D82CA90AF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE842206B8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgELRKe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 13:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELRKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 13:10:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F88C061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 10:10:34 -0700 (PDT)
Received: from localhost ([::1]:45480 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jYYQK-00026F-Qj; Tue, 12 May 2020 19:10:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] libxt_SECMARK: Fix for failing target comparison
Date:   Tue, 12 May 2020 19:10:18 +0200
Message-Id: <20200512171018.16871-4-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200512171018.16871-1-phil@nwl.cc>
References: <20200512171018.16871-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel fills in structxt_secmark_target_info->secid, so when the
rule is received from kernel it won't match a newly created one. This
prevented delete by rulespec and check commands.

Make use of newly introduced matchmask callback to prepare a mask which
explicitly excludes the secid field.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_SECMARK.c | 10 ++++++++++
 extensions/libxt_SECMARK.t |  4 ++++
 2 files changed, 14 insertions(+)
 create mode 100644 extensions/libxt_SECMARK.t

diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 6ba8606355daa..e9fd133642f00 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
 #include <stdio.h>
+#include <string.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_SECMARK.h>
 
@@ -68,6 +69,14 @@ static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 	print_secmark(info);
 }
 
+static void SECMARK_matchmask(void *mask)
+{
+	struct xt_secmark_target_info *info = mask;
+
+	memset(mask, 0xFF, XT_ALIGN(sizeof(struct xt_secmark_target_info)));
+	info->secid = 0;
+}
+
 static struct xtables_target secmark_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "SECMARK",
@@ -80,6 +89,7 @@ static struct xtables_target secmark_target = {
 	.save		= SECMARK_save,
 	.x6_parse	= SECMARK_parse,
 	.x6_options	= SECMARK_opts,
+	.matchmask	= SECMARK_matchmask,
 };
 
 void _init(void)
diff --git a/extensions/libxt_SECMARK.t b/extensions/libxt_SECMARK.t
new file mode 100644
index 0000000000000..39d4c09348bf4
--- /dev/null
+++ b/extensions/libxt_SECMARK.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+*security
+-j SECMARK --selctx system_u:object_r:firewalld_exec_t:s0;=;OK
+-j SECMARK;;FAIL
-- 
2.25.1

