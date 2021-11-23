Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584BEC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 13:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhKWNUM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:20:12 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60230 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbhKWNUM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 08:20:12 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3607A64704;
        Tue, 23 Nov 2021 14:14:53 +0100 (CET)
Date:   Tue, 23 Nov 2021 14:16:59 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/8] mptcp subtype option match support
Message-ID: <YZzpy9bk4AFahSVI@salvia>
References: <20211119152847.18118-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119152847.18118-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 19, 2021 at 04:28:39PM +0100, Florian Westphal wrote:
> This series adds 'tcp option mptcp subtype' matching to nft.

LGTM.

> Because the subtype is only 4 bits in size the exthdr
> delinearization needs a fixup to remove the binop added by the
> evaluation step.

By the bitwise operation to take the 4 bits you can infer this refers to
mptcp, but it might be good to store in the rule userdata area that this
expression refers to mptcp as a suggestion to userspace when
delinearizing the rule. I wanted to look into this for a different
usecase.

> One remaining usablility problem is the lack of mnemonics for the
> subtype, i.e. something like:
> 
> static const struct symbol_table mptcp_subtype_tbl = {
>        .base           = BASE_DECIMAL,
>        .symbols        = {
>                SYMBOL("mp-capable",    0),
>                SYMBOL("mp-join",       1),
>                SYMBOL("dss",           2),
>                SYMBOL("add-addr",      3),
>                SYMBOL("remove-addr",   4),
>                SYMBOL("mp-prio",       5),
>                SYMBOL("mp-fail",       6),
>                SYMBOL("mp-fastclose",  7),
>                SYMBOL("mp-tcprst",     8),
>                SYMBOL_LIST_END
>        },
> 
> ... but this would need addition of yet another data type.
>
> Use of implicit/context-dependent symbol table would
> be preferrable, I will look into this next.

Could you develop your idea?

Thanks.
