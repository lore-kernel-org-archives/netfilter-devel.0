From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft parser and names for constants (was [PATCH v2] parser: add
 kludges for "param-problem" and "redirect")
Date: Thu, 9 Apr 2015 12:07:45 +0100
Message-ID: <20150409110745.GI12203@acer.localdomain>
References: <20150404115550.GA5832@salvia>
 <20150405113214.GA23433@acer.localdomain>
 <20150405121104.GD23433@acer.localdomain>
 <552187FB.60904@ahsoftware.de>
 <20150406015128.GA20515@acer.localdomain>
 <55224776.4040108@ahsoftware.de>
 <55224B70.1070309@ahsoftware.de>
 <55224E82.3010206@ahsoftware.de>
 <20150406112543.GB24191@acer.localdomain>
 <552659D6.8090902@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62484 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbbDILHv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 07:07:51 -0400
Content-Disposition: inline
In-Reply-To: <552659D6.8090902@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.04, Alexander Holler wrote:
> >>E.g. the ICMPv6 parameter-problem is good example. In the linux headers it
> >>is called ICMPV6_PARAMPROB, nft named it param-problem and in documentations
> >>it is often named as parameter-problem.
> >>
> >>So if nft would use icmpv6_paramprob, the documentation could just refer to
> >>the c-headers.
> >
> >No, an icmpv6_ prefix is redundant and I don't see any benefit in doing
> >that. "Documentations", whatever that is, don't matter, what matters is
> >our documentation. And whether we point people to that or some header
> >file really doesn't matter, except that we don't expect people to read
> >header files to use nft. Its a tool for admins, not programmers.
> 
> Even some admins can code.
> 
> Because nft is just at 0.4 and not widely used (or usable), I decided it's
> worse to write another follow up in order to try to fix things before they
> can't be fixed anymore.
> 
> 1. I don't think that a brutforce-approach like "if error try something
> else" is the right way to fix a problem in the parser.

Its perfectly fine in this case since the error is only caught in spots
where we expect symbolic constants. So basically its treating the next
keyword as symbolic constant no matter what.

> 2. "icmpv6_paramprob" (or even something like "icmpv6_parameter-problem")
> doesn't have something redundant. It's a name for constant and e.g.
> "icmp_redirect" is a much more descriptive name than just "redirect" because
> "icmp_redirect" describes the context too and thus the name is much more
> verbose and readable (besides that it would fix the problem the parser
> currently has).

It is redundant since it can only occur in the context of ICMP expressions.
icmp type icmp_redirect is obviously redundant.

> 3. I don't see why admins have to use another set of names for constants
> than developers. Inventing a new set of names for a list of constants for
> which there already exist a very widely used set of names just leads to more
> confusion. And if it's ok to invent new names, why does nft use
> "param-problem" and not "parameter-problem"? Of course, I would suggest to
> use the existing name icmp_parameterprob (like it's used in every
> c/c++-source).

In case of ICMP we use the same names that iptables used, so this actually
spares admins from getting used to new constants. We're not going to use
source code identifiers, there's no benefit at all, especially if you
consider that Linux headers use different identifiers than the BSD headers.

But I agree, ICMPv6 shouldn't use param-problem but parameter-problem for
consistency with both ICMP and ip6tables.
