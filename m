Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B781EE49A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjHUTnJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjHUTnG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:06 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093E3DB
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ETIOQoM+fZhOKikY3+mu4szxQ+mvL/F6uZ2TanBy4sI=; b=afks4r6BLGzoCeTcAjuT91QJFO
        FsE++J0gfSIngBwDVRCIDDKgkMd9zqpmUxWeCIQA5jTxAAX1qGHspI8uNQGBCGbHr6BIjq7FARoic
        vd5RkA+78yKDEIVMy00giC+Df8+7PI7LoIzg7x/rl2yu+AdKxe0ZfS6vSWUHqimkzh2oScFwZvM+I
        MPdOqjXyXf1lbVb2wcHG5+I/g/h0sC/xnuTmWT3bCV+yTSFz6dfpITV12FRH4pLAEtE0T+mlujPIw
        RJddAU6UcUBDff8lepeZgQHIRA3yTt+27BRtDFp1s0CD4O93w5/MVBXlhCchFGhilxOuvubK2TMZb
        Nko4X3wg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-1o
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 03/11] printpkt, raw2packet_BASE: keep gateway address in NBO
Date:   Mon, 21 Aug 2023 20:42:29 +0100
Message-Id: <20230821194237.51139-4-jeremy@azazel.net>
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

Everywhere else ipv4 addresses are left in NBO until output.  The only
exception is the IP2HBIN filter, which is explicitly intended to convert
from NBO to HBO.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c | 2 +-
 util/printpkt.c                           | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 9117d27da09a..14423486a880 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -645,7 +645,7 @@ static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *icmph,
 		break;
 	case ICMP_REDIRECT:
 	case ICMP_PARAMETERPROB:
-		okey_set_u32(&ret[KEY_ICMP_GATEWAY], ntohl(icmph->un.gateway));
+		okey_set_u32(&ret[KEY_ICMP_GATEWAY], icmph->un.gateway);
 		break;
 	case ICMP_DEST_UNREACH:
 		if (icmph->code == ICMP_FRAG_NEEDED) {
diff --git a/util/printpkt.c b/util/printpkt.c
index 11126b3c9af7..09a219417f91 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -260,8 +260,9 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 					   ikey_get_u16(&res[KEY_ICMP_ECHOSEQ]));
 			break;
 		case ICMP_PARAMETERPROB:
+			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]);
 			buf_cur += sprintf(buf_cur, "PARAMETER=%u ",
-					   ikey_get_u32(&res[KEY_ICMP_GATEWAY]) >> 24);
+					   *(uint8_t *) &paddr);
 			break;
 		case ICMP_REDIRECT:
 			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]);
-- 
2.40.1

