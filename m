From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ipvs: ip_vs_sip_fill_param() BUG: bad check of return
 value
Date: Mon, 29 Apr 2013 11:35:59 -0400 (EDT)
Message-ID: <20130429.113559.2253896979065180482.davem@davemloft.net>
References: <1367085974-7750-1-git-send-email-pablo@netfilter.org>
	<1367085974-7750-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1367085974-7750-2-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 27 Apr 2013 20:06:14 +0200

> From: Hans Schillstrom <hans@schillstrom.com>
> 
> The reason for this patch is crash in kmemdup
> caused by returning from get_callid with uniialized
> matchoff and matchlen.
> 
> Removing Zero check of matchlen since it's done by ct_sip_get_header()
 ...
> Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
> Acked-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Simon Horman <horms@verge.net.au>

Applied.
