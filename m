Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932E5C5519F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5632222F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IoAvqT5J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgKTJxI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKTJxI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:53:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FAAC0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=taXbEmbJ23h3ZZoR5OLcqyWWYe4ykcWqY5PbOPgOoY4=; b=IoAvqT5JWJK7x+dMpKMaAuGydq
        G4FcNPnbsRwQ6AtQydMVRwpmh/lvKLzoJVmmVJIzPvAmg20Wb1l+hoj/X/SepMWCYW2C0Z1FCziCR
        c2ioRfn782gePuDnDG6O/1T67Gv+8nwljg7cnr/TpBYYu2l4MGzgJwqw3IdJmmUq39WcVLx2tKa4p
        q7gfo8oucyXhLZOfxFOluVd/j0N9PzdCXCPaHs17yu5whsKzxrWBet1YfWCTvPjjFfBkTsurVj7nx
        BCRjXOn2nqJUDvme30ZEDri9bZMAreTxOxNRXQIbqyBvIaibqZEBpzLcs49SF2JZ4D4B4J0LYMYMf
        3bwBBdRQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kg36E-0006ez-Fm; Fri, 20 Nov 2020 09:53:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 18164304D28;
        Fri, 20 Nov 2020 10:53:02 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 02B692B06A309; Fri, 20 Nov 2020 10:53:01 +0100 (CET)
Date:   Fri, 20 Nov 2020 10:53:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     subashab@codeaurora.org
Cc:     Florian Westphal <fw@strlen.de>, Will Deacon <will@kernel.org>,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201120095301.GB3092@hirez.programming.kicks-ass.net>
References: <983d178e6f3aac81d491362ab60db61f@codeaurora.org>
 <20201116182028.GE22792@breakpoint.cc>
 <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
 <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
 <20201118211007.GA15137@breakpoint.cc>
 <7d8bc917b7a6790fa789085ba8324b08@codeaurora.org>
 <20201120094413.GA3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120094413.GA3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 20, 2020 at 10:44:13AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 19, 2020 at 10:53:13PM -0700, subashab@codeaurora.org wrote:
> > +struct xt_table_info
> > +*xt_table_get_private_protected(const struct xt_table *table)
> > +{
> > +	return rcu_dereference_protected(table->private,
> > +					 mutex_is_locked(&xt[table->af].mutex));
> > +}
> > +EXPORT_SYMBOL(xt_table_get_private_protected);
> 
> In all debug builds this function compiles to a single memory

! went missing... :/

> dereference. Do you really want that out-of-line?
