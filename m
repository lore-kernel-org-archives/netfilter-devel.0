Return-Path: <SRS0=paBM=CS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A666DC10DAA
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 15:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE9422240
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 15:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIL3b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Sep 2020 07:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgIIL3O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Sep 2020 07:29:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753ABC061796
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 04:29:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kFyHi-0002LP-2e; Wed, 09 Sep 2020 13:29:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: proc: rename stat column
Date:   Wed,  9 Sep 2020 13:29:01 +0200
Message-Id: <20200909112901.27879-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Rename 'searched' column to 'clashres' (same len).

conntrack(8) using the old /proc interface (ctnetlink not available) shows:

cpu=0  entries=4784 clashres=2292 [..]

Another alternative is to add another column, but this increases the
number of always-0 columns.

Fixes: bc92470413f3af1 ("netfilter: conntrack: add clash resolution stat counter")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_standalone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ff39740797d..46c5557c1fec 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -428,14 +428,14 @@ static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
-		seq_puts(seq, "entries  searched found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
+		seq_puts(seq, "entries  clashres found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
 		return 0;
 	}
 
 	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
 			"%08x %08x %08x %08x %08x  %08x %08x %08x %08x\n",
 		   nr_conntracks,
-		   st->clash_resolve, /* was: searched */
+		   st->clash_resolve,
 		   st->found,
 		   0,
 		   st->invalid,
-- 
2.26.2

