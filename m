From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: NFQUEUE: don't xor src/dst ip address
Date: Wed, 6 Jun 2012 01:57:02 +0200
Message-ID: <20120605235702.GC27222@1984>
References: <1338814434-15130-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab2FEX5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:57:04 -0400
Content-Disposition: inline
In-Reply-To: <1338814434-15130-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 04, 2012 at 02:53:54PM +0200, Florian Westphal wrote:
> because reply packets need to go to the same nfqueue, src/dst ip
> address were xor'd prior to jhash().
> 
> However, this causes bad distribution for some workloads, e.g.
> flows a.b.1.{1,n} -> a.b.2.{1,n} all share the same hash value.
> 
> Avoid this by hashing both. To get same hash for replies,
> first argument is the smaller address.

Applied. Thanks Florian.
