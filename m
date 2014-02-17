From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nftables: fix nf_trace always-on with
 XT_TRACE=n
Date: Mon, 17 Feb 2014 11:40:02 +0100
Message-ID: <20140217104002.GA8103@localhost>
References: <1392504525-21134-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60537 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaBQKkr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:40:47 -0500
Content-Disposition: inline
In-Reply-To: <1392504525-21134-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 15, 2014 at 11:48:45PM +0100, Florian Westphal wrote:
> When using nftables with CONFIG_NETFILTER_XT_TARGET_TRACE=n, we get
> lots of "TRACE: filter:output:policy:1 IN=..." warnings as several
> places will leave skb->nf_trace uninitialised.
> 
> Unlike iptables tracing functionality is not conditional in nftables,
> so always copy/zero nf_trace setting when nftables is enabled.
> 
> Move this into __nf_copy() helper.

Applied, thanks.
