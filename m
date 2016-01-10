From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] scanner: disable most rules when we expect literal
 symbol
Date: Sun, 10 Jan 2016 22:38:43 +0100
Message-ID: <20160110213843.GA3184@breakpoint.cc>
References: <1451788347-11846-1-git-send-email-fw@strlen.de>
 <20160105113407.GC1731@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52010 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbcAJVip (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jan 2016 16:38:45 -0500
Content-Disposition: inline
In-Reply-To: <20160105113407.GC1731@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > nft fails to parse certain corner-cases, for example:
> > 
> > nft add rule filter input meta rtclassid daddr
> > 
> > ... as it finds DADDR token.  However, 'daddr' might be a valid
> > routing realm listed in iproute2/rt_realms, so this should be allowed.
> > 
> > Pablo suggested to change the start conditions in the scanner
> > accordingly.
> > 
> > After this patch, the following rule works:
> > 
> > ct label & (foobar | saddr) == saddr ip saddr 1.2.3.4 rtclassid { 42, cosmos, rule}
> 
> Note that this will not work:
> 
> ct label eq foobar

This patch doesn't work, we can return from literal mode too early.

rtclassid { rule, saddr }

we will leave literal mode after 'rule' so we choke on the SADDR token.

I'm flagging this as 'rejected' and will see if this can be fixed somehow.
