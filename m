Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391F3EE49A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjHUTnG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:06 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0954BE8
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2/L3wmJzY6e8hmg12erEoZUnPJ1B1Zfg+lBuTrnxglg=; b=onfIpHKDXHcmWmQsBZ52LCVbVW
        Xzt2spSv63iiANW+Q9rbDaaKPHVqQ1qcPKDDGLSM2YHK1ndnmeejqtcSWGI3BNR3wgVhDCYbpzNwu
        T99ao7NqiDlxG1gUwtMKjH040NB29M8MfHyTffHR/l0U/TEZZizV+MPTskD+u0nZ2d7Xg1q14/GHm
        ThxXSkDdNSonYmzcqcjGmpxiICcdBd5OR6NB1b8NkLf353hCd/g4fgoU3ZKKrSQFsNSf7am/rHuxH
        hg4yLoF/Sle0kpH3bRKhPJNuwTN8Yq5D1IYg3sEuMVSsNHQKzWk2IPnvtF5T01YIefcPHXaCu20OS
        StZi1kbA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-1W
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 01/11] src: record length of integer key values
Date:   Mon, 21 Aug 2023 20:42:27 +0100
Message-Id: <20230821194237.51139-2-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/ulogd/ulogd.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 092d9f521a70..cb0174042235 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -134,36 +134,42 @@ static inline void okey_set_b(struct ulogd_key *key, uint8_t value)
 {
 	key->u.value.b = value;
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.b);
 }
 
 static inline void okey_set_u8(struct ulogd_key *key, uint8_t value)
 {
 	key->u.value.ui8 = value;
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.ui8);
 }
 
 static inline void okey_set_u16(struct ulogd_key *key, uint16_t value)
 {
 	key->u.value.ui16 = value;
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.ui16);
 }
 
 static inline void okey_set_u32(struct ulogd_key *key, uint32_t value)
 {
 	key->u.value.ui32 = value;
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.ui32);
 }
 
 static inline void okey_set_u64(struct ulogd_key *key, uint64_t value)
 {
 	key->u.value.ui64 = value;
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.ui64);
 }
 
 static inline void okey_set_u128(struct ulogd_key *key, const void *value)
 {
-	memcpy(key->u.value.ui128, value, 16);
+	memcpy(key->u.value.ui128, value, sizeof(key->u.value.ui128));
 	key->flags |= ULOGD_RETF_VALID;
+	key->len = sizeof(key->u.value.ui128);
 }
 
 static inline void okey_set_ptr(struct ulogd_key *key, void *value)
@@ -309,6 +315,7 @@ void __ulogd_log(int level, char *file, int line, const char *message, ...)
 #define SET_NEEDED(x)	(x.flags |= ULOGD_RETF_NEEDED)
 
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
+#define GET_LENGTH(res, x)	(res[x].u.source->len)
 #define pp_is_valid(res, x)	\
 	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
 
-- 
2.40.1

