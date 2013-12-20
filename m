From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next 2/2] netfilter: ctnetlink: honor CTA_MARK_MASK when
 setting ctmark
Date: Fri, 20 Dec 2013 10:33:56 +0100
Message-ID: <20131220093356.GB12971@localhost>
References: <1387473915-26753-1-git-send-email-fw@strlen.de>
 <1387473915-26753-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47966 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab3LTJeI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:34:08 -0500
Content-Disposition: inline
In-Reply-To: <1387473915-26753-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 19, 2013 at 06:25:15PM +0100, Florian Westphal wrote:
> Useful to only set a particular range of the conntrack mark while
> leaving exisiting parts of the value alone, e.g. when setting
> conntrack marks via NFQUEUE.
> 
> Follows same scheme as MARK/CONNMARK targets, i.e. the mask defines
> those bits that should be altered.  No mask is equal to '~0', ie.
> the old value is replaced by new one.

Also applied, thanks.
