From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: bridge: don't leak skb in error paths
Date: Thu, 2 Jul 2015 20:29:52 +0200
Message-ID: <20150702182952.GA28965@salvia>
References: <1435696071-26841-1-git-send-email-fw@strlen.de>
 <20150702125944.GA22321@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbbGBSYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 14:24:21 -0400
Content-Disposition: inline
In-Reply-To: <20150702125944.GA22321@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 02, 2015 at 02:59:44PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jun 30, 2015 at 10:27:51PM +0200, Florian Westphal wrote:
> > br_nf_dev_queue_xmit must free skb in its error path.
> > NF_DROP is misleading -- its an okfn, not a netfilter hook.
> 
> Good catch.

Florian, would you send me a backport of this patch for -stable?

git describe says this problem is there since v2.6.37.

Let me know, thanks.
