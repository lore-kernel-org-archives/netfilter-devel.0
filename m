From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: iptables 1.4.0 and Linux 2.4
Date: Sun, 30 Dec 2007 11:36:04 +0100
Message-ID: <x6fxxklbaj@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:36873 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXL3LAB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 06:00:01 -0500
Received: from dsl5401c0b5.pool.t-online.hu [84.1.192.181]
	by odpn1.odpn.net for netfilter-devel@vger.kernel.org
	id 1J8vVu-0004gE-9a; Sun, 30 Dec 2007 11:35:27 +0100
Received: from gzp1.gzp.hu [192.168.192.1]
	by gzp1.gzp.hu for netfilter-devel@vger.kernel.org
	id 1J8vWX-00057x-5P; Sun, 30 Dec 2007 11:36:05 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[kernel]
Linux gzp1 2.4.35.1-gzp1 #1 SMP Tue Aug 21 17:11:48 CEST 2007 i686
GNU/Linux

[glibc]
GNU C Library stable release version 2.3.6, by Roland McGrath et al.
Compiled by GNU CC version 4.1.2.
Compiled on a Linux 2.4.34-gzp1 system on 2007-04-04.

[gcc]
gcc (GCC) 3.4.6

[binutils]
GNU ld (Linux/GNU Binutils) 2.18.50.0.3.20071102

Making dependencies: please wait...
Unable to resolve dependency on linux/dccp.h. Try 'make clean'.
Extensions found:
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
gcc-3.4.6 -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_addrtype_sh.o -c extensions/libipt_addrtype.c
gcc-3.4.6 -shared  -o extensions/libipt_addrtype.so extensions/libipt_addrtype_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
gcc-3.4.6 -shared  -o extensions/libipt_conntrack.so extensions/libipt_conntrack_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_ecn_sh.o -c extensions/libipt_ecn.c
gcc-3.4.6 -shared  -o extensions/libipt_ecn.so extensions/libipt_ecn_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_icmp_sh.o -c extensions/libipt_icmp.c
gcc-3.4.6 -shared  -o extensions/libipt_icmp.so extensions/libipt_icmp_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_iprange_sh.o -c extensions/libipt_iprange.c
gcc-3.4.6 -shared  -o extensions/libipt_iprange.so extensions/libipt_iprange_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_owner_sh.o -c extensions/libipt_owner.c
gcc-3.4.6 -shared  -o extensions/libipt_owner.so extensions/libipt_owner_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_policy_sh.o -c extensions/libipt_policy.c
gcc-3.4.6 -shared  -o extensions/libipt_policy.so extensions/libipt_policy_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_realm_sh.o -c extensions/libipt_realm.c
gcc-3.4.6 -shared  -o extensions/libipt_realm.so extensions/libipt_realm_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_recent_sh.o -c extensions/libipt_recent.c
gcc-3.4.6 -shared  -o extensions/libipt_recent.so extensions/libipt_recent_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_tos_sh.o -c extensions/libipt_tos.c
gcc-3.4.6 -shared  -o extensions/libipt_tos.so extensions/libipt_tos_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_ttl_sh.o -c extensions/libipt_ttl.c
gcc-3.4.6 -shared  -o extensions/libipt_ttl.so extensions/libipt_ttl_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_unclean_sh.o -c extensions/libipt_unclean.c
gcc-3.4.6 -shared  -o extensions/libipt_unclean.so extensions/libipt_unclean_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_CLUSTERIP_sh.o -c extensions/libipt_CLUSTERIP.c
gcc-3.4.6 -shared  -o extensions/libipt_CLUSTERIP.so extensions/libipt_CLUSTERIP_sh.o
gcc-3.4.6 -O2 -Wall -Wunused -I"/lib/modules/2.4.35.1-gzp1/build"/include -I/usr/src/linux-2.4.35.1-gzp1//include -Iinclude/ -DIPTABLES_VERSION=\"1.4.0\"  -fPIC -o extensions/libipt_DNAT_sh.o -c extensions/libipt_DNAT.c
In file included from include/linux/netfilter/nf_nat.h:4,
                 from extensions/libipt_DNAT.c:9:
include/linux/netfilter/nf_conntrack_tuple.h:29: error: syntax error before "__be32"
include/linux/netfilter/nf_conntrack_tuple.h:29: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:30: warning: type defaults to `int' in declaration of `ip6'
include/linux/netfilter/nf_conntrack_tuple.h:30: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:31: error: syntax error before '}' token
include/linux/netfilter/nf_conntrack_tuple.h:41: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:41: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:41: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:42: warning: type defaults to `int' in declaration of `tcp'
include/linux/netfilter/nf_conntrack_tuple.h:42: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:44: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:44: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:45: warning: type defaults to `int' in declaration of `udp'
include/linux/netfilter/nf_conntrack_tuple.h:45: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:47: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:47: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:48: warning: type defaults to `int' in declaration of `icmp'
include/linux/netfilter/nf_conntrack_tuple.h:48: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:50: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:50: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:51: warning: type defaults to `int' in declaration of `sctp'
include/linux/netfilter/nf_conntrack_tuple.h:51: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:53: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:53: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:54: warning: type defaults to `int' in declaration of `gre'
include/linux/netfilter/nf_conntrack_tuple.h:54: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:55: error: syntax error before '}' token
include/linux/netfilter/nf_conntrack_tuple.h:60: error: field `u3' has incomplete type
include/linux/netfilter/nf_conntrack_tuple.h:61: error: field `u' has incomplete type
include/linux/netfilter/nf_conntrack_tuple.h:73: error: field `u3' has incomplete type
include/linux/netfilter/nf_conntrack_tuple.h:79: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:79: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:79: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:82: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:82: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:82: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:83: warning: type defaults to `int' in declaration of `udp'
include/linux/netfilter/nf_conntrack_tuple.h:83: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:86: error: conflicting types for 'icmp'
include/linux/netfilter/nf_conntrack_tuple.h:48: error: previous declaration of 'icmp' was here
include/linux/netfilter/nf_conntrack_tuple.h:88: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:88: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:89: warning: type defaults to `int' in declaration of `sctp'
include/linux/netfilter/nf_conntrack_tuple.h:89: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:91: error: syntax error before "__be16"
include/linux/netfilter/nf_conntrack_tuple.h:91: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_conntrack_tuple.h:92: warning: type defaults to `int' in declaration of `gre'
include/linux/netfilter/nf_conntrack_tuple.h:92: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:93: error: syntax error before '}' token
include/linux/netfilter/nf_conntrack_tuple.h:93: warning: type defaults to `int' in declaration of `u'
include/linux/netfilter/nf_conntrack_tuple.h:93: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:100: error: syntax error before '}' token
include/linux/netfilter/nf_conntrack_tuple.h:100: warning: type defaults to `int' in declaration of `dst'
include/linux/netfilter/nf_conntrack_tuple.h:100: warning: data definition has no type or storage class
include/linux/netfilter/nf_conntrack_tuple.h:101: error: syntax error before '}' token
In file included from extensions/libipt_DNAT.c:9:
include/linux/netfilter/nf_nat.h:28: error: syntax error before "__be32"
include/linux/netfilter/nf_nat.h:28: warning: no semicolon at end of struct or union
include/linux/netfilter/nf_nat.h:32: error: syntax error before '}' token
include/linux/netfilter/nf_nat.h:40: error: field `range' has incomplete type
extensions/libipt_DNAT.c: In function `append_range':
extensions/libipt_DNAT.c:46: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:53: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c: In function `parse_to':
extensions/libipt_DNAT.c:63: error: storage size of 'range' isn't known
extensions/libipt_DNAT.c:63: warning: unused variable `range'
extensions/libipt_DNAT.c: In function `print_range':
extensions/libipt_DNAT.c:197: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:200: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:202: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:202: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:203: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:207: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:209: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:210: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:210: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c:211: error: dereferencing pointer to incomplete type
extensions/libipt_DNAT.c: At top level:
include/linux/netfilter/nf_nat.h:31: error: storage size of `min' isn't known
include/linux/netfilter/nf_nat.h:31: error: storage size of `max' isn't known
make: *** [extensions/libipt_DNAT_sh.o] Error 1
