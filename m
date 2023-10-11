Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3958CD6E5A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 11:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbjJKLLE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbjJKLKr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 07:10:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CA5D67
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 04:10:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qqX6j-00086Y-Ql; Wed, 11 Oct 2023 13:10:29 +0200
Date:   Wed, 11 Oct 2023 13:10:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH conntrack] conntrack: label update requires a previous
 label in place
Message-ID: <20231011111029.GE1407@breakpoint.cc>
References: <20231011095503.131168-1-pablo@netfilter.org>
 <ZSZ39VSJWfPjeizQ@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSZ39VSJWfPjeizQ@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 11, 2023 at 11:55:03AM +0200, Pablo Neira Ayuso wrote:
> > You have to set an initial label if you plan to update it later on.  If
> > conntrack comes with no initial label, then it is not possible to attach
> > it later because conntrack extensions are created by the time the new
> > entry is created.
> > 
> > Skip entries with no label to skip ENOSPC error for conntracks that have
> > no initial label (this is assuming a scenario with conntracks with and
> > _without_ labels is possible, and the conntrack command line tool is used
> > to update all entries regardless they have or not an initial label, e.g.
> > conntrack -U --label-add "testlabel".
> 
> Still not fully correct.
> 
> Current behaviour is:
> 
> If there is at least one rule in the ruleset that uses the connlabel,
> then connlabel conntrack extension is always allocated.
> 
> I wonder if this needs a sysctl toggle just like
> nf_conntrack_timestamp. Otherwise I am not sure how to document this.

Rationale was that if you have no rules that check on labels then
there is never a need to allocate the space.

I'm working on a patchset that will also set/enable the label
extension if its enabled on the template. The idea is to convert
ovs and act_ct to it, currently they point-blank increment
net->ct.labels_used which means that all conntrack objects get the
label area allocated.

But thats not what the counter was (originally) meant to convey, it
was really 'number of connlabel rules'.

As soon as act_ct or ovs modules are loaded, then all the namespaces
see 'I need conntrack labels', which completely voids all attempts to
avoid ct->ext allocation.

