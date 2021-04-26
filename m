Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD66C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE9161042
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhDZMH0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 08:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbhDZMHZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 08:07:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5DDC061574
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Apr 2021 05:06:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lb00g-0000FS-Hp; Mon, 26 Apr 2021 14:06:42 +0200
Date:   Mon, 26 Apr 2021 14:06:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: allow to turn off xtables compat layer
Message-ID: <20210426120642.GC19277@breakpoint.cc>
References: <20210426101440.25335-1-fw@strlen.de>
 <25p6qsnp-r7p1-ps60-s7np-nsq1899446n2@vanv.qr>
 <20210426105714.GA300@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426105714.GA300@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Apr 26, 2021 at 12:47:12PM +0200, Jan Engelhardt wrote:
> > 
> > On Monday 2021-04-26 12:14, Florian Westphal wrote:
> > 
> > >The compat layer needs to parse untrusted input (the ruleset)
> > >to translate it to a 64bit compatible format.
> > >
> > >We had a number of bugs in this department in the past, so allow users
> > >to turn this feature off.
> > >
> > >+++ b/include/linux/netfilter/x_tables.h
> > >@@ -158,7 +158,7 @@ struct xt_match {
> > > 
> > > 	/* Called when entry of this type deleted. */
> > > 	void (*destroy)(const struct xt_mtdtor_param *);
> > >-#ifdef CONFIG_COMPAT
> > >+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> > > 	/* Called when userspace align differs from kernel space one */
> > > 	void (*compat_from_user)(void *dst, const void *src);
> > > 	int (*compat_to_user)(void __user *dst, const void *src);
> > 
> > There are not a lot of '\.compat_to_user' instaces anymore. It would appear we
> > managed to throw out most of the flexing structs over the past 15 years.
> > 
> > Perhaps the remaining one (struct xt_rateinfo) could be respecified
> > as a v1, with the plan to ditch the v0.
> > 
> > Then the entire xtables_compat code could go as well.
> 
> If the remaining matches and targets that rely on this get a new
> revision to fix their structure layout issues, then this entire layer
> could be peeled off.

Hmm, no, because the blob format itself (match, target structures,
ip(6)t_entry have different alignment requirements.

Also, ipt_get_entries has padding on x86_64 in the middle of the
structure that is not there in on i686.

Even the 'compat_to_user' helpers can't be removed because they
are needed by the standard target, see compat_standard_to_user()).

We could simplify things a bit though, if we only consider the matches,
then ebt mark and xt_limit are the only users; at least the xt_match
compat callback could be removed.
