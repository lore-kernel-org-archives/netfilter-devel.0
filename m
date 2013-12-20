From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next 1/2] net: netfilter: avoid get_random_bytes calls
Date: Fri, 20 Dec 2013 10:33:39 +0100
Message-ID: <20131220093339.GA12971@localhost>
References: <1387473915-26753-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47769 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab3LTJdp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:33:45 -0500
Content-Disposition: inline
In-Reply-To: <1387473915-26753-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 19, 2013 at 06:25:14PM +0100, Florian Westphal wrote:
> All these users need an initial seed value for jhash, prandom is
> perfectly fine.  This avoids draining the entropy pool where
> its not strictly required.
> 
> nfnetlink_log did not use the random value at all.

Applied, thanks Florian.
