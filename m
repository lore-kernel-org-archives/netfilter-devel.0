Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C75C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhK3LSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbhK3LSB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B30EC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iCWmAYEZF/v0WIOer3lgyeoNkpB7V749Na3zkI+8xPk=; b=QkQGctdGVMrVpxIn5EsEswTWHP
        2yI+gm3ncx9P0gM/6SnBKkwFql/OT95H0j2O2l1fr8mSIptQn37AJ4a2iyaeMd7ZNzcdIt6fj79h5
        ISTePhaiMAH6qfo+/TeBHoaK8wmWCmNp4buUUnt0RQbPyfiTuq8J/WXFmleoO0Fvn3V8gJC3+6NWw
        NKawL0oJ/hLrIQPWtkWCH89QUB7viJGQiDNOKqa1/f1+1rZVPF36+ykSrB0plp/4PjerRwUVN9zZB
        VvMlP5Ud1Cdg35+Pew/wLASuTZ2JqAPpiLI1OKYOY4fBGv7GMIlr8VHCVbM3fjeOYWL8JbqyC01Od
        GV/VHnaQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-RN
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 10/32] input: UNIXSOCK: prevent unaligned pointer access
Date:   Tue, 30 Nov 2021 10:55:38 +0000
Message-Id: <20211130105600.3103609-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`struct ulogd_unixsock_packet_t` is packed, so taking the address of its
`struct iphdr payload` member may yield an unaligned pointer value.  We
only actually dereference the pointer to get the IP version, so replace
the pointer with a version variable and elsewhere use `pkt.payload`
directly.

Remove a couple of stray semicolons.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 66735e3ab4fe..5cf7cfb57703 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -371,7 +371,7 @@ struct ulogd_unixsock_option_t  {
 static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_packet_t *pkt, uint16_t total_len)
 {
 	char *data = NULL;
-	struct iphdr *ip;
+	unsigned int ip_version = pkt->payload.version;
 	struct ulogd_key *ret = upi->output.keys;
 	uint8_t oob_family;
 	uint16_t payload_len;
@@ -387,22 +387,22 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 
 	payload_len = ntohs(pkt->payload_length);
 
-	ip = &pkt->payload;
-	if (ip->version == 4)
+	if (ip_version == 4)
 		oob_family = AF_INET;
-	else if (ip->version == 6)
+	else if (ip_version == 6)
 		oob_family = AF_INET6;
-	else oob_family = 0;
+	else
+		oob_family = 0;
 
 	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);
-	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
+	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], &pkt->payload);
 	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
 
 	/* options */
 	if (total_len > payload_len + sizeof(uint16_t)) {
 		/* option starts at the next aligned address after the payload */
 		new_offset = USOCK_ALIGN(payload_len);
-		options_start = (void*)ip + new_offset;
+		options_start = (void*)&pkt->payload + new_offset;
 		data = options_start;
 		total_len -= (options_start - (char*)pkt);
 
@@ -460,7 +460,7 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 						"ulogd2: unknown option %d\n",
 						option_number);
 				break;
-			};
+			}
 		}
 	}
 
@@ -666,7 +666,7 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 		}
 
 		/* handle_packet has shifted data in buffer */
-	};
+	}
 
 	return 0;
 }
-- 
2.33.0

