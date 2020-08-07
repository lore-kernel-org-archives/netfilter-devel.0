Return-Path: <SRS0=v7HC=BR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FD6C433E1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 14:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDE322CA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 14:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHGOvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 10:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgHGOvK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 10:51:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82304C061756
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Aug 2020 07:51:08 -0700 (PDT)
Received: from localhost ([::1]:60268 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k43i5-0007Cg-D7; Fri, 07 Aug 2020 16:51:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-monitor: Fix ip6tables rule printing
Date:   Fri,  7 Aug 2020 16:51:00 +0200
Message-Id: <20200807145100.21340-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When printing an ip6tables rule event, false family ops are used as they
are initially looked up for AF_INET and reused no matter the current
rule's family. In practice, this means that nft_rule_print_save() calls
the wrong rule_to_cs, save_rule and clear_cs callbacks. Therefore, if a
rule specifies a source or destination address, the address is not
printed.

Fix this by performing a family lookup each time rule_cb is called.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 57def83e2eea0..4008cc00d4694 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -93,6 +93,8 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	if (arg->nfproto && arg->nfproto != family)
 		goto err_free;
 
+	arg->h->ops = nft_family_ops_lookup(family);
+
 	if (arg->is_event)
 		printf(" EVENT: ");
 	switch (family) {
-- 
2.27.0

