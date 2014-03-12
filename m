From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/7] netfilter: connlimit: scalability improvements
Date: Wed, 12 Mar 2014 13:58:20 +0100
Message-ID: <20140312125820.GA26286@localhost>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36155 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaCLM7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:59:17 -0400
Content-Disposition: inline
In-Reply-To: <1394199435-14395-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 07, 2014 at 02:37:08PM +0100, Florian Westphal wrote:
> Florian Westphal (7):
>       netfilter: connlimit: factor hlist search into new function
>       netfilter: connlimit: improve packet-to-closed-connection logic
>       netfilter: connlimit: move insertion of new element out of count function
>       netfilter: connlimit: use kmem_cache for conn objects

Unless you have any concern, I'm going to apply from 1 to 4 which look
good to me. You can send me the three remaining patches after you have
address remaining issues.

Thanks.

>       netfilter: connlimit: use keyed locks
>       netfilter: connlimit: make same_source_net signed
>       netfilter: connlimit: use rbtree for per-host conntrack obj storage
