From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: (usagi-core 19560) [RFC] filtering bridged IPv6 traffic
Date: Wed, 01 Sep 2004 10:09:51 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409010109.i8119qSB018496@toshiba.co.jp>
References: <200408312309.59155.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yoshfuji@linux-ipv6.org, davem@redhat.com,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: usagi-core@linux-ipv6.org, bdschuym@pandora.be
In-Reply-To: <200408312309.59155.bdschuym@pandora.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


[Cc'ing netfilter-devel]

Hi,

From: Bart De Schuymer <bdschuym@pandora.be>
Date: Tue, 31 Aug 2004 23:09:59 +0200

> Hello,
> 
> Dave redirected me to this list.
> I have made a patch that allows ip6tables to see bridged IPv6 traffic. The 
> patch has been tested but there is one thing I'm not sure about.

Great. This was missing piece.

> Before giving a bridged IPv6 packet to ip6tables, the IPv6 sanity checks are 
> done (copied from ipv6_rcv()). Unfortunately, these checks are more 
> complicated than the ones done for IPv4. I would like to know which checks 
> are necessary for ip6tables not to behave oddly (oops or whatever).
> 
> I'm particularly interested in knowing if the check below has to be done 
> (copied from ipv6_rcv()):
> 
> if (hdr->nexthdr == NEXTHDR_HOP) {
>         skb->h.raw = (u8*)(hdr+1);
>         if (ipv6_parse_hopopts(skb, offsetof(struct ipv6hdr, nexthdr)) < 0) {
>                 IP6_INC_STATS_BH(IPSTATS_MIB_INHDRERRORS);
>                 return 0;
>         }
>         hdr = skb->nh.ipv6h;
> }
>
> If it's necessary to call ipv6_parse_hopopts() then this function will need
> to be exported (the other option would be copying all the code to 
> br_netfilter.c). Note that we only need ip6tables to behave correctly. So,
> if this function call is not absolutely needed, I would opt not to call it.

I don't correctly know why HBH header is processed before PRE_ROUTING.
But at least, trimming the packet length is necessary if it is jumbo payload.

> I think the line skb->h.raw = (u8*)(hdr+1); will be needed for ip6tables to 
> behave correctly. This can be easily undone later, so that should be no 
> problem.

I think this is not necessary. If I understand correctly, netfilter assumes
that
	- skb->nh.raw and skb->data point to the start of IPv6 header
	- skb->len is equal to the length from the start of IPv6 header
	  to the end of application data.

When netfilter want the transport header, it parses IPv6 header and extension
headers.

> 
> Is the IP6CB stuff needed for ip6tables? My guess is no.

No.

> Since the patch has already been posted on netdev and netfilter-devel, I opted 
> not to post it here again. I'll happily send it to you if you'd like to have 
> a look (it is versus 2.6.8.1) . The patch has been tested by someone with 
> ip6tables and he found no problems, but I guess I'll be setting up a little 
> IPv6 network in the near future to test it myself.
> 
> cheers,
> Bart

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
