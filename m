From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= <yoshfuji@linux-ipv6.org>
Subject: Re: (usagi-core 18584) Re: [PATCH]: 1st step to remove
 skb_linearize() in ip6_tables.c and optimization
Date: Thu, 24 Jun 2004 22:48:29 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040624.224829.125081590.yoshfuji@linux-ipv6.org>
References: <200406241304.WAA12656@toshiba.co.jp>
	<Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
	netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
	kisza@securityaudit.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: usagi-core@linux-ipv6.org, kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In article <Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu> (at Thu, 24 Jun 2004 15:25:54 +0200 (CEST)), Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> says:

> I'm unfamiliar with the deep magic behind IPv6: I simply assumed that
> linear headers up to the transport protocol headers in IPv6 would just be
> fine and enough for the matches. That'd require an ugly processing header
> by header in skb_ip6_make_headers_linear ;-), I think.

It is full of beauty to process header by header.
Skip processing extension header is BAD idea.
You cannot (and shouldn't) see next header (or payload)
until you really process the current header.

--yoshfuji
