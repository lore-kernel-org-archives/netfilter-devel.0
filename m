From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 01:44:25 +0200
Message-ID: <20150409234424.GB6169@salvia>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409232106.GB13473@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35723 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbbDIXkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:40:17 -0400
Content-Disposition: inline
In-Reply-To: <20150409232106.GB13473@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 10, 2015 at 12:21:06AM +0100, Patrick McHardy wrote:
> On 10.04, Pablo Neira Ayuso wrote:
> > On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> > > Why would I want to re-write a working nft+compat ruleset to one
> > > that only uses native expressions?
> > 
> > The fact is that we cannot push users to use nf_tables, but we can
> > provide good reasons to adopt the native replacements and tools to
> > migrate easily.
> 
> We actually can by translating their iptables ruleset transparently.

Users' ruleset can be very sophisticated, some of them may just not
move forward because only one single feature that they need is
missing. So they will postpone migration. That is not good.

The translation is a complementary thing, not a replacement of the
compatibility layer.
