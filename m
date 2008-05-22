From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 1/3] export conntrack status also on destroy event
Date: Thu, 22 May 2008 10:13:14 +0100
Message-ID: <1211447594.6878.37.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44392 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764010AbYEVJNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 05:13:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=EF=BB=BFWhen a conntrack is destroyed, the connection status does not =
get=20
exported to netlink. I don't see a reason for not doing so. This patch=20
exports the status on all conntrack events.

--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-20=
 21:05:05.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:2=
1:56.000000000 +0100
@@ -472,14 +472,14 @@
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
=20
+	if (ctnetlink_dump_status(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 			goto nla_put_failure;
 	} else {
-		if (ctnetlink_dump_status(skb, ct) < 0)
-			goto nla_put_failure;
-
 		if (ctnetlink_dump_timeout(skb, ct) < 0)
 			goto nla_put_failure;
=20


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
