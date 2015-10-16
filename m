From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: remove hook owner refcounting
Date: Fri, 16 Oct 2015 18:25:59 +0200
Message-ID: <20151016162559.GA1868@salvia>
References: <1444739608-9327-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60464 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbbJPQS5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 12:18:57 -0400
Content-Disposition: inline
In-Reply-To: <1444739608-9327-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 13, 2015 at 02:33:25PM +0200, Florian Westphal wrote:
> Get rid of .owner = THIS_MODULE in all nf_hook_ops, its not needed
> anymore.
> 
> The only facility that used this was nfqueue but nowadays we zap all
> queued entries that make use of a to-be-removed nf hook.
> 
> Followup commit simplifies nfqeue a bit (nf_queue_entry_get_refs can't
> fail anymore) and gets rid of a bunch of unneeded rcu readlocks.
> 
> diffstat:
> 21 files changed, 11 insertions(+), 99 deletions(-)

Series applied, thanks Florian!
