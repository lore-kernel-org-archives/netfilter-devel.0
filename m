Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5446BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33BC260F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhJ3RNJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhJ3RNI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:08 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDF2C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x73y1mbw3WGFoL3pEhh4auiua5LnQS+c66HxqxTbjN4=; b=NvVdcSeaDYNUQ5nM6+UzgwyyEv
        9carLBepoUOt7p0gy5G7bRAtSW7snW5G/TfyNotOW1rtaVD+2zXuVYDFwNNLIb32o3SQ+MZw65DSH
        SUnSr/dXhSa7dl4Qts4mrEbLCs5rhpCxPwRRs1V/l50zbnbtdQQLFHxncBmwppw+eixcjKnCxU9wp
        asEHi7GGZGg3IepjpWIXmLHwF+d7rLvIAxgk+b0+SL/q/+8Fbqq1yiXJ2WPfEFf9zFgG3ELlqF3QT
        hKIqNlVPyFdljXGdqy1NF/ZRNb6SDYshyO+X2q5FNQey30np6cwmfxXo2PeEhwn6MSLlwrh99Omfa
        ARMFkmLA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT9-00AFgT-Sh
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 15/26] input: UNIXSOCK: prevent unaligned pointer access.
Date:   Sat, 30 Oct 2021 17:44:21 +0100
Message-Id: <20211030164432.1140896-16-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`struct ulogd_unixsock_packet_t` is packed, so taking the address of its
`struct iphdr payload` member may yield an unaligned pointer value.
Copy it to a local variable instead.

Remove a couple of stray semicolons.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index af2fbeca1f4c..f7611189363c 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -371,7 +371,7 @@ struct ulogd_unixsock_option_t  {
 static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_packet_t *pkt, uint16_t total_len)
 {
 	char *data = NULL;
-	struct iphdr *ip;
+	struct iphdr ip = pkt->payload;
 	struct ulogd_key *ret = upi->output.keys;
 	uint8_t oob_family;
 	uint16_t payload_len;
@@ -387,22 +387,22 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 
 	payload_len = ntohs(pkt->payload_length);
 
-	ip = &pkt->payload;
-	if (ip->version == 4)
+	if (ip.version == 4)
 		oob_family = AF_INET;
-	else if (ip->version == 6)
+	else if (ip.version == 6)
 		oob_family = AF_INET6;
-	else oob_family = 0;
+	else
+		oob_family = 0;
 
 	okey_set_u8(&ret[UNIXSOCK_KEY_OOB_FAMILY], oob_family);
-	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], ip);
+	okey_set_ptr(&ret[UNIXSOCK_KEY_RAW_PCKT], &ip);
 	okey_set_u32(&ret[UNIXSOCK_KEY_RAW_PCKTLEN], payload_len);
 
 	/* options */
 	if (total_len > payload_len + sizeof(uint16_t)) {
 		/* option starts at the next aligned address after the payload */
 		new_offset = USOCK_ALIGN(payload_len);
-		options_start = (void*)ip + new_offset;
+		options_start = (char *) &ip + new_offset;
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
 
@@ -674,7 +674,7 @@ static int unixsock_instance_read_cb(int fd, unsigned int what, void *param)
 		}
 
 		/* handle_packet has shifted data in buffer */
-	};
+	}
 
 	return 0;
 }
-- 
2.33.0

