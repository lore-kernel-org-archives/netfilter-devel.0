Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F82DC2D0E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 01:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07426221FC
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 01:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JMudM8ou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgKUB1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 20:27:41 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:15340 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgKUB1l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 20:27:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605922060; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=vTpX9KsfrYILz1LnAMjiCUL3o8wKqWPlQxwy08n9Sgo=;
 b=JMudM8ouTdYV1KgDpoiLGOWPrtlrlyTRUo0TBbEqxNTYrUdlNyzPBb6qSRrV+KZKPrcz/CBN
 oc/1xgxd0Q3HgxG5jIaSS/YEPT0olu9iJmhVVsg6Z33jbivgQWS0okhI6ztEle2n/LqiQXwf
 yeds9LY+9IByrSBLEEeRSCuLWrg=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fb86d0c22377520ee099a9d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Nov 2020 01:27:40
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D8810C43460; Sat, 21 Nov 2020 01:27:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54046C433ED;
        Sat, 21 Nov 2020 01:27:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Nov 2020 18:27:39 -0700
From:   subashab@codeaurora.org
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Florian Westphal <fw@strlen.de>, Will Deacon <will@kernel.org>,
        pablo@netfilter.org, Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
In-Reply-To: <20201120104736.GC3021@hirez.programming.kicks-ass.net>
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
 <20201120104736.GC3021@hirez.programming.kicks-ass.net>
Message-ID: <274d2f3877b3007a7a6e86775eb9a40a@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

>> > > > +struct xt_table_info
>> > > > +*xt_table_get_private_protected(const struct xt_table *table)
>> > > > +{
>> > > > +	return rcu_dereference_protected(table->private,
>> > > > +					 mutex_is_locked(&xt[table->af].mutex));
>> > > > +}
>> > > > +EXPORT_SYMBOL(xt_table_get_private_protected);
>> > >
>> > > In all debug builds this function compiles to a single memory
>> >
>> > ! went missing... :/
>> 
>> ? Not sure about "!".
> 
> !debug gets you a single deref, for debug builds do we get extra code.

Can you elaborate on this. I am not able to get the context here.
Are you referring to the definition of RCU_LOCKDEP_WARN.
RCU_LOCKDEP_WARN is a NOOP if CONFIG_PROVE_RCU is false.

#ifdef CONFIG_PROVE_RCU
#define RCU_LOCKDEP_WARN(c, s)						\
	do {								\
		static bool __section(.data.unlikely) __warned;		\
		if (debug_lockdep_rcu_enabled() && !__warned && (c)) {	\
			__warned = true;				\
			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
		}							\
	} while (0)
...
#else /* #ifdef CONFIG_PROVE_RCU */

#define RCU_LOCKDEP_WARN(c, s) do { } while (0)
