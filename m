From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: Re: [PATCH] iptables: link libxtables against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 11:19:48 -0300
Message-ID: <520A4084.200@zacarias.com.ar>
References: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar> <20130813135932.GJ29345@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:57476 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab3HMOT5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:19:57 -0400
In-Reply-To: <20130813135932.GJ29345@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/13/2013 10:59 AM, Florian Westphal wrote:

> Only with --enable-static, right?
> Can you make it conditional on ENABLE_STATIC, like this?

Not really, it's failing for a dynamic build as well, remember binutils
2.22+ defaults to --no-copy-dt-needed (it's patched away in many
distributions to avoid the general package build breakage).
It's failing for me on a buildroot cross build which doesn't patch binutils.
Regards.

-----

/bin/sh ../libtool --tag=CC   --mode=link
/home/gustavoz/b/net/output/host/usr/bin/i686-pc-linux-gnu-gcc -Wall
-Waggregate-return -Wmissing-declarations    -Wmissing-prototypes
-Wredundant-decls -Wshadow -Wstrict-prototypes         -Winline -pipe
-DALL_INCLUSIVE -DENABLE_IPV4 -DENABLE_IPV6 -pipe -Os    -o
xtables-multi xtables_multi-xtables-multi.o xtables_multi-iptables-xml.o
xtables_multi-iptables-save.o xtables_multi-iptables-restore.o
xtables_multi-iptables-standalone.o xtables_multi-iptables.o
xtables_multi-ip6tables-save.o xtables_multi-ip6tables-restore.o
xtables_multi-ip6tables-standalone.o xtables_multi-ip6tables.o
xtables_multi-xshared.o ../extensions/libext.a ../libiptc/libip4tc.la
../extensions/libext4.a ../libiptc/libip6tc.la ../extensions/libext6.a
../libxtables/libxtables.la -lm
libtool: link:
/home/gustavoz/b/net/output/host/usr/bin/i686-pc-linux-gnu-gcc -Wall
-Waggregate-return -Wmissing-declarations -Wmissing-prototypes
-Wredundant-decls -Wshadow -Wstrict-prototypes -Winline -pipe
-DALL_INCLUSIVE -DENABLE_IPV4 -DENABLE_IPV6 -pipe -Os -o xtables-multi
xtables_multi-xtables-multi.o xtables_multi-iptables-xml.o
xtables_multi-iptables-save.o xtables_multi-iptables-restore.o
xtables_multi-iptables-standalone.o xtables_multi-iptables.o
xtables_multi-ip6tables-save.o xtables_multi-ip6tables-restore.o
xtables_multi-ip6tables-standalone.o xtables_multi-ip6tables.o
xtables_multi-xshared.o  ../extensions/libext.a
../libiptc/.libs/libip4tc.so ../extensions/libext4.a
../libiptc/.libs/libip6tc.so ../extensions/libext6.a
../libxtables/.libs/libxtables.so -lm -Wl,-rpath
-Wl,/home/gustavoz/b/net/output/build/iptables-1.4.20/libiptc/.libs
-Wl,-rpath
-Wl,/home/gustavoz/b/net/output/build/iptables-1.4.20/libxtables/.libs
../extensions/libext.a(libxt_connlabel.o): In function `connlabel_get_name':
libxt_connlabel.c:(.text+0xe): undefined reference to
`nfct_labelmap_get_name'
../extensions/libext.a(libxt_connlabel.o): In function `connlabel_mt_parse':
libxt_connlabel.c:(.text+0x6a): undefined reference to
`nfct_labelmap_get_bit'
../extensions/libext.a(libxt_connlabel.o): In function
`libxt_connlabel_init':
libxt_connlabel.c:(.text+0x1ab): undefined reference to `nfct_labelmap_new'
collect2: error: ld returned 1 exit status
make[3]: *** [xtables-multi] Error 1

-----
