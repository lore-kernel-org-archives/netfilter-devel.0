Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9F9EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 18:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjGJSFb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 14:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbjGJSF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 14:05:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CD1F18D
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 11:05:26 -0700 (PDT)
Date:   Mon, 10 Jul 2023 20:05:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Igor Raits <igor@gooddata.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: ebtables-nft can't delete complex rules by specifying complete
 rule with kernel 6.3+
Message-ID: <ZKxIYuw8z4KqkQaA@calendula>
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
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 10, 2023 at 08:03:04PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
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
> 
> Could you cherry-pick this kernel patch? It is currently missing 6.1.38:
> 
> commit 3e70489721b6c870252c9082c496703677240f53
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Mon Jun 26 00:42:18 2023 +0200
> 
>     netfilter: nf_tables: unbind non-anonymous set if rule construction fails
>     
>     Otherwise a dangling reference to a rule object that is gone remains
>     in the set binding list.
> 
> I have requested included to -stable already.

Oh wait, you mentioned this works fine for you with 6.1.x.
