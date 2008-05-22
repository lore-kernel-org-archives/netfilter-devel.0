From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 2/3] set SEEN_REPLY before destroying conntrack on TCP RST
Date: Thu, 22 May 2008 10:13:21 +0100
Message-ID: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761353AbYEVJNX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 05:13:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=EF=BB=BFIf a connection fails with a TCP reset, the conntrack is destr=
oyed=20
immediately. This patch sets the SEEN_REPLY bit before destroying the=20
conntrack.

--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-=
20 21:05:06.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-21 09=
:41:15.000000000 +0100
@@ -962,6 +962,8 @@
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
+			if (ctinfo >=3D IP_CT_IS_REPLY)
+				set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
 			if (del_timer(&ct->timeout))
 				ct->timeout.function((unsigned long)ct);
 			return NF_ACCEPT;


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
