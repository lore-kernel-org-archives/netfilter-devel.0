From: Patrick McHardy <kaber@trash.net>
Subject: Re: [net-next PATCH 15/16] iptables TPROXY target
Date: Thu, 02 Oct 2008 11:28:52 +0200
Message-ID: <48E49454.9070506@trash.net>
References: <20081001142431.4893.48078.stgit@este> <20081001142431.4893.51517.stgit@este>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52853 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbYJBJ3y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:29:54 -0400
In-Reply-To: <20081001142431.4893.51517.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

KOVACS Krisztian wrote:
> The TPROXY target implements redirection of non-local TCP/UDP traffic to local
> sockets. Additionally, it's possible to manipulate the packet mark if and only
> if a socket has been found. (We need this because we cannot use multiple
> targets in the same iptables rule.)
>
>   

Applied, thanks.

