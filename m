Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8383DC5519F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 06:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3E722256
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 06:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKTGba (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 01:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgKTGba (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 01:31:30 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7572AC0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Nov 2020 22:31:30 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kfzx6-000744-Cd; Fri, 20 Nov 2020 07:31:24 +0100
Date:   Fri, 20 Nov 2020 07:31:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     subashab@codeaurora.org
Cc:     Florian Westphal <fw@strlen.de>, Will Deacon <will@kernel.org>,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201120063124.GM15137@breakpoint.cc>
References: <20201116170440.GA26150@breakpoint.cc>
 <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
 <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
 <20201118211007.GA15137@breakpoint.cc>
 <7d8bc917b7a6790fa789085ba8324b08@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d8bc917b7a6790fa789085ba8324b08@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

subashab@codeaurora.org <subashab@codeaurora.org> wrote:
> I've updated the patch with your comments.
> Do you expect a performance impact either in datapath or perhaps more in
> the rule installation with the rcu changes.

Rule installation.  synchronize_rcu() can take several seconds on busy
systems.

> diff --git a/net/ipv4/netfilter/arp_tables.c
> b/net/ipv4/netfilter/arp_tables.c
> index d1e04d2..dda5d8f 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -203,7 +203,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
> 
>  	local_bh_disable();
>  	addend = xt_write_recseq_begin();
> -	private = READ_ONCE(table->private); /* Address dependency. */
> +	private = xt_table_get_private_protected(table);

Err, no, this needs to be plain rcu_dereference(table->private).
Same in the other _do_table() versions.

We do not hold the table mutex here.
