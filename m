From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error and memory leak?
Date: Wed, 24 Sep 2003 07:11:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0309240708480.25611-100000@blackhole.kfki.hu>
References: <20030921150458.GE22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Martin Josefsson <gandalf@wlug.westbo.se>, c0g <c0g@wp.pl>,
	jozsef Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030921150458.GE22223@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 21 Sep 2003, Harald Welte wrote:

> Mh. So why does it call get_tuple() anyway?  To check if the tuple is
> taken (i.e. the packet is part of an already tracked connection)?  I
> think we can safely split this check, since
>
> 1) it tries to work around an obvious misconfiguration by the user
> 2) it adds significant runtime cost to the NOTRACK target (call
>    get_tuple, which calls in turn the l4 protocol helper get_tuple, then
>    tuple_taken(), which in turn locks the conntrack lock, ...)
> 3) it introduces the problem above.
>
> Yes, we can still try to make it work, even with that check.  But I
> think we can just skip it and make our life easier.
>
> Jozsef?

I'll release an updated patch before the weekend (together with the
non-userspace 40_nf_log patch).

> btw: I wan to merge the 'raw' table userspace changes into iptables
> before 1.2.9 is released... All we need to make it compile even on a
> non-rawtable-kernel is:
>
> #ifndef IPT_CONNTRACK_STATE_UNTRACKED
> #define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_IS_REPLY+3))
> #endif
>
> in one of our (userspace) header files.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
