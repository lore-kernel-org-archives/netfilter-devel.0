From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: [PATCH?] Fix getorigdst() in ip_conntrack_core.c on 2.4.22-ac2
Date: Wed, 10 Sep 2003 06:32:11 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030910133211.1360.qmail@web40908.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi everyone!

gcc fails with the following error when compiling ip_conntrack_core.c on 2.4.22-ac2
with gcc 3.2.2:

make -C ipv4/netfilter modules
make[2]: Entering directory `/opt/src/linux-2.4.22-ac2+nfpom/net/ipv4/netfilter'
gcc -D__KERNEL__ -I/opt/src/linux-2.4.22-ac2+nfpom/include -Wall -Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer -pipe
-mpreferred-stack-boundary=2 -march=pentium4 -DMODULE  -nostdinc -iwithprefix
include -DKBUILD_BASENAME=ip_conntrack_core  -c -o ip_conntrack_core.o
ip_conntrack_core.c
ip_conntrack_core.c: In function `getorigdst':
ip_conntrack_core.c:1419: invalid type argument of `->'
ip_conntrack_core.c:1419: invalid type argument of `->'
make[2]: *** [ip_conntrack_core.o] Error 1
make[2]: Leaving directory `/opt/src/linux-2.4.22-ac2+nfpom/net/ipv4/netfilter'
make[1]: *** [_modsubdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/opt/src/linux-2.4.22-ac2+nfpom/net'
make: *** [_mod_net] Error 2

So I made the following patch to fix it:

--- net/ipv4/netfilter/ip_conntrack_core.c.orig	2003-09-10 14:24:33.000000000 -0400
+++ net/ipv4/netfilter/ip_conntrack_core.c	2003-09-10 14:24:46.000000000 -0400
@@ -1414,14 +1414,14 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple;
+	struct ip_conntrack_tuple *tuple;
 
-	IP_CT_TUPLE_BLANK(&tuple);
-	tuple.src.ip = sk->rcv_saddr;
-	tuple.src.u.tcp.port = sk->sport;
-	tuple.dst.ip = sk->daddr;
-	tuple.dst.u.tcp.port = sk->dport;
-	tuple.dst.protonum = IPPROTO_TCP;
+	IP_CT_TUPLE_BLANK(tuple);
+	tuple->src.ip = sk->rcv_saddr;
+	tuple->src.u.tcp.port = sk->sport;
+	tuple->dst.ip = sk->daddr;
+	tuple->dst.u.tcp.port = sk->dport;
+	tuple->dst.protonum = IPPROTO_TCP;
 
 	/* We only do TCP at the moment: is there a better way? */
 	if (strcmp(sk->prot->name, "TCP") != 0) {
@@ -1435,7 +1435,7 @@
 		return -EINVAL;
 	}
 
-	h = ip_conntrack_find_get(&tuple, NULL);
+	h = ip_conntrack_find_get(tuple, NULL);
 	if (h) {
 		struct sockaddr_in sin;

gcc 3.2.2 compiles this properly with only a warning about the possiblity that
tuple will be uninitialized. The original code looks perfectly legal and proper,
so why would gcc 3.x fail?

NOTE: I did apply some patches from patch-o-matic-20030909, but no conntrack-core-
modifying patches that weren't already present.

TIA

Brad Chapman

=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
