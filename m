From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nfq: NFQNL_MSG_VERDICT_BATCH support
Date: Tue, 6 Sep 2011 13:40:47 +0200
Message-ID: <20110906114047.GB3415@1984>
References: <1315249897-5477-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1IFLlK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:41:10 -0400
Content-Disposition: inline
In-Reply-To: <1315249897-5477-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 05, 2011 at 09:11:37PM +0200, Florian Westphal wrote:
> add nfq_set_verdict_batch() and nfq_set_verdict_batch2 (to also
> set the nfmark of all packets).
> 
> verdicts sent by the _batch variant will affect all queued skbs
> whose id is smaller or equal to the given id.
> 
> This facility is available from Linux 3.1 onwards.

Thanks Florian.

> While at it, add notes on use of NF_STOLEN and NF_REPEAT verdicts.

I'm going to split this patch into two chunks. This doesn't really
belong here.
