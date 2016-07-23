From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/25] netfilter: nf_conntrack_h323: fix off-by-one in DecodeQ931
Date: Sat, 23 Jul 2016 13:02:12 +0200
Message-ID: <1469271745-14523-13-git-send-email-pablo@netfilter.org>
References: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35307 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbcGWLDS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:03:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 484AAE7DA8
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3278FFF6F9
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ACF926DA2D
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 13:03:10 +0200 (CEST)
In-Reply-To: <1469271745-14523-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Toby DiPasquale <toby@cbcg.net>

This patch corrects an off-by-one error in the DecodeQ931 function in
the nf_conntrack_h323 module. This error could result in reading off
the end of a Q.931 frame.

Signed-off-by: Toby DiPasquale <toby@cbcg.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index bcd5ed6..89b2e46 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -846,9 +846,10 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q931)
 	sz -= len;
 
 	/* Message Type */
-	if (sz < 1)
+	if (sz < 2)
 		return H323_ERROR_BOUND;
 	q931->MessageType = *p++;
+	sz--;
 	PRINT("MessageType = %02X\n", q931->MessageType);
 	if (*p & 0x80) {
 		p++;
-- 
2.1.4

