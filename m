From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:29:04 +0200
Message-ID: <20150619132904.GI22946@acer.localdomain>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
 <20150619125724.GG22946@acer.localdomain>
 <2024102.ynN6JVsV1M@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56542 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbbFSN3I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:29:08 -0400
Content-Disposition: inline
In-Reply-To: <2024102.ynN6JVsV1M@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Patrick Schaaf wrote:
> On Friday 19 June 2015 14:57:24 Patrick McHardy wrote:
> >
> > Is tee a name we want to use for userspace syntax? It's not particulary
> > descriptive for people who don't know what "tee" is, which I guess are
> > quite a few.
> 
> Naming the thing "tee" was a conscious decision when I invented the it as an 
> option to the ROUTE target back in 2004  - because it is a huge foot gun, and 
> obscurity seemed appropriate.

Yeah, but we're trying to have a descriptive language. Its not that
"duplicate" doesn't also sound dangerous.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
