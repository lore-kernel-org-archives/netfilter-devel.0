From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/25] [v2] netfilter updates for net-next (upcoming
 3.5)
Date: Tue, 08 May 2012 13:12:30 -0400 (EDT)
Message-ID: <20120508.131230.1416742757463609913.davem@davemloft.net>
References: <1336463394-3119-1-git-send-email-pablo@netfilter.org>
	<20120508.124926.2241646617733136639.davem@davemloft.net>
	<20120508171049.GA16205@1984>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:59656 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2EHRNe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 13:13:34 -0400
In-Reply-To: <20120508171049.GA16205@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 8 May 2012 19:10:49 +0200

> I can rebase all my patches on top of fresh tree, fix all conflicts
> myself and send you another patchset that will apply to your current
> tree.
> 
> Please, let me know how to proceed.

Yes, please build a tree that compiles properly :-)

The error is pretty trivial to reproduce, just "allmodconfig" like I
do.
