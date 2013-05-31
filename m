From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] sctp: Correct byte order of access to
 skb->{network, transport}_header
Date: Fri, 31 May 2013 01:41:59 -0700 (PDT)
Message-ID: <20130531.014159.1353890306713950983.davem@davemloft.net>
References: <1369982171-22317-1-git-send-email-horms@verge.net.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bhutchings@solarflare.com
To: horms@verge.net.au
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1369982171-22317-1-git-send-email-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Fri, 31 May 2013 15:36:11 +0900

> Corrects an byte order conflict introduced by "sctp: Correct access to
> skb->{network, transport}_header". All the values in question are host
> byte order.
> 
> Reported-by: Ben Hutchings <bhutchings@solarflare.com>
> Signed-off-by: Simon Horman <horms@verge.net.au>

Applied, thanks Simon.
