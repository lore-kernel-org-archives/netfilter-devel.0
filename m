From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: iptables/ipset "-m set" alignment problem 64bit kernel 32bit
 userspace
Date: Sat, 1 Nov 2014 10:51:12 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411011047410.7336@blackhole.kfki.hu>
References: <alpine.DEB.2.11.1410312256090.1586@aurora.sdinet.de> <20141031225037.GP10069@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven-Haegar Koch <haegar@sdinet.de>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:46602 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaKAJub (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Nov 2014 05:50:31 -0400
In-Reply-To: <20141031225037.GP10069@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 31 Oct 2014, Florian Westphal wrote:

> Sven-Haegar Koch <haegar@sdinet.de> wrote:
> > Hallo,
> > 
> > Problem with 32bit userspace iptables, 64bit kernel and the "-m set" 
> > ipset match.
> > 
> > iptables:
> > 32bit, debian 1.4.21-2 plus the ipset patch from the git branch
> > 
> > kernel:
> > 64bit, debian 3.2.63-2+deb7u1 plus ipset 6.23
> > 
> > When trying to add an iptables set match it fails with the following 
> > error when using 64bit kernel and 32bit userspace:
> > 
> > sims:~# iptables -A OUTPUT -m set --match-set testset src -j ACCEPT
> > iptables: Invalid argument. Run `dmesg' for more information.
> > 
> > In syslog:
> > x_tables: ip_tables: set.3 match: invalid size 48 (kernel) != (user) 32
> > 
> > 
> > Adding some hacky paddings to the userspace iptables makes it work with 
> > my 64bit kernel, but this way is naturally no real solution:
> > 
> > (whitespace damaged, cut&paste)
> > 
> > --- a/include/linux/netfilter/ipset/ip_set.h
> > +++ b/include/linux/netfilter/ipset/ip_set.h
> > @@ -238,6 +238,7 @@ enum {
> >  
> >  struct ip_set_counter_match {
> >         __u8 op;
> > +       __u8 padding[7];
> >         __u64 value;
> 
> Ouch.
> 
> > I do not see a way to cleanly fix the revision 3 set match, as any 
> > change would break it for either existing 32+32 or 64+64 environments -
> 
> Right.
> 
> The unclean fix is to provide compat fixup hooks to transparently
> convert it in the kernel.
> 
> See net/netfilter/xt_limit.c for full example, essentially the
> target/match description has to provide
> 
> static struct xt_match limit_mt_reg __read_mostly = {
>         .name             = "limit",
> [..]
> #ifdef CONFIG_COMPAT
>         .compatsize       = sizeof(struct compat_xt_rateinfo),
>         .compat_from_user = limit_mt_compat_from_user,
>         .compat_to_user   = limit_mt_compat_to_user,
> #endif
> 
> The size of the 32bit layout and convert hooks that translate
> from the 32 to 64 bit layout (and vice versa).
> 
> Jozsef -- v4 or compat crap? :-)

v4 of course! That's the best way to go...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
