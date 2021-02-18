Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E433AC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9899064D9A
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhBRREp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 12:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBRNlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 08:41:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B943EC061756;
        Thu, 18 Feb 2021 05:41:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lCjYI-0006xj-Uv; Thu, 18 Feb 2021 14:41:07 +0100
Date:   Thu, 18 Feb 2021 14:41:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210218134106.GC22944@breakpoint.cc>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
 <20210217234131.GN3141668@madcap2.tricolour.ca>
 <20210218082207.GJ2766@breakpoint.cc>
 <20210218124211.GO3141668@madcap2.tricolour.ca>
 <20210218125248.GB22944@breakpoint.cc>
 <20210218132843.GP3141668@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218132843.GP3141668@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> Ok, can I get one more clarification on this "hierarchy"?  Is it roughly
> in the order they appear in nf_tables_commit() after step 3?  It appears
> it might be mostly already.  If it isn't already, would it be reasonable
> to re-order them?  Would you suggest a different order?

For audit purposes I think enum nf_tables_msg_types is already in the
most relevant order, the lower numbers being more imporant.

So e.g. NEWTABLE would be more interesting than DELRULE, if both
are in same batch.

> > > such that it would be desirable to filter them out
> > > to reduce noise in that single log line if it is attempted to list all
> > > the change ops?  It almost sounds like it would be better to do one
> > > audit log line for each table for each family, and possibly for each op
> > > to avoid the need to change userspace.  This would already be a
> > > significant improvement picking the highest ranking op.
> > 
> > I think i understand what you'd like to do.  Yes, that would reduce
> > the log output a lot.
> 
> Would the generation change id be useful outside the kernel?

Yes, we already announce it to interested parties via nfnetlink.

> What
> exactly does it look like?

Its just a u64 counter that gets incremented whenever there is a change.

> I don't quite understand the genmask purpose.

Thats an implementation detail only.  When we process a transaction,
changes to the ruleset are being made but they should not have any
effect until the entire transaction is processed.

So there are two 'generations' at any time:
1. The active ruleset
2. The future ruleset

2) is what is being changed/modified.

When the transaction completes, then the future ruleset becomes
the active ruleset.  If the transaction has to be aborted, the
pending changes are reverted and the genid/genmasks are not changed.
