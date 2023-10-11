Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31CECD6E69
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 13:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjJKNfX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjJKNfX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 09:35:23 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A519392
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 06:35:20 -0700 (PDT)
Received: from [78.30.34.192] (port=41622 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqZMq-00C8Y0-Bq; Wed, 11 Oct 2023 15:35:18 +0200
Date:   Wed, 11 Oct 2023 15:35:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack] conntrack: label update requires a previous
 label in place
Message-ID: <ZSakk9nuZZXAb+qE@calendula>
References: <20231011095503.131168-1-pablo@netfilter.org>
 <ZSZ39VSJWfPjeizQ@calendula>
 <20231011111029.GE1407@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231011111029.GE1407@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 01:10:29PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Oct 11, 2023 at 11:55:03AM +0200, Pablo Neira Ayuso wrote:
> > > You have to set an initial label if you plan to update it later on.  If
> > > conntrack comes with no initial label, then it is not possible to attach
> > > it later because conntrack extensions are created by the time the new
> > > entry is created.
> > > 
> > > Skip entries with no label to skip ENOSPC error for conntracks that have
> > > no initial label (this is assuming a scenario with conntracks with and
> > > _without_ labels is possible, and the conntrack command line tool is used
> > > to update all entries regardless they have or not an initial label, e.g.
> > > conntrack -U --label-add "testlabel".
> > 
> > Still not fully correct.
> > 
> > Current behaviour is:
> > 
> > If there is at least one rule in the ruleset that uses the connlabel,
> > then connlabel conntrack extension is always allocated.
> > 
> > I wonder if this needs a sysctl toggle just like
> > nf_conntrack_timestamp. Otherwise I am not sure how to document this.
> 
> Rationale was that if you have no rules that check on labels then
> there is never a need to allocate the space.
> 
> I'm working on a patchset that will also set/enable the label
> extension if its enabled on the template. The idea is to convert
> ovs and act_ct to it, currently they point-blank increment
> net->ct.labels_used which means that all conntrack objects get the
> label area allocated.
> 
> But thats not what the counter was (originally) meant to convey, it
> was really 'number of connlabel rules'.

> As soon as act_ct or ovs modules are loaded, then all the namespaces
> see 'I need conntrack labels', which completely voids all attempts to
> avoid ct->ext allocation.

OK, so instead a of per-netns sysctl toggle, you propose to use the
conntrack template to selectively enable this.
