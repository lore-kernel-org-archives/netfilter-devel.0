From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: nf_log: release skbuff on nlmsg put
 failure
Date: Fri, 24 Oct 2014 14:35:09 +0200
Message-ID: <20141024123509.GC4587@salvia>
References: <1414053368-29037-1-git-send-email-fw@strlen.de>
 <1414053368-29037-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Houcheng Lin <houcheng@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41963 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbaJXMdh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:33:37 -0400
Content-Disposition: inline
In-Reply-To: <1414053368-29037-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2014 at 10:36:08AM +0200, Florian Westphal wrote:
> From: Houcheng Lin <houcheng@gmail.com>
> 
> The kernel should reserve enough room in the skb so that the DONE
> message can always be appended.  However, in case of e.g. new attribute
> erronously not being size-accounted for, __nfulnl_send() will still
> try to put next nlmsg into this full skbuf, causing the skb to be stuck
> forever and blocking delivery of further messages.
> 
> Fix issue by releasing skb immediately after nlmsg_put error and
> WARN() so we can track down the cause of such size mismatch.

Good idea.

> [ fw@strlen.de: add tailroom/len info to WARN ]

Applied, thanks.
