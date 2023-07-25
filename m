Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146BBC41513
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jul 2023 11:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbjGYL0t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbjGYL0p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2023 07:26:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F1DE76;
        Tue, 25 Jul 2023 04:26:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA7B61648;
        Tue, 25 Jul 2023 11:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1ADC433C8;
        Tue, 25 Jul 2023 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690284400;
        bh=0nTn+APEI1It+1x0qO7kmSRYY9Il4Enobp52ARqWkwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDbOgtCaWYu3YZcq7HbScyTjuKzMuQ9jmALx7d4OdO+1qXs/6aqoLd6SMIMQ3bSbW
         ySrdGFF+Z2Lhu48j6VSIX5/KGAV3IPTEB4mvWH/sfrW1hsnYdUheslqB/VqFvnEUe7
         nmQ6ezGyOPUZiO7ZefnRXxMLKxEJe5zebZxN58PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 313/509] netfilter: nf_tables: add rescheduling points during loop detection walks
Date:   Tue, 25 Jul 2023 12:44:12 +0200
Message-ID: <20230725104608.073564624@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 81ea010667417ef3f218dfd99b69769fe66c2b67 ]

Add explicit rescheduling points during ruleset walk.

Switching to a faster algorithm is possible but this is a much
smaller change, suitable for nf tree.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3164,6 +3164,8 @@ int nft_chain_validate(const struct nft_
 			if (err < 0)
 				return err;
 		}
+
+		cond_resched();
 	}
 
 	return 0;
@@ -8506,9 +8508,13 @@ static int nf_tables_check_loops(const s
 				break;
 			}
 		}
+
+		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
+		cond_resched();
+
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||


