Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BD4C001DC
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jul 2023 10:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjGUKAX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jul 2023 06:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjGUKAQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jul 2023 06:00:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B84F30DD
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jul 2023 02:59:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qMmvT-0007v5-RO; Fri, 21 Jul 2023 11:59:55 +0200
Date:   Fri, 21 Jul 2023 11:59:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        igor@gooddata.com
Subject: Re: [iptables PATCH 1/3] extensions: libebt_among: Fix for false
 positive match comparison
Message-ID: <ZLpXG2GzqH3QLveA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        igor@gooddata.com
References: <20230715125928.18395-1-phil@nwl.cc>
 <20230715125928.18395-2-phil@nwl.cc>
 <ZLUg97WtqnWR6aqT@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZLUg97WtqnWR6aqT@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo,

On Mon, Jul 17, 2023 at 01:07:35PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 15, 2023 at 02:59:26PM +0200, Phil Sutter wrote:
> > When comparing matches for equality, trailing data in among match is not
> > considered. Therefore two matches with identical pairs count may be
> > treated as identical when the pairs actually differ.
> 
> By "trailing data", you mean the right-hand side of this?
> 
>         fe:ed:ba:be:00:01=10.0.0.1
> 
> > Matches' parsing callbacks have no access to the xtables_match itself,
> > so can't update userspacesize field as needed.
> > 
> > To fix this, extend struct nft_among_data by a hash field to contain a
> > DJB hash of the trailing data.
> 
> Is this DJB hash use subject to collisions?

Thanks for the heads-up. I suspected DJB hash algo might not be perfect
when it comes to collisions, but "good enough" for the task. In fact,
collisions are pretty common, so this approach is not a proper solution
to the problem.

Searching for other ways to fix the issue, I noticed that
compare_matches() was deliberately changed to compare only the first
'userspacesize' bytes of extensions to avoid false-negatives caused by
kernel-internals in extension data.

I see two different solutions and would like to hear your opinion. First
one is a hack, special treatment for among match in compare_matches():

| @@ -381,6 +381,7 @@ bool compare_matches(struct xtables_rule_match *mt1,
|         for (mp1 = mt1, mp2 = mt2; mp1 && mp2; mp1 = mp1->next, mp2 = mp2->next) {
|                 struct xt_entry_match *m1 = mp1->match->m;
|                 struct xt_entry_match *m2 = mp2->match->m;
| +               size_t cmplen = mp1->match->userspacesize;
|  
|                 if (strcmp(m1->u.user.name, m2->u.user.name) != 0) {
|                         DEBUGP("mismatching match name\n");
| @@ -392,8 +393,10 @@ bool compare_matches(struct xtables_rule_match *mt1,
|                         return false;
|                 }
|  
| -               if (memcmp(m1->data, m2->data,
| -                          mp1->match->userspacesize) != 0) {
| +               if (!strcmp(m1->u.user.name, "among"))
| +                       cmplen = m1->u.match_size - sizeof(*m1);
| +
| +               if (memcmp(m1->data, m2->data, cmplen) != 0) {
|                         DEBUGP("mismatch match data\n");
|                         return false;
|                 }

The second one is more generic, reusing extensions' 'udata' pointer. One
could make xtables_option_{m,t}fcall() functions zero the scratch area
if present (so locally created extensions match ones fetched from
kernel) and compare that scratch area in compare_matches(). For among
match, using the scratch area to store pairs is fine.

Cheers, Phil
