From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Tue, 04 Sep 2007 11:18:35 +1000
Message-ID: <46DCB26B.4060902@snapgear.com>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<46DBD8CD.9060804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DBD8CD.9060804@trash.net>
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

Patrick McHardy wrote:
> Philip Craig wrote:
>> +#define NFA_NEST(skb, type) \
>> +({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
>> +	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
>> +	__start;  })
> 
> 
> The latest libnetfilter_conntrack version doesn't send the NFA_NEST
> bit to the kernel anymore since we intend to get rid of it, at
> least on the receive side. Please change this to not send it here
> as well.

This is just a copy of the kernel header (maybe an old one though).
I haven't added send support to libnl yet, but when I do I'll be
sure not to use this.
