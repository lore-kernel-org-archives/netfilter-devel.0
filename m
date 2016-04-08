From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 00/17] netfilter: xtables: stricter ruleset validation
Date: Fri, 8 Apr 2016 13:59:05 +0200
Message-ID: <20160408115905.GA7001@breakpoint.cc>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
 <20160408115818.GA6954@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58429 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbcDHL7I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 07:59:08 -0400
Content-Disposition: inline
In-Reply-To: <20160408115818.GA6954@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Apr 01, 2016 at 02:17:20PM +0200, Florian Westphal wrote:
> > This series adds more checks on xtables (arp, ip, ip6tables) rulesets.
> > 
> > - check all offsets (target, next) of all rules during initial pass
> >   after copy from userspace.
> > - check targets of jumps (-j bla): offset should be start of a rule
> > - assert that alleged target size is at least as big as minimum target
> >   structure
> > - change CONFIG_COMPAT code path to push ruleset via normal setsockopt
> >   path after initial 32->64 bit conversion to avoid duplicating checks
> > - use a common helper to copy counters from userspace instead of
> >   the ip/ip6/arp implementation.
> >
> > Tested:
> > - iptables.git iptables-test.py passes
> > - made a few performance tests w. really silly rulesets to verify
> > that things don't slow down too much, see individual patches for details.
> > 
> >  include/linux/netfilter/x_tables.h |   12 +
> >  net/ipv4/netfilter/arp_tables.c    |  303 ++++++++++------------------------
> >  net/ipv4/netfilter/ip_tables.c     |  327 +++++++++----------------------------
> >  net/ipv6/netfilter/ip6_tables.c    |  320 ++++++++----------------------------
> >  net/netfilter/x_tables.c           |  244 +++++++++++++++++++++++++++
> >  5 files changed, 506 insertions(+), 700 deletions(-)
> 
> Nice work, and we got less code to maintain, good :)
> 
> I'm starting to consider that, given that this has been broken since
> day 1, we pass this through nf-next and then later on we request
> inclusion for -stable.

Fine with me.
