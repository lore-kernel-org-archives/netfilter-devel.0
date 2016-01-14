From: Romaneev Vasily <entervuz@yandex.ru>
Subject: [xtables-addons] Problem with compilation
Date: Thu, 14 Jan 2016 18:17:43 +0300
Message-ID: <38301452784663@web4g.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward20p.cmail.yandex.net ([77.88.31.15]:42084 "EHLO
	forward20p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbcANPZF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2016 10:25:05 -0500
Received: from web4g.yandex.ru (web4g.yandex.ru [95.108.252.104])
	by forward20p.cmail.yandex.net (Yandex) with ESMTP id 63450218F5
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2016 18:17:44 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!
I try to compile xtables-addons-2.10 and latest snapshot from git on Ce=
ntos 7.2, kernel version is 3.10.0-327.3.1.el7.x86_64
and both build are failed.

Could you advice - how to build xtables ?

Thank you!


make errors:
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c: In function =E2=80=98tarpit_tcp4=E2=80=99=
:
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:295:3: warning: passing argument 3 of =E2=80=
=98NF_HOOK=E2=80=99 from incompatible pointer type [enabled by default]
   skb_dst(nskb)->dev, dst_output);
   ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: expected =E2=80=98struct sock *=E2=
=80=99 but argument is of type =E2=80=98struct sk_buff *=E2=80=99
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:295:3: warning: passing argument 6 of =E2=80=
=98NF_HOOK=E2=80=99 from incompatible pointer type [enabled by default]
   skb_dst(nskb)->dev, dst_output);
   ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: expected =E2=80=98struct net_dev=
ice *=E2=80=99 but argument is of type =E2=80=98int (*)(struct sk_buff =
*)=E2=80=99
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:295:3: error: too few arguments to functio=
n =E2=80=98NF_HOOK=E2=80=99
   skb_dst(nskb)->dev, dst_output);
   ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: declared here
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c: In function =E2=80=98tarpit_tcp6=E2=80=99=
:
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:418:10: warning: passing argument 3 of =E2=
=80=98NF_HOOK=E2=80=99 from incompatible pointer type [enabled by defau=
lt]
          skb_dst(nskb)->dev, dst_output);
          ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: expected =E2=80=98struct sock *=E2=
=80=99 but argument is of type =E2=80=98struct sk_buff *=E2=80=99
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:418:10: warning: passing argument 6 of =E2=
=80=98NF_HOOK=E2=80=99 from incompatible pointer type [enabled by defau=
lt]
          skb_dst(nskb)->dev, dst_output);
          ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: expected =E2=80=98struct net_dev=
ice *=E2=80=99 but argument is of type =E2=80=98int (*)(struct sk_buff =
*)=E2=80=99
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
/root/xtables-addons-xtables-addons-5038e160f81efb815d61929b1f55d002a15=
ffa76/extensions/xt_TARPIT.c:418:10: error: too few arguments to functi=
on =E2=80=98NF_HOOK=E2=80=99
          skb_dst(nskb)->dev, dst_output);
          ^
In file included from include/uapi/linux/netfilter_ipv6.h:11:0,
                 from include/linux/netfilter_ipv6.h:10,
                 from /root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions/xt_TARPIT.c:45:
include/linux/netfilter.h:245:1: note: declared here
 NF_HOOK(uint8_t pf, unsigned int hook, struct sock *sk, struct sk_buff=
 *skb,
 ^
make[4]: *** [/root/xtables-addons-xtables-addons-5038e160f81efb815d619=
29b1f55d002a15ffa76/extensions/xt_TARPIT.o] Error 1
make[3]: *** [_module_/root/xtables-addons-xtables-addons-5038e160f81ef=
b815d61929b1f55d002a15ffa76/extensions] Error 2
make[3]: Leaving directory `/usr/src/kernels/3.10.0-327.3.1.el7.x86_64'
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/root/xtables-addons-xtables-addons-5038e16=
0f81efb815d61929b1f55d002a15ffa76/extensions'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/root/xtables-addons-xtables-addons-5038e16=
0f81efb815d61929b1f55d002a15ffa76'
make: *** [all] Error 2


------
Romaneev Vasily
=D0=9C=D0=BE=D0=B1=D0=B8=D0=BB=D1=8C=D0=BD=D1=8B=D0=B9: +7-987-636-62-6=
7
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
