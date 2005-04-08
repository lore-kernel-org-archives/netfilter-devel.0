From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: (usagi-core 22742) Re: [PATCH] REJECT for 2.6.9+
Date: Fri, 08 Apr 2005 18:41:53 +0900 (JST)
Message-ID: <200504080941.j389frQT003417@toshiba.co.jp>
References: <42503569.5080406@trash.net>
	<200504080758.j387wkif011777@toshiba.co.jp>
	<20050408.173206.113294790.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: yoshfuji@linux-ipv6.org
In-Reply-To: <20050408.173206.113294790.yoshfuji@linux-ipv6.org>
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


It just calls icmpv6_send().

Please see

http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c?rev=3812&view=auto

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date: Fri, 08 Apr 2005 17:32:06 +0900 (JST)

> In article <200504080758.j387wkif011777@toshiba.co.jp> (at Fri, 08 Apr 2005 16:58:45 +0900 (JST)), Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> says:
> 
> > This patch makes send_reset() look xfrm policy and deletes unnecessary
> > dst_hold().
> > 
> > 	Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
> 
> How about send_unreach()?
> 
> --yoshfuji
> 
