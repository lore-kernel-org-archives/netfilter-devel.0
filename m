Return-Path: <SRS0=OxIk=DL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0D3C4363C
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 14:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BD4206B6
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Oct 2020 14:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgJDOxp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Oct 2020 10:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDOxp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Oct 2020 10:53:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ACEC0613CE
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2020 07:53:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kP5ON-0005pW-QF; Sun, 04 Oct 2020 16:53:39 +0200
Date:   Sun, 4 Oct 2020 16:53:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 1/3] libxtables: Make sure extensions register
 in revision order
Message-ID: <20201004145339.GE29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-2-phil@nwl.cc>
 <20201003111741.GA3035@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003111741.GA3035@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Oct 03, 2020 at 01:17:41PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 23, 2020 at 12:53:39AM +0200, Phil Sutter wrote:
> > Insert extensions into pending lists in ordered fashion: Group by
> > extension name (and, for matches, family) and order groups by descending
> > revision number.
> >
> > This allows to simplify the later full registration considerably. Since
> > that involves kernel compatibility checks, the extra cycles here pay off
> > eventually.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  libxtables/xtables.c | 64 +++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 58 insertions(+), 6 deletions(-)
> > 
> > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > index 8907ba2069be7..63d0ea5def2d5 100644
> > --- a/libxtables/xtables.c
> > +++ b/libxtables/xtables.c
> > @@ -948,8 +948,14 @@ static void xtables_check_options(const char *name, const struct option *opt)
> >  		}
> >  }
> >  
> > +static int xtables_match_prefer(const struct xtables_match *a,
> > +				const struct xtables_match *b);
> > +
> >  void xtables_register_match(struct xtables_match *me)
> >  {
> > +	struct xtables_match **pos;
> > +	bool seen_myself = false;
> > +
> >  	if (me->next) {
> >  		fprintf(stderr, "%s: match \"%s\" already registered\n",
> >  			xt_params->program_name, me->name);
> > @@ -1001,10 +1007,32 @@ void xtables_register_match(struct xtables_match *me)
> >  	if (me->extra_opts != NULL)
> >  		xtables_check_options(me->name, me->extra_opts);
> >  
> > +	/* order into linked list of matches pending full registration */
> > +	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> > +		/* NOTE: No extension_cmp() here as we accept all families */
> > +		if (strcmp(me->name, (*pos)->name) ||
> > +		    me->family != (*pos)->family) {
> > +			if (seen_myself)
> > +				break;
> > +			continue;
> > +		}
> > +		seen_myself = true;
> > +		if (xtables_match_prefer(me, *pos) >= 0)
> 
> xtables_match_prefer() evaluates >= 0 if 'me' has higher revision
> number than *pos. So list order is: higher revision first.

Correct.

> > +			break;
> > +	}
> > +	if (!*pos)
> > +		pos = &xtables_pending_matches;
> >  
> > -	/* place on linked list of matches pending full registration */
> > -	me->next = xtables_pending_matches;
> > -	xtables_pending_matches = me;
> > +	me->next = *pos;
> 
> This line above is placing 'me' right before the existing match in the list.

Also correct. As stated in the description, xtables_pending_matches
should be grouped by name and family and within those groups ordered by
descending revision.

> > +	*pos = me;
> 
> This line above only works if *pos is &xtables_pending_matches?

This piece of code confused me at first, too. I even wrote a quick test
to make sure the pointer stuff works as intended. :D

In fact, *pos can't be &xtables_pending_matches: pos is type 'struct
xtables_match **' (note the double pointer). pos is either
&xtables_pending_matches or the address of the right position's previous
element's 'next' pointer. Still confusing, but the for-loop is clear:

| for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {

So by doing '*pos = me', the 'next' pointer value is changed (or the
value of xtables_pending_matches.

> Looking at the in-tree extensions, they are always ordered from lower
> to higher (in array definitions).

This is in favor of the sorting algorithm: Inserting revision N+1 will
find revision N first in its group if revisions 0..N were inserted
before. So having extension revisions ordered ascending in their array
is optimal.

Cheers, Phil
