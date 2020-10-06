Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C24C41604
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 091052068E
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 10:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgJFKNF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJFKNF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 06:13:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C953C061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 03:13:05 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kPjxv-0007oA-H1; Tue, 06 Oct 2020 12:13:03 +0200
Date:   Tue, 6 Oct 2020 12:13:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 1/3] libxtables: Make sure extensions register
 in revision order
Message-ID: <20201006101303.GM29050@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-2-phil@nwl.cc>
 <20201003111741.GA3035@salvia>
 <20201004145339.GE29050@orbyte.nwl.cc>
 <20201005224255.GA13440@salvia>
 <20201006092723.GJ29050@orbyte.nwl.cc>
 <20201006095047.GA17114@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006095047.GA17114@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 06, 2020 at 11:50:47AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 06, 2020 at 11:27:23AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Oct 06, 2020 at 12:42:55AM +0200, Pablo Neira Ayuso wrote:
> > > On Sun, Oct 04, 2020 at 04:53:39PM +0200, Phil Sutter wrote:
> > > > On Sat, Oct 03, 2020 at 01:17:41PM +0200, Pablo Neira Ayuso wrote:
> > > > > On Wed, Sep 23, 2020 at 12:53:39AM +0200, Phil Sutter wrote:
> > > > > > Insert extensions into pending lists in ordered fashion: Group by
> > > > > > extension name (and, for matches, family) and order groups by descending
> > > > > > revision number.
> > > > > >
> > > > > > This allows to simplify the later full registration considerably. Since
> > > > > > that involves kernel compatibility checks, the extra cycles here pay off
> > > > > > eventually.
> > > > > > 
> > > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > > ---
> > > > > >  libxtables/xtables.c | 64 +++++++++++++++++++++++++++++++++++++++-----
> > > > > >  1 file changed, 58 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > > > > > index 8907ba2069be7..63d0ea5def2d5 100644
> > > > > > --- a/libxtables/xtables.c
> > > > > > +++ b/libxtables/xtables.c
> > > > > > @@ -948,8 +948,14 @@ static void xtables_check_options(const char *name, const struct option *opt)
> > > > > >  		}
> > > > > >  }
> > > > > >  
> > > > > > +static int xtables_match_prefer(const struct xtables_match *a,
> > > > > > +				const struct xtables_match *b);
> > > > > > +
> > > > > >  void xtables_register_match(struct xtables_match *me)
> > > > > >  {
> > > > > > +	struct xtables_match **pos;
> > > > > > +	bool seen_myself = false;
> > > > > > +
> > > > > >  	if (me->next) {
> > > > > >  		fprintf(stderr, "%s: match \"%s\" already registered\n",
> > > > > >  			xt_params->program_name, me->name);
> > > > > > @@ -1001,10 +1007,32 @@ void xtables_register_match(struct xtables_match *me)
> > > > > >  	if (me->extra_opts != NULL)
> > > > > >  		xtables_check_options(me->name, me->extra_opts);
> > > > > >  
> > > > > > +	/* order into linked list of matches pending full registration */
> > > > > > +	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> > > > > > +		/* NOTE: No extension_cmp() here as we accept all families */
> > > > > > +		if (strcmp(me->name, (*pos)->name) ||
> > > > > > +		    me->family != (*pos)->family) {
> > > > > > +			if (seen_myself)
> > > > > > +				break;
> > > > > > +			continue;
> > > > > > +		}
> > > > > > +		seen_myself = true;
> > > > > > +		if (xtables_match_prefer(me, *pos) >= 0)
> > > > > 
> > > > > xtables_match_prefer() evaluates >= 0 if 'me' has higher revision
> > > > > number than *pos. So list order is: higher revision first.
> > > > 
> > > > Correct.
> > > > 
> > > > > > +			break;
> > > > > > +	}
> > > > > > +	if (!*pos)
> > > > > > +		pos = &xtables_pending_matches;
> > > > > >  
> > > > > > -	/* place on linked list of matches pending full registration */
> > > > > > -	me->next = xtables_pending_matches;
> > > > > > -	xtables_pending_matches = me;
> > > > > > +	me->next = *pos;
> > > > > 
> > > > > This line above is placing 'me' right before the existing match in the list.
> > > > 
> > > > Also correct. As stated in the description, xtables_pending_matches
> > > > should be grouped by name and family and within those groups ordered by
> > > > descending revision.
> > > > 
> > > > > > +	*pos = me;
> > > > > 
> > > > > This line above only works if *pos is &xtables_pending_matches?
> > > > 
> > > > This piece of code confused me at first, too. I even wrote a quick test
> > > > to make sure the pointer stuff works as intended. :D
> > > > 
> > > > In fact, *pos can't be &xtables_pending_matches: pos is type 'struct
> > > > xtables_match **' (note the double pointer). pos is either
> > > > &xtables_pending_matches or the address of the right position's previous
> > > > element's 'next' pointer. Still confusing, but the for-loop is clear:
> > > > 
> > > > | for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> > > > 
> > > > So by doing '*pos = me', the 'next' pointer value is changed (or the
> > > > value of xtables_pending_matches.
> > > 
> > > pos is always &xtables_pending_matches:
> > > 
> > > - The first element in the array finds no matching, then:
> > > 
> > >         if (!*pos)
> > >                pos = &xtables_pending_matches;
> > > 
> > >   kicks in and and pos is set to &xtables_pending_matches, so this is
> > >   inserted in the first position of the xtables_pending_matches.
> > > 
> > > - The follow up element in the array (higher revision) finds itself at
> > >   the very beginning of the iteration, so pos here is
> > >   &xtables_pending_matches too.
> > > 
> > > So *pos = me; is always updating the next pointer in the
> > > xtables_pending_matches.
> > 
> > This is true only if you assume the ordering of arrays passed to the
> > function. But you can't since it's an exported library function. Also,
> > there are already cases where the above does not hold due to the
> > grouping by name *and* family value. Apply the patch, build with
> > -DDEBUG, add a rule with connlimit match and you'll see.
> 
> If you can insert entries in the middle of the list, before an
> existing node, assuming
> 
>         pos = &(*pos)->next
> 
> then
> 
>         *pos = me;
> 
> is updating the ->next pointer of the existing entry in the list to
> 'me' (appending).
> 
> But the existing entry is actually placed after the new one (inserting).
> 
>         me->next = *pos;
> 
> do I need more coffee here?

Seems so! :D

I am always inserting me before *pos. The for-loop searches the relevant
group first (by comparing name and family). If found, 'seen_myself' is
set to true. Within that group, xtables_match_prefer() serves in finding
the first element which is less preferred than 'me'. At that point we
break and insert. If no less preferred one is found, due to
'seen_myself' the loop breaks at the first item no longer belonging to
the own group. If the own group is not found at all (i.e., we insert the
first item in that group), the insert is done up front (replacing
xtables_pending_matches value) because we assume more group members to
come and so the for-loop does not have to iterate over all other groups.

> > I found a bug, though: When inserting same name and family extensions in
> > descending revision order, for all consecutive extensions the for-loop
> > never breaks and the 'if (!*pos)' clause inserts the new (lowest)
> > revision into the beginning. The fix is trivial though.
> 
> Just to clarify: You assume that input array does _not_ need to be
> sorted from lower to higher, correct? This was not obvious to me.

Put more simply: I'm not assuming *any* ordering in input, not even
grouped input by name. But I chose the algorithm to optimize for input
which is grouped by name and family and sorted by ascending revision
within groups, as that is mostly the case in in-tree extensions.

Cheers, Phil
