From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Mon, 09 Aug 2004 10:40:07 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408090140.KAA22024@toshiba.co.jp>
References: <20040801181150.GI14539@sunbeam2>
	<200408020405.NAA27078@toshiba.co.jp>
	<200408072105.GAA23792@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        netfilter-devel@lists.netfilter.org, kisza@securityaudit.hu,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: yasuyuki.kozakai@toshiba.co.jp
In-Reply-To: <200408072105.GAA23792@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Sorry for my misstakes ...

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Sun, 08 Aug 2004 06:05:35 +0900 (JST)

> 2.1 On router
> I applied the patches to kernel on a router, inserted 2000 non-matching rules
                                                        ^^^^
This is 1000.

> 2.2 On host
> I applied the patches to kernel on a host, inserted 1000 non-matching rules
                                                      ^^^^
This is 2000.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
