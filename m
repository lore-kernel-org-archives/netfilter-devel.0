From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_socket: fix broken v0 support
Date: Mon, 15 Jul 2013 20:20:21 +0200
Message-ID: <20130715182021.GA12140@localhost>
References: <1373595739.4600.123.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev <netdev@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org,
	Neal Cardwell <ncardwell@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373595739.4600.123.camel@edumazet-glaptop>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jul 11, 2013 at 07:22:19PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 681f130f39e10 ("netfilter: xt_socket: add XT_SOCKET_NOWILDCARD
> flag") added a potential NULL dereference if an old iptables package
> uses v0 of the match.
> 
> Fix this by removing the test on @info in fast path.
> 
> IPv6 can remove the test as well, as it uses v1 or v2.

Applied, thanks Eric.
