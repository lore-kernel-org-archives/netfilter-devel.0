From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 9/9]: fixes the bug which fails to find
 conntrack
Date: Tue, 22 Mar 2005 23:10:06 +0900 (JST)
Message-ID: <200503221410.j2MEA7Wb029617@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Mar_22_23:10:06_2005_284)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
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

----Next_Part(Tue_Mar_22_23:10:06_2005_284)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes the bug which fails to find conntrack in getorigdst()
for IPv6.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Tue_Mar_22_23:10:06_2005_284)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="09-fixed-getorigdst.patch"

diff -Nur linux-2.6.11-nfct-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.11-nfct-fixed-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.11-nfct-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 21:14:03.000000000 +0900
+++ linux-2.6.11-nfct-fixed-getorigdst/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-03-22 21:15:05.000000000 +0900
@@ -422,10 +422,11 @@
 	ipv6_addr_copy((struct in6_addr *)tuple.dst.u3.ip6, &np->daddr);
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.u.tcp.port = inet->dport;
+	tuple.src.l3num = PF_INET6;
 	tuple.dst.protonum = IPPROTO_TCP;
 
 	/* We only do TCP at the moment: is there a better way? */
-	if (strcmp(sk->sk_prot->name, "TCP")) {
+	if (strcmp(sk->sk_prot->name, "TCPv6")) {
 		DEBUGP("IPV6 ORIGINAL_DST: Not a TCP socket\n");
 		return -ENOPROTOOPT;
 	}

----Next_Part(Tue_Mar_22_23:10:06_2005_284)----
