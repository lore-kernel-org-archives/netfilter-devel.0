From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 2/3] set SEEN_REPLY before destroying conntrack on TCP
	RST
Date: Mon, 26 May 2008 19:25:04 +0100
Message-ID: <1211826305.19222.8.camel@pumper.lan.luxnet.ch>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34557 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753252AbYEZSZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 May 2008 14:25:16 -0400
In-Reply-To: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2008-05-22 at 10:13 +0100, Fabian Hugelshofer wrote:
> =EF=BB=BFIf a connection fails with a TCP reset, the conntrack is des=
troyed=20
> immediately. This patch sets the SEEN_REPLY bit before destroying the=
=20
> conntrack.

This updated version also increments the accounting counters.

Do I see this right, that the commits should be observable in the
patch-o-matic git, if they are done?

--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-=
26 17:43:01.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-26 17=
:32:17.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
@@ -960,8 +961,19 @@
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
 		   problem case, so we can delete the conntrack
-		   immediately.  --RR */
+		   immediately.  --RR
+		   The SEEN_REPLY bit and the accounting counters are updated
+		   here to have the correct information in the ct event. */
 		if (th->rst) {
+			if (ctinfo >=3D IP_CT_IS_REPLY)
+				set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+#ifdef CONFIG_NF_CT_ACCT
+			spin_lock_bh(&nf_conntrack_lock);
+			ct->counters[CTINFO2DIR(ctinfo)].packets++;
+			ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D
+				skb->len - skb_network_offset(skb);
+			spin_unlock_bh(&nf_conntrack_lock);
+#endif
 			if (del_timer(&ct->timeout))
 				ct->timeout.function((unsigned long)ct);
 			return NF_ACCEPT;


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
