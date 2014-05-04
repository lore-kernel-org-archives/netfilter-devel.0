From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipv4: defrag: set local_df flag on
 defragmented skb
Date: Sun, 4 May 2014 13:24:24 +0200
Message-ID: <20140504112424.GA3830@localhost>
References: <1399037536-5294-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37237 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaEDLY3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 07:24:29 -0400
Content-Disposition: inline
In-Reply-To: <1399037536-5294-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 02, 2014 at 03:32:16PM +0200, Florian Westphal wrote:
> else we may fail to forward skb even if original fragments do fit
> outgoing link mtu:
> 
> 1. remote sends 2k packets in two 1000 byte frags, DF set
> 2. we want to forward but only see '2k > mtu and DF set'
> 3. we then send icmp error saying that outgoing link is 1500
> 
> But original sender never sent a packet that would not fit
> the outgoing link.
> 
> Setting local_df makes outgoing path test size vs.
> IPCB(skb)->frag_max_size, so we will still send the correct
> error in case the largest original size did not fit
> outgoing link mtu.

Thanks Florian for picking up this issue posted in netdev and cooking
a patch for it. Enqueued to the nf tree.
