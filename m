From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Sun, 18 Dec 2011 01:21:05 +0100
Message-ID: <20111218002105.GA586@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <1323860443-7129-2-git-send-email-pablo@netfilter.org>
 <1323861408.2334.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111214124122.GA2749@1984>
 <1323868723.2334.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <1323870320.2334.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41826 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1LRAVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 19:21:11 -0500
Content-Disposition: inline
In-Reply-To: <1323870320.2334.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 02:45:20PM +0100, Eric Dumazet wrote:
> [PATCH] conntrack: use atomic64 for acct counters
> 
> We can use atomic64_t infrastructure to avoid taking a spinlock in fast
> path, and remove inaccuracies while reading values in
> ctnetlink_dump_counters() and connbytes_mt() on 32bit arches.
> 
> Suggested by Pablo
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied to nf-next, thanks Eric!
