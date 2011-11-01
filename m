From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: do not propagate nf_queue errors in
 nf_hook_slow
Date: Tue, 1 Nov 2011 10:11:19 +0100
Message-ID: <20111101091119.GA5545@1984>
References: <1320060016-9390-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37184 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KAJLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:11:34 -0400
Content-Disposition: inline
In-Reply-To: <1320060016-9390-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 31, 2011 at 12:20:16PM +0100, Florian Westphal wrote:
> commit f15850861860636c905b33a9a5be3dcbc2b0d56a
> (netfilter: nfnetlink_queue: return error number to caller)
> erronously assigns the return value of nf_queue() to the "ret" value.
> 
> This can cause bogus return values if we encounter QUEUE verdict
> when bypassing is enabled, the listener does not exist and the
> next hook returns NF_STOLEN.
> 
> In this case nf_hook_slow returned -ESRCH instead of 0.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
