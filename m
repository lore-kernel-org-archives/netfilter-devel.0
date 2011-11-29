From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/3] netfilter updates for 3.2-rc
Date: Tue, 29 Nov 2011 01:23:43 -0500 (EST)
Message-ID: <20111129.012343.2029150726335495024.davem@davemloft.net>
References: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:35000 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1K2GYv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:24:51 -0500
In-Reply-To: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Mon, 28 Nov 2011 04:30:57 +0100

> The following patches are three bugfixes for 3.2-rc. One that fixes
> the stopping one lxc container while having conntracks in the table
> and nf_netlink_conntrack enabled. Some minor compilation warning in
> ipset and unaligned access in ip_route_me_harder.
> 
> You can pull these changes from (my nf branch):
> 
> git://1984.lsi.us.es/net nf

Pulled, thanks a lot.
