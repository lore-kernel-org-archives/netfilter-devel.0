From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 1/3] export conntrack status also on destroy event
Date: Tue, 10 Jun 2008 10:46:13 +0100
Message-ID: <1213091173.13425.11.camel@pumper.lan.luxnet.ch>
References: <1211447594.6878.37.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57474 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752062AbYFJJq1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:46:27 -0400
In-Reply-To: <1211447594.6878.37.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(This is a repost as requested by Patrick. The patch is already applied
to net-next-2.6 but not yet to nf-next-2.6.)

netfilter: ctnetlink: include conntrack status in destroy event message

When a conntrack is destroyed, the connection status does not get 
exported to netlink. I don't see a reason for not doing so. This patch 
exports the status on all conntrack events.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_netlink.c	2008-05-20 21:05:05.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_netlink.c	2008-05-20 22:21:56.000000000 +0100
@@ -472,14 +472,14 @@
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
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
 

