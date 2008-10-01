From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 05/16] Conditionally enable transparent flow
 flag when connecting
Date: Wed, 01 Oct 2008 07:36:05 -0700 (PDT)
Message-ID: <20081001.073605.211381274.davem@davemloft.net>
References: <20081001142431.4893.48078.stgit@este>
	<20081001142431.4893.36455.stgit@este>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: hidden@sch.bme.hu
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081001142431.4893.36455.stgit@este>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: KOVACS Krisztian <hidden@sch.bme.hu>
Date: Wed, 01 Oct 2008 16:24:31 +0200

> Set FLOWI_FLAG_ANYSRC in flowi->flags if the socket has the
> transparent socket option set. This way we selectively enable certain
> connections with non-local source addresses to be routed.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Applied to net-next-2.6
