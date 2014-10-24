From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: nf_log: account for size of NLMSG_DONE
 attribute
Date: Fri, 24 Oct 2014 14:39:01 +0200
Message-ID: <20141024123901.GA6201@salvia>
References: <1414053368-29037-1-git-send-email-fw@strlen.de>
 <1414053368-29037-2-git-send-email-fw@strlen.de>
 <20141024123027.GA4587@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44687 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571AbaJXNEK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:04:10 -0400
Content-Disposition: inline
In-Reply-To: <20141024123027.GA4587@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 24, 2014 at 02:30:27PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2014 at 10:36:06AM +0200, Florian Westphal wrote:
> > We currently neither account for the nlattr size, nor do we consider
> > the size of the trailing NLMSG_DONE when allocating nlmsg skb.
> > 
> > This can result in nflog to stop working, as __nfulnl_send() re-tries
> > sending forever if it failed to append NLMSG_DONE (which will never
> > work if buffer is not large enough).
> 
> Applied, thanks.

BTW, I'm going to pass this to -stable, it applies cleanly starting
2.6.32 and upwards.
