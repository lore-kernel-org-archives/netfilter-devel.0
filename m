Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C497C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2478F20693
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfCMPe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:34:59 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48114 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfCMPe7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:34:59 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h45uB-0006y2-SC; Wed, 13 Mar 2019 16:34:55 +0100
Date:   Wed, 13 Mar 2019 16:34:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190313153455.GN4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
 <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
 <20190313150634.GM4851@orbyte.nwl.cc>
 <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 04:22:27PM +0100, Fernando Fernandez Mancera wrote:
> On 3/13/19 4:06 PM, Phil Sutter wrote:
> > Hi Fernando,
> > 
> > On Wed, Mar 13, 2019 at 03:15:51PM +0100, Fernando Fernandez Mancera wrote:
> >> On 3/13/19 12:27 PM, Phil Sutter wrote:
> >>> On Wed, Mar 13, 2019 at 11:14:04AM +0100, Fernando Fernandez Mancera wrote:
> >>>> Hi Phil,
> >>>>
> >>>> On 3/13/19 10:44 AM, Phil Sutter wrote:
> >>>>> Hi Fernando,
> >>>>>
> >>>>> On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
> >>>>>> Add support for version fingerprint in "osf" expression. Example:
> >>>>>>
> >>>>>> table ip foo {
> >>>>>> 	chain bar {
> >>>>>> 		type filter hook input priority filter; policy accept;
> >>>>>> 		osf ttl skip name "Linux"
> >>>>>> 		osf ttl skip name version "Linux:4.20"
> >>>>>> 	}
> >>>>>> }
> >>>>>
> >>>>> The syntax seems overly complicated to me, although I'm not really
> >>>>> familiar with OSF so may lack background knowledge. Any reason why you
> >>>>> didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?
> >>>>>
> >>>>
> >>>> You are right, 'osf ttl skip name "Linux" version "4.20"' was my first
> >>>> thought but in compilation time the parser applies shift-reduce to the
> >>>> expression.. I decided 'osf ttl skip name version "Linux:4.20"' to avoid
> >>>> a complex workaround in the parser.
> >>>
> >>> Shift/reduce warnings often require voodoo to fix, but it's not
> >>> impossible. :)
> >>>
> >>> Regarding my suggestion, I see that this string is actually the
> >>> right-hand-side of a relational expression. To implement what I had in
> >>> mind you would have to turn osf expression into a statement.
> >>>
> >>>> The fingerprints database syntax is "genre:version:subtype:details" so
> >>>> the nft 'osf' expression syntax is like the original one.
> >>>
> >>> Can we deduce required flags from the given string on RHS? I.e. by
> >>> looking at the amount of semi-colons and the number of characters
> >>> between them? I'm assuming the syntax works like "genre::subtype" and
> >>> "genre:::details" to omit certain parts, is that correct?
> >>>
> >>
> >> Yes that is correct. We can do that if you think it is more suitable. Do
> >> we all agree then?
> > 
> > I think reducing redundancy is always a good thing. Only having to
> > specify the string and extracting the required info from it would make
> > it easier for users I guess.
> > 
> > That whole string is sent to the kernel, right? So it wouldn't make
> > sense to split the fields it is made up from into separate properties in
> > JSON, correct?
> > 
> > Thanks, Phil
> > 
> 
> Yes, that makes sense. In this case, we don't need flags support anymore
> so it reduces the patch series. Should we continue with the
> implementation of the flags support or just forget about it until needed
> again?

What other flags do you have in mind?

Cheers, Phil
