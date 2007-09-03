From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 03 Sep 2007 11:50:05 +0200
Message-ID: <46DBD8CD.9060804@trash.net>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DB9776.8020209@snapgear.com>
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

Philip Craig wrote:
> +#define NFA_NEST(skb, type) \
> +({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
> +	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
> +	__start;  })


The latest libnetfilter_conntrack version doesn't send the NFA_NEST
bit to the kernel anymore since we intend to get rid of it, at
least on the receive side. Please change this to not send it here
as well.
