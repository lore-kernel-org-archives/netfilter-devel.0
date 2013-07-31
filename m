From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/7] netfilter: conntrack: remove duplicate code in
 conntrack_netlink
Date: Wed, 31 Jul 2013 18:58:41 +0200
Message-ID: <20130731165841.GE25900@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51632 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760518Ab3GaQ6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:58:50 -0400
Content-Disposition: inline
In-Reply-To: <1375105316-13216-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:41:54PM +0200, Florian Westphal wrote:
> ctnetlink contains copy-paste code from death_by_timeout.  In order to
> avoid changing both places in upcoming event delivery patch,
> export death_by_timeout functionality and use it in the ctnetlink code.
> 
> Based on earlier patch from Pablo Neira.

I like it. Applied, thanks.
