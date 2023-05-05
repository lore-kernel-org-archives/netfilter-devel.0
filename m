Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF4BC77B7F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 14:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjEEOce (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 10:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjEEOcd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 10:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D050A1634A
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 07:32:32 -0700 (PDT)
Date:   Fri, 5 May 2023 16:32:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nf_tables: reject loads from
 uninitialized registers
Message-ID: <ZFUTfE/u4q34TTDY@calendula>
References: <20230505111656.32238-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505111656.32238-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, May 05, 2023 at 01:16:53PM +0200, Florian Westphal wrote:
> Keep a per-rule bitmask that tracks registers that have seen a store,
> then reject loads when the accessed registers haven't been flagged.
> 
> This changes uabi contract, because we previously allowed this.
> Neither nftables nor iptables-nft create such rules.
> 
> In case there is breakage, we could insert an 'store 0 to x'
> immediate expression into the ruleset automatically, but this
> isn't done here.
> 
> Let me know if you think the "refuse" approach is too risky.

Might the NFT_BREAK case defeat this approach? Sequence is:

1) expression that writes on register hits NFT_BREAK (nothing is written)
2) expression that read from register, it reads uninitialized data.

From ruleset load step, we cannot know if the write fails, because it
is subject to NFT_BREAK.

Thanks.
