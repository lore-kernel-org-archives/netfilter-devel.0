From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next] nf_nat: make find/put static
Date: Mon, 04 Oct 2010 20:54:12 +0200
Message-ID: <4CAA22D4.9040106@trash.net>
References: <20101002141736.0a31bcd7@s6510>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20101002141736.0a31bcd7@s6510>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Am 02.10.2010 07:17, schrieb Stephen Hemminger:
> The functions nf_nat_proto_find_get and nf_nat_proto_put are
> only used internally in nf_nat_core. This might break some out
> of tree NAT module.

Applied, thanks Stephen.
