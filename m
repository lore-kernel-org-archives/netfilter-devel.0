Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224FBC5519F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B28B20888
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 10:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RadFmD+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgKTKrp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 05:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgKTKro (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 05:47:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF35C0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 02:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1L5jZaxwaAEFGievx6sty1SCpwXqm09MeOMpo11lABk=; b=RadFmD+hkdMOkPMLLUXixJtQ/7
        LYzXm2hhXW+kYAwO81MmZ68gccndi8jiX5RDwA7EQZNZ/JM76jD1HCejPIfR6J3Ewm/sK1soR89tZ
        JNQwlgWm7m+8StsUK00XzeghPF9koMaM60j8y3WodvSQu5rvaGayGS+bLNh9LQKNsvkFa90vZolU7
        rUkx8cbH+RomFMB6sqpz0FZxPlqBJi74LMaCEZmxllKzLeK3H2g3FOp4+9uq+Sc3FkYpDxk8WZfJF
        Dn3/WLjZCv0yoEPUytz8bYq97b5LlSoosMEi7aii0KqYsMs1deRFc0P9mSv5QCWfvy9wZ587zCzl8
        UbX7fa/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kg3x3-0001f4-6M; Fri, 20 Nov 2020 10:47:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 870AF3011C6;
        Fri, 20 Nov 2020 11:47:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6F0AD200DF1A2; Fri, 20 Nov 2020 11:47:36 +0100 (CET)
Date:   Fri, 20 Nov 2020 11:47:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     subashab@codeaurora.org, Will Deacon <will@kernel.org>,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
Message-ID: <20201120104736.GC3021@hirez.programming.kicks-ass.net>
References: <20201118121322.GA1821@willie-the-truck>
 <20201118124228.GJ22792@breakpoint.cc>
 <20201118125406.GA2029@willie-the-truck>
 <20201118131419.GK22792@breakpoint.cc>
 <7d52f54a7e3ebc794f0b775e793ab142@codeaurora.org>
 <20201118211007.GA15137@breakpoint.cc>
 <7d8bc917b7a6790fa789085ba8324b08@codeaurora.org>
 <20201120094413.GA3040@hirez.programming.kicks-ass.net>
 <20201120095301.GB3092@hirez.programming.kicks-ass.net>
 <20201120102032.GO15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120102032.GO15137@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 20, 2020 at 11:20:32AM +0100, Florian Westphal wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, Nov 20, 2020 at 10:44:13AM +0100, Peter Zijlstra wrote:
> > > On Thu, Nov 19, 2020 at 10:53:13PM -0700, subashab@codeaurora.org wrote:
> > > > +struct xt_table_info
> > > > +*xt_table_get_private_protected(const struct xt_table *table)
> > > > +{
> > > > +	return rcu_dereference_protected(table->private,
> > > > +					 mutex_is_locked(&xt[table->af].mutex));
> > > > +}
> > > > +EXPORT_SYMBOL(xt_table_get_private_protected);
> > > 
> > > In all debug builds this function compiles to a single memory
> > 
> > ! went missing... :/
> 
> ? Not sure about "!".

!debug gets you a single deref, for debug builds do we get extra code.

> > > dereference. Do you really want that out-of-line?
> 
> Its the lesser of two evils, the other solution would be to export
> xt[] from x_tables.c; its static right now.

Bah, missed that.
