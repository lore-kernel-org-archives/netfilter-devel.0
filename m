From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sun, 19 Jun 2005 17:18:13 -0700 (PDT)
Message-ID: <20050619.171813.104659699.davem@davemloft.net>
References: <42B56D9B.9070401@trash.net>
	<E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@manty.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, kaber@trash.net,
	ebtables-devel@lists.sourceforge.net, rankincj@yahoo.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: herbert@gondor.apana.org.au
In-Reply-To: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 20 Jun 2005 10:05:42 +1000

> Patrick McHardy <kaber@trash.net> wrote:
> >
> > The bridge-netfilter code defers calling of some NF_IP_* hooks to the
> > bridge layer, when the conntrack reference is already gone, so the entry
> 
> Why does it defer them at all? Shouldn't the fact that the device is
> bridged be transparent to the IP layer?

The bridge netfilter layer uses netif_rx(skb) at the deepest level in
order to avoid too deep stack usage.

This is also why the NF_HOOK*() macros were semantically changed
a little bit several months ago.
