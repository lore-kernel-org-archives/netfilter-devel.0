From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH][RESEND] netfilter: fix CONFIG_COMPAT support
Date: Mon, 23 Aug 2010 14:41:46 -0700 (PDT)
Message-ID: <20100823.144146.173873857.davem@davemloft.net>
References: <1282568186-20475-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53181
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab0HWVl3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:41:29 -0400
In-Reply-To: <1282568186-20475-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Mon, 23 Aug 2010 14:56:26 +0200

> commit f3c5c1bfd430858d3a05436f82c51e53104feb6b
> (netfilter: xtables: make ip_tables reentrant) forgot to
> also compute the jumpstack size in the compat handlers.
> 
> Result is that "iptables -I INPUT -j userchain" turns into -j DROP.
> 
> Reported by Sebastian Roesner on #netfilter, closes
> http://bugzilla.netfilter.org/show_bug.cgi?id=669.
> 
> Note: arptables change is compile-tested only.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Florian.
