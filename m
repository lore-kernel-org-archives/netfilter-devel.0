From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_counter: add per-cpu support
Date: Fri, 19 Jun 2015 11:22:39 +0200
Message-ID: <20150619092239.GB22946@acer.localdomain>
References: <1434651697-9905-1-git-send-email-pablo@netfilter.org>
 <1434651697-9905-2-git-send-email-pablo@netfilter.org>
 <20150618222529.GA24649@acer.localdomain>
 <20150619092503.GA11247@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54389 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbFSJWm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 05:22:42 -0400
Content-Disposition: inline
In-Reply-To: <20150619092503.GA11247@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2015 at 12:25:30AM +0200, Patrick McHardy wrote:
> > On 18.06, Pablo Neira Ayuso wrote:
> > > This patch adds rule per-cpu counters. This introduces a new NFTA_COUNTER_TYPE
> > > netlink attribute to indicate the type of counters to be used. The default is
> > > the compact seqlock representation for compatibility.
> > 
> > I don't think that userspace should care about the implementation details.
> > I'd just switch to percpu unconditionally.
> 
> Will send a v2.
> 
> I can't find a use-case for the compact memory representation of the
> seqlock counter, but if that ever happens we can go back to this type
> attribute so the user can select.

I agree. Thanks!
