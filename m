From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: add and use nf_afinfo in xt_addrtype
Date: Thu, 16 May 2013 20:47:51 +0200
Message-ID: <20130516184751.GA29218@breakpoint.cc>
References: <1368445651-6822-1-git-send-email-fw@strlen.de>
 <20130516161530.GA7533@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arpad@andrews.hu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53687 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab3EPSrw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 May 2013 14:47:52 -0400
Content-Disposition: inline
In-Reply-To: <20130516161530.GA7533@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> ipv6_find_hdr was also moved from ip6tables to ipv6 core code
> recently. Now we got a hard dependency on ipv6 if Hans' HMARK is used
> as well. So we need another hook for it. Again, that function is
> pretty specific of IPv6. So I think that we can add a new struct
> nf_afinfo_ipv6 to keep IPv6-only hooks like this and the one for
> ipv6_find.

Alright, i'll re-work this patch into a series, first adding
such a new struct.  We can then fix other dependency crap
later as time permits.

> I don't like putting this into nf_afinfo either, since it's specific
> of IPv6, but I want a small fix that fulfill the -stable rules. It
> will take some time until people get the fix for xt_addrtype IPv6 if
> we make it the nice way.

True, although this isn't a regression.

> Seems like merge ipt and ip6t module is bringing us more problems that
> expected.

Yes, and I think that separating all of those again is not realistic, so
a new ipv6 specific hook struct seems like the best shot.
