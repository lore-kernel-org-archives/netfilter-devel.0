From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next 0/2] netfilter: IPv4/v6 IPcomp match support
Date: Tue, 17 Dec 2013 14:05:55 +0100
Message-ID: <20131217130555.GA8874@localhost>
References: <1386937082-30412-1-git-send-email-fan.du@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, steffen.klassert@secunet.com,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Fan Du <fan.du@windriver.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1386937082-30412-1-git-send-email-fan.du@windriver.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 13, 2013 at 08:18:00PM +0800, Fan Du wrote:
> Hi,
> 
> This patchset adds IPv4/v6 IPComp 'match' plugin to enables user setting
> ACTONs for IPcomp flows sepecified with SPI value.
> 
> Corresponding iptables patchset will be sent here after soon.
> 
> Fan Du (2):
>   netfilter: add IPv4 IPComp extension match support
>   netfilter: add IPv6 IPComp extension match support

This looks good, but I have to ask you to merge those two modules into
one single xt_ipcomp, they are fairly small and we can save the
overhead of having two different modules. Moreover, at quick glance I
don't see any dependency with IPv4/IPv6 exported symbols that may
cause ifdef pollution.

Please, see net/netfilter/xt_tcpudp.c as reference to rework this.
Thanks.
