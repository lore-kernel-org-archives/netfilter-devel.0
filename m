From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 13/25] ipvs: remove check for IP_VS_CONN_F_SYNC from
 ip_vs_bind_dest
Date: Mon, 07 May 2012 22:16:17 -0400 (EDT)
Message-ID: <20120507.221617.296952751857969791.davem@davemloft.net>
References: <1336436539-5880-14-git-send-email-pablo@netfilter.org>
	<20120507.213607.2054696052002528963.davem@davemloft.net>
	<20120508020843.GA9027@verge.net.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: horms@verge.net.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:53482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2EHCR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 22:17:27 -0400
In-Reply-To: <20120508020843.GA9027@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>
Date: Tue, 8 May 2012 11:08:44 +0900

> can I fix this up as a subsequent patch?

Pablo's tree needs to get respun to address the other feedback
I gave, so no reason for him or you to not fix this as well.
