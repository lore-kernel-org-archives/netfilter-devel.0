From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] bug fixes and introducing skb_header_pointer() to
 ip6t_frag.c
Date: Wed, 13 Oct 2004 21:28:56 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410131228.i9DCSvg7017325@toshiba.co.jp>
References: <200410070456.i974usIv027450@toshiba.co.jp>
	<416CD206.5080201@trash.net>
	<20041013.161927.74097059.kozakai@isl.rdc.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20041013.161927.74097059.kozakai@isl.rdc.toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Patrick and all,

From: Yasuyuki Kozakai <kozakai@isl.rdc.toshiba.co.jp>
Date: Wed, 13 Oct 2004 16:19:27 +0900 (JST)

> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 13 Oct 2004 08:58:14 +0200

(snip)

> > Thanks Yasuyuki, your patches all look great. I've applied the
> > prepare-to-remove-skb_linearize and skb_header_pointer patches
> > to a post-2.6.9 tree and will push the fixes to Dave immediately.
> > Just one thing, please sign off your patches next time.

By the way, same fixes are needed to linux 2.4, too ? If so, I'll
make patches which doesn't include skb_header_pointer(). But I wonder
I can change the arguments of match/target functions in linux 2.4
so that ip6tables.c skips extension header correctly.

comments ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
