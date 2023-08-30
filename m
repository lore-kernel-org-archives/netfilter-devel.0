Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449AFC83F01
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbjH3Six (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242270AbjH3HqM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 03:46:12 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440C2CD8
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 00:46:07 -0700 (PDT)
Received: from [78.30.34.192] (port=50674 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qbFtp-000rLM-Ii; Wed, 30 Aug 2023 09:46:04 +0200
Date:   Wed, 30 Aug 2023 09:46:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 5/5] datatype: check against negative "type" argument
 in datatype_lookup()
Message-ID: <ZO7zuKiWk3x7E5bS@calendula>
References: <20230829185509.374614-1-thaller@redhat.com>
 <20230829185509.374614-6-thaller@redhat.com>
 <ZO5Cnmck5tKCvVFE@calendula>
 <ZO5DsA4eCnYkEWxC@calendula>
 <c452805919f688f15a95e52139c8686e1a6571a1.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c452805919f688f15a95e52139c8686e1a6571a1.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 09:58:53PM +0200, Thomas Haller wrote:
> On Tue, 2023-08-29 at 21:14 +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 29, 2023 at 09:10:26PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Aug 29, 2023 at 08:54:11PM +0200, Thomas Haller wrote:
> > > > An enum can be either signed or unsigned (implementation
> > > > defined).
> > > > 
> > > > datatype_lookup() checks for invalid type arguments. Also check,
> > > > whether
> > > > the argument is not negative (which, depending on the compiler it
> > > > may
> > > > never be).
> > > > 
> > > > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > > > ---
> > > >  src/datatype.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/src/datatype.c b/src/datatype.c
> > > > index ba1192c83595..91735ff8b360 100644
> > > > --- a/src/datatype.c
> > > > +++ b/src/datatype.c
> > > > @@ -87,7 +87,7 @@ const struct datatype *datatype_lookup(enum
> > > > datatypes type)
> > > >  {
> > > >         BUILD_BUG_ON(TYPE_MAX & ~TYPE_MASK);
> > > >  
> > > > -       if (type > TYPE_MAX)
> > > > +       if ((uintmax_t) type > TYPE_MAX)
> > > 
> > >             uint32_t ?
> 
> The more straight forward way would be
> 
>     if (type < 0 || type > TYPE_MAX)
> 
> However, if the enum is unsigned, then the compiler might see that the
> condition is never true and warn against that. It does warn, if "type"
> were just an "unsigned int". I cannot actually reproduce a compiler
> warning with the enum (for now).

Then, better keep it back?

> The size of the enum is most likely int/unsigned (or smaller, with "-
> fshort-enums" or packed). Is it on POSIX/Linux always guaranteed that
> an int is 32bit? I think not, but I cannot find an architecture where
> int is larger either. Also, if someone would add an enum value larger
> than the 32 bit range, then the behavior is compiler dependent, but
> most likely the enum type would be a 64 bit integer and
> "uint"/"uint32_t" would not be the right check.

I don't expect to ever have such a large number of types. Specifically
because there are API restrictions that apply in this case.

> All of this is highly theoretical. But "uintmax_t" avoids all those
> problems and makes fewer assumptions on what the enum actually is. Is
> there a hypothetical scenario where it wouldn't work correctly?

I was trying to figure out what this is fixing.

> > Another question: What warning does clang print on this one?
> > Description does not specify.
> 
> this one isn't about a compiler warning. Sorry, I should not have
> included it in this set.

This TYPE_MAX will not ever become very large to require 64-bits.
With an implementation where enum is taken as signed, then this should
be sufficient too:

     if (type > TYPE_MAX)

If this is not fixing up anything right now, I would prefer to keep
this back.

I'll take this series except this one.

Thanks.
