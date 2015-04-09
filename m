From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Fri, 10 Apr 2015 00:48:44 +0100
Message-ID: <20150409234843.GF13473@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
 <20150409203616.GA27610@acer.localdomain>
 <20150409205135.GG20653@breakpoint.cc>
 <20150409223417.GA3205@salvia>
 <20150409232106.GB13473@acer.localdomain>
 <20150409234424.GB6169@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34766 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbbDIXss (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 19:48:48 -0400
Content-Disposition: inline
In-Reply-To: <20150409234424.GB6169@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04, Pablo Neira Ayuso wrote:
> On Fri, Apr 10, 2015 at 12:21:06AM +0100, Patrick McHardy wrote:
> > On 10.04, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 09, 2015 at 10:51:35PM +0200, Florian Westphal wrote:
> > > > Why would I want to re-write a working nft+compat ruleset to one
> > > > that only uses native expressions?
> > > 
> > > The fact is that we cannot push users to use nf_tables, but we can
> > > provide good reasons to adopt the native replacements and tools to
> > > migrate easily.
> > 
> > We actually can by translating their iptables ruleset transparently.
> 
> Users' ruleset can be very sophisticated, some of them may just not
> move forward because only one single feature that they need is
> missing. So they will postpone migration. That is not good.
> 
> The translation is a complementary thing, not a replacement of the
> compatibility layer.

The difference is that the translation layer doesn't restrict us in
future decisions, and this one does.

And actually if you consider what the majority of users are, its people
using distro provided firewalls, the translation layer will actually
get us the huge majority of users.

People who actively want to switch won't mind changing their ruleset,
so they might as well tell us if some feature is missing and we can
then discuss how to implement it in nftables.
