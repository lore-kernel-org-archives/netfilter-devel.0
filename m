Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF4BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 16:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLOQSb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiLOQS2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 11:18:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B2A2EF05
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 08:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cFefFVj1DDd+cMdsnYIdLZrg5f1lXXqFtCnZhnUGqA8=; b=IPeU/mkhHgT0JcnxzkMajTE6nc
        TF7MQl79ACBihmnXpCoER4Sc58Rn+GrnF35QMGaoauyhIf0HG2y1nD7hcHSpJrZA5PNVWXKsn8l6W
        nLlOojkCQC/8DYigi2Dwyr8VA45FaXzkqR+G56EWhJKSfn3baZJV68SVcpXMPpP8npCvmHYfQC4R9
        4Wb7IqN5YDa0DnbPKiH32dsXkjyYzJ0KBmKKCYOClWxkH2ZSjpew3TBhnzcDFDnQIoqJQ7Gip5Mj8
        48GogiMisa+PzCN0SZ+ckWjuIiDAeIMfoCmoPOGdrH2pf3AwCfc5mb7d5BRXc6W82aG1XkPiTSVQ2
        AuUz5pXg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5qwE-0001vE-1J; Thu, 15 Dec 2022 17:18:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 4/4] nft: Make rule parsing errors fatal
Date:   Thu, 15 Dec 2022 17:17:56 +0100
Message-Id: <20221215161756.3463-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221215161756.3463-1-phil@nwl.cc>
References: <20221215161756.3463-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Finish parsing the rule, thereby printing all potential problems and
abort the program.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c13fc307e7a89..4a7b5406892c4 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1362,7 +1362,7 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_range(&ctx, expr);
 
 		if (ctx.errmsg) {
-			fprintf(stderr, "%s", ctx.errmsg);
+			fprintf(stderr, "Error: %s\n", ctx.errmsg);
 			ctx.errmsg = NULL;
 			ret = false;
 		}
@@ -1404,6 +1404,8 @@ bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 	if (!cs->jumpto)
 		cs->jumpto = "";
 
+	if (!ret)
+		xtables_error(VERSION_PROBLEM, "Parsing nftables rule failed");
 	return ret;
 }
 
-- 
2.38.0

