Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF83DC61DD8
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 16:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3B9207DE
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 16:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgKNQxf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Nov 2020 11:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgKNQxf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Nov 2020 11:53:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60DDC0613D1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 08:53:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kdynq-0005rq-KC; Sat, 14 Nov 2020 17:53:30 +0100
Date:   Sat, 14 Nov 2020 17:53:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Sean Tranchetti <stranche@codeaurora.org>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        subashab@codeaurora.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201114165330.GM23619@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sean Tranchetti <stranche@codeaurora.org> wrote:
> xtables uses a modified version of a seqcount lock for synchronization
> between replacing private table information and the packet processing
> path (i.e. XX_do_table). The main modification is in the "write"
> semantics, where instead of adding 1 for each write, the write side will
> add 1 only if it finds no other writes ongoing, and adds 1 again (thereby
> clearing the LSB) when it finishes.
> 
> This allows the read side to avoid calling read_seqcount_begin() in a loop
> if a write is detected, since the value is guaranteed to only increment
> once all writes have completed. As such, it is only necessary to check if
> the initial value of the sequence count has changed to inform the reader
> that all writes are finished.
> 
> However, the current check for the changed value uses the wrong API;
> raw_seqcount_read() is protected by smp_rmb() in the same way as
> read_seqcount_begin(), making it appropriate for ENTERING read-side
> critical sections, but not exiting them. For that, read_seqcount_rety()
> must be used to ensure the proper barrier placement for synchronization
> with xt_write_recseq_end() (itself modeled after write_seqcount_end()).

[..]

> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index af22dbe..39f1f2b 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1404,7 +1404,7 @@ xt_replace_table(struct xt_table *table,
>  			do {
>  				cond_resched();
>  				cpu_relax();
> -			} while (seq == raw_read_seqcount(s));
> +			} while (!read_seqcount_retry(s, seq));

I'm fine with this change but AFAIU this is just a cleanup since
this part isn't a read-sequence as no  'shared state' is accessed/read between
the seqcount begin and the do{}while. smb_rmb placement should not matter here.

Did I miss anything?

Thanks.

