From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko]
 undefined!
Date: Fri, 22 Apr 2005 21:07:04 +0900 (JST)
Message-ID: <20050422.210704.52375730.yoshfuji@linux-ipv6.org>
References: <200504221331.27454.pluto@pld-linux.org>
	<20050422.205957.47968472.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pluto@pld-linux.org
In-Reply-To: <20050422.205957.47968472.yoshfuji@linux-ipv6.org>
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

In article <20050422.205957.47968472.yoshfuji@linux-ipv6.org> (at Fri, 22 Apr 2005 20:59:57 +0900 (JST)), YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> says:

> I disagree. Please try not to use nd_tbl;
> maybe, by making and exporting neigh_lookup().

Oops, ndisc_lookup().

-- 
Hideaki YOSHIFUJI @ USAGI Project <yoshfuji@linux-ipv6.org>
Homepage: http://www.yoshifuji.org/~hideaki/
GPG FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
