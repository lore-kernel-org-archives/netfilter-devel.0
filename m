From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libmnl PATCH] Improve nf-queue example: Avoid possible NULL pointer
 dereference
Date: Wed, 24 Aug 2011 18:48:33 +0200
Message-ID: <4E552B61.6070706@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs04.intra2net.com ([85.214.66.2]:45026 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1HXRNW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:13:22 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rs04.intra2net.com (Postfix) with ESMTP id 1B182220128
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:48:35 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id CC5512AC54
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:48:34 +0200 (CEST)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id A3E8F2AC52
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Aug 2011 18:48:33 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 examples/netfilter/nf-queue.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/examples/netfilter/nf-queue.c b/examples/netfilter/nf-queue.c
index 3658ba2..a0ace28 100644
--- a/examples/netfilter/nf-queue.c
+++ b/examples/netfilter/nf-queue.c
@@ -72,9 +72,11 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data)
 	if (tb[NFQA_PACKET_HDR]) {
 		ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
 		id = ntohl(ph->packet_id);
-	}
-	printf("packet received (id=%u hw=0x%04x hook=%u)\n",
-		id, ntohs(ph->hw_protocol), ph->hook);
+
+		printf("packet received (id=%u hw=0x%04x hook=%u)\n",
+			id, ntohs(ph->hw_protocol), ph->hook);
+	} else
+		printf("packet received without header\n");
 
 	return MNL_CB_OK + id;
 }
-- 
1.7.4.4

