From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] netfilter: xtables make functions local
Date: Sat, 28 Dec 2013 01:21:29 -0500 (EST)
Message-ID: <20131228.012129.170537567898112631.davem@davemloft.net>
References: <20131227120937.702bc383@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: stephen@networkplumber.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20131227120937.702bc383@nehalam.linuxnetplumber.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Fri, 27 Dec 2013 12:09:37 -0800

> A couple of functions only used in x_tables, don't need to be global
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

I'll let Pablo pick this up, thanks.
