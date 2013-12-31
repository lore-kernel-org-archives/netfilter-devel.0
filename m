From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH nf] netfilter: nf_nat: fix buffer overflow in IRC NAT helper
Date: Tue, 31 Dec 2013 16:28:39 +0100
Message-ID: <1388503719-17766-1-git-send-email-dborkman@redhat.com>
Cc: netfilter-devel@vger.kernel.org,
	Harald Welte <laforge@gnumonks.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab3LaP2x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:28:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 5901b6be885e attempted to introduce IPv6 support into
IRC NAT helper. By doing so, the following code seemed to be removed
by accident:

  ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
  sprintf(buffer, "%u %u", ip, port);
  pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n", buffer, &ip, port);

This leads to the fact that buffer[] was left uninitialized and
contained some stack value. When we call nf_nat_mangle_tcp_packet(),
we call strlen(buffer) on excatly this uninitialized buffer. If we
are unlucky and the skb has enough tailroom, we overwrite resp. leak
contents with values that sit on our stack into the packet and send
that out to the receiver.

Since the rather informal DCC spec [1] does not seem to specify
IPv6 support right now, we log such occurences so that admins can
act accordingly, and drop the packet. I've looked into XChat source,
and IPv6 is not supported there: addresses are in u32 and print
via %u format string.

Therefore, restore old behaviour as in IPv4, use snprintf(), and
log IPv6 packets for now (maybe if there's consensus one day, we
can still add support here). By this, we can safely use strlen(buffer)
in nf_nat_mangle_tcp_packet() and prevent a buffer overflow. Also
simplify some code as we now have ct variable anyway.

  [1] http://www.irchelp.org/irchelp/rfc/ctcpspec.html

Fixes: 5901b6be885e ("netfilter: nf_nat: support IPv6 in IRC NAT helper")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Harald Welte <laforge@gnumonks.org>
---
 net/netfilter/nf_nat_irc.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index f02b360..fbbb1e6 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -34,10 +34,14 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("4294967296 65635")];
+	struct nf_conn *ct = exp->master;
+	union nf_inet_addr newaddr;
 	u_int16_t port;
 	unsigned int ret;
 
 	/* Reply comes from server. */
+	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
+
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
@@ -57,17 +61,41 @@ static unsigned int help(struct sk_buff *skb,
 	}
 
 	if (port == 0) {
-		nf_ct_helper_log(skb, exp->master, "all ports in use");
+		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
 
-	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
-				       protoff, matchoff, matchlen, buffer,
-				       strlen(buffer));
+	/* strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
+	 * strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
+	 * strlen("\1DCC SEND F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC MOVE F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC TSEND F AAAAAAAA P S\1\n")=27
+	 *
+	 * AAAAAAAAA: bound addr (1.0.0.0==16777216, min 8 digits,
+	 *                        255.255.255.255==4294967296, 10 digits)
+	 * P:         bound port (min 1 d, max 5d (65635))
+	 * F:         filename   (min 1 d )
+	 * S:         size       (min 1 d )
+	 * 0x01, \n:  terminators
+	 */
+	/* AAA = "us", ie. where server normally talks to. */
+	if (nf_ct_l3num(ct) == NFPROTO_IPV4) {
+		snprintf(buffer, sizeof(buffer), "%u %u",
+			 ntohl(newaddr.ip), port);
+		pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+			 buffer, &newaddr.ip, port);
+	} else {
+		nf_ct_helper_log(skb, ct, "IPv6 DCC unsupported for now");
+		return NF_DROP;
+	}
+
+	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				       matchlen, buffer, strlen(buffer));
 	if (ret != NF_ACCEPT) {
-		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
+		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
 	}
+
 	return ret;
 }
 
-- 
1.7.11.7

