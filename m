Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1F7C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0347D613BC
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 17:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhEDRDk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 May 2021 13:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhEDRDj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 May 2021 13:03:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3258C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  4 May 2021 10:02:44 -0700 (PDT)
Received: from localhost ([::1]:42904 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1ldyRX-0008DJ-Ip; Tue, 04 May 2021 19:02:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] extensions: sctp: Fix nftables translation
Date:   Tue,  4 May 2021 19:02:33 +0200
Message-Id: <20210504170234.25400-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If both sport and dport was present, incorrect nft syntax was generated.

Fixes: defc7bd2bac89 ("extensions: libxt_sctp: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_sctp.c      | 10 ++++------
 extensions/libxt_sctp.txlate | 10 +++++-----
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 140de2653b1ef..ee4e99ebf11bf 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -495,15 +495,13 @@ static int sctp_xlate(struct xt_xlate *xl,
 	if (!einfo->flags)
 		return 0;
 
-	xt_xlate_add(xl, "sctp ");
-
 	if (einfo->flags & XT_SCTP_SRC_PORTS) {
 		if (einfo->spts[0] != einfo->spts[1])
-			xt_xlate_add(xl, "sport%s %u-%u",
+			xt_xlate_add(xl, "sctp sport%s %u-%u",
 				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0], einfo->spts[1]);
 		else
-			xt_xlate_add(xl, "sport%s %u",
+			xt_xlate_add(xl, "sctp sport%s %u",
 				     einfo->invflags & XT_SCTP_SRC_PORTS ? " !=" : "",
 				     einfo->spts[0]);
 		space = " ";
@@ -511,11 +509,11 @@ static int sctp_xlate(struct xt_xlate *xl,
 
 	if (einfo->flags & XT_SCTP_DEST_PORTS) {
 		if (einfo->dpts[0] != einfo->dpts[1])
-			xt_xlate_add(xl, "%sdport%s %u-%u", space,
+			xt_xlate_add(xl, "%ssctp dport%s %u-%u", space,
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0], einfo->dpts[1]);
 		else
-			xt_xlate_add(xl, "%sdport%s %u", space,
+			xt_xlate_add(xl, "%ssctp dport%s %u", space,
 				     einfo->invflags & XT_SCTP_DEST_PORTS ? " !=" : "",
 				     einfo->dpts[0]);
 	}
diff --git a/extensions/libxt_sctp.txlate b/extensions/libxt_sctp.txlate
index 72f4641ab021c..0d6c59e183675 100644
--- a/extensions/libxt_sctp.txlate
+++ b/extensions/libxt_sctp.txlate
@@ -23,16 +23,16 @@ iptables-translate -A INPUT -p sctp ! --dport 50:56 -j ACCEPT
 nft add rule ip filter INPUT sctp dport != 50-56 counter accept
 
 iptables-translate -A INPUT -p sctp --dport 80 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 dport 80 counter accept
+nft add rule ip filter INPUT sctp sport 50 sctp dport 80 counter accept
 
 iptables-translate -A INPUT -p sctp --dport 80:100 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 dport 80-100 counter accept
+nft add rule ip filter INPUT sctp sport 50 sctp dport 80-100 counter accept
 
 iptables-translate -A INPUT -p sctp --dport 80 --sport 50:55 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50-55 dport 80 counter accept
+nft add rule ip filter INPUT sctp sport 50-55 sctp dport 80 counter accept
 
 iptables-translate -A INPUT -p sctp ! --dport 80:100 --sport 50 -j ACCEPT
-nft add rule ip filter INPUT sctp sport 50 dport != 80-100 counter accept
+nft add rule ip filter INPUT sctp sport 50 sctp dport != 80-100 counter accept
 
 iptables-translate -A INPUT -p sctp --dport 80 ! --sport 50:55 -j ACCEPT
-nft add rule ip filter INPUT sctp sport != 50-55 dport 80 counter accept
+nft add rule ip filter INPUT sctp sport != 50-55 sctp dport 80 counter accept
-- 
2.31.0

