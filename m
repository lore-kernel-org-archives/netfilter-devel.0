Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EEAC001B0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 11:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjHILTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 07:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbjHILTK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 07:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAC719A1;
        Wed,  9 Aug 2023 04:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F42631AC;
        Wed,  9 Aug 2023 11:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78023C433C8;
        Wed,  9 Aug 2023 11:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691579948;
        bh=8L/TvAryEMTfA6i07lOCF+U37J9ixVgJfRQIS/3uIRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcHJdIlp/cak4weaqHlQcgF0AXFsHllDKiJ8ecyNYRSNSqovJDUhFkbIKElZF/oBU
         r0kJRP7cO1WO0VhmW15zJGuiHPoA/sgk1aA6hEZI5xKArE8jhVe5fWzvK5pAHJ1+0q
         EzP3T49xUk/jIXA/0ENVNWAnTvaD8gges9glhwH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 133/323] netfilter: nf_tables: fix scheduling-while-atomic splat
Date:   Wed,  9 Aug 2023 12:39:31 +0200
Message-ID: <20230809103704.216917829@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ 2024439bd5ceb145eeeb428b2a59e9b905153ac3 ]

nf_tables_check_loops() can be called from rhashtable list
walk so cond_resched() cannot be used here.

Fixes: 81ea01066741 ("netfilter: nf_tables: add rescheduling points during loop detection walks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7021,13 +7021,9 @@ static int nf_tables_check_loops(const s
 				break;
 			}
 		}
-
-		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
-		cond_resched();
-
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||


