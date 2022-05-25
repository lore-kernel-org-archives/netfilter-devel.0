Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E42C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 09:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiEYJ5d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 05:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiEYJ5c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 05:57:32 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A139E50E0B
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 02:57:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1653472647; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Nx2pmq0CYH4XYUBrgGguNm6hKXsuCDq+wdLrixcuTDn+TB+5XeQStyp4v9pGkmMpK9X55JLAaQsthnad+inrhIChHjK3TYQUci0zZu4Gx4S0jhmn025fjHKl8gD/inG9lNGUz2lKrCwgM96HyTJ5sR+kaVt7IOxxOuByyfRzp90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1653472647; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=rLFbkUnodImhY+GijZfb8XuJA4WQuHsT3p3cM0Tyasc=; 
        b=ACIgueZqWeXLSvExT37wu4DuX1n0A61SpqjsnxL/y6a15Q0HssLLE2wJWht2Y1VGaqeG4zL7HAFC/VVCfQTH4uXQfv6ok1bcUmbzHT64W5kH/yGAft1C5aBmV60FKg3o1uI8uPib4HrBT8z3zpvFSGz/OJkkiJcZqKb56z9svj4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=chandergovind.org;
        spf=pass  smtp.mailfrom=mail@chandergovind.org;
        dmarc=pass header.from=<mail@chandergovind.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653472647;
        s=zoho; d=chandergovind.org; i=mail@chandergovind.org;
        h=Message-ID:Date:Date:MIME-Version:To:To:From:From:Subject:Subject:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=rLFbkUnodImhY+GijZfb8XuJA4WQuHsT3p3cM0Tyasc=;
        b=I69u+aIu6+tWKYQW4/4WHPjQ/sYtuMCep3JdwDeG1Bd66avVS7K9diVTI08wPExw
        8J4/k4ZskKSjVuTti/zcOSMn+9oouCYjJxf8kbIXqAoh+rogT08qXDQKGksLhKrnIsv
        HAmEJpc65CbqgaUThQXuaEJpWgArPfZEQI9xKgD8=
Received: from [192.168.1.38] (103.195.203.231 [103.195.203.231]) by mx.zohomail.com
        with SMTPS id 1653472645717114.5406472672131; Wed, 25 May 2022 02:57:25 -0700 (PDT)
Message-ID: <9e9387c5-7416-3325-32c0-49b21b95b21e@chandergovind.org>
Date:   Wed, 25 May 2022 15:25:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
From:   Chander Govindarajan <mail@chandergovind.org>
Subject: [PATCH] nft: simplify chain lookup in do_list_chain
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

use the chain_cache_find function for faster lookup of chain instead of
iterating over all chains in table

Signed-off-by: ChanderG <mail@chandergovind.org>
---
  src/rule.c | 8 ++------
  1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 799092eb..7f61bdc1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2309,13 +2309,9 @@ static int do_list_chain(struct netlink_ctx *ctx, 
struct cmd *cmd,

  	table_print_declaration(table, &ctx->nft->output);

-	list_for_each_entry(chain, &table->chain_cache.list, cache.list) {
-		if (chain->handle.family != cmd->handle.family ||
-		    strcmp(cmd->handle.chain.name, chain->handle.chain.name) != 0)
-			continue;
-
+	chain = chain_cache_find(table, cmd->handle.chain.name);
+	if (chain)
  		chain_print(chain, &ctx->nft->output);
-	}

  	nft_print(&ctx->nft->output, "}\n");

-- 
2.27.0
