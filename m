From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Thu, 24 Jun 2004 18:50:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DB0658.3070604@trash.net>
References: <200406241304.WAA12656@toshiba.co.jp>	<Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu> <200406241506.AAA06087@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@lists.netfilter.org,
	laforge@netfilter.org, kisza@securityaudit.hu,
	usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200406241506.AAA06087@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki Kozakai wrote:

>>I'm confused: why should we remove it? The function would be called
>>directly from nf_hook_slow and not from the matches.
>>
>
>Sorry, I misstook. But why nf_hook_slow() ? I think users expect that
>skb is not linearized if ip_tables.ko is not loaded.
>Then how about ipt_do_table() or hooks in iptable_filter.c ?
>
It would be nice if the skb_copy_bits calls in conntrack and nat copying
only the transport protocol headers could be removed as well. We could
register for the PREROUTING hook with highest priority and linearize the
headers when a global flag is set. ip_conntrack and ip_tables would both
set this flag.

>>>And I'm not sure about IPv6. At least, I don't like to skip IPv6 extension
>>>header in skb_ip6_make_writable() to figure out that skb should be copied
>>>or pulled.
>>>
>>I'm unfamiliar with the deep magic behind IPv6: I simply assumed that
>>linear headers up to the transport protocol headers in IPv6 would just be
>>fine and enough for the matches. That'd require an ugly processing header
>>by header in skb_ip6_make_headers_linear ;-), I think.
>>
>
>In the first place, I don't understand why skb_ip_make_writable() checks
>required length is up to the transport protocol header or not.
>If skb_ip6_make_headers_linear() will check that too, extension headers are
>skipped many times. That's why I don't like it. I want to reduce the number of
>times of skipping extension headers as possible.
>
I also don't understand this, I thought the linear part of an skb is
skb_headlen(skb), why the distinction between different protocols ?

Regards
Patrick
