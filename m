From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/17] netfilter/ipvs updates for net-next
Date: Mon, 24 Nov 2014 16:01:24 -0500 (EST)
Message-ID: <20141124.160124.1790575206232093878.davem@davemloft.net>
References: <1416835674-11871-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaKXVB3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:01:29 -0500
In-Reply-To: <1416835674-11871-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 24 Nov 2014 14:27:37 +0100

> The following patchset contains Netfilter updates for your net-next
> tree, this includes the NAT redirection support for nf_tables, the
> cgroup support for nft meta and conntrack zone support for the connlimit
> match. Coming after those, a bunch of sparse warning fixes, missing
> netns bits and cleanups. More specifically, they are:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
