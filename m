From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 13:33:39 +0100
Message-ID: <20160302123339.GA4930@salvia>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41100 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbcCBMdr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:33:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 94CD061E89
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:33:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 828C9DA3A4
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:33:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 882E2DA38C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:33:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302121033.GA4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 01:10:33PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think meta random 0.10000000009 will only match for the exact case.
> 
> No; I thought that 'nft ... meta random 0.5' should on average match half of
> the time so the proposed nft prandom patch set makes LE the default op.
> 
> So meta random 0.1 is in fact 'meta random le 0.1' (and nft will display
> it like this).
> 
> > > $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> > > 0.1 -j ACCEPT
> > > nft add rule ip filter INPUT meta random != 0.10000000009 counter accept
> > 
> > Then, the opposite has to be:
> > 
> >         meta random gte 0.10000000009
> 
> Good point, this is not intuitive.
> 
> Currently if no operator is given and the type is TYPE_PROBABILITY then
> we just use le instead of eq (just like we pick "&" in some cases).
> 
> But if user asks 'meta random ne 0.1' then the match propability is close
> to 100%.
> 
> Do you think its enough to just document that you need to use le/ge etc.
> for this?
>
> Other option would be to rewrite NE to GE if rh value is a probability,
> but I'm not sure if such 'helpful' logic isn't too likely to get in the
> way.
> 
> Yet another option is to just disallow EQ and NE ops and throw an error.
> 
> Other suggestions?

I'm fine with the probability scaling, but I think we should keep this
consistent with other selectors, so I would use lt and gte instead
here.

We can potentially use ranges here too and other available operations
such as prefixes (although this one I don't know use case for this).

Thanks.
