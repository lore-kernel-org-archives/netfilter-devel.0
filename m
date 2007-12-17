From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [NETFILTER] xt_hashlimit : Can generate better code if only
 IPV4 needed
Date: Mon, 17 Dec 2007 14:11:25 +0100
Message-ID: <20071217141125.77bb5288.dada1@cosmosbay.com>
References: <4762A920.8060609@cosmosbay.com>
	<47666AC5.4040207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pfx2.jmh.fr ([194.153.89.55]:37380 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbXLQNL2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:11:28 -0500
In-Reply-To: <47666AC5.4040207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 17 Dec 2007 13:25:41 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Eric Dumazet wrote:
> > This patch generalizes the (CONFIG_IP6_NF_IPTABLES || 
> > CONFIG_IP6_NF_IPTABLES_MODULE)
> > test done in hashlimit_init_dst() to all the xt_hashlimit module.
> > 
> > This permits a size reduction of "struct dsthash_dst". This saves memory 
> > and cpu for IPV4 only hosts.
> 
> 
> Applied, thanks. I didn't really like the IFIPV6 macro though, so
> I replaced it by open coded #ifdefs and removed the ones for
> procdir selection since without ip6_tables we'll never have
> family != AF_INET anyway.
> 

Thanks Patrick
