From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: bridge: fix NULL deref in physin/out
 ifindex helpers
Date: Mon, 27 Apr 2015 13:26:52 +0200
Message-ID: <20150427112652.GA3684@salvia>
References: <1429526147-4058-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38793 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbD0LWV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2015 07:22:21 -0400
Content-Disposition: inline
In-Reply-To: <1429526147-4058-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 20, 2015 at 12:35:47PM +0200, Florian Westphal wrote:
> Might not have an outdev yet. We'll oops when iface goes down while skbs
> are still nfqueue'd:
> 
> RIP: 0010:[<ffffffff81422a2f>]  [<ffffffff81422a2f>] dev_cmp+0x4f/0x80
> nfqnl_rcv_dev_event+0xe2/0x150
> notifier_call_chain+0x53/0xa0
> 
> Fixes: c737b7c4510026 ("netfilter: bridge: add helpers for fetching physin/outdev")

Applied, thanks Florian.
