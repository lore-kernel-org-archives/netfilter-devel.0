From: Robby <inet6@mail.be>
Subject: compile error ip6t_REJECT.c and 2.4.27-rc5
Date: Sat, 7 Aug 2004 21:36:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <761227.1091907394234.JavaMail.Administrator@pumbaa>
Reply-To: Robby <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm getting an error as you can see below, there was also something with ULOG that errored,
but since I didn't need that I went back in menuconfig and disabled it.
This is with the patch-o-matic-ng CVS of 07/08/2004 at 13:14 CEST.
It used to compile before (back with 2.4.25-rc3 and I still have it running).
The machine is a RH7.3 box.

[...]
gcc -D__KERNEL__ -I/usr/src/linux-2.4.27-rc5/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i586 -DMODULE -DMODVERSIONS -include /usr/src/linux-2.4.27-rc5/include/linux/modversions.h  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip6t_MARK  -c -o ip6t_MARK.o ip6t_MARK.c
gcc -D__KERNEL__ -I/usr/src/linux-2.4.27-rc5/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i586 -DMODULE -DMODVERSIONS -include /usr/src/linux-2.4.27-rc5/include/linux/modversions.h  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip6t_REJECT  -c -o ip6t_REJECT.o ip6t_REJECT.c
ip6t_REJECT.c: In function `maybe_reroute':
ip6t_REJECT.c:61: warning: implicit declaration of function `dst_output'
ip6t_REJECT.c: In function `send_reset':
ip6t_REJECT.c:76: parse error before `int'
ip6t_REJECT.c:123: warning: passing arg 1 of `ipv6_addr_copy' from incompatible pointer type
ip6t_REJECT.c:124: warning: passing arg 1 of `ipv6_addr_copy' from incompatible pointer type
ip6t_REJECT.c:125: structure has no member named `fl_ip_sport'
ip6t_REJECT.c:126: structure has no member named `fl_ip_dport'
ip6t_REJECT.c:127: `err' undeclared (first use in this function)
ip6t_REJECT.c:127: (Each undeclared identifier is reported only once
ip6t_REJECT.c:127: for each function it appears in.)
ip6t_REJECT.c:127: warning: implicit declaration of function `ip6_dst_lookup'
ip6t_REJECT.c:135: structure has no member named `header_len'
ip6t_REJECT.c:136: structure has no member named `trailer_len'
ip6t_REJECT.c:149: structure has no member named `header_len'
ip6t_REJECT.c:154: warning: implicit declaration of function `dst_metric'
ip6t_REJECT.c:154: `RTAX_HOPLIMIT' undeclared (first use in this function)
ip6t_REJECT.c: In function `send_unreach':
ip6t_REJECT.c:252: sizeof applied to an incomplete type
ip6t_REJECT.c:257: dereferencing pointer to incomplete type
ip6t_REJECT.c:275: warning: passing arg 1 of `ipv6_addr_copy' from incompatible pointer type
ip6t_REJECT.c:276: warning: passing arg 1 of `ipv6_addr_copy' from incompatible pointer type
ip6t_REJECT.c:277: structure has no member named `fl_icmp_type'
ip6t_REJECT.c:278: structure has no member named `fl_icmp_code'
ip6t_REJECT.c:298: warning: implicit declaration of function `dst_pmtu'
ip6t_REJECT.c:306: structure has no member named `header_len'
ip6t_REJECT.c:306: structure has no member named `trailer_len'
ip6t_REJECT.c:319: structure has no member named `header_len'
ip6t_REJECT.c:324: `RTAX_HOPLIMIT' undeclared (first use in this function)
make[2]: *** [ip6t_REJECT.o] Error 1
make[2]: Leaving directory `/usr/src/linux-2.4.27-rc5/net/ipv6/netfilter'
make[1]: *** [_modsubdir_ipv6/netfilter] Error 2
make[1]: Leaving directory `/usr/src/linux-2.4.27-rc5/net'
make: *** [_mod_net] Error 2
[root@core1-fe0-gw1 linux-2.4.27-rc5]# 
-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
