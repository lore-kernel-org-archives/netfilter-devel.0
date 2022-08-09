Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE08C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 21:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiHIVjJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiHIVjH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 17:39:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 592B46AA12
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 14:39:06 -0700 (PDT)
Date:   Tue, 9 Aug 2022 23:39:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, mingi cho <mgcho.minic@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix null deref due to zeroed
 list head
Message-ID: <YvLT94oa20O6TZL1@salvia>
References: <20220809163402.20227-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809163402.20227-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 09, 2022 at 06:34:02PM +0200, Florian Westphal wrote:
> In nf_tables_updtable, if nf_tables_table_enable returns an error,
> nft_trans_destroy is called to free the transaction object.
> 
> nft_trans_destroy() calls list_del(), but the transaction was never
> placed on a list -- the list head is all zeroes, this results in
> a null dereference:
> 
> BUG: KASAN: null-ptr-deref in nft_trans_destroy+0x26/0x59
> Call Trace:
>  nft_trans_destroy+0x26/0x59
>  nf_tables_newtable+0x4bc/0x9bc
>  [..]
> 
> Its sane to assume that nft_trans_destroy() can be called
> on the transaction object returned by nft_trans_alloc(), so
> make sure the list head is initialised.

Applied to nf.git, thanks
