From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Thu, 23 Oct 2008 03:11:49 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810230253170.15215@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-2133777948-1224724310=:15215"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:49466 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYJWBLz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:11:55 -0400
In-Reply-To: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-2133777948-1224724310=:15215
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 20 Oct 2008, Jozsef Kadlecsik wrote:

> Hello,
>
> I'm happy to announce ipset 2.4. The new release contains some bugfixes,
> a compatibility fix for kernels >= 2.6.27 and three new set types:
>
> - ipportiphash: you can store and match IP address, port number and
>  IP address triples in it, where the first IP address must come from
>  a /16 sized network or range.
> - ipportnethash: you can store and match IP address, port number
>  and network address triples in it, where the first IP address
>  must come from a /16 sized network or range.

Hello again,

In file included from net/ipv4/netfilter/ip_set_iptree.c:23:
include/linux/netfilter_ipv4/ip_set_iptree.h:25: error: field 'gc' has incomplete type
net/ipv4/netfilter/ip_set_iptree.c: In function 'ip_tree_gc':
net/ipv4/netfilter/ip_set_iptree.c:258: error: implicit declaration of function 'add_timer'
net/ipv4/netfilter/ip_set_iptree.c: In function 'init_gc_timer':
net/ipv4/netfilter/ip_set_iptree.c:270: error: implicit declaration of function 'init_timer'
net/ipv4/netfilter/ip_set_iptree.c: In function 'iptree_destroy':
net/ipv4/netfilter/ip_set_iptree.c:332: error: implicit declaration of function 'del_timer'
make[3]: *** [net/ipv4/netfilter/ip_set_iptree.o] Error 1
make[3]: *** Waiting for unfinished jobs....
In file included from net/ipv4/netfilter/ip_set_iptreemap.c:27:
include/linux/netfilter_ipv4/ip_set_iptreemap.h:26: error: field 'gc' has incomplete type
net/ipv4/netfilter/ip_set_iptreemap.c: In function 'gc':
net/ipv4/netfilter/ip_set_iptreemap.c:456: error: implicit declaration of function 'add_timer'
net/ipv4/netfilter/ip_set_iptreemap.c: In function 'init_gc_timer':
net/ipv4/netfilter/ip_set_iptreemap.c:464: error: implicit declaration of function 'init_timer'
net/ipv4/netfilter/ip_set_iptreemap.c: In function 'iptreemap_destroy':
net/ipv4/netfilter/ip_set_iptreemap.c:506: error: implicit declaration of function 'del_timer'
make[3]: *** [net/ipv4/netfilter/ip_set_iptreemap.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
Command exited with non-zero status 2

# head -4 Makefile
VERSION = 2
PATCHLEVEL = 6
SUBLEVEL = 26
EXTRAVERSION = .7

It seems that "#include <linux/timer.h>" is missing in both files, however 
it worked with the previous ipset release (2.6.26.6 + ipset-2.3.2a) 
without such include. Strange.

Best regards,

 				Krzysztof Olêdzki
---1144830174-2133777948-1224724310=:15215--
