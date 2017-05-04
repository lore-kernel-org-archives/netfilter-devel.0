From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Fri, 5 May 2017 00:38:31 +0200
Message-ID: <20170504223831.GE20805@orbyte.nwl.cc>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia>
 <20170504134419.GG13320@breakpoint.cc>
 <4d219738-b12e-3c33-7ba3-bcb54b82bf2a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57373 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752536AbdEDWid (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 18:38:33 -0400
Content-Disposition: inline
In-Reply-To: <4d219738-b12e-3c33-7ba3-bcb54b82bf2a@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 04, 2017 at 05:37:25PM +0200, Thomas Woerner wrote:
> On 05/04/2017 03:44 PM, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> On Thu, May 04, 2017 at 02:34:21PM +0200, Phil Sutter wrote:
> >>> Being able to retrieve an added rule's handle atomically is a crucial
> >>> feature for scripts invoking nft command: Without it, there is no way to
> >>> be sure a handle extracted from 'nft list ruleset' command actually
> >>> refers to the rule one has added before or that of another process which
> >>> ran in between.
> >>>
> >>> Extracting an added rule's handle itself is not an easy task already,
> >>> since there is a chance that a given rule is printed differently than
> >>> when it was added before. A simple example is port number vs. service
> >>> name:
> >>>
> >>> | nft add rule ip t c tcp dport { ssh, 80 } accept
> >>>
> >>> There is no way to make 'nft list ruleset' return the rule just like
> >>> this as depending on whether '-nn' was given or not, it either prints
> >>> the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
> >>> that was used when adding it.
> >>>
> >>> This patch prints an identifying string for each added rule which may be
> >>> used as single parameter to a later 'nft delete rule' command. So a
> >>> simple scripting example looks like this:
> >>>
> >>> | handle=$(nft add rule ip t c counter)
> >>
> >> This is a hack.
> >>
> >> We should follow the rule description path.
> > 
> > You mean delete-by-name?
> > 
> > Its just as ugly, just a different kind of ugly.
> > 
> Delete by name for rules would be an atomic operation. The solution above is 
> not as two calls are needed to remove one rule. Saving the handles while the 
> rule has been added is not possible all the time and will most likely require 
> bigger changes in several projects.

This was not the aspect I was talking about when mentioning missing
atomicity: I didn't have the delete by description approach in mind at
all, and looking at delete by handle the problem is that it requires a
non-atomic operation to add a rule and retrieve it's handle.

With the proposed solution in place, if you take care to collect the
handles for the rules you're adding along the way, you can be sure
you're later deleting exactly the rule you've added before.

But I agree with you in that the situation right now is really messy:
Add a rule, call 'nft -a list ruleset' and then have fun parsing the
output and searching for your rule. I guess pretty much anything is
better than that. :)

> I also do not understand why delete by name is possible for tables, chains and 
> sets but not for rules.

I didn't design all this, but I guess an explanation would be that table
names and the combination of table name and chain name are unique, while
the rule description is not.

Cheers, Phil
