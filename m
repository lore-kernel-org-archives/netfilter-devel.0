From: kilobug@freesurf.fr (=?iso-8859-1?q?Ga=EBl_Le_Mignot?=)
Subject: Re: Call for testing: patch-o-matic-ng
Date: Wed, 24 Dec 2003 01:26:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <plopm3u13rysa7.fsf@drizzt.kilobug.org>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
	<plopm3zndjoexg.fsf@drizzt.kilobug.org>
	<20031223173022.GA3879@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031223173022.GA3879@obroa-skai.de.gnumonks.org> (Harald
 Welte's message of "Tue, 23 Dec 2003 18:30:22 +0100")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Harald, hello netfiler list ;)

I did  some tests on which  patch from the patch-o-matic  works on 2.6
and which ones don't compile. Here is the complete result of my tests.

I just try compiling them (after applying patches on a vanilla 2.6.0),
I didn't try to load or use them.

I've noticed too that when  a patch doesn't apply, pom-ng doesn't seem
to display it - or do it so fast that I don't notice it.

Here is the list from 'base' and 'extra' sets:

**** BASE ****

Does not compile:

- pool, nf-log, raw:
  CC      net/core/netfilter.o
net/core/netfilter.c: In function `nf_log_register':
net/core/netfilter.c:760: warning: implicit declaration of function `br_write_lock_bh'
net/core/netfilter.c:760: error: `BR_NETPROTO_LOCK' undeclared (first use in this function)
net/core/netfilter.c:760: error: (Each undeclared identifier is reported only once
net/core/netfilter.c:760: error: for each function it appears in.)
net/core/netfilter.c:765: warning: implicit declaration of function `br_write_unlock_bh'
net/core/netfilter.c: In function `nf_log_unregister':
net/core/netfilter.c:770: error: `BR_NETPROTO_LOCK' undeclared (first use in this function)

- HOPLIMIT: 
  Does not compile, but exists has ip6t_hl.o in vanilla 2.6.0

- connlimit:
  CC [M]  net/ipv4/netfilter/ipt_connlimit.o
net/ipv4/netfilter/ipt_connlimit.c:214: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_connlimit.c: In function `init':
net/ipv4/netfilter/ipt_connlimit.c:219: error: `ip_conntrack_module' undeclared (first use in this function)
net/ipv4/netfilter/ipt_connlimit.c:219: error: (Each undeclared identifier is reported only once
net/ipv4/netfilter/ipt_connlimit.c:219: error: for each function it appears in.)
net/ipv4/netfilter/ipt_connlimit.c:220: warning: implicit declaration of function `__MOD_INC_USE_COUNT'
net/ipv4/netfilter/ipt_connlimit.c: In function `fini':
net/ipv4/netfilter/ipt_connlimit.c:227: error: `ip_conntrack_module' undeclared (first use in this function)
net/ipv4/netfilter/ipt_connlimit.c:228: warning: implicit declaration of function `__MOD_DEC_USE_COUNT'

It seems to be module initialisation stuff changes, probably easy to fix.

- NETLINK:
  CC [M]  net/ipv4/netfilter/ipt_NETLINK.o
net/ipv4/netfilter/ipt_NETLINK.c:90: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_NETLINK.c:91: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_NETLINK.c: In function `fini':
net/ipv4/netfilter/ipt_NETLINK.c:115: error: structure has no member named `socket'
net/ipv4/netfilter/ipt_NETLINK.c:115: error: structure has no member named `socket'
make[3]: *** [net/ipv4/netfilter/ipt_NETLINK.o] Error 1

Compiles with warning:

  CC [M]  net/ipv4/netfilter/ipt_quota.o
net/ipv4/netfilter/ipt_quota.c:65: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_dstlimit.o
net/ipv4/netfilter/ipt_dstlimit.c:468: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_mport.o
net/ipv4/netfilter/ipt_mport.c:99: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_time.o
net/ipv4/netfilter/ipt_time.c:124: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_random.o
net/ipv4/netfilter/ipt_random.c:75: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_psd.o
net/ipv4/netfilter/ipt_psd.c: In function `ipt_psd_match':
net/ipv4/netfilter/ipt_psd.c:178: warning: comparison of distinct pointer types lacks a cast
net/ipv4/netfilter/ipt_psd.c:178: warning: comparison of distinct pointer types lacks a cast
net/ipv4/netfilter/ipt_psd.c: At top level:
net/ipv4/netfilter/ipt_psd.c:336: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_nth.o
net/ipv4/netfilter/ipt_nth.c:144: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_ipv4options.o
net/ipv4/netfilter/ipt_ipv4options.c:155: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_fuzzy.o
net/ipv4/netfilter/ipt_fuzzy.c:171: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_u32.o
net/ipv4/netfilter/ipt_u32.c:198: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_TTL.o
net/ipv4/netfilter/ipt_TTL.c:97: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_TTL.c:97: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.o
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:66: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_IPV4OPTSSTRIP.c:66: warning: initialization from incompatible pointer type
  CC [M]  net/ipv6/netfilter/ip6table_mangle.o
net/ipv6/netfilter/ip6table_mangle.c: In function `ip6t_local_hook':
net/ipv6/netfilter/ip6table_mangle.c:162: warning: `skb_linearize' is deprecated (declared at include/linux/skbuff.h:1136)
  CC [M]  net/ipv6/netfilter/ip6t_REJECT.o
net/ipv6/netfilter/ip6t_REJECT.c: In function `reject6_target':
net/ipv6/netfilter/ip6t_REJECT.c:149: warning: passing arg 5 of `icmpv6_send' discards qualifiers from pointer target type
net/ipv6/netfilter/ip6t_REJECT.c:152: warning: passing arg 5 of `icmpv6_send' discards qualifiers from pointer target type
net/ipv6/netfilter/ip6t_REJECT.c:155: warning: passing arg 5 of `icmpv6_send' discards qualifiers from pointer target type
net/ipv6/netfilter/ip6t_REJECT.c:158: warning: passing arg 5 of `icmpv6_send' discards qualifiers from pointer target type
net/ipv6/netfilter/ip6t_REJECT.c:161: warning: passing arg 5 of `icmpv6_send' discards qualifiers from pointer target type
  CC [M]  net/ipv4/netfilter/ipt_osf.o
net/ipv4/netfilter/ipt_osf.c:83: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_realm.o
net/ipv4/netfilter/ipt_realm.c:55: warning: initialization from incompatible pointer type

Compiles without warning:

NETMAP SAME iprange 


**** EXTRA ****

Does not compile:

- rsh
  CC      net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:26:
include/linux/netfilter_ipv4/ip_conntrack.h:88: error: field `ct_rsh_info' has incomplete type

- mms-conntrack-nat 
  CC      net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:26:
include/linux/netfilter_ipv4/ip_conntrack.h:89: error: field `ct_mms_info' has incomplete type

- h323-conntrack-nat 
  CC      net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:26:
include/linux/netfilter_ipv4/ip_conntrack.h:90: error: field `ct_h225_info' has incomplete type

- cuseemee-nat
oops forgot to copy/paste the error message, sorry

- rtsp-conntrack 
  CC      net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:26:
include/linux/netfilter_ipv4/ip_conntrack.h:74: error: field `ct_rtsp_info' has incomplete type

- talk-conntrack-nat
  CC      net/ipv4/netfilter/ip_conntrack_standalone.o
In file included from net/ipv4/netfilter/ip_conntrack_standalone.c:26:
include/linux/netfilter_ipv4/ip_conntrack.h:89: error: field `ct_talk_info' has incomplete type


Compiles with warning:

  CC [M]  net/ipv4/netfilter/ipt_IPMARK.o
net/ipv4/netfilter/ipt_IPMARK.c:72: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_IPMARK.c:72: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_CONNMARK.o
net/ipv4/netfilter/ipt_CONNMARK.c:71: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_CONNMARK.c:71: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ip_conntrack_egg.o
net/ipv4/netfilter/ip_conntrack_egg.c: In function `init':
net/ipv4/netfilter/ip_conntrack_egg.c:207: warning: assignment from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_XOR.o
net/ipv4/netfilter/ipt_XOR.c:94: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_XOR.c:94: warning: initialization from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ip_conntrack_rpc_tcp.o
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c: In function `alloc_request_p':
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:164: warning: missing braces around initializer
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:164: warning: (near initialization for `(anonymous).timeout.lock')
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:164: warning: excess elements in struct initializer
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:164: warning: (near initialization for `(anonymous).timeout.lock')
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:165: warning: initialization makes integer from pointer without a cast
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c: In function `check_rpc_packet':
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:252: warning: operation on `data' may be undefined
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c: In function `init':
net/ipv4/netfilter/ip_conntrack_rpc_tcp.c:457: warning: assignment from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ip_conntrack_rpc_udp.o
net/ipv4/netfilter/ip_conntrack_rpc_udp.c: In function `alloc_request_p':
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:164: warning: missing braces around initializer
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:164: warning: (near initialization for `(anonymous).timeout.lock')
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:164: warning: excess elements in struct initializer
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:164: warning: (near initialization for `(anonymous).timeout.lock')
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:165: warning: initialization makes integer from pointer without a cast
net/ipv4/netfilter/ip_conntrack_rpc_udp.c: In function `check_rpc_packet':
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:252: warning: operation on `data' may be undefined
net/ipv4/netfilter/ip_conntrack_rpc_udp.c: In function `init':
net/ipv4/netfilter/ip_conntrack_rpc_udp.c:452: warning: assignment from incompatible pointer type
  CC [M]  net/ipv4/netfilter/ipt_rpc.o
net/ipv4/netfilter/ipt_rpc.c:76: warning: type defaults to `int' in declaration of `EXPORT_NO_SYMBOLS'
net/ipv4/netfilter/ipt_rpc.c:76: warning: data definition has no type or storage class
net/ipv4/netfilter/ipt_rpc.c:389: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_rpc.c: In function `init':
net/ipv4/netfilter/ipt_rpc.c:398: warning: implicit declaration of function `__MOD_INC_USE_COUNT'
net/ipv4/netfilter/ipt_rpc.c: In function `fini':
net/ipv4/netfilter/ipt_rpc.c:421: warning: implicit declaration of function `__MOD_DEC_USE_COUNT'

*** Warning: "__MOD_DEC_USE_COUNT" [net/ipv4/netfilter/ipt_rpc.ko] undefined!
*** Warning: "__MOD_INC_USE_COUNT" [net/ipv4/netfilter/ipt_rpc.ko] undefined!

  CC [M]  net/ipv4/netfilter/ipt_addrtype.o
net/ipv4/netfilter/ipt_addrtype.c:50: warning: initialization from incompatible pointer type

  CC [M]  net/ipv4/netfilter/ipt_TCPLAG.o
net/ipv4/netfilter/ipt_TCPLAG.c: In function `divide_down':
net/ipv4/netfilter/ipt_TCPLAG.c:102: warning: statement with no effect
net/ipv4/netfilter/ipt_TCPLAG.c: At top level:
net/ipv4/netfilter/ipt_TCPLAG.c:643: warning: initialization from incompatible pointer type
net/ipv4/netfilter/ipt_TCPLAG.c:644: warning: initialization from incompatible pointer type

Compiles without warning:

quake3-conntrack-nat
   


-- 
Gael Le Mignot "Kilobug" - kilobug@nerim.net - http://kilobug.free.fr
GSM         : 06.71.47.18.22 (in France)   ICQ UIN   : 7299959
Fingerprint : 1F2C 9804 7505 79DF 95E6 7323 B66B F67B 7103 C5DA

Member of HurdFr: http://hurdfr.org - The GNU Hurd: http://hurd.gnu.org
