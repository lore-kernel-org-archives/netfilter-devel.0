Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2E6C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA8C208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfFQR0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:26:55 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33586 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfFQR0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:26:55 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hcvPB-000324-9X; Mon, 17 Jun 2019 19:26:53 +0200
Date:   Mon, 17 Jun 2019 19:26:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft,v2 2/5] tests: shell: cannot use handle for
 non-existing rule in kernel
Message-ID: <20190617172653.GW31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190617171842.1227-1-pablo@netfilter.org>
 <20190617171842.1227-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617171842.1227-2-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Pablo!

On Mon, Jun 17, 2019 at 07:18:39PM +0200, Pablo Neira Ayuso wrote:
> This test invokes the 'replace rule ... handle 2' command. However,
> there are no rules in the kernel, therefore it always fails.

I found the cause for why this stopped working: You forgot to adjust
rule_evaluate(), what you need is something like this:

diff --git a/src/evaluate.c b/src/evaluate.c
index ff0888d0c7842..f17bebe4a5f22 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3295,7 +3295,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
        }
 
        /* add rules to cache only if it is complete enough to contain them */
-       if (!cache_is_complete(&ctx->nft->cache, CMD_LIST))
+       if (!(ctx->nft->cache.flags & NFT_CACHE_RULE))
                return 0;
 
        return rule_cache_update(ctx, op);

Then handle guessing works again. :)

Cheers, Phil
