From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix nf_conntrack_l4proto_register()
Date: Fri, 29 Oct 2010 20:00:39 +0200
Message-ID: <4CCB0BC7.6040705@trash.net>
References: <1288375022.2560.306.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44288 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0J2SAl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:00:41 -0400
In-Reply-To: <1288375022.2560.306.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 29.10.2010 19:57, schrieb Eric Dumazet:
> While doing __rcu annotations work on net/netfilter I found following
> bug. On some arches, it is possible we publish a table while its content
> is not yet committed to memory, and lockless reader can dereference wild
> pointer.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
