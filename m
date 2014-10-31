From: Florian Westphal <fw@strlen.de>
Subject: Re: iptables/ipset "-m set" alignment problem 64bit kernel 32bit
 userspace
Date: Fri, 31 Oct 2014 23:50:37 +0100
Message-ID: <20141031225037.GP10069@breakpoint.cc>
References: <alpine.DEB.2.11.1410312256090.1586@aurora.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Sven-Haegar Koch <haegar@sdinet.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42020 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729AbaJaWuj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:50:39 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410312256090.1586@aurora.sdinet.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sven-Haegar Koch <haegar@sdinet.de> wrote:
> Hallo,
> 
> Problem with 32bit userspace iptables, 64bit kernel and the "-m set" 
> ipset match.
> 
> iptables:
> 32bit, debian 1.4.21-2 plus the ipset patch from the git branch
> 
> kernel:
> 64bit, debian 3.2.63-2+deb7u1 plus ipset 6.23
> 
> When trying to add an iptables set match it fails with the following 
> error when using 64bit kernel and 32bit userspace:
> 
> sims:~# iptables -A OUTPUT -m set --match-set testset src -j ACCEPT
> iptables: Invalid argument. Run `dmesg' for more information.
> 
> In syslog:
> x_tables: ip_tables: set.3 match: invalid size 48 (kernel) != (user) 32
> 
> 
> Adding some hacky paddings to the userspace iptables makes it work with 
> my 64bit kernel, but this way is naturally no real solution:
> 
> (whitespace damaged, cut&paste)
> 
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -238,6 +238,7 @@ enum {
>  
>  struct ip_set_counter_match {
>         __u8 op;
> +       __u8 padding[7];
>         __u64 value;

Ouch.

> I do not see a way to cleanly fix the revision 3 set match, as any 
> change would break it for either existing 32+32 or 64+64 environments -

Right.

The unclean fix is to provide compat fixup hooks to transparently
convert it in the kernel.

See net/netfilter/xt_limit.c for full example, essentially the
target/match description has to provide

static struct xt_match limit_mt_reg __read_mostly = {
        .name             = "limit",
[..]
#ifdef CONFIG_COMPAT
        .compatsize       = sizeof(struct compat_xt_rateinfo),
        .compat_from_user = limit_mt_compat_from_user,
        .compat_to_user   = limit_mt_compat_to_user,
#endif

The size of the 32bit layout and convert hooks that translate
from the 32 to 64 bit layout (and vice versa).

Jozsef -- v4 or compat crap? :-)
