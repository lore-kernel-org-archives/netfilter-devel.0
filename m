From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Sat, 26 Jun 2004 16:25:13 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406260725.QAA11173@toshiba.co.jp>
References: <200406250457.NAA07080@toshiba.co.jp>
	<Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
        netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
        kisza@securityaudit.hu, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.33.0406251133230.11001-100000@blackhole.kfki.hu>
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

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Fri, 25 Jun 2004 12:01:37 +0200 (CEST)

> > > >Sorry, I misstook. But why nf_hook_slow() ? I think users expect that
> > > >skb is not linearized if ip_tables.ko is not loaded.
> > > >Then how about ipt_do_table() or hooks in iptable_filter.c ?
> > > >
> > > It would be nice if the skb_copy_bits calls in conntrack and nat copying
> > > only the transport protocol headers could be removed as well. We could
> > > register for the PREROUTING hook with highest priority and linearize the
> > > headers when a global flag is set. ip_conntrack and ip_tables would both
> > > set this flag.
> >
> > flag is good idea. But in the case of IPv6, the fact remains that
> > skipping IPv6 ext headers are needed to find transport protocol.
> 
> - conntrack requires linearized protocol headers
> 	- with the TCP window tracking code it means the complete
> 	  TCP header, including the options due to the SACK support
> - nat requires writable protocol headers, including the TCP options
>   due to the SACK support
> - raw/filter tables require linearized protocol headers in general (we can
>   safely assume port matching rules :-)
> - mark table requires writable protocol headers if we mangle the packet
>   headers

That's right at this point.

> So I think when any component of netfilter is enabled, we can assume that
> at least linearized protocol headers are required. Therefore I suggested
> to add such a function to nf_hook_slow.

As you said, I think nf_hook_slow is best point for IPv4 modules.
And I found that the issue of IPv6 can be solved by adding flag to the
argument nf_hook_register(). This flag tell whether request to linearize
or not.

And I have a (maybe) last issue. Are we allowed to add protocol dependent
codes to nf_hook_slow() ?

> We cannot add (back) a general skb_linearize: that was a constant complain
> against netfilter from performance reason and was therefore removed.

I think so, too.

> In order to spare skipping again and again the extension headers in IPv6,
> wouldn't it make sense to add a new argument to the hook functions which
> argument would point then to the protocol header?

If so, the transport protocol number is needed, too. You can find the
transport protocol number at Next Header field in previous header.

> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary

Best regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
