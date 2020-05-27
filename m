Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D5AC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA5B2089D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 20:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgE0UGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 16:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgE0UGD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 16:06:03 -0400
X-Greylist: delayed 18763 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 May 2020 13:06:03 PDT
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6055EC05BD1E;
        Wed, 27 May 2020 13:06:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1je2JN-0002DO-Fg; Wed, 27 May 2020 22:06:01 +0200
Date:   Wed, 27 May 2020 22:06:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v1] audit: log nftables configuration change
 events
Message-ID: <20200527200601.GJ2915@breakpoint.cc>
References: <d92a718b54269f426acc18f28e561031da66d3ca.1590579994.git.rgb@redhat.com>
 <20200527145317.GI2915@breakpoint.cc>
 <20200527152443.7axktc2im3zpvk37@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527152443.7axktc2im3zpvk37@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> Well, we are only logging "some change", so is it necessary to log the
> generation count to show that?  Is the generation count of specific
> interest?

No, its of no specific interest.  I just worded this poorly.
If the generation id increments, then something has been changed by the
batch, thats all.

> > (After that, kernel can't back down anymore, i.e. all errors are
> >  caught/handled beforehand).
> 
> I did think of recording all failed attempts too, but coding that would
> be more effort.  It is worth doing if it is deemed important,
> particularly for permission issues (as opposed to resource limits or
> packet format errors.  This would be more of interest to a security
> officer rather than a network technician, but the latter may find it
> useful for debugging.

The permission check is done early, in nfnetlink_rcv() (search for
EPERM), you would need to add an audit call there if thats relevant
for audit purposes.

> > If its 'any config change', then you also need to handle adds
> > or delete from sets/maps, since that may allow something that wasn't
> > allowed before, e.g. consider
> > 
> > ip saddr @trused accept
> > 
> > and then, later on,
> > nft add element ip filter @trusted { 10.0.0.0/8, 192.168.0.1 }
> > 
> > This would not add a table, or chain, or set, but it does implicitly
> > alter the ruleset.
> 
> Ah, ok, so yes, we would need that too.  I see family and table in
> there, op is evident.  Is there a useful value we can use in the
> "entries" field?

Maybe the handle of the set that the element was added to.
Each set, rule, chain, ... has a kernel-assigned number that
serves as a unique identifier.

> > Is that record format expected to emit the current number of chains?
> 
> I was aiming for a relevant value such as perhaps the new rule number or
> the rule number being deleted.

In that case, use the handle, which is a u64 with a unique value (for a
given table).

> > Since table names can be anything in nf_tables (they have no special
> > properties anymore), the table name is interesting from a informational
> > pov, but not super interesting.
> 
> I don't think we need to be able to completely reconstruct the
> tables/chains/rules from the information in the audit log, but be aware
> of who is changing what when.

Ok.  Have a look at nf_tables_fill_gen_info() in that case, you probably
want to emit at least the pid and task info, unless audit doesn't add
that already anyway.

> > Consider a batch update that commits 100 new rules in chain x,
> > this would result in 100 audit_log_nfcfg() calls, each with the
> > same information.
> 
> So rule number would be a useful differentiator here.

Ok.  Yes, that is available (rule->handle).
