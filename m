From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 03 Sep 2007 12:06:51 +0200
Message-ID: <46DBDCBB.8080903@trash.net>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<46DBD8CD.9060804@trash.net>
	<20070903100148.GG18480@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070903100148.GG18480@postel.suug.ch>
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

Thomas Graf wrote:
> * Patrick McHardy <kaber@trash.net> 2007-09-03 11:50
> 
>>Philip Craig wrote:
>>
>>>+#define NFA_NEST(skb, type) \
>>>+({	struct nfattr *__start = (struct nfattr *)skb_tail_pointer(skb); \
>>>+	NFA_PUT(skb, (NFNL_NFA_NEST | type), 0, NULL); \
>>>+	__start;  })
>>
>>
>>The latest libnetfilter_conntrack version doesn't send the NFA_NEST
>>bit to the kernel anymore since we intend to get rid of it, at
>>least on the receive side. Please change this to not send it here
>>as well.
> 
> 
> Great, so basically the attribute interfaces could be merged on the
> sending side.


Yes, hopefully. We're using big endian for numeric values, but that
shouldn't be a problem I think.

> I think I can live with checking for the bit on the receiving side,
> the only problem it could cause is when the attribute type is used
> to encode information such as a port number. So if we are willing
> to take that risk the receiving path could be merged as well.


That kind of information should be stored as attribute value, no?
