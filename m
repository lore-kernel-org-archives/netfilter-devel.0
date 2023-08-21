Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D131AEE49AE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjHUTnK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjHUTnH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:07 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18855F3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jZ9O6CRbiBKsWabEkLnyd26dau9cMzRFsGDcEYwuE+s=; b=fUDWTxclPlCRUh6AcrO2npOFLL
        NX/OfyE5d22hZqr3J+d9XOpchUafFRQ4q85/6NM1Jrv02bNfc1M4t1gKYzPiyN9LHqaGwNUZCs8eW
        EqXt7xWAaikJSB5Xem8LfdL9IIPc8She+jxcdNIRRi5T9sJ2Nek3pxxuPmjEmosL7RIduQC/IDZvg
        8Tiawnw44jf3biuOLjDkVm2LOfyZMktKTrQIxLvMFpxo91jTRTCXP8ChkEfvcga9zi7+iyx9oCeCv
        PAmsDk8DdgO+KL0gZkfFM0Ps6UTok5H8pY1D/ZrfeGxJPb81NSuJFuy2Xhk5IxocLO6KKu/7DisBy
        KbZkcq3Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-1y;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Robert O'Brien <robrien@foxtrot-research.com>
Subject: [PATCH ulogd2 v3 04/11] raw2packet_BASE: store ARP address values as integers
Date:   Mon, 21 Aug 2023 20:42:30 +0100
Message-Id: <20230821194237.51139-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821194237.51139-1-jeremy@azazel.net>
References: <20230821194237.51139-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Keys of type `ULOGD_RET_IPADDR` may be ipv4 or ipv6.  ARP protocol
addresses are 32-bits (i.e., ipv4).  By using `okey_set_u32` we keep
track of the size and allow downstream plug-ins to handle them
correctly.

Reported-by: Robert O'Brien <robrien@foxtrot-research.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 14423486a880..09e931349acf 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -896,18 +896,23 @@ static int _interp_arp(struct ulogd_pluginstance *pi, uint32_t len)
 	struct ulogd_key *ret = pi->output.keys;
 	const struct ether_arp *arph =
 		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
+	uint32_t arp_spa, arp_tpa;
 
 	if (len < sizeof(struct ether_arp))
 		return ULOGD_IRET_OK;
 
-	okey_set_u16(&ret[KEY_ARP_HTYPE], ntohs(arph->arp_hrd));
-	okey_set_u16(&ret[KEY_ARP_PTYPE], ntohs(arph->arp_pro));
+	okey_set_u16(&ret[KEY_ARP_HTYPE],  ntohs(arph->arp_hrd));
+	okey_set_u16(&ret[KEY_ARP_PTYPE],  ntohs(arph->arp_pro));
 	okey_set_u16(&ret[KEY_ARP_OPCODE], ntohs(arph->arp_op));
 
 	okey_set_ptr(&ret[KEY_ARP_SHA], (void *)&arph->arp_sha);
-	okey_set_ptr(&ret[KEY_ARP_SPA], (void *)&arph->arp_spa);
 	okey_set_ptr(&ret[KEY_ARP_THA], (void *)&arph->arp_tha);
-	okey_set_ptr(&ret[KEY_ARP_TPA], (void *)&arph->arp_tpa);
+
+	memcpy(&arp_spa, arph->arp_spa, sizeof(arp_spa));
+	memcpy(&arp_tpa, arph->arp_tpa, sizeof(arp_tpa));
+
+	okey_set_u32(&ret[KEY_ARP_SPA], arp_spa);
+	okey_set_u32(&ret[KEY_ARP_TPA], arp_tpa);
 
 	return ULOGD_IRET_OK;
 }
-- 
2.40.1

