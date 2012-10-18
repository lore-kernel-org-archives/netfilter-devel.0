From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Thu, 18 Oct 2012 22:38:09 +0200
Message-ID: <20121018203809.GA18674@breakpoint.cc>
References: <1350577344-16321-1-git-send-email-fw@strlen.de>
 <20121018165104.GA15142@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48157 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401Ab2JRUiL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:38:11 -0400
Content-Disposition: inline
In-Reply-To: <20121018165104.GA15142@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > When users wish to annotate connections with extra information,
> > (e.g. "connection came in on interface eth1"), the only way of doing so
> > at the moment is using connmarks.
> > 
[..]
> > This patch essentially adds a kernel store of (user-defined) label names.
> > Users can then assign these names to connections, with as many names per
> > connection as desired (current - arbitrarily chosen - limit is 32k
> > different names total).
> > 
> > Also includes match/target extensions to add/match based on connection names
> > (or "connection labels").
> 
> I like this feature, but I'd propose that the kernel stores a specific
> 32-bits integer instead (not connmark, something new added as
> extension. In user-space we would have a file like:
> 
> $ cat /etc/iptables/connlabel.conf
> 1 "traffic leaving from eth0"
> 2 "traffic entering eth0"
> 3 "http traffic"

Awesome.  Originally I wanted to hide the exact label<->number mapping
from userspace but you've got me convinced.

> So we can do something like:
> 
> iptables -I INPUT -i eth0 -m connlabel --set-connlabel "traffic leaving from eth0"
> 
> [ Note I'm proposing (ab)using the match so we can use it together with
> targets in one single rule, we're doing that for nfacct so it should
> not be a problem ]

Yuck.  But ok ;-)

> The connlabel match will open the file and will look up for that
> string.
> 
> Then, ctnetlink only dumps a 32-bits integer with the connlabel. We
> can extend conntrack to translate connlabels to strings.

The problem i have with this is that 32 unique bits is a bit (pun intended)
low.  If its used as enumeration its plentiful but i specifically want
to be able to attach 'lots of' different labels to a conntrack entry.

> The kernel will work with integer, which is good for performance and
> memory. User-space will work on the translation.

I'll rework this; the label names will be removed.  Instead the kernel
will store bits only.

> Adding rules will be slow via iptables, but we can add some quick path
> in iptables-restore to open the file once and populate some array that
> we can use for fast lookups. Same thing for the conntrack utility.
> 
> Does this match with your initiali idea or I'm missing anything?

No, your suggestions should work nicely with what i had in mind.

Thanks!
