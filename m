From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink: meta: fix wrong type in attributes
Date: Mon, 17 Feb 2014 20:14:36 +0100
Message-ID: <20140217191436.GA9665@localhost>
References: <1392652085-8225-1-git-send-email-fw@strlen.de>
 <20140217172559.GA9866@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46290 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbaBQTOm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:14:42 -0500
Content-Disposition: inline
In-Reply-To: <20140217172559.GA9866@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 17, 2014 at 05:25:59PM +0000, Patrick McHardy wrote:
> On Mon, Feb 17, 2014 at 04:48:05PM +0100, Florian Westphal wrote:
> > We segfault on 'list filter' when meta expr is used as _u8
> > returns invalid register 0.
> 
> This seems to only affect the master branch. Not sure how many people
> are using that and if its worth doing a new release. I'd rather merge
> the next-3.14 branch and have people use that.

Please, go ahead with that.

> On a side note: there's no reason to have our releases timed after
> kernel releases. At this point I'd rather go for more frequent releases
> of the current code instead of backporting fixes.

We can probably point to the nftables git snapshots from the website
and make the releases when we consider that there a good number of
relevant changes/fixes to make an announce.
