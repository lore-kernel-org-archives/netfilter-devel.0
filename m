Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58214C47082
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD44610FA
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 16:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhE2QzM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 May 2021 12:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhE2QzM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 May 2021 12:55:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF01BC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 29 May 2021 09:53:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ln2DO-0000nk-A5; Sat, 29 May 2021 18:53:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: fix clang-12 fmt string warnings
Date:   Sat, 29 May 2021 18:53:25 +0200
Message-Id: <20210529165325.150196-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_h323_main.c:198:6: warning: format specifies type 'unsigned short' but
xt_AUDIT.c:121:9: warning: format specifies type 'unsigned char' but the argument has type 'int' [-Wformat]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_h323_main.c | 2 +-
 net/netfilter/xt_AUDIT.c               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index aafaff00baf1..2eb31ffb3d14 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -194,7 +194,7 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 		if (tcpdatalen == 4) {	/* Separate TPKT header */
 			/* Netmeeting sends TPKT header and data separately */
 			pr_debug("nf_ct_h323: separate TPKT header indicates "
-				 "there will be TPKT data of %hu bytes\n",
+				 "there will be TPKT data of %d bytes\n",
 				 tpktlen - 4);
 			info->tpkt_len[dir] = tpktlen - 4;
 			return 0;
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 9cdc16b0d0d8..b6a015aee0ce 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -117,7 +117,7 @@ static int audit_tg_check(const struct xt_tgchk_param *par)
 	const struct xt_audit_info *info = par->targinfo;
 
 	if (info->type > XT_AUDIT_TYPE_MAX) {
-		pr_info_ratelimited("Audit type out of range (valid range: 0..%hhu)\n",
+		pr_info_ratelimited("Audit type out of range (valid range: 0..%u)\n",
 				    XT_AUDIT_TYPE_MAX);
 		return -ERANGE;
 	}
-- 
2.31.1

