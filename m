From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Thu, 24 Jun 2004 15:25:54 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406241510140.8190-100000@blackhole.kfki.hu>
References: <200406241304.WAA12656@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	<netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>, <kisza@securityaudit.hu>,
	<usagi-core@linux-ipv6.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200406241304.WAA12656@toshiba.co.jp>
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

On Thu, 24 Jun 2004, Yasuyuki Kozakai wrote:

> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Thu, 24 Jun 2004 13:50:27 +0200 (CEST)
>
> > On Thu, 24 Jun 2004, Patrick McHardy wrote:
> >
> > > I'm not sure the way iptables does it is really the right way. We call
> > > skb_copy_bits for anything that needs to be matched after the ip_header.
> > > Think of 100 rules matching "-p tcp --dport X". We copy the tcp header
> > > 100 times, for a total of 2000 bytes. One call to skb_linearize would
> > > most likely be less expensive. I'm thinking about putting the copied
> > > protocol header in the control buffer, this would reduce this extensive
> > > copying a lot. We could also do some common preprocessing steps in one
> > > place, like converting things to host byte order.
> >
> > Wouldn't an skb_ip[6]_make_headers_writable function based on
> > skb_ip_make_writable more optimal?
>
> I think so in the case of IPv4.
>
> > The function would make the full IP[v6], transport protocol (and IPv6
> > option protocol) headers writable and could be called from nf_hook_slow.
>
> skb is not required to be writable. if skb_headlen(skb) is greater than
> the length required to be linear, copying is not needed even though skb is
> shared or clone.

Your're of course right. For matching we don't really need the headers to
be writable, linear is just enough. However mangle and NAT requires
writable headers because typically we modify the headers only (let's not
consider the conntrack/NAT protocol helpers).

> And one issue is that the argument "skb" in match() is const. Can we
> really remove it ?

I'm confused: why should we remove it? The function would be called
directly from nf_hook_slow and not from the matches.

> And I'm not sure about IPv6. At least, I don't like to skip IPv6 extension
> header in skb_ip6_make_writable() to figure out that skb should be copied
> or pulled.

I'm unfamiliar with the deep magic behind IPv6: I simply assumed that
linear headers up to the transport protocol headers in IPv6 would just be
fine and enough for the matches. That'd require an ugly processing header
by header in skb_ip6_make_headers_linear ;-), I think.

I'll try to cook some code to see how it'd come out.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
