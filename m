From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v5] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Sat, 14 Sep 2013 11:05:53 +0200
Message-ID: <1379149553-18945-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:46180 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3INJGH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 05:06:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 0E401A2FA7
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2013 10:06:05 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 7foboJgntOwy for <netfilter-devel@vger.kernel.org>;
	Sat, 14 Sep 2013 10:05:55 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This fixes a serious bug affecting all hash types with a net element -
specifically, if a CIDR value is deleted such that none of the same size
exist any more, all larger (less-specific) values will then fail to
match. Adding back any prefix with a CIDR equal to or more specific than
the one deleted will fix it.

Steps to reproduce:
ipset -N test hash:net
ipset -A test 1.1.0.0/16
ipset -A test 2.2.2.0/24
ipset -T test 1.1.1.1		#1.1.1.1 IS in set
ipset -D test 2.2.2.0/24
ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set

This is due to the fact that the nets counter was unconditionally
decremented prior to the iteration that shifts up the entries. Now, we
first check if there is a proceeding entry and if not, decrement it and
return. Otherwise, we proceed to iterate and then zero the last element,
which, in most cases, will already be zero.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/net/netfilter/ipset/ip_set_hash_gen.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 7a5b776..3add0bf 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -307,18 +307,22 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 static void
 mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
 {
-	u8 i, j;
+	u8 i, j, net_end = nets_length - 1;
 
-	for (i = 0; i < nets_length - 1 && h->nets[i].cidr[n] != cidr; i++)
-		;
-	h->nets[i].nets[n]--;
-
-	if (h->nets[i].nets[n] != 0)
+	for (i = 0; i < nets_length; i++) {
+		if (h->nets[i].cidr[n] != cidr)
+			continue;
+		if (h->nets[i].nets[n] > 1 || i == net_end ||
+		    h->nets[i + 1].nets[n] == 0) {
+			h->nets[i].nets[n]--;
+			return;
+		}
+		for (j = i; j < net_end && h->nets[j].nets[n]; j++) {
+			h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
+			h->nets[j].nets[n] = h->nets[j + 1].nets[n];
+		}
+		h->nets[j].nets[n] = 0;
 		return;
-
-	for (j = i; j < nets_length - 1 && h->nets[j].nets[n]; j++) {
-		h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
-		h->nets[j].nets[n] = h->nets[j + 1].nets[n];
 	}
 }
 #endif
-- 
1.8.3.2

