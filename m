From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: ctnetlink: fix uninitialized variable
Date: Wed, 28 Aug 2013 00:51:17 +0200
Message-ID: <20130827225117.GA15566@localhost>
References: <1377596846-1790-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab3H0WvW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:51:22 -0400
Content-Disposition: inline
In-Reply-To: <1377596846-1790-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 27, 2013 at 11:47:26AM +0200, Florian Westphal wrote:
> net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_nfqueue_attach_expect':
> 'helper' may be used uninitialized in this function
>
> It was only initialized in if CTA_EXPECT_HELP_NAME attribute was
> present, it must be NULL otherwise.
> 
> Problem added recently in bd077937
> (netfilter: nfnetlink_queue: allow to attach expectations to conntracks).

Applied, thanks Florian!
