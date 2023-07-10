Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA66EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 19:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjGJTSv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 15:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGJTSr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 15:18:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612CC95
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 12:18:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qIwPD-0006zi-IL; Mon, 10 Jul 2023 21:18:43 +0200
Date:   Mon, 10 Jul 2023 21:18:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Igor Raits <igor@gooddata.com>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: ebtables-nft can't delete complex rules by specifying complete
 rule with kernel 6.3+
Message-ID: <20230710191843.GA22277@breakpoint.cc>
References: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
 <20230710112135.GA12203@breakpoint.cc>
 <20230710124950.GC12203@breakpoint.cc>
 <CA+9S74h4ME7sxt7L1VcU+hPXj1H-cWwTcrEsyyrjSAHx_UxCwA@mail.gmail.com>
 <ZKxH1eNXcI5k9oJq@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZKxH1eNXcI5k9oJq@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jul 10, 2023 at 04:41:27PM +0200, Igor Raits wrote:
> > Hello Florian,
> > 
> > On Mon, Jul 10, 2023 at 2:49 PM Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Florian Westphal <fw@strlen.de> wrote:
> > > > Igor Raits <igor@gooddata.com> wrote:
> > > > > Hello,
> > > > >
> > > > > We started to observe the issue regarding ebtables-nft and how it
> > > > > can't wipe rules when specifying full rule. Removing the rule by index
> > > > > works fine, though. Also with kernel 6.1.y it works completely fine.
> > > > >
> > > > > I've started with 1.8.8 provided in CentOS Stream 9, then tried the
> > > > > latest git version and all behave exactly the same. See the behavior
> > > > > below. As you can see, simple DROP works, but more complex one do not.
> > > > >
> > > > > As bugzilla requires some special sign-up procedure, apologize for
> > > > > reporting it directly here in the ML.
> > > >
> > > > Thanks for the report, I'll look into it later today.
> > >
> > > Its a bug in ebtables-nft, it fails to delete the rule since
> > >
> > > 938154b93be8cd611ddfd7bafc1849f3c4355201,
> > > netfilter: nf_tables: reject unbound anonymous set before commit phase
> > >
> > > But its possible do remove the rule via
> > > nft delete rule .. handle $x
> > >
> > > so the breakge is limited to ebtables-nft.
> > 
> > Thanks for confirmation and additional information regarding where
> > exactly the issue was introduced.
> > The ebtables-nft (well, ebtables in general) is heavily used by the
> > OpenStack Neutron (in linuxbridge mode), so this breaks our setup
> > quite a bit. Would you recommend to revert kernel change or would you
> > have the actual fix soon (ebtables-nft or kernel)?
> 
> Just to make sure this bug is not caused by something else.

No no no, this is a userspace bug.
netfilter: nf_tables: reject unbound anonymous set before commit phase

ebtables-nft emits a DELRULE followed by creation of a (dangling!)
anon set, because backend code that handles add/delete is identical,
so 'delete' request for among schedules addition of the set.
