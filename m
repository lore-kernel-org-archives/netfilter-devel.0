Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B9FC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 11:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BE9C610E8
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 11:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhJOL1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:27:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48672 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhJOL1l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 07:27:41 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7CE0A60098;
        Fri, 15 Oct 2021 13:23:54 +0200 (CEST)
Date:   Fri, 15 Oct 2021 13:25:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/17] Eliminate dedicated arptables-nft
 parser
Message-ID: <YWllKW6PmE9FJHhn@salvia>
References: <20210930140419.6170-1-phil@nwl.cc>
 <YWiZacKr4s3mkdhU@salvia>
 <20211015110124.GL1668@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211015110124.GL1668@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 15, 2021 at 01:01:24PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Oct 14, 2021 at 10:56:09PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 30, 2021 at 04:04:02PM +0200, Phil Sutter wrote:
> > > Commandline parsing was widely identical with iptables and ip6tables.
> > > This series adds the necessary code-changes to unify the parsers into a
> > > common one.
> > > 
> > > Changes since v1:
> > > - Fix patch 12, the parser has to check existence of proto_parse
> > >   callback before dereferencing it. Otherwise arptables-nft segfaults if
> > >   '-p' option is given.
> > 
> > LGTM.
> 
> Thanks for your review!
> 
> > > - Patches 13-17 add all the arptables quirks to restore compatibility
> > >   with arptables-legacy. I didn't consider them important enough to push
> > >   them unless someone complains. Yet breaking existing scripts is bad
> > >   indeed. Please consider them RFC: If you consider (one of) them not
> > >   important, please NACk and I will drop them before pushing.
> > 
> > For patch 13-16, you could display a warning for people to fix their
> > scripts, so this particular (strange) behaviour in some cases can be
> > dropped (at least, 13-15 look like left-over/bugs). For the
> > check_inverse logic, I'd suggest to display a warning too, this is
> > what it was done in iptables time ago to address this inconsistency.
> 
> I wonder how likely it is for someone to rely upon the behaviour. I can
> imagine a script passing an empty interface name and expecting the
> argument to be ignored (patch 13). Though what are the odds someone
> actually calls arptables with '-m something' (patch 14) or a bogus table
> name (patch 15)?

I think this is a leftover/bug that has been there for long time.

> > I'd probably keep back patch 17/17, the max chain name length was
> > reduced by when the revision field was introduced and this resulted in
> > no issue being reported.
> 
> If that's OK with you, I would turn the empty interface name error into
> a warning for arptables-nft, reintroduce the warning for intrapositioned
> negations and drop the remaining quirks as they are likely hiding a bug.

Agreed.
