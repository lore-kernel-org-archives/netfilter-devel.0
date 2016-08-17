From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: tproxy: properly refcount tcp listeners
Date: Thu, 18 Aug 2016 00:51:40 +0200
Message-ID: <20160817225140.GA5966@salvia>
References: <627722c51d9ce454dfaf1a79519ceb59@nuclearcat.com>
 <1471448525.29842.1.camel@edumazet-glaptop3.roam.corp.google.com>
 <1471449871.29842.3.camel@edumazet-glaptop3.roam.corp.google.com>
 <09c3ca74357572464b5ff280f1cd0ddc@nuclearcat.com>
 <1471453006.29842.15.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>,
	David Miller <davem@davemloft.net>,
	Linux Kernel Network Developers <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471453006.29842.15.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Aug 17, 2016 at 09:56:46AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> inet_lookup_listener() and inet6_lookup_listener() no longer
> take a reference on the found listener.
> 
> This minimal patch adds back the refcounting, but we might do
> this differently in net-next later.

Applied, thanks Eric!
