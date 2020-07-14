Return-Path: <SRS0=S2pA=AZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0210C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B37852242B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgGNQ4G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgGNQ4G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 12:56:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E77C061755
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2020 09:56:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jvODs-0001LP-Ho; Tue, 14 Jul 2020 18:56:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] monitor: print "dormant" flag in monitor mode
Date:   Tue, 14 Jul 2020 18:55:57 +0200
Message-Id: <20200714165558.14733-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This distinction is important: a table with this flag is inert -- all
base chains are unregistered and see no traffic.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/monitor.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/monitor.c b/src/monitor.c
index bb269c02950c..3872ebcfbdaf 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -214,6 +214,10 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 
 		nft_mon_print(monh, "%s %s", family2str(t->handle.family),
 			      t->handle.table.name);
+
+		if (t->flags & TABLE_F_DORMANT)
+			nft_mon_print(monh, " { flags dormant; }");
+
 		if (nft_output_handle(&monh->ctx->nft->output))
 			nft_mon_print(monh, " # handle %" PRIu64 "",
 				      t->handle.handle.id);
-- 
2.26.2

