From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: avoid build error if TPROXY/SOCKET=y &&
 NF_DEFRAG_IPV6=m
Date: Fri, 15 May 2015 21:05:24 +0200
Message-ID: <20150515190524.GA11008@salvia>
References: <1431000958-671-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34234 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbbEOTAk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 15:00:40 -0400
Content-Disposition: inline
In-Reply-To: <1431000958-671-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 07, 2015 at 02:15:58PM +0200, Florian Westphal wrote:
> With TPROXY=y but DEFRAG_IPV6=m we get build failure:
> 
> net/built-in.o: In function `tproxy_tg_init':
> net/netfilter/xt_TPROXY.c:588: undefined reference to `nf_defrag_ipv6_enable'
> 
> If DEFRAG_IPV6 is modular, TPROXY must be too.
> (or both must be builtin).
> 
> This enforces =m for both.

Applied, thanks Florian.
