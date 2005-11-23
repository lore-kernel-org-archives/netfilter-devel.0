From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack & NAT
Date: Wed, 23 Nov 2005 21:25:47 +0900 (JST)
Message-ID: <200511231225.jANCPmYd015427@toshiba.co.jp>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl
In-Reply-To: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
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


Hi,

From: Krzysztof Oledzki <olenf@ans.pl>
Date: Wed, 23 Nov 2005 12:30:07 +0100 (CET)

> Hello,
> 
> As we have now working nfnetlink in nf_conntrack (thanks!) I'm wonder if 
> there any plans for porting IPv4 NAT to nf_conntrack

Of cause we have. But

>                                                      and adding NAT 
> support for IPv6?

Never ever. You can learn why people don't want to do it from many sources.
For example, You can use many addresses in IPv6 world. And I don't want people
get troubles due to NAT traversal issues in IPv6 world.

-- Yasuyuki Kozakai
