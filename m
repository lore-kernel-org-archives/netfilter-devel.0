From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] fixes for ipv6header/eui64 and introduce
 skb_header_pointer
Date: Thu, 04 Nov 2004 19:44:27 +0900 (JST)
Message-ID: <200411041044.iA4AiSWj006510@toshiba.co.jp>
References: <200411010840.iA18eeia001852@toshiba.co.jp>
	<41899235.1030309@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <41899235.1030309@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 04 Nov 2004 03:21:41 +0100

> Yasuyuki Kozakai wrote:
> 
> >Hi, all
> >
> >These patches fix bugs in ipv6header and eui64 match.
> >And also introduce skb_header_pointer() to ipv6header match.
> >
> All applied, thanks Yasuyuki. Could you also provide patches
> with the fixes needed for 2.4 ?

OK, today I wrote patches for 2.4 and started testing them. But I don't have
enough time to test next week, maybe I'll send them at the week after next.

By the way, is there any other IPv6 module which is needed to change to work
without skb_linearize() ? If no, we can finally remove it from ip6_tables.c

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
