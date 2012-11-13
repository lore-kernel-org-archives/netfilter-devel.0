From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] Introduce notification chain for routing changes
Date: Tue, 13 Nov 2012 17:15:15 -0500 (EST)
Message-ID: <20121113.171515.552672146557270042.davem@davemloft.net>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu>
	<1352837857-22087-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:50460 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2KMWPQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:15:16 -0500
In-Reply-To: <1352837857-22087-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Tue, 13 Nov 2012 21:17:36 +0100

> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/inetdevice.h |    2 ++
>  include/linux/netdevice.h  |    1 +
>  net/ipv4/fib_trie.c        |   18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 0 deletions(-)

A change like this needs to be reviewed on netdev, not
netfilter-devel
