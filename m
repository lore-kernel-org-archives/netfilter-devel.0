From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Thu, 4 Nov 2004 13:00:28 -0800
Message-ID: <20041104130028.099fc130.davem@davemloft.net>
References: <418A7B0B.7040803@trash.net>
	<E1CPoUT-0000sk-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	kaber@trash.net, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <E1CPoUT-0000sk-00@gondolin.me.apana.org.au>
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

On Fri, 05 Nov 2004 07:45:53 +1100
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Patrick McHardy <kaber@trash.net> wrote:
> >
> > The data that is changed is only a copy, the actual packet is not touched.
> 
> Does it call skb_ip_make_writable anywhere? If not then it may be
> shared/cloned and can't be written at all.

You're right... the bug was introduced by my skb_header_pointer() changes.
Look at this:

	amp = skb_header_pointer(skb, dataoff,
				 skb->len - dataoff, amanda_buffer);
	BUG_ON(amp == NULL);
	data = amp;
	data_limit = amp + skb->len - dataoff;
	*data_limit = '\0';

It should just use the amanda_buffer always.
