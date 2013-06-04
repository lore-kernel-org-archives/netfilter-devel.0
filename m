From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: xt_TCPMSS: Avoid violating RFC 879 in absence of
 MSS option
Date: Tue, 4 Jun 2013 11:09:27 -0400
Message-ID: <20130604150927.GA9108@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f170.google.com ([209.85.160.170]:45609 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3FDPJc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:09:32 -0400
Received: by mail-gh0-f170.google.com with SMTP id z10so36076ghb.15
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Jun 2013 08:09:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported in bug #662, the clamp-mss-to-pmtu option of the xt_TCPMSS target
can cause issues connecting to websites if there was no MSS option present in
the original SYN packet from the client.  In these cases, it adds an MSS higher
than the default specified in RFC 879.  Fix this by never setting a value > 536
IFF none was specified by the client.  

This closes bug #662.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-662

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index a75240f..53af7db 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -125,6 +125,13 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	skb_put(skb, TCPOLEN_MSS);
 
+	/*
+	 * RFC 879 states that the default MSS is 536 without specific
+	 * knowledge that the destination host is prepared to accept larger.
+	 * Since no MSS was provided, we MUST NOT set a value > 536.
+	 */
+	newmss = min(newmss, (u16)536);
+
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 

--XsQoSWH+UP9D9v3l--
