From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: conntrack: avoid zeroing timer
Date: Thu, 27 Nov 2014 12:58:59 +0100
Message-ID: <20141127115859.GA9521@salvia>
References: <1416839157-26849-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbaK0L4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:56:48 -0500
Content-Disposition: inline
In-Reply-To: <1416839157-26849-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 03:25:57PM +0100, Florian Westphal wrote:
> add a __nfct_init_offset annotation member to struct nf_conn to make
> it clear which members are covered by the memset when the conntrack
> is allocated.
> 
> This avoids zeroing timer_list and ct_net; both are already inited
> explicitly.

Applied, thanks Florian.
