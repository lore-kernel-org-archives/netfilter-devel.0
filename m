From: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Subject: Kernel 2.6.19 and match set doesn't compile
Date: Thu, 07 Dec 2006 22:20:25 +0100
Message-ID: <1165526425.8465.18.camel@builder.kity.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi.
I have kernel 2.6.19 with match set, u32 and target ROUTE from
patch-o-matic-ng-20061206.
I run make, and:

  CC      net/ipv4/netfilter/ipt_SET.o
net/ipv4/netfilter/ipt_SET.c:124: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ipt_SET.c:128: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ipt_SET.c:129: warning: initialization from
incompatible pointer type
C      net/ipv4/netfilter/ip_set.o
net/ipv4/netfilter/ip_set.c:12:26: linux/config.h: No such file or
directory
net/ipv4/netfilter/ip_set.c:30:43: linux/netfilter_ipv4/listhelp.h: No
such file or directory
net/ipv4/netfilter/ip_set.c: In function `ip_set_find_in_hash':
net/ipv4/netfilter/ip_set.c:90: warning: implicit declaration of
function `LIST_FIND'
net/ipv4/netfilter/ip_set.c:91: error: syntax error before "struct"
net/ipv4/netfilter/ip_set.c: In function `ip_set_hash_del':
net/ipv4/netfilter/ip_set.c:122: error: syntax error before "struct"
net/ipv4/netfilter/ip_set.c: In function `ip_set_hash_add':
net/ipv4/netfilter/ip_set.c:147: error: syntax error before "struct"
net/ipv4/netfilter/ip_set.c: In function `find_set_type':
net/ipv4/netfilter/ip_set.c:299: error: syntax error before "struct"
net/ipv4/netfilter/ip_set.c:301: warning: no return statement in
function returning non-void
net/ipv4/netfilter/ip_set.c: In function `ip_set_register_set_type':
net/ipv4/netfilter/ip_set.c:328: warning: implicit declaration of
function `list_append'
net/ipv4/netfilter/ip_set.c: In function `ip_set_unregister_set_type':
net/ipv4/netfilter/ip_set.c:344: warning: implicit declaration of
function `LIST_DELETE'
make[3]: *** [net/ipv4/netfilter/ip_set.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2


Also compilation u32 and ROUTE prints warnings:

net/ipv4/netfilter/ipt_u32.c:221: warning: initialization from
incompatible pointer type

net/ipv4/netfilter/ipt_ROUTE.c:438: warning: initialization from
incompatible pointer type
net/ipv4/netfilter/ipt_ROUTE.c:440: warning: initialization from
incompatible pointer type

net/ipv6/netfilter/ip6t_ROUTE.c:287: warning: initialization from
incompatible pointer type
net/ipv6/netfilter/ip6t_ROUTE.c:289: warning: initialization from
incompatible pointer type

Please help.


-- 
cheers,
Krzysztof Mościcki
