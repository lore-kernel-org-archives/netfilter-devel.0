From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Fw: PROBLEM: Conntrack/NAT bug
Date: 10 Oct 2002 16:18:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034259531.25142.6.camel@tux>
References: <20021010.062046.47003148.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-t+g5lCR23ea4C6M1daJu"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Lanyon <toml@internode.on.net>
In-Reply-To: <20021010.062046.47003148.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-t+g5lCR23ea4C6M1daJu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

 
> [1.] One line summary of the problem:   Some sort of coding problem in
> conntrack.
> [2.] Full description of the problem/report:
> The following error pops up quite often in my console:
> ASSERT ip_conntrack_core.c:94 &ip_conntrack_lock readlocked
> ASSERT: ip_nat_core.c:841 &ip_conntrack_lock not readlocked

This is not a real bug, it's harmless. The ASSERT's are because the
lock-debugging in netfilter can't handle "recursive" read-locks on the
same lock and cpu.

Attached is a patch that will eliminate these printouts, it's a bit
unclean and was rejected by Harald (it's perfectly safe) but it will
shut them up (at least the ASSERT's you reported in your mail).

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-t+g5lCR23ea4C6M1daJu
Content-Disposition: attachment; filename=exp_for_packet-lockpatch2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=exp_for_packet-lockpatch2; charset=ISO-8859-15

diff -x '*.orig' -urN linux-2.4.20-pre8-ac3.orig/include/linux/netfilter_ip=
v4/ip_conntrack_core.h linux-2.4.20-pre8-ac3/include/linux/netfilter_ipv4/i=
p_conntrack_core.h
--- linux-2.4.20-pre8-ac3.orig/include/linux/netfilter_ipv4/ip_conntrack_co=
re.h	2002-10-10 15:41:55.000000000 +0200
+++ linux-2.4.20-pre8-ac3/include/linux/netfilter_ipv4/ip_conntrack_core.h	=
2002-10-10 16:07:16.000000000 +0200
@@ -17,7 +17,7 @@
 struct ip_conntrack_protocol;
 extern struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol);
 /* Like above, but you already have conntrack read lock. */
-extern struct ip_conntrack_protocol *__find_proto(u_int8_t protocol);
+extern struct ip_conntrack_protocol *__ip_ct_find_proto(u_int8_t protocol)=
;
 extern struct list_head protocol_list;
=20
 /* Returns conntrack if it dealt with ICMP, and filled in skb->nfct */
diff -x '*.orig' -urN linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_conn=
track_core.c linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_conntrack_core.c	2002-=
10-10 15:41:57.000000000 +0200
+++ linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-10=
 16:07:16.000000000 +0200
@@ -74,7 +74,7 @@
 	return protocol =3D=3D curr->proto;
 }
=20
-struct ip_conntrack_protocol *__find_proto(u_int8_t protocol)
+struct ip_conntrack_protocol *__ip_ct_find_proto(u_int8_t protocol)
 {
 	struct ip_conntrack_protocol *p;
=20
@@ -92,7 +92,7 @@
 	struct ip_conntrack_protocol *p;
=20
 	READ_LOCK(&ip_conntrack_lock);
-	p =3D __find_proto(protocol);
+	p =3D __ip_ct_find_proto(protocol);
 	READ_UNLOCK(&ip_conntrack_lock);
 	return p;
 }
diff -x '*.orig' -urN linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_conn=
track_standalone.c linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_conntrack_st=
andalone.c
--- linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_conntrack_standalone.c=
	2002-10-10 15:41:57.000000000 +0200
+++ linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_conntrack_standalone.c	2002=
-10-10 16:07:16.000000000 +0200
@@ -71,7 +71,7 @@
 	len +=3D sprintf(buffer + len, "use=3D%u proto=3D%u ",
 		      atomic_read(&expect->use), expect->tuple.dst.protonum);
 	len +=3D print_tuple(buffer + len, &expect->tuple,
-			   __find_proto(expect->tuple.dst.protonum));
+			   __ip_ct_find_proto(expect->tuple.dst.protonum));
 	len +=3D sprintf(buffer + len, "\n");
 	return len;
 }
@@ -81,7 +81,7 @@
 {
 	unsigned int len;
 	struct ip_conntrack_protocol *proto
-		=3D __find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+		=3D __ip_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 			       .tuple.dst.protonum);
=20
 	len =3D sprintf(buffer, "%-8s %u %lu ",
@@ -361,6 +361,7 @@
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh);
 EXPORT_SYMBOL(ip_ct_find_proto);
+EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
diff -x '*.orig' -urN linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_nat_=
core.c linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.20-pre8-ac3.orig/net/ipv4/netfilter/ip_nat_core.c	2002-10-10 =
16:10:49.000000000 +0200
+++ linux-2.4.20-pre8-ac3/net/ipv4/netfilter/ip_nat_core.c	2002-10-10 16:10=
:36.000000000 +0200
@@ -739,7 +739,7 @@
 	int ret =3D 1;
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
+	proto =3D __ip_ct_find_proto((*pskb)->nh.iph->protocol);
 	if (proto->exp_matches_pkt)
 		ret =3D proto->exp_matches_pkt(exp, pskb);
=20

--=-t+g5lCR23ea4C6M1daJu--
