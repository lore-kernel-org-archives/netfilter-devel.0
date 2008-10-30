From: Marek Szuba <Marek.Szuba@if.pw.edu.pl>
Subject: IPv6 conntrack support for neighbour discovery
Date: Thu, 30 Oct 2008 14:52:18 +0100
Message-ID: <20081030145218.5395c3fe@hiperon.ws.hirg>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/GFQ+lOTws=4kKrB_MBbIj8j"
Cc: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from student.if.pw.edu.pl ([194.29.174.5]:41894 "EHLO
	student.if.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbYJ3N7E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:59:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--MP_/GFQ+lOTws=4kKrB_MBbIj8j
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello everyone,

Following a suggestion I was given at the kernel Bugzilla I am
forwarding this here.

It has come to my attention lately that the only two ICMPv6 packet
types which IPv6 conntrack allows at present to initiate new
connections are "echo request" and "node information query"; all other
types appearing in this context are considered invalid. In particular,
this includes two neighbour-discovery types specified in RFC 2461:
"router solicitation" and "neighbour solicitation" - meaning that if a
server drops all INVALID packets early in its INPUT or OUTPUT chain of
IPv6 netfilter's filter table, neither of the two can be received from
clients. Given that router solicitation is used for stateless network
autoconfiguration and neighbour solicitation is an IPv6 equivalent of
ARP requests, having these two dropped can be quite bad - especially
the latter, as it pretty much kills IPv6 over Ethernet.

Steps to reproduce:

1. Obtain an IPv6 address assigned to an Ethernet interface of host A
(link-local will do);
2. If necesssary, flush all ip6tables filter chains on host A and set
their policies to ACCEPT;
3. From host B on the same Ethernet network, ping6 the aforementioned IP
address to verify that everything works;
4. On host A, run something like "ip6tables -I INPUT 1 -m state --state
INVALID -j DROP";
5. Try to repeat step 3. This time the ping should fail and counters
associated with the aforementioned rule should increment;
6. Repeat all the above using OUTPUT instead of INPUT, with the same
final result.

BTW. This problem was discovered and (hopefully) fixed collaboratively
by =C5=81ukasz Stelmach <steelman@post.pl> and myself, please attribute both
of us should the patch make it into code repositories.

Attaching a proposed solution to the problem - the enclosed patch adds
"router solicitation" and "neighbour solicitation" to the list of
ICMPv6 types IPv6 conntrack considers allowed to initiate new
connections. Note that in principle "router advertisement" ICMPv6
packets could also be considered valid-new, as e.g. radvd periodically
advertises its presence to the local network - as however it is not
necessary to let this through as new to have things work (plus we
aren't that big on broadcasting, even on supposedly-secure networks),
the patch only adds solicitations to the list.

Best regards,
--=20
MS

--MP_/GFQ+lOTws=4kKrB_MBbIj8j
Content-Type: text/x-patch;
 name=nf_conntrack_proto_icmpv6.c-ndiscIsValid.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=nf_conntrack_proto_icmpv6.c-ndiscIsValid.patch

--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2008-04-17 04:49:44.000000000 +0200
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2008-10-20 16:49:09.000000000 +0200
@@ -108,6 +108,8 @@
 {
 	static const u_int8_t valid_new[] = {
 		[ICMPV6_ECHO_REQUEST - 128] = 1,
+		[NDISC_ROUTER_SOLICITATION - 128] = 1,
+		[NDISC_NEIGHBOUR_SOLICITATION - 128] = 1,
 		[ICMPV6_NI_QUERY - 128] = 1
 	};
 	int type = ct->tuplehash[0].tuple.dst.u.icmp.type - 128;

--MP_/GFQ+lOTws=4kKrB_MBbIj8j--
