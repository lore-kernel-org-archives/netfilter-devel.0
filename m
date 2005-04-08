From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: (usagi-core 22748) Re: [PATCH] REJECT for 2.6.9+
Date: Fri, 08 Apr 2005 18:48:37 +0900 (JST)
Message-ID: <20050408.184837.121601242.yoshfuji@linux-ipv6.org>
References: <200504080758.j387wkif011777@toshiba.co.jp>
	<20050408.173206.113294790.yoshfuji@linux-ipv6.org>
	<200504080941.j389frQT003417@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200504080941.j389frQT003417@toshiba.co.jp>
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

In article <200504080941.j389frQT003417@toshiba.co.jp> (at Fri, 08 Apr 2005 18:41:53 +0900 (JST)), Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> says:

> 
> It just calls icmpv6_send().
> 
> Please see
> 
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c?rev=3812&view=auto

Ah, ok, thanks.

--yoshfuji
