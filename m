Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B24C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 22:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31A23206C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 22:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgJEWnB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 18:43:01 -0400
Received: from correo.us.es ([193.147.175.20]:48946 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJEWnA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 18:43:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F4A2D28C4
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 00:42:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ED6CDA73F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 00:42:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44596DA722; Tue,  6 Oct 2020 00:42:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E586EDA704;
        Tue,  6 Oct 2020 00:42:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Oct 2020 00:42:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CA5A142EF42A;
        Tue,  6 Oct 2020 00:42:55 +0200 (CEST)
Date:   Tue, 6 Oct 2020 00:42:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: Re: [iptables PATCH 1/3] libxtables: Make sure extensions register
 in revision order
Message-ID: <20201005224255.GA13440@salvia>
References: <20200922225341.8976-1-phil@nwl.cc>
 <20200922225341.8976-2-phil@nwl.cc>
 <20201003111741.GA3035@salvia>
 <20201004145339.GE29050@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201004145339.GE29050@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 04, 2020 at 04:53:39PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Sat, Oct 03, 2020 at 01:17:41PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 23, 2020 at 12:53:39AM +0200, Phil Sutter wrote:
> > > Insert extensions into pending lists in ordered fashion: Group by
> > > extension name (and, for matches, family) and order groups by descending
> > > revision number.
> > >
> > > This allows to simplify the later full registration considerably. Since
> > > that involves kernel compatibility checks, the extra cycles here pay off
> > > eventually.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  libxtables/xtables.c | 64 +++++++++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 58 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> > > index 8907ba2069be7..63d0ea5def2d5 100644
> > > --- a/libxtables/xtables.c
> > > +++ b/libxtables/xtables.c
> > > @@ -948,8 +948,14 @@ static void xtables_check_options(const char *name, const struct option *opt)
> > >  		}
> > >  }
> > >  
> > > +static int xtables_match_prefer(const struct xtables_match *a,
> > > +				const struct xtables_match *b);
> > > +
> > >  void xtables_register_match(struct xtables_match *me)
> > >  {
> > > +	struct xtables_match **pos;
> > > +	bool seen_myself = false;
> > > +
> > >  	if (me->next) {
> > >  		fprintf(stderr, "%s: match \"%s\" already registered\n",
> > >  			xt_params->program_name, me->name);
> > > @@ -1001,10 +1007,32 @@ void xtables_register_match(struct xtables_match *me)
> > >  	if (me->extra_opts != NULL)
> > >  		xtables_check_options(me->name, me->extra_opts);
> > >  
> > > +	/* order into linked list of matches pending full registration */
> > > +	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> > > +		/* NOTE: No extension_cmp() here as we accept all families */
> > > +		if (strcmp(me->name, (*pos)->name) ||
> > > +		    me->family != (*pos)->family) {
> > > +			if (seen_myself)
> > > +				break;
> > > +			continue;
> > > +		}
> > > +		seen_myself = true;
> > > +		if (xtables_match_prefer(me, *pos) >= 0)
> > 
> > xtables_match_prefer() evaluates >= 0 if 'me' has higher revision
> > number than *pos. So list order is: higher revision first.
> 
> Correct.
> 
> > > +			break;
> > > +	}
> > > +	if (!*pos)
> > > +		pos = &xtables_pending_matches;
> > >  
> > > -	/* place on linked list of matches pending full registration */
> > > -	me->next = xtables_pending_matches;
> > > -	xtables_pending_matches = me;
> > > +	me->next = *pos;
> > 
> > This line above is placing 'me' right before the existing match in the list.
> 
> Also correct. As stated in the description, xtables_pending_matches
> should be grouped by name and family and within those groups ordered by
> descending revision.
> 
> > > +	*pos = me;
> > 
> > This line above only works if *pos is &xtables_pending_matches?
> 
> This piece of code confused me at first, too. I even wrote a quick test
> to make sure the pointer stuff works as intended. :D
> 
> In fact, *pos can't be &xtables_pending_matches: pos is type 'struct
> xtables_match **' (note the double pointer). pos is either
> &xtables_pending_matches or the address of the right position's previous
> element's 'next' pointer. Still confusing, but the for-loop is clear:
> 
> | for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
> 
> So by doing '*pos = me', the 'next' pointer value is changed (or the
> value of xtables_pending_matches.

pos is always &xtables_pending_matches:

- The first element in the array finds no matching, then:

        if (!*pos)
               pos = &xtables_pending_matches;

  kicks in and and pos is set to &xtables_pending_matches, so this is
  inserted in the first position of the xtables_pending_matches.

- The follow up element in the array (higher revision) finds itself at
  the very beginning of the iteration, so pos here is
  &xtables_pending_matches too.

So *pos = me; is always updating the next pointer in the
xtables_pending_matches.

Same picture you're describing? I just found a bit confusing that this
is using *pos = me to refresh xtables_pending_matches, probably you
can just use

xtables_pending_matches = me;

I would add a bug check somewhere too in case that an extension is
not inserted in the first position, *pos = me won't work in that case.

May I suggest you please extend the commit message a bit to describe
this logic?

> > Looking at the in-tree extensions, they are always ordered from lower
> > to higher (in array definitions).
> 
> This is in favor of the sorting algorithm: Inserting revision N+1 will
> find revision N first in its group if revisions 0..N were inserted
> before. So having extension revisions ordered ascending in their array
> is optimal.

This is optimizing userspace for more recent kernels, that sounds
reasonable.
