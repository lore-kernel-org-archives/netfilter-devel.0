Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE8BC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 22:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6520561212
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Sep 2021 22:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbhIXWNN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:13:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49780 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345517AbhIXWNE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 18:13:04 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2CEDB63EBC;
        Sat, 25 Sep 2021 00:10:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 13/15] netfilter: iptable_raw: drop bogus net_init annotation
Date:   Sat, 25 Sep 2021 00:11:11 +0200
Message-Id: <20210924221113.348767-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is a leftover from the times when this function was wired up via
pernet_operations.  Now its called when userspace asks for the table.

With CONFIG_NET_NS=n, iptable_raw_table_init memory has been discarded
already and we get a kernel crash.

Other tables are fine, __net_init annotation was removed already.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: youling 257 <youling257@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

