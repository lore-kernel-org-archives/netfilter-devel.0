Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F26EB64D7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Jun 2023 13:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjFRNfW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Jun 2023 09:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjFRNfV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2023 09:35:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563F31A8;
        Sun, 18 Jun 2023 06:35:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qAsYf-0003J2-3b; Sun, 18 Jun 2023 15:35:09 +0200
Date:   Sun, 18 Jun 2023 15:35:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com
Cc:     netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft list sets changed behavior
Message-ID: <20230618133509.GA869@breakpoint.cc>
References: <60e59333-3d37-5b66-e0ed-8e7d4c01d956@qmail.sunbirdgrove.com>
 <20230618122216.3bdd0e34776293adb0655516@plushkava.net>
 <962b1e4f-63e2-bc3b-bf27-5569c6402c0f@qmail.sunbirdgrove.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962b1e4f-63e2-bc3b-bf27-5569c6402c0f@qmail.sunbirdgrove.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

moving to nf-devel

nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com <nft.ogxzcrqhuhgchbvxcs4j7wws@qmail.sunbirdgrove.com> wrote:
> Thanks for your reply. On Debian 11 it did list the elements for at least a
> year, that's why I'm surprised about this change. 0.9.8 vs. 1.0.6.
> 
> I'll look into filing a bug.

No need, consider the bug filed.

Pablo, we have a behaviour change in
"nft -j list sets".

1.0.0:
nft -j list sets : lists sets with elements.
nft list sets : no elements.

1.0.1+:
nft -j list sets : no elements.
nft list sets : no elements.

So 1.0.1+ it at least consistent, no set elements
are shown.

But it breaks at least one user setup:
> > > After updating to Debian 12 my tools relying on 'nft -j list sets' fail.
> > > It now does not include the elements in those lists like it did on 11.

I see three possible solutions:
1 - accept the breakage.
2 - repair the inconsistency so we get 1.0.0 and
    earlier behaviour back.
3 - make "list sets" *always* include set elements,
    unless --terse was given.

Thoughts? I'd go with 3, I dislike the
different behaviour that 2) implies and we already
have --terse, we just need to make use of it here.

I'd even favour 1 over 2.

This change came with
commit a1a6b0a5c3c4b4b305fa34a77932ee1c6452d1c8
cache: finer grain cache population for list commands

so it would be easy to resolve, e.g.:

diff --git a/src/cache.c b/src/cache.c
--- a/src/cache.c
+++ b/src/cache.c
@@ -235,6 +235,8 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
        case CMD_OBJ_SETS:
        case CMD_OBJ_MAPS:
                flags |= NFT_CACHE_TABLE | NFT_CACHE_SET;
+               if (!nft_output_terse(&nft->output))
+                       flags |= NFT_CACHE_SETELEM;
                break;
        case CMD_OBJ_FLOWTABLE:
                if (filter &&
