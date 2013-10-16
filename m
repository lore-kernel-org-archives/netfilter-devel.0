From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Wed, 16 Oct 2013 12:02:56 +0100
Message-ID: <20131016110255.GB18568@macbook.localnet>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
 <20131016103949.GA10032@localhost>
 <20131016110043.GB12157@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Anand Raj Manickam <anandrm@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55719 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760542Ab3JPLDA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:00 -0400
Content-Disposition: inline
In-Reply-To: <20131016110043.GB12157@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 16, 2013 at 01:00:43PM +0200, Florian Westphal wrote:
> 
> > >   - removes a FIXME in netlink_delinearize.  What was that about? :-}
> > 
> > I don't remember the reason for that case, please try to dig it out
> > from the history. Thanks!
> 
> // FIXME
> if (left->len && left->dtype && left->dtype->type != TYPE_STRING
> 
> ... is from Patricks initial commit.  Lets see if Patrick remembers :)

I already tried, but not off the top of my head. Let me check closer.
Might take a few days though, currently quite busy.


