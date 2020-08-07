Return-Path: <SRS0=v7HC=BR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D691EC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B78582075D
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgHGMCa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgHGMC3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 08:02:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4AEC061575
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2020 05:02:27 -0700 (PDT)
Received: from localhost ([::1]:59778 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k414q-0004Zb-4R; Fri, 07 Aug 2020 14:02:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 1/2] nft: Fix command name in ip6tables error message
Date:   Fri,  7 Aug 2020 14:02:13 +0200
Message-Id: <20200807120214.3762-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Upon errors, ip6tables-nft would prefix its error messages with
'iptables:' instead of 'ip6tables:'. Turns out the command name was
hard-coded, use 'progname' variable instead.
While being at it, merge the two mostly identical fprintf() calls into
one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Added this fix. Related test ignored the prefix value, so this went
  unnoticed.
---
 iptables/xtables-standalone.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index dd6fb7919d2e1..7b71db62f1ea6 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -75,14 +75,10 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 	xtables_fini();
 
 	if (!ret) {
-		if (errno == EINVAL) {
-			fprintf(stderr, "iptables: %s. "
-					"Run `dmesg' for more information.\n",
-				nft_strerror(errno));
-		} else {
-			fprintf(stderr, "iptables: %s.\n",
-				nft_strerror(errno));
-		}
+		fprintf(stderr, "%s: %s.%s\n", progname, nft_strerror(errno),
+			(errno == EINVAL ?
+			 " Run `dmesg' for more information." : ""));
+
 		if (errno == EAGAIN)
 			exit(RESOURCE_PROBLEM);
 	}
-- 
2.27.0

