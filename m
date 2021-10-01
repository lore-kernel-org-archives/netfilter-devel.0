Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382C2C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1EF619F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355189AbhJARrY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E438C06177D
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=64STmJf6oBXBeftc8t2ERVuWNqZ3ShHvBTMiDn6hAH8=; b=X+bFOUvS9puY0YFPZG/CV/88K0
        EbaJ9/YblfKa0pXNZTVaMPHfAbXMFiU5wvKYF7RqMpEaLKopK+5IewORxTjlppfl28rlHsf6WQhIW
        6qiKDdldNS+/7bPz17uwL4p8WetasifW17kzccTBn65USpptzB8+LJ0K+wl7WaXvFPlk5W4MSlbdG
        BrpNGElC0LsAc404syCsRxzkfFThvuzUI3fnBlPG66aKk8q64IhWnUll6H8mZZskViRMNQtgabKHg
        gp3Bu2p9kEUTqq07Od5FeysQBqtgAqagZ21uNeHLjlPROaAC6N+zLaPcE3o7vHOoRIY9TCfzEqQ3u
        kTaSGbWQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbF-002RLP-MT; Fri, 01 Oct 2021 18:45:33 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 1/8] nft: fix indentation error.
Date:   Fri,  1 Oct 2021 18:41:35 +0100
Message-Id: <20211001174142.1267726-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`add_action` was indented with 7 spaces.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index dc1f5160eb98..5613bc968046 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1320,27 +1320,27 @@ int add_verdict(struct nftnl_rule *r, int verdict)
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs,
 	       bool goto_set)
 {
-       int ret = 0;
-
-       /* If no target at all, add nothing (default to continue) */
-       if (cs->target != NULL) {
-	       /* Standard target? */
-	       if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
-		       ret = add_verdict(r, NF_ACCEPT);
-	       else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
-		       ret = add_verdict(r, NF_DROP);
-	       else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
-		       ret = add_verdict(r, NFT_RETURN);
-	       else
-		       ret = add_target(r, cs->target->t);
-       } else if (strlen(cs->jumpto) > 0) {
-	       /* Not standard, then it's a go / jump to chain */
-	       if (goto_set)
-		       ret = add_jumpto(r, cs->jumpto, NFT_GOTO);
-	       else
-		       ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
-       }
-       return ret;
+	int ret = 0;
+
+	/* If no target at all, add nothing (default to continue) */
+	if (cs->target != NULL) {
+		/* Standard target? */
+		if (strcmp(cs->jumpto, XTC_LABEL_ACCEPT) == 0)
+			ret = add_verdict(r, NF_ACCEPT);
+		else if (strcmp(cs->jumpto, XTC_LABEL_DROP) == 0)
+			ret = add_verdict(r, NF_DROP);
+		else if (strcmp(cs->jumpto, XTC_LABEL_RETURN) == 0)
+			ret = add_verdict(r, NFT_RETURN);
+		else
+			ret = add_target(r, cs->target->t);
+	} else if (strlen(cs->jumpto) > 0) {
+		/* Not standard, then it's a go / jump to chain */
+		if (goto_set)
+			ret = add_jumpto(r, cs->jumpto, NFT_GOTO);
+		else
+			ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
+	}
+	return ret;
 }
 
 static void nft_rule_print_debug(struct nftnl_rule *r, struct nlmsghdr *nlh)
-- 
2.33.0

