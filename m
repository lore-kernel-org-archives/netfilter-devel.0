From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/6] netfilter: ctnetlink: use GFP_ATOMIC in all
 allocations
Date: Tue, 06 Mar 2012 15:20:33 -0500 (EST)
Message-ID: <20120306.152033.705109948612764345.davem@davemloft.net>
References: <1331032975-5303-4-git-send-email-pablo@netfilter.org>
	<1331038221.9504.9.camel@edumazet-glaptop>
	<20120306144838.GA1527@1984>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: eric.dumazet@gmail.com, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:39231 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030950Ab2CFUVk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:21:40 -0500
In-Reply-To: <20120306144838.GA1527@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 6 Mar 2012 15:48:38 +0100

> David, can you take all patches except this one?

That's what I did, thanks.
