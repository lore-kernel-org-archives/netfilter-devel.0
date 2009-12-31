From: Rui Sousa <rui.p.m.sousa@gmail.com>
Subject: [PATCH] conntrack event missing TCP protoinfo
Date: Thu, 31 Dec 2009 14:03:21 +0100
Message-ID: <200912311403.21983.rui.p.m.sousa@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:13528 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZLaND0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Dec 2009 08:03:26 -0500
Received: by ey-out-2122.google.com with SMTP id 25so1934201eya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Dec 2009 05:03:25 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Under some conditions it's possible to send a conntrack netlink event to 
userspace which is missing the TCP connection state 
(CDA_PROTOINFO_TCP_STATE) even though it is well defined.
This one liner should fix the problem. What do you think?

Br,
Rui

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3c96437..a514f5f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1045,6 +1045,7 @@ static int tcp_packet(struct nf_conn *ct,
 		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
+		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 		nf_conntrack_event_cache(IPCT_STATUS, ct);
 	}
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeout);
