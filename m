From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 0/4] fixes for dst/hbh and introducing skb_header_pointer()
Date: Fri, 22 Oct 2004 11:54:05 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410220254.i9M2s6br003008@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, all,

These patches fix the following bugs in ip6t_{dst, hbh}.c and introduces
skb_header_pointer() to them.

ip6t_dst.c:

	- ".me = THIS_MODULE," is missing 

common bugs in ip6t_{dst,hbh}.c:

	- The cast of the pointer to the next IPv6 extension header is wrong.

	- hdrlen may underflow.

	- (u16)*optdesc causes to alignment problem.

	- The calculation of the offset to next option is wrong. In the case
	  that the type isn't 0, it should be "Opt Data Len" field + 2
	  (see RFC2460).

By the way, In the original code, if ip6tables passes 0xFF as "Opt Data Len",
length check is skipped. But this field in the packet is possible to be 0xFF.
This means that user cannot make a rule matching the 255 bytes option.
I don't know this is the bug or intended behavior, so I didn't change it.

Before trying these patches, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
