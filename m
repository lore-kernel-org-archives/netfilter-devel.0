From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipv6: only provide sk_bound_dev_if for
 link-local addr
Date: Wed, 14 Nov 2012 18:56:57 +0100
Message-ID: <20121114175657.GA25730@1984>
References: <1352801844-23852-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	yoshfuji@linux-ipv6.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49652 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab2KNR5D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:57:03 -0500
Content-Disposition: inline
In-Reply-To: <1352801844-23852-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 13, 2012 at 11:17:24AM +0100, Florian Westphal wrote:
> yoshfuji points out that sk_bound_dev_if should only be provided
> for link-local addresses.
> 
> IPv6 getpeer/sockname also has this test, i.e. we will now
> only set sin6_scope_id if the original(!) destination
> was a link-local address.

Applied, thanks Florian.
