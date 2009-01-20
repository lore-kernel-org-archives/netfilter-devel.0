From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] add hw src address, physindev and physoutdev support to nfqnl_test
Date: Tue, 20 Jan 2009 17:23:56 +0100
Message-ID: <4975FA9C.8090007@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:35461 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbZATQY0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:24:26 -0500
Received: from wilson.telenet-ops.be (wilson.telenet-ops.be [195.130.132.42])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id C43A0681593
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:24:23 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by wilson.telenet-ops.be (Postfix) with SMTP id 233CB3402C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:23:57 +0100 (CET)
Received: from [127.0.0.1] (d54C6FD43.access.telenet.be [84.198.253.67])
	by wilson.telenet-ops.be (Postfix) with ESMTP id E1D233405A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2009 17:23:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This adds the hardware source address, physindev and physoutdev support
to nfqnl_test

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- libnetfilter_queue-0.0.16/utils/nfqnl_test.c.old	2009-01-17 16:20:06.000000000 +0100
+++ libnetfilter_queue-0.0.16/utils/nfqnl_test.c	2009-01-17 16:22:44.000000000 +0100
@@ -13,17 +13,28 @@ static u_int32_t print_pkt (struct nfq_d
 {
 	int id = 0;
 	struct nfqnl_msg_packet_hdr *ph;
+	struct nfqnl_msg_packet_hw *hwph;
 	u_int32_t mark,ifi; 
 	int ret;
 	char *data;
-	
+
 	ph = nfq_get_msg_packet_hdr(tb);
-	if (ph){
+	if (ph) {
 		id = ntohl(ph->packet_id);
 		printf("hw_protocol=0x%04x hook=%u id=%u ",
 			ntohs(ph->hw_protocol), ph->hook, id);
 	}
-	
+
+	hwph = nfq_get_packet_hw(tb);
+	if (hwph) {
+		int i, hlen = ntohs(hwph->hw_addrlen);
+
+		printf("hw_src_addr=");
+		for (i = 0; i < hlen-1; i++)
+			printf("%02x:", hwph->hw_addr[i]);
+		printf("%02x ", hwph->hw_addr[hlen-1]);
+	}
+
 	mark = nfq_get_nfmark(tb);
 	if (mark)
 		printf("mark=%u ", mark);
@@ -35,6 +46,13 @@ static u_int32_t print_pkt (struct nfq_d
 	ifi = nfq_get_outdev(tb);
 	if (ifi)
 		printf("outdev=%u ", ifi);
+	ifi = nfq_get_physindev(tb);
+	if (ifi)
+		printf("physindev=%u ", ifi);
+
+	ifi = nfq_get_physoutdev(tb);
+	if (ifi)
+		printf("physoutdev=%u ", ifi);
 
 	ret = nfq_get_payload(tb, &data);
 	if (ret >= 0)
