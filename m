From: David Miller <davem@davemloft.net>
Subject: Re: [patch 1/1] net/netfilter/nfnetlink_acct.c: use linux/atomic.h
Date: Sun, 01 Apr 2012 16:17:03 -0400 (EDT)
Message-ID: <20120401.161703.814745867737769975.davem@davemloft.net>
References: <20120328221057.9A6DAA001B@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	kaber@trash.net, pablo@netfilter.org
To: akpm@linux-foundation.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:44447 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2DAUTO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:19:14 -0400
In-Reply-To: <20120328221057.9A6DAA001B@akpm.mtv.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: akpm@linux-foundation.org
Date: Wed, 28 Mar 2012 15:10:57 -0700

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: net/netfilter/nfnetlink_acct.c: use linux/atomic.h
> 
> There's no known problem here, but this is one of only two non-arch files
> in the kernel which use asm/atomic.h instead of linux/atomic.h.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied.
