From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Fri, 25 Jun 2004 13:57:39 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406250457.NAA07080@toshiba.co.jp>
References: <Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
	<200406241506.AAA06087@toshiba.co.jp>
	<40DB0658.3070604@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@lists.netfilter.org,
        laforge@netfilter.org, kisza@securityaudit.hu,
        usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <40DB0658.3070604@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, 

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 24 Jun 2004 18:50:32 +0200

> Yasuyuki Kozakai wrote:
> >
> >Sorry, I misstook. But why nf_hook_slow() ? I think users expect that
> >skb is not linearized if ip_tables.ko is not loaded.
> >Then how about ipt_do_table() or hooks in iptable_filter.c ?
> >
> It would be nice if the skb_copy_bits calls in conntrack and nat copying
> only the transport protocol headers could be removed as well. We could
> register for the PREROUTING hook with highest priority and linearize the
> headers when a global flag is set. ip_conntrack and ip_tables would both
> set this flag.

flag is good idea. But in the case of IPv6, the fact remains that
skipping IPv6 ext headers are needed to find transport protocol.

> >In the first place, I don't understand why skb_ip_make_writable() checks
> >required length is up to the transport protocol header or not.
> >If skb_ip6_make_headers_linear() will check that too, extension headers are
> >skipped many times. That's why I don't like it. I want to reduce the number of
> >times of skipping extension headers as possible.
> >
> I also don't understand this, I thought the linear part of an skb is
> skb_headlen(skb), why the distinction between different protocols ?

It looks like this function was introduced in 2.5.70 by Rusty Russel.

Anyway, I think the function which requires to skip IPv6 extension headers
should not be called in nf_hook_slow() since skipping is occurred 2 times
- nf_hook_slow() and ip6_do_table(). It's better to linearize header by header
while finding transport protocol header in ip6_do_table().

> Regards
> Patrick

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
