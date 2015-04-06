From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Mon, 6 Apr 2015 13:25:45 +0200
Message-ID: <20150406112543.GB24191@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
 <20150405113214.GA23433@acer.localdomain>
 <20150405121104.GD23433@acer.localdomain>
 <552187FB.60904@ahsoftware.de>
 <20150406015128.GA20515@acer.localdomain>
 <55224776.4040108@ahsoftware.de>
 <55224B70.1070309@ahsoftware.de>
 <55224E82.3010206@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33732 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbbDFLZs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 07:25:48 -0400
Content-Disposition: inline
In-Reply-To: <55224E82.3010206@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.04, Alexander Holler wrote:
> Am 06.04.2015 um 11:01 schrieb Alexander Holler:
> >Am 06.04.2015 um 10:44 schrieb Alexander Holler:
> >>Am 06.04.2015 um 03:51 schrieb Patrick McHardy:
> >>>On 05.04, Alexander Holler wrote:
> >>>>Am 05.04.2015 um 14:11 schrieb Patrick McHardy:
> >>>>>On 05.04, Patrick McHardy wrote:
> >>>>
> >>>>>>Basically this involves splitting the expression types into lhs
> >>>>>>(non-const)
> >>>>>>and rhs (const) parts. Keywords on the RHS side can be caught
> >>>>>>using an
> >>>>>>error statement and deferred to resolution during runtime.
> >>>>
> >>>>Sounds like trial and error. ;)
> >>>
> >>>The approach is, the patch isn't, it changes the grammar to have
> >>>these kinds of errors in a defined state. The patch I sent
> >>>however is, but I'm quite sure i understand the implications.
> >>
> >>Just to mention it, there is still the possibility to define and use
> >>keywords for all the icmp type names.
> >
> >Preferable with names as used in icmp.h and icmpv6.h. As these are
> >defines in C-headers, there is very high probability that these names
> >are unique, even across a large number of different sets of type or
> >other names.
> 
> That would also remove the need to look up what name nft uses if would be
> clear that the names are the same as defined in c-headers.
> 
> E.g. the ICMPv6 parameter-problem is good example. In the linux headers it
> is called ICMPV6_PARAMPROB, nft named it param-problem and in documentations
> it is often named as parameter-problem.
> 
> So if nft would use icmpv6_paramprob, the documentation could just refer to
> the c-headers.

No, an icmpv6_ prefix is redundant and I don't see any benefit in doing
that. "Documentations", whatever that is, don't matter, what matters is
our documentation. And whether we point people to that or some header
file really doesn't matter, except that we don't expect people to read
header files to use nft. Its a tool for admins, not programmers.
