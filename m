Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F90C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A94B20881
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 13:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfEWNnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 09:43:55 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48838 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729698AbfEWNnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 09:43:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hTo0e-0007ju-U7; Thu, 23 May 2019 15:43:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/8] netfilter: xt_HL: prefer skb_ensure_writable
Date:   Thu, 23 May 2019 15:44:10 +0200
Message-Id: <20190523134412.3295-7-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523134412.3295-1-fw@strlen.de>
References: <20190523134412.3295-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also, make the argument to be only the needed size of the header
we're altering, no need to pull in the full packet into linear area.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_HL.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
index 4653b071bed4..a37b8824221f 100644
--- a/net/netfilter/xt_HL.c
+++ b/net/netfilter/xt_HL.c
@@ -32,7 +32,7 @@ ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ipt_TTL_info *info = par->targinfo;
 	int new_ttl;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, sizeof(*iph)))
 		return NF_DROP;
 
 	iph = ip_hdr(skb);
@@ -72,7 +72,7 @@ hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct ip6t_HL_info *info = par->targinfo;
 	int new_hl;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
 	ip6h = ipv6_hdr(skb);
-- 
2.21.0

