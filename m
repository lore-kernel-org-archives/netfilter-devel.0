Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCA6C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 17:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8126921473
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 17:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfCRRnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:43:10 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:60922 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfCRRmx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 13:42:53 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h5wHb-0005Rd-2A; Mon, 18 Mar 2019 18:42:43 +0100
Date:   Mon, 18 Mar 2019 18:42:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190318174243.GT4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315171328.c5xgazye2hattjxr@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Mar 15, 2019 at 06:13:28PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Mar 15, 2019 at 11:03:33AM +0100, Phil Sutter wrote:
> [...]
> > On Thu, Mar 14, 2019 at 09:07:37PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > The osf expression returns a string with the OS genre, and if thev
> > > version flag is set on, it appends the version to this string, ie.
> > > genre + version.
> > > 
> > > This allows us to build maps, ie.
> > > 
> > >         meta mark set osf genre { "linux" : 0x10, "windows" : 0x20, "macos" : 0x40 }
> > > 
> > > But, with this new version, you could also do:
> > > 
> > >         meta mark set osf genre { "linux::4.0" : 0x11, "linux::3.0" : 0x12, ...}
> > > 
> > > and so on.
> > > 
> > > So I see this version thing as a extended matching.
> > > 
> > > The osf engine actually _already_ finds a precise matching, ie. genre
> > > + version, since the fingerprint is per genre + version. But you can
> > > just decide to match on the genre (eg. linux).
> > 
> > The problem we're facing IMO is that nft_cmp is limited to a simple
> > memcmp(). This demands LHS to know what RHS contains. I'm not implying
> > it would be a good idea, but imagine nft_cmp could handle wildcards, we
> > could use "linux:*" to match on genre only, "linux:4.0:*" to match on
> > genre and version and even "linux:4.*" to match genre and major version
> > number.
> >
> > Actually we might be able to implement the above by setting 'len' field
> > correctly.
> 
> The wildcard at the end of the string already works out of the box
> via:
> 
>         iifname eth\*
> 
> The wildcard matching is generic, so it can be used from any string
> datatype, including the osf expression.

For osf expression, I guess we would want to add it implicitly in
userspace.

> > > > Applying the same logic to osf expression, we would implement 'osf name
> > > > foo osf version 3.141' and add 'osf_try_merge()' routine to
> > > > 'rule_postprocess()' which tries to combine the two statements.
> > > > Obviously, this is quite a bit of extra work, not sure if feasible.
> > > 
> > > I think the discussion here is the syntax, ie.
> > > 
> > >         osf genre "Linux::4.10"
> > > 
> > > vs.
> > > 
> > >         osf genre "Linux" version "4.10"
> > > 
> > > This only requires changes to the userspace nftables side, if you
> > > prefer this syntax, which is what I understand you would like to see,
> > > right?
> > 
> > Not quite. I like how osf is an expression, not a statement. This makes
> > things like 'osf name != "Linux"' possible. What I didn't like was how
> > the proposed extension requires users to input redundant info:
> > 
> > | osf name version "Linux:4.20"
> > 
> > RHS contains the version number, so LHS should not need to have
> > "version" explicitly stated.
> 
> I see, then part of your discussion is focused on this syntax:
> 
>         osf name version "Linux:4.20"
> 
> in order to remove the "version" keyword there and make it more
> compact.

I really don't think it's needed. The only reason for it I can see is
supporting a use-case where users pass "Linux:4.20" on RHS but actually
don't want to match on version, but they could just omit it in the first
place then.

> > On Thu, Mar 14, 2019 at 09:13:09PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > I think we could even extend this later on to match things like:
> > > 
> > > # Popular cluster config scripts disable timestamps and
> > > # selective ACK:
> > > S4:64:1:48:M1460,N,W0:          Linux:2.4:cluster:Linux 2.4 in cluster
> > >                                 ^^^^^^^^^^^^^^^^^
> > > Then, do:
> > > 
> > >         os gente "Linux:2.4:cluster"
> > > 
> > > by adding a new flag to match the "Subtype" field (according to the
> > > file description in pf.os).
> > 
> > In an ideal world, we could match on any (combination of) fields in the
> > database. I am aware this is probably over-engineering. :)
> 
> We can probably achieve this with a more advance nft_cmp expression,
> that allows us to do some sort of limited regex matching. But I agree
> in that adding this only for the osf expression is probably too much.
> I don't like regex, they will use it for layer-7, and users do not
> understand the computational complexity of the regular expressions
> (they can easily ruin performance by adding a few expression that need
> to be search all over the packet payload).
> 
> Anyway, this is a different topic :-).

Yes, no point in making this widely used expression more complicated
just for a case nobody uses eventually. :)

> > What we could do though with little effort is to make use of the OS info
> > structure in database by making use of nft_cmp comparing only the first
> > 'len' bytes of data in registers. My idea would be that:
> > 
> > * 'osf' expression always returns "full" data, i.e.: "OS:VER:SUB"
> > * nft_cmp compares that string to RHS up to RHS length
> > 
> > So let's assume DB lookup returns "Windows:2003:AS:", then:
> > 
> > osf name "Windows" -> match
> > osf name "Windows:" -> match
> > osf name "Windows:XP:" -> no match
> > osf name "Windows:2000:" -> no match
> > osf name "Windows:200" -> match
> > 
> > So we have optional version match and even a poor-man's wildcard
> > functionality. Specifying the trailing semi-colon implicitly causes an
> > exact match on the last field.
> > 
> > What do you think?
> 
> Hm, if we follow this path, this would need a bit more work, note
> that:
> 
> * nft userspace currently compares 16 bytes for the string case,
>   according to what I see via --debug=mnl.

This is because osf_expr_alloc() sets expr->len to NFT_OSF_MAXGENRELEN *
BITS_PER_BYTE (with NFT_OSF_MAXGENRELEN being defined to 16 in
include/linux/netfilter/nf_tables.h).

> * When the string is less than 16 bytes, it assumes it is a wildcard
>   matching and the end of the string.

I guess that's because RHS length is then smaller than LHS?

> * Kernel would need to inconditionally build the OS:version string.

Yes, exactly. nft_osf.c would return "OS:version:subtype:opt" and
nft_cmp.c will do the right thing if nft_cmp_expr->len is set to RHS
length.

> * We may need to ask users to break existing osf ruleset so they
>   explicitly add the wildcard at the end, ie.
> 
>         osf name "Windows\*"
>         osf name "Linux:4.\*"

Not if cmp expr len is set correctly.

> And the kernel would have no notion of what userspace is willing to
> match.

Yes, it boils down to a string comparison. Do you see a downside in
that?

> If the problem is the syntax, not the NFT_OSF_F_VERSION flags, we
> could explore this syntax:
> 
>         osf genre "Linux"
>         osf version "Linux:4.20"
> 
> then, in the future (if ever needed) add subtypes:
> 
>         osf subtype "Linux:2.4:cluster"

IMHO this is still redundant: RHS contains <something>:<something>, user
wants to match on OS and version. RHS contains <sth>:<sth>:<sth>, user
wants to match on OS, version and subtype.

> With flags in place, we would have a bit of knowledge of what the user
> is doing vs. matching part of a string.

Yes, but I don't see where this would be beneficial. Maybe in optimizing
redundant expressions? Like

| osf name "Linux" osf version "Linux:4.20"

but it's not a big deal. With my approach described above, userspace
could compare both RHS strings:

* if memcmp(str1, str2, min(len1, len2) != 0 rule will never match
* else keep only the expression with longer RHS.

Cheers, Phil
