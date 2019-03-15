Return-Path: <SRS0=WWTr=RS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49019C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1751A2184C
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbfCOKDh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:03:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:52634 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbfCOKDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 06:03:37 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h4jgb-0003bC-SL; Fri, 15 Mar 2019 11:03:33 +0100
Date:   Fri, 15 Mar 2019 11:03:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190315100333.GD3511@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Batching messages here since I'm apparently too slow in replying. :)

On Thu, Mar 14, 2019 at 07:24:23PM +0100, Fernando Fernandez Mancera wrote:
> El 14 de marzo de 2019 18:34:54 CET, Phil Sutter <phil@nwl.cc> escribió:
> >On Thu, Mar 14, 2019 at 02:58:40PM +0100, Pablo Neira Ayuso wrote:
> >> On Thu, Mar 14, 2019 at 12:14:23PM +0100, Fernando Fernandez Mancera
> >wrote:
> >> > I have been thinking more about this today. I don't know how access
> >to
> >> > the right-hand-side string from the kernel if it is possible. Sorry
> >if
> >> > the question is very dumb, but I may lack experience with the nft
> >> > registers and RHS data of an expression.
> >> 
> >> I think you can hide flags from json, which is what Phil suggests, I
> >> mean, just infer version flags from the syntax, ie. if
> >> "genre::version" is used, then set of the version flag.
> >> 
> >> I think Phil is not suggesting kernel changes.
> 
> That makes sense to me.

In general, I think we should not deviate too much in both APIs. Also, a
bit more complicated syntax is less of a problem in JSON, while OTOH I
think spending a few extra cycles on keeping CLI syntax as simple as
possible is worth doing.

> >Assuming the above is correct, my suggestion of making the flag option
> >implicit does not quite hold, at least not without painful
> >postprocessing of relational statement in userspace.
> >
> >Right now this all seems to me like enabling multiple comparisons
> >within
> >a single relational, i.e. one for genre and the other for version.
> >Nftables doesn't quite do such things. E.g. matching on two TCP header
> >fields requires two relationals, e.g. 'tcp dport 22 tcp sport > 1024'.
> >Internally then, these two statements may be combined into a single
> >payload match if suitable.
> 
> I think in this case we can't do that. In my opinion it doesn't make sense to evaluate only the version without the OS genre. Do you agree? Thanks!

Well, I guess we could but the question is indeed if we want to. In
general, I tend to leave the decision what makes sense and what not to
the user. Although a bit sloppy, something like 'osf version "XP"' might
be a valuable shortcut for some.

On Thu, Mar 14, 2019 at 09:07:37PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 14, 2019 at 06:34:54PM +0100, Phil Sutter wrote:
[...]
> > Actually I'm still in the process of understanding how all this works.
> > What I got so far is (correct me if I'm wrong): osf expr does the
> > fingerprinting and returns a string which relational expr compares to
> > right-hand side. This new version flag defines whether osf expr adds the
> > version to returned string or not.
> > 
> > Assuming the above is correct, my suggestion of making the flag option
> > implicit does not quite hold, at least not without painful
> > postprocessing of relational statement in userspace.
> > 
> > Right now this all seems to me like enabling multiple comparisons within
> > a single relational, i.e. one for genre and the other for version.
> > Nftables doesn't quite do such things. E.g. matching on two TCP header
> > fields requires two relationals, e.g. 'tcp dport 22 tcp sport > 1024'.
> > Internally then, these two statements may be combined into a single
> > payload match if suitable.
> 
> The osf expression returns a string with the OS genre, and if the
> version flag is set on, it appends the version to this string, ie.
> genre + version.
> 
> This allows us to build maps, ie.
> 
>         meta mark set osf genre { "linux" : 0x10, "windows" : 0x20, "macos" : 0x40 }
> 
> But, with this new version, you could also do:
> 
>         meta mark set osf genre { "linux::4.0" : 0x11, "linux::3.0" : 0x12, ...}
> 
> and so on.
> 
> So I see this version thing as a extended matching.
> 
> The osf engine actually _already_ finds a precise matching, ie. genre
> + version, since the fingerprint is per genre + version. But you can
> just decide to match on the genre (eg. linux).

The problem we're facing IMO is that nft_cmp is limited to a simple
memcmp(). This demands LHS to know what RHS contains. I'm not implying
it would be a good idea, but imagine nft_cmp could handle wildcards, we
could use "linux:*" to match on genre only, "linux:4.0:*" to match on
genre and version and even "linux:4.*" to match genre and major version
number.

Actually we might be able to implement the above by setting 'len' field
correctly.

> > Applying the same logic to osf expression, we would implement 'osf name
> > foo osf version 3.141' and add 'osf_try_merge()' routine to
> > 'rule_postprocess()' which tries to combine the two statements.
> > Obviously, this is quite a bit of extra work, not sure if feasible.
> 
> I think the discussion here is the syntax, ie.
> 
>         osf genre "Linux::4.10"
> 
> vs.
> 
>         osf genre "Linux" version "4.10"
> 
> This only requires changes to the userspace nftables side, if you
> prefer this syntax, which is what I understand you would like to see,
> right?

Not quite. I like how osf is an expression, not a statement. This makes
things like 'osf name != "Linux"' possible. What I didn't like was how
the proposed extension requires users to input redundant info:

| osf name version "Linux:4.20"

RHS contains the version number, so LHS should not need to have
"version" explicitly stated.

On Thu, Mar 14, 2019 at 09:13:09PM +0100, Pablo Neira Ayuso wrote:
[...]
> I think we could even extend this later on to match things like:
> 
> # Popular cluster config scripts disable timestamps and
> # selective ACK:
> S4:64:1:48:M1460,N,W0:          Linux:2.4:cluster:Linux 2.4 in cluster
>                                 ^^^^^^^^^^^^^^^^^
> Then, do:
> 
>         os gente "Linux:2.4:cluster"
> 
> by adding a new flag to match the "Subtype" field (according to the
> file description in pf.os).

In an ideal world, we could match on any (combination of) fields in the
database. I am aware this is probably over-engineering. :)

What we could do though with little effort is to make use of the OS info
structure in database by making use of nft_cmp comparing only the first
'len' bytes of data in registers. My idea would be that:

* 'osf' expression always returns "full" data, i.e.: "OS:VER:SUB"
* nft_cmp compares that string to RHS up to RHS length

So let's assume DB lookup returns "Windows:2003:AS:", then:

osf name "Windows" -> match
osf name "Windows:" -> match
osf name "Windows:XP:" -> no match
osf name "Windows:2000:" -> no match
osf name "Windows:200" -> match

So we have optional version match and even a poor-man's wildcard
functionality. Specifying the trailing semi-colon implicitly causes an
exact match on the last field.

What do you think?

Cheers, Phil
