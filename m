Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40DEC6FA83
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Sep 2022 16:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiIFQBc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Sep 2022 12:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiIFQBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2022 12:01:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00E28F97F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Sep 2022 08:20:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVaNg-0004CI-5p; Tue, 06 Sep 2022 17:20:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: nat: avoid long-running port range loop
Date:   Tue,  6 Sep 2022 17:20:36 +0200
Message-Id: <20220906152036.27394-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906152036.27394-1-fw@strlen.de>
References: <netfilter-devel>
 <20220906152036.27394-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Looping a large port range takes too long. Instead select a random
offset within [ntohs(exp->saved_proto.tcp.port), 65535] and try 128
ports.

This is a rehash of an erlier patch to do the same, but generalized
to handle other helpers as well.

Link: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210920204439.13179-2-Cole.Dishington@alliedtelesis.co.nz/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_helper.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 067d6d6f6b7d..a95a25196943 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -201,8 +201,18 @@ EXPORT_SYMBOL(nf_nat_follow_master);
 
 u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port)
 {
+	static const unsigned int max_attempts = 128;
+	int range, attempts_left;
+	u16 min = port;
+
+	range = USHRT_MAX - port;
+	attempts_left = range;
+
+	if (attempts_left > max_attempts)
+		attempts_left = max_attempts;
+
 	/* Try to get same port: if not, try to change it. */
-	for (; port != 0; port++) {
+	for (;;) {
 		int res;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
@@ -210,8 +220,10 @@ u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port)
 		if (res == 0)
 			return port;
 
-		if (res != -EBUSY)
+		if (res != -EBUSY || (--attempts_left < 0))
 			break;
+
+		port = min + prandom_u32_max(range);
 	}
 
 	return 0;
-- 
2.35.1

