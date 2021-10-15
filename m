Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE2AC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 11:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 539FD61073
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 11:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbhJOLDg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbhJOLDf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 07:03:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD5C061570
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 04:01:29 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mbKxo-0001il-Dg; Fri, 15 Oct 2021 13:01:24 +0200
Date:   Fri, 15 Oct 2021 13:01:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/17] Eliminate dedicated arptables-nft
 parser
Message-ID: <20211015110124.GL1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210930140419.6170-1-phil@nwl.cc>
 <YWiZacKr4s3mkdhU@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWiZacKr4s3mkdhU@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Oct 14, 2021 at 10:56:09PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 30, 2021 at 04:04:02PM +0200, Phil Sutter wrote:
> > Commandline parsing was widely identical with iptables and ip6tables.
> > This series adds the necessary code-changes to unify the parsers into a
> > common one.
> > 
> > Changes since v1:
> > - Fix patch 12, the parser has to check existence of proto_parse
> >   callback before dereferencing it. Otherwise arptables-nft segfaults if
> >   '-p' option is given.
> 
> LGTM.

Thanks for your review!

> > - Patches 13-17 add all the arptables quirks to restore compatibility
> >   with arptables-legacy. I didn't consider them important enough to push
> >   them unless someone complains. Yet breaking existing scripts is bad
> >   indeed. Please consider them RFC: If you consider (one of) them not
> >   important, please NACk and I will drop them before pushing.
> 
> For patch 13-16, you could display a warning for people to fix their
> scripts, so this particular (strange) behaviour in some cases can be
> dropped (at least, 13-15 look like left-over/bugs). For the
> check_inverse logic, I'd suggest to display a warning too, this is
> what it was done in iptables time ago to address this inconsistency.

I wonder how likely it is for someone to rely upon the behaviour. I can
imagine a script passing an empty interface name and expecting the
argument to be ignored (patch 13). Though what are the odds someone
actually calls arptables with '-m something' (patch 14) or a bogus table
name (patch 15)?

> I'd probably keep back patch 17/17, the max chain name length was
> reduced by when the revision field was introduced and this resulted in
> no issue being reported.

If that's OK with you, I would turn the empty interface name error into
a warning for arptables-nft, reintroduce the warning for intrapositioned
negations and drop the remaining quirks as they are likely hiding a bug.

Cheers, Phil
