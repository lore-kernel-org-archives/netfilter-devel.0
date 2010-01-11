From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] net/netfilter/xt_osf.c: Change %pi4 to %pI4
Date: Mon, 11 Jan 2010 11:56:15 +0100
Message-ID: <4B4B03CF.8050004@trash.net>
References: <1262830818.1872.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1262830818.1872.52.camel@Joe-Laptop.home>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Joe Perches wrote:
> commit 8a27f7c90ffcb791eed7574922b51fb60b08fc89
> changed the output style of %pi4 to use fixed
> width leading zero IP addresses "001.002.003.004".
> 
> It's useful when printing multiple lines of
> addresses, but was a change in output style for
> some existing uses.
> 
> Using %pI4 restores the previous output style.

Applied, thanks.
