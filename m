Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F39BC63797
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbjALSFL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240289AbjALSDq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22065D8A6
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j225oaoLvGYd0XmWeeph4DlU3FICwA+oDKMitQlYTMk=; b=dpGjREYs20GTBUx07UW6HdUeLV
        dNaD8HTyaHn+CTDF6LKah6XlBszZiMJK6+XlcHhMlo0o+U2zBRC9SuQyIS2y7YqMzkUJzV2B2+Kcz
        qkiAhz7GKkpXjQI8YAPtMceBNEKMEM+wa3x8gxlAgGWP/d60lrY6uWf4Co012eEycAw6boeis3m5X
        X2t638s5Z+2tTBImDs2i0pPOd104Mfbsm5NwEhk1nQnKc+MKPzmQ3zyeyvkqbQibBooycGQIC7Gk9
        kQXtnwvnIlftM4TLihI2SBl0g1CwvNIOsyHIDF22WW7Qoge17khTtJ9mS+t5HV7OVwSRCph40nXsq
        If6VFnlQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1Ng-0000DO-2X; Thu, 12 Jan 2023 18:28:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <psutter@redhat.com>
Subject: [nft PATCH 2/5] optimize: Do not return garbage from stack
Date:   Thu, 12 Jan 2023 18:28:20 +0100
Message-Id: <20230112172823.7298-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <psutter@redhat.com>

If input does not contain a single 'add' command (unusual, but
possible), 'ret' value was not initialized by nft_optimize() before
returning its value.

Fixes: fb298877ece27 ("src: add ruleset optimization infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/optimize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/optimize.c b/src/optimize.c
index 12cae00da4ab4..289c442dc915e 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1217,7 +1217,7 @@ static int cmd_optimize(struct nft_ctx *nft, struct cmd *cmd)
 int nft_optimize(struct nft_ctx *nft, struct list_head *cmds)
 {
 	struct cmd *cmd;
-	int ret;
+	int ret = 0;
 
 	list_for_each_entry(cmd, cmds, list) {
 		switch (cmd->op) {
-- 
2.38.0

