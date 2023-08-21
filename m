Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF493EE49A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 20:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjHUUE1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjHUUE0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 16:04:26 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1167123
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 13:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9uFpsL9cffabb6z6Hq2bexS83tmfyL4Quf1zHAJ6IdM=; b=H6ub7PpCUb8UBNDE1805qX9kG9
        iN6Dx3OzVxba+Lc4e/8K0HoOrL2tVycTciUT+UJ9NvuFktZo3BRg8JviLcLbvnvZlADWZ8sR1AfIa
        MecbZUzoMQfQhD5/jbUrNUR54s6stiiOyJC9v4DlKiuZn76TMxfFPP+mci5wWyGCeVUhrpfLxuEdP
        CXI3iH92uuxpCYA4YFwTxK1mbelP9em8iYUN7AZZJhNwgsQgRzmfnxYPfctuai78xRkoKQWx0YPnK
        puzZN2QPq3eyCQdCRxYEbDTmg1NuIzQcdSRZ1U7WNprD9pWl6ObVRIvYv8XSSN+C/fA+5IL6sE94P
        OU2GMolg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-2s
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 10/11] sqlite3: insert ipv6 addresses as null rather than garbage
Date:   Mon, 21 Aug 2023 20:42:36 +0100
Message-Id: <20230821194237.51139-11-jeremy@azazel.net>
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

Currently, the plug-in assumes that all IP addresses are 32-bit ipv4
addresses, so ipv6 addresses get truncated and inserted as garbage.
Insert nulls instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 3a823892a2dd..6aeb7a3865e1 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -33,6 +33,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <arpa/inet.h>
+#include <netinet/in.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 #include <sqlite3.h>
@@ -178,7 +179,11 @@ sqlite3_interp(struct ulogd_pluginstance *pi)
 			break;
 
 		case ULOGD_RET_IPADDR:
-			ret = sqlite3_bind_int(priv->p_stmt, i, k_ret->u.value.ui32);
+			if (k_ret->len == sizeof(struct in_addr))
+				ret = sqlite3_bind_int(priv->p_stmt, i,
+						       k_ret->u.value.ui32);
+			else
+				ret = sqlite3_bind_null(priv->p_stmt, i);
 			break;
 
 		case ULOGD_RET_UINT64:
-- 
2.40.1

