From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink: don't probe module if it exists
Date: Wed, 28 Oct 2015 03:45:20 +0100
Message-ID: <20151028024520.GA3254@salvia>
References: <1445948425-19080-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49075 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbbJ1CiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 22:38:14 -0400
Content-Disposition: inline
In-Reply-To: <1445948425-19080-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 27, 2015 at 01:20:25PM +0100, Florian Westphal wrote:
> nfnetlink_bind request_module()s all the time as nfnetlink_get_subsys()
> shifts the argument by 8 to obtain the subsys id.
> 
> So using type instead of type << 8 always returns NULL.

Applied, thanks Florian.
