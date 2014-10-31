From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: iptables/ipset "-m set" alignment problem 64bit kernel 32bit
 userspace
Date: Fri, 31 Oct 2014 23:57:50 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1410312352260.15556@nerf08.vanv.qr>
References: <alpine.DEB.2.11.1410312256090.1586@aurora.sdinet.de> <20141031225037.GP10069@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven-Haegar Koch <haegar@sdinet.de>,
	netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:39611 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaJaW5x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:57:53 -0400
In-Reply-To: <20141031225037.GP10069@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2014-10-31 23:50, Florian Westphal wrote:
>
>The unclean fix is to provide compat fixup hooks to transparently
>convert it in the kernel.
>
>[..]
>#ifdef CONFIG_COMPAT
>        .compatsize       = sizeof(struct compat_xt_rateinfo),
>        .compat_from_user = limit_mt_compat_from_user,
>        .compat_to_user   = limit_mt_compat_to_user,
>#endif
>
>The size of the 32bit layout and convert hooks that translate
>from the 32 to 64 bit layout (and vice versa).

That is not going to work, especially if you have more than three or
more ABIs in the system. Like, o32/n32/64 for mips (or
i386/x86_64/x32). A report about that happens about every year on the
mailing list.

The only fix is to define a v4, and to make sure that there is no
implicit padding of 32 bits or more.
