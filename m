From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] bug fixes and introducing skb_header_pointer() to
 ip6t_frag.c
Date: Wed, 13 Oct 2004 16:19:27 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410130719.i9D7JS8n003916@toshiba.co.jp>
References: <200410070456.i974usIv027450@toshiba.co.jp>
	<416CD206.5080201@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <416CD206.5080201@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 13 Oct 2004 08:58:14 +0200

> Yasuyuki Kozakai wrote:
> 
> >Hi,
> >
> >The first patch fixes following bugs in ip6t_frag.c,
> >
> >	- Wrong cast the pointer to extension header.
> >	- header length of Fragment Header is statically 8 octets.
> >	  Then the option "--frag-len" doesn't make sense.
> >	- There are endian issues where using frag->info.
> >	- Reserved fields are not 2 bit but 8bit + 2 bit. (see RFC2460)
> >
> >And the second patch enables ip6t_frag.c to work without skb_linearize().
> >
> >Before trying these patches, don't forget to apply the patch which prepare
> >to removing skb_linearize().
> >
> 
> Thanks Yasuyuki, your patches all look great. I've applied the
> prepare-to-remove-skb_linearize and skb_header_pointer patches
> to a post-2.6.9 tree and will push the fixes to Dave immediately.
> Just one thing, please sign off your patches next time.

Thanks a lot. Just in case...

	 Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
