From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: deprecate "flow table" syntax, replace it by
 "meter"
Date: Fri, 24 Nov 2017 15:03:02 +0100
Message-ID: <20171124140302.GA21727@salvia>
References: <20171123142322.6444-1-pablo@netfilter.org>
 <CAOkSjBgPMs=xWGYWizam9ttPRKJQyj9Frj1dmB2fcu7J47yp+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, rwhite@pobox.com,
        neal.p.murphy@alum.wpi.edu
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55306 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753751AbdKXODK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 09:03:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2AE96392E04
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:03:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A9D9DA86C
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2017 15:03:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgPMs=xWGYWizam9ttPRKJQyj9Frj1dmB2fcu7J47yp+g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 24, 2017 at 01:13:10PM +0100, Arturo Borrero Gonzalez wrote:
> On 23 November 2017 at 15:23, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > According to bugzilla 1137: "flow tables" should not be syntactically
> > unique.
> >
> > "Flow tables are always named, but they don't conform to the way sets,
> > maps, and dictionaries work in terms of "add" and "delete" and all that.
> >
> > They are also "flow tables" instead of one word like "flows" or
> > "throttle" or something.
> >
> > It seems weird to just have these break the syntactic expectations."
> >
> > Personally, I never liked the reference to "table" since we have very
> > specific semantics in terms of what a "table" is netfilter for long
> > time.
> >
> > This patch promotes "meter" as the new keyword. The former syntax is
> > still accepted for a while, just to reduce chances of breaking things.
> > At some point the former syntax will just be removed.
> >
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1137
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >
> 
> I agree.

Thanks, I just sent a few more patches to incrementally address what
this is describing.

> What about adding a warning in case of using the old syntax?
> Something like:
> 
> WARNING: this syntax is deprecated and will be deleted in the future,
> use 'meter' instead.

We can probably make a patch to add warnings on all things that we
plan to deprecate.

There are more things that we're just taking from the grammar to avoid
sudden breakages, it would take a bit of time to review the existing
grammar and spot them with a warning too.

After that, make a new 0.8.1 release asap, including --with-mini-gmp
fix if possible.
