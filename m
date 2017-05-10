From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2] List handles of added rules if requested
Date: Wed, 10 May 2017 10:17:45 +0200
Message-ID: <20170510081745.GP20805@orbyte.nwl.cc>
References: <20170505143323.29654-1-phil@nwl.cc>
 <20170508173109.GA32191@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56359 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752511AbdEJIRs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 04:17:48 -0400
Content-Disposition: inline
In-Reply-To: <20170508173109.GA32191@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 08, 2017 at 07:31:09PM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 05, 2017 at 04:33:23PM +0200, Phil Sutter wrote:
> > Being able to retrieve an added rule's handle atomically is a crucial
> > feature for scripts invoking nft command: Without it, there is no way to
> > be sure a handle extracted from 'nft list ruleset' command actually
> > refers to the rule one has added before or that of another process which
> > ran in between.
> > 
> > Extracting an added rule's handle itself is not an easy task already,
> > since there is a chance that a given rule is printed differently than
> > when it was added before. A simple example is port number vs. service
> > name:
> > 
> > | nft add rule ip t c tcp dport { ssh, 80 } accept
> > 
> > There is no way to make 'nft list ruleset' return the rule just like
> > this as depending on whether '-nn' was given or not, it either prints
> > the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
> > that was used when adding it.
> > 
> > This patch prints an identifying string for each added rule which may be
> > used as single parameter to a later 'nft delete rule' command. So a
> > simple scripting example looks like this:
> > 
> > | handle=$(nft add rule ip t c counter)
> > | ...
> > | nft delete rule $handle
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v1:
> > - Pass NLM_F_ECHO to kernel to leverage already existing reporting
> >   infrastructure and therefore not require a seperate kernel patch.
> > - Limit mnl_callback() action to NEWRULE messages - when replacing a
> >   rule, it would otherwise print the deleted rule as well.
> 
> This does not work for nft -i.

It does, if I pass '-a' along with '-i':

| % sudo ./src/nft -i -a
| nft> replace rule ip t c handle 2 counter accept
| ip t c handle 2
| nft> 

Or should this behave differently then in your opinion?

Thanks, Phil
