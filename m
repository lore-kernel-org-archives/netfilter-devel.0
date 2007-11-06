From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] fix the number of bytes cleaned by clean_nat() in net/ipv4/netfilter/nf_nat_core.c
Date: Tue, 06 Nov 2007 21:58:54 +0100
Message-ID: <4730D58E.2080107@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:54975 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKFU65 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 15:58:57 -0500
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out3.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IpVVg-00043j-Kb
	for <netfilter-devel@vger.kernel.org>; Tue, 06 Nov 2007 21:58:56 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Zero out 'sizeof(*nat)' rather than 'sizeof(nat)' bytes of the struct 
nf_conn_nat pointer 'nat'

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 56e93f6..70e7997 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, void *data)
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
