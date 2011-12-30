From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_acct now available at git.netfilter.org
Date: Fri, 30 Dec 2011 01:05:46 +0100
Message-ID: <20111230000546.GC7866@1984>
References: <20111229184741.GA6405@1984>
 <alpine.LNX.2.01.1112292221210.29747@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab1L3AFu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:05:50 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1112292221210.29747@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 29, 2011 at 10:23:58PM +0100, Jan Engelhardt wrote:
> On Thursday 2011-12-29 19:47, Pablo Neira Ayuso wrote:
> 
> >Hi!
> >
> >JFYI: I just uploaded libnetfilter_acct to git.netfilter.org.
> >
> >http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_acct.git;a=summary
> >
> >This library provides the programming interface (API) to the Netfilter
> >extended accounting infrastructure. It includes the documentation in
> >doxygen format and a couple of examples.
> >
> >The first client of this library will be the `nfacct' tool.
> >
> >I'm thinking about including this tool into the iptables tree, instead
> >of distributing it separately, but I may change my mind. Let me know
> >if you have any preference.
> 
> It would pose - just formally - the question how many more tools we 
> intend to ship with iptables. For example, try to find an answer as to 
> why conntrack-tools and ipset are separate instead of being included in 
> iptables.

Good question.

>From what I see (because the policy is not clear to me either), I can
extract that it's a matter of how big (in terms of LOC) the project is
and how many changes you expect from that code.

> I am not particular for or against, since there is already e.g. nfnl_osf 
> (and libipq...) in the iptables tree, for a lack of a better place.

QUEUE should be scheduled for removal IMO, I'd take a patch for
that. People already had time the time to migrate to NFQUEUE.

Unless someone comes with some strong argument to keep it in the tree.

For nfnl_osf, we can move it to one standalone tool.

Probably it's better to avoid polluting iptables tree with other
projects and provide standalone trees for everyone.
