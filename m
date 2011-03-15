From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xt_connlimit: fix daddr connlimit in SNAT
 scenario
Date: Tue, 15 Mar 2011 13:24:43 +0100
Message-ID: <4D7F5A8B.5050100@trash.net>
References: <1300085414-27275-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1COMYo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:24:44 -0400
In-Reply-To: <1300085414-27275-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.03.2011 07:50, Changli Gao wrote:
> We use the reply tuples when limiting the connections by the destination
> addresses, however, in SNAT scenario, the final reply tuples won't be
> ready until SNAT is done in POSTROUING or INPUT chain, and the following
> nf_conntrack_find_get() in count_tem() will get nothing, so connlimit
> can't work as expected.
> 
> In this patch, the original tuples are always used, and an additional
> member addr is appended to save the address in either end.

Applied, thanks.

