From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c
 and optimization
Date: Fri, 25 Jun 2004 00:06:49 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406241506.AAA06087@toshiba.co.jp>
References: <200406241304.WAA12656@toshiba.co.jp>
	<Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, kaber@trash.net,
        netfilter-devel@lists.netfilter.org, laforge@netfilter.org,
        kisza@securityaudit.hu, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
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
Date: Thu, 24 Jun 2004 15:25:54 +0200 (CEST)

> > > The function would make the full IP[v6], transport protocol (and IPv6
> > > option protocol) headers writable and could be called from nf_hook_slow.
> >
> > skb is not required to be writable. if skb_headlen(skb) is greater than
> > the length required to be linear, copying is not needed even though skb is
> > shared or clone.
> 
> Your're of course right. For matching we don't really need the headers to
> be writable, linear is just enough. However mangle and NAT requires
> writable headers because typically we modify the headers only (let's not
> consider the conntrack/NAT protocol helpers).
> 
> > And one issue is that the argument "skb" in match() is const. Can we
> > really remove it ?
> 
> I'm confused: why should we remove it? The function would be called
> directly from nf_hook_slow and not from the matches.

Sorry, I misstook. But why nf_hook_slow() ? I think users expect that
skb is not linearized if ip_tables.ko is not loaded.
Then how about ipt_do_table() or hooks in iptable_filter.c ?

> > And I'm not sure about IPv6. At least, I don't like to skip IPv6 extension
> > header in skb_ip6_make_writable() to figure out that skb should be copied
> > or pulled.
> 
> I'm unfamiliar with the deep magic behind IPv6: I simply assumed that
> linear headers up to the transport protocol headers in IPv6 would just be
> fine and enough for the matches. That'd require an ugly processing header
> by header in skb_ip6_make_headers_linear ;-), I think.

In the first place, I don't understand why skb_ip_make_writable() checks
required length is up to the transport protocol header or not.
If skb_ip6_make_headers_linear() will check that too, extension headers are
skipped many times. That's why I don't like it. I want to reduce the number of
times of skipping extension headers as possible.

Regards,

> I'll try to cook some code to see how it'd come out.
> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
