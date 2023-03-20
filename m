Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB87EC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Mar 2023 13:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjCTNrN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Mar 2023 09:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCTNrM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2023 09:47:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8A1B9
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Mar 2023 06:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VaBS80Gx/T1yWBnQxR12AgKW/cPmr2h1dkZZjaAVr2o=; b=D/btImrJnX/dqVqs6uwJ06KtpS
        iahg3rHzRiBJVwmtl/nOUxT6dq5uYT5IzQwF3cc7N5PWM46ynveMar2hZzRJJJKYmNjd6kw6O4eAd
        fz85yoJfZObpJZF5q9cjlpzPKR8rrHFlXFhN/+DqgUymXkh0+zNOR+21Of1iAQljSF+618H9Dx0NB
        WolUlVr7wH2ZhDPO5bwREM2nI3pHKN3W4RGTnyyr9Da3B3Gu2g8lLUhbVU2dgVGm0eWKdHA/D6cvS
        l3XNi91nO8abVw0UxZ3U5kMxhs3CjXoVTdUUpCvWnNFOdIXJdKawRmUdsjA64NrUgB7ULNTQbQHj9
        deciodRA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1peFqt-0006zV-W2; Mon, 20 Mar 2023 14:47:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] Avoid a memleak with 'reset rules' command
Date:   Mon, 20 Mar 2023 14:46:59 +0100
Message-Id: <20230320134659.13731-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230320134659.13731-1-phil@nwl.cc>
References: <20230320134659.13731-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Like other 'reset' commands, 'reset rules' also lists the (part of the)
ruleset which was affected to give users a chance to store the zeroed
values. Therefore do_command_reset() calls do_command_list(). This in
turn calls do_list_ruleset() for CMD_OBJ_RULES which wasn't prepared for
values stored in cmd->handle other than a possible family value and thus
freely reused the pointers as scratch area for the do_list_table() call
whiich in the past fetched each table's data directly from kernel.

Meanwhile ruleset listing code has been integrated into the common
caching logic, the 'cmd' pointer became unused by do_list_table(). The
temporary cmd->handle manipulation is not needed anymore, dropping it
prevents a memleak caused by overwriting of allocated table name
pointer.

Fixes: 1694df2de79f3 ("Implement 'reset rule' and 'reset rules' commands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index fadd7670d97a2..06042239c8437 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2184,15 +2184,10 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 		    table->handle.family != family)
 			continue;
 
-		cmd->handle.family = table->handle.family;
-		cmd->handle.table.name = table->handle.table.name;
-
 		if (do_list_table(ctx, table) < 0)
 			return -1;
 	}
 
-	cmd->handle.table.name = NULL;
-
 	return 0;
 }
 
-- 
2.38.0

