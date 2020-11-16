Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934E1C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6310322265
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgKPOSQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 09:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKPOSP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 09:18:15 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4716C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 06:18:15 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kefKc-0006fs-VT; Mon, 16 Nov 2020 15:18:11 +0100
Date:   Mon, 16 Nov 2020 15:18:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     subashab@codeaurora.org
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201116141810.GB22792@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> > I'm fine with this change but AFAIU this is just a cleanup since
> > this part isn't a read-sequence as no  'shared state' is accessed/read
> > between
> > the seqcount begin and the do{}while. smb_rmb placement should not
> > matter here.
> > 
> > Did I miss anything?
> > 
> > Thanks.
> 
> Hi Florian
> 
> To provide more background on this, we are seeing occasional crashes in a
> regression rack in the packet receive path where there appear to be
> some rules being modified concurrently.
> 
> Unable to handle kernel NULL pointer dereference at virtual
> address 000000000000008e
> pc : ip6t_do_table+0x5d0/0x89c
> lr : ip6t_do_table+0x5b8/0x89c
> ip6t_do_table+0x5d0/0x89c
> ip6table_filter_hook+0x24/0x30
> nf_hook_slow+0x84/0x120
> ip6_input+0x74/0xe0
> ip6_rcv_finish+0x7c/0x128
> ipv6_rcv+0xac/0xe4
> __netif_receive_skb+0x84/0x17c
> process_backlog+0x15c/0x1b8
> napi_poll+0x88/0x284
> net_rx_action+0xbc/0x23c
> __do_softirq+0x20c/0x48c
> 
> We found that ip6t_do_table was reading stale values from the READ_ONCE
> leading to use after free when dereferencing per CPU jumpstack values.
> 
> [https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv6/netfilter/ip6_tables.c?h=v5.4.77#n282]
> 	addend = xt_write_recseq_begin();
> 	private = READ_ONCE(table->private); /* Address dependency. */
> 
> We were able to confirm that the xt_replace_table & __do_replace
> had already executed by logging the seqcount values. The value of
> seqcount at ip6t_do_table was 1 more than the value at xt_replace_table.

Can you elaborate? Was that before xt_write_recseq_begin() or after?

> The seqcount read at xt_replace_table also showed that it was an even value
> and hence meant that there was no conccurent writer instance
> (xt_write_recseq_begin)
> at that point.

Ok, so either ip6_do_table was done or just starting (and it should not
matter which one).

> [https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/x_tables.c?h=v5.4.77#n1401]
> 		u32 seq = raw_read_seqcount(s);
> 
> This means that table assignment at xt_replace_table did not take effect
> as expected.

You mean
"private = READ_ONCE(table->private); /* Address dependency. */" in
ip6_do_table did pick up the 'old' private pointer, AFTER xt_replace
had updated it?

> [https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/x_tables.c?h=v5.4.77#n1386]
> 	smp_wmb();
> 	table->private = newinfo;
> 
> 	/* make sure all cpus see new ->private value */
> 	smp_wmb();
> 
> We want to know if this barrier usage is as expected here.
> Alternatively, would changing this help here -
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 525f674..417ea1b 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1431,11 +1431,11 @@ xt_replace_table(struct xt_table *table,
>          * Ensure contents of newinfo are visible before assigning to
>          * private.
>          */
> -       smp_wmb();
> -       table->private = newinfo;
> +       smp_mb();
> +       WRITE_ONCE(table->private, newinfo);

The WRITE_ONCE looks correct.

>         /* make sure all cpus see new ->private value */
> -       smp_wmb();
> +       smp_mb();

Is that to order wrt. seqcount_sequence?
Do you have a way to reproduce such crashes?

I tried to no avail but I guess thats just because amd64 is more
forgiving.

Thanks!
