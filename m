Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49DDC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 09:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE2B610A4
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhIQJ5z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhIQJ5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 05:57:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5611AC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Sep 2021 02:56:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mRAbe-00013h-Jf; Fri, 17 Sep 2021 11:56:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, youling 257 <youling257@gmail.com>
Subject: [PATCH nf] netfilter: iptable_raw: drop bogus net_init annotation
Date:   Fri, 17 Sep 2021 11:56:25 +0200
Message-Id: <20210917095625.1338-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a leftover from the times when this function was wired up via
pernet_operations.  Now its called when userspace asks for the table.

With CONFIG_NET_NS=n, iptable_raw_table_init memory has been discarded
already and we get a kernel crash.

Other tables are fine, __net_init annotation was removed already.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: youling 257 <youling257@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/iptable_raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index b88e0f36cd05..8265c6765705 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -42,7 +42,7 @@ iptable_raw_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
-static int __net_init iptable_raw_table_init(struct net *net)
+static int iptable_raw_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	const struct xt_table *table = &packet_raw;
-- 
2.32.0

