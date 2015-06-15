From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] x_tables: remove XT_TABLE_INFO_SZ and a
 dereference.
Date: Mon, 15 Jun 2015 23:01:21 +0200
Message-ID: <20150615210121.GA3458@salvia>
References: <1434387450.27504.139.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56499 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbbFOU4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 16:56:02 -0400
Content-Disposition: inline
In-Reply-To: <1434387450.27504.139.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 15, 2015 at 09:57:30AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After Florian patches, there is no need for XT_TABLE_INFO_SZ anymore :
> Only one copy of table is kept, instead of one copy per cpu.
> 
> We also can avoid a dereference if we put table data right after
> xt_table_info. It reduces register pressure and helps compiler.
> 
> Then, we attempt a kmalloc() if total size is under order-3 allocation,
> to reduce TLB pressure, as in many cases, rules fit in 32 KB.

Applied, thanks a lot Eric.
