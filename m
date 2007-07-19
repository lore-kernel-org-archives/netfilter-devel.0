From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: REDIRECT and IPv6
Date: Thu, 19 Jul 2007 18:21:16 +0900 (JST)
Message-ID: <20070719.182116.64281593.yoshfuji@linux-ipv6.org>
References: <1246.130.217.140.56.1184804730.squirrel@webmail.treenet.co.nz>
	<469F280B.3070900@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: squid3@treenet.co.nz, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469F280B.3070900@trash.net>
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

In article <469F280B.3070900@trash.net> (at Thu, 19 Jul 2007 10:59:55 +0200), Patrick McHardy <kaber@trash.net> says:

> You're right, nf_conntrack_ipv4 only registeres SO_ORIGINAL_DST for
> AF_INET, changing that should make it work I believe. I feel like
> I'm missing something though ..

BTW, the name of the socket option is rather bogus.
It should be named IP_xxx, not SO_xxx because
it is in IP level, not in socket level...

--yoshfuji
