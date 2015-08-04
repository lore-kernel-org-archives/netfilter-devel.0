From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nf_tables: add generation mask to
 set objects
Date: Tue, 4 Aug 2015 19:23:52 +0200
Message-ID: <20150804172352.GA3936@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <1438679128-4146-3-git-send-email-pablo@netfilter.org>
 <20150804103813.GA12016@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbbHDRRz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 13:17:55 -0400
Content-Disposition: inline
In-Reply-To: <20150804103813.GA12016@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 12:38:13PM +0200, Patrick McHardy wrote:
> On 04.08, Pablo Neira Ayuso wrote:
> > Use the generation mask approach to obtain a consistent list of set objects
> > from netlink dump commands.
> > 
> > Get rid of the internal NFT_SET_INACTIVE flag.
> 
> In this case I don't see how deletion and creation in the same
> batch will work at all since we don't check any active bits in
> nf_tables_newset().

Right, the update of nf_tables_set_lookup() is missing.

> We also have the problem that f.i. delset checks for activeness
> in the current instead of the next generation.

I guess you refer to the same problem I'm discussing in the other
thread, right? As I said, this checking for add+delete in the same
batch.
