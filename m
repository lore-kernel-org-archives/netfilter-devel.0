From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: (usagi-core 22742) Re: [PATCH] REJECT for 2.6.9+
Date: Fri, 08 Apr 2005 17:32:06 +0900 (JST)
Message-ID: <20050408.173206.113294790.yoshfuji@linux-ipv6.org>
References: <200503300205.j2U25fCc021930@toshiba.co.jp>
	<42503569.5080406@trash.net>
	<200504080758.j387wkif011777@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200504080758.j387wkif011777@toshiba.co.jp>
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

In article <200504080758.j387wkif011777@toshiba.co.jp> (at Fri, 08 Apr 2005 16:58:45 +0900 (JST)), Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> says:

> This patch makes send_reset() look xfrm policy and deletes unnecessary
> dst_hold().
> 
> 	Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

How about send_unreach()?

--yoshfuji
