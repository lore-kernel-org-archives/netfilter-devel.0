Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E41C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4125865229
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhCIVSa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 16:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbhCIVSU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 16:18:20 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9295C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 13:18:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lJjk9-0000It-MP; Tue, 09 Mar 2021 22:18:17 +0100
Date:   Tue, 9 Mar 2021 22:18:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, fmyhr@fhmtech.com,
        stefanh@hafenthal.de
Subject: Re: [PATCH RFC nf-next 0/2] ct helper object name matching
Message-ID: <20210309211817.GG10808@breakpoint.cc>
References: <20210309210134.13620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309210134.13620-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> From nftables, existing (inconsistent) syntax can be left in place for
> backward compatibility. The new proposed syntax would more explicitly
> refer to match the user wants to do, e.g.
> 
> 	ct helper name set "ftp-21"

That would be same as 'ct helper set "ftp-21" that we use at the
moment, i.e. this generates same byte code, correct?

> 	ct helper name "ftp-21"

I see, kernel ct extension gains a pointer to the objref name.

> For NFT_CT_HELPER_TYPE (formerly NFT_CT_HELPER), syntax would be:
> 
> 	ct helper type "ftp"

That would be the 'new' name for existing 'ct helper', so same bytecode,
correct?

> It should be also possible to support for:
> 
> 	ct helper type set "ftp"

IIRC another argument for objref usage was that this won't work
with set infra.

> via implicit object, this infrastructure is missing in the kernel
> though, the idea would be to create an implicit object that is attached
> to the rule.  Such object would be released when the rule is removed.

Ah, I see.

Yes, that would work.

> Let me know.

Looks good to me.
