From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] Enable automerge feature for anonymous sets
Date: Wed, 7 Feb 2018 10:53:36 +0100
Message-ID: <20180207095336.GK2285@orbyte.nwl.cc>
References: <20180206181847.14434-1-phil@nwl.cc>
 <20180206233943.6shg7qeg2mg6u2gg@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Jeff Kletsky <netfilter@allycomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49514 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeBGJxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 04:53:39 -0500
Content-Disposition: inline
In-Reply-To: <20180206233943.6shg7qeg2mg6u2gg@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Feb 07, 2018 at 12:39:43AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 06, 2018 at 07:18:47PM +0100, Phil Sutter wrote:
> > Automatic merging of adjacent/overlapping ranges upon insertion has
> > clear benefits performance- and readability-wise. The drawbacks which
> > led to disabling it by default don't apply to anonymous sets since they
> > are read-only anyway, so enable this feature for them again.
> 
> Question is, why someone would be adding elements with overlapping
> ranges in an anonymous set? Then, when listing the ruleset you will
> get something different to what you've added. This would also be
> inconsistent with regards to the existing behaviour in named sets,
> where this is turned off by default.

Recapping the pros and cons of automatic merging the discussion brought
up (I probably miss some):

+ Overlaps may be hard to spot (and avoid) if they sit in different
  defines used to fill a single set.

- Items added to a set can't be removed again if they were merged with
  others added at the same time.

>From those, I assume that if one uses defines to manage e.g. white/black
lists, a named set is probably not used either. The con above applies
only to named sets since anonymous ones can't be changed. Therefore I
considered automatic merging happening in anonymous sets to be
desirable.

> For named sets, that are useful to maintain white/blacklists, I
> understand this simplifies complexity for people dealing with them.
> But not sure for anonymous sets.

I'm not entirely sure about that since there are multiple ways to see
things. AFAIR, Jeff's point was when he combines set elements from
different sources he doesn't want to check them manually for potential
overlaps (or even can't). So there automatic merging is a good thing. If
my fail2ban script can't delete a range previously added after it
timeouts, it fails and recovery is not trivial (find the merged element
and divide it again). Here, merging is a bad thing. Overall though, I
wonder whether using interval sets for white/black lists isn't a bad
idea at all. :)

> @Jeff: Is this also useful to you in the anonymous set use-case? IIRC
> we agreed that this was good for named sets, but not for anonymous
> sets.

I'm curious to hearing his thoughts as well.

Cheers, Phil
