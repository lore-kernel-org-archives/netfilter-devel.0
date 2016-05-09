From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: remove uninitialized shadow
 variable
Date: Mon, 9 May 2016 22:01:17 +0200
Message-ID: <20160509200117.GA6957@salvia>
References: <1462823254-3137116-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Florian Westphal <fw@strlen.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sasha.levin@oracle.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462823254-3137116-1-git-send-email-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 09, 2016 at 09:47:23PM +0200, Arnd Bergmann wrote:
> A recent commit introduced an unconditional use of an uninitialized
> variable, as reported in this gcc warning:
> 
> net/netfilter/nf_conntrack_core.c: In function '__nf_conntrack_confirm':
> net/netfilter/nf_conntrack_core.c:632:33: error: 'ctinfo' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>    bytes = atomic64_read(&counter[CTINFO2DIR(ctinfo)].bytes);
>                                  ^
> net/netfilter/nf_conntrack_core.c:628:26: note: 'ctinfo' was declared here
>    enum ip_conntrack_info ctinfo;
> 
> The problem is that a local variable shadows the function parameter.
> This removes the local variable, which looks like what Pablo originally
> intended.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Sorry for this, I wonder why gcc didn't catch up this here.

@David, you can integrate this into your net-next tree.

Thanks for fixing up this Arnd.
