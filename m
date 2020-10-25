Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69784C55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A17120720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="HOEjXrma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416232AbgJYNRT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894311AbgJYNRT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:17:19 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10001C0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wVsxldErMxXku4F2RABeggwkTqULGoXk/SfQXJli2Yo=; b=HOEjXrmah5IlxEW2Hhj4o1fol/
        BcUYq9tVQiZGAQLyykUjeckSygNVQ6cVxoNLuqZjFmkMWc881ajUcmwL7UXaApd2t/Rp1FzigknlF
        ElrhkIZHOwlRffzwC1adrupA19hGvZ3VRoLjdz7iDhTk2cJx4IKD3RyZATEIUseNUsrLPw+QHPqyI
        h45IHzIDQg3exQDilLUKinazEpuiEjtTHXZmcMOk7aF/tl6U8FuRL+Jg0V/Py7ru4COX8CVaWdgYY
        bJOCOb09QRR0jIwyTXTM0v4o1uefkmmDCMcG5QXfl6VNAXsjiUAJeFiYUAKidfhW8UqtqZjrbj0KF
        MPyWu7gA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsW-0001SE-K1; Sun, 25 Oct 2020 13:16:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 11/13] pknock: xt_pknock: use kzalloc.
Date:   Sun, 25 Oct 2020 13:15:57 +0000
Message-Id: <20201025131559.920038-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace some instances of kmalloc + memset.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index ba8161517d27..ae3ab2445c3b 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -450,13 +450,12 @@ add_rule(struct xt_pknock_mtinfo *info)
 		return true;
 	}
 
-	rule = kmalloc(sizeof(*rule), GFP_KERNEL);
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
 	if (rule == NULL)
 		return false;
 
 	INIT_LIST_HEAD(&rule->head);
 
-	memset(rule->rule_name, 0, sizeof(rule->rule_name));
 	strncpy(rule->rule_name, info->rule_name, info->rule_name_len);
 	rule->rule_name_len = info->rule_name_len;
 
@@ -681,12 +680,9 @@ msg_to_userspace_nl(const struct xt_pknock_mtinfo *info,
 	struct cn_msg *m;
 	struct xt_pknock_nl_msg msg;
 
-	m = kmalloc(sizeof(*m) + sizeof(msg), GFP_ATOMIC);
+	m = kzalloc(sizeof(*m) + sizeof(msg), GFP_ATOMIC);
 	if (m == NULL)
 		return false;
-
-	memset(m, 0, sizeof(*m) + sizeof(msg));
-	m->seq = 0;
 	m->len = sizeof(msg);
 
 	msg.peer_ip = peer->ip;
@@ -731,7 +727,7 @@ static bool
 has_secret(const unsigned char *secret, unsigned int secret_len, uint32_t ipsrc,
     const unsigned char *payload, unsigned int payload_len)
 {
-	char result[64]; // 64 bytes * 8 = 512 bits
+	char result[64] = ""; // 64 bytes * 8 = 512 bits
 	char *hexresult;
 	unsigned int hexa_size;
 	int ret;
@@ -752,13 +748,10 @@ has_secret(const unsigned char *secret, unsigned int secret_len, uint32_t ipsrc,
 	if (payload_len != hexa_size + 1)
 		return false;
 
-	hexresult = kmalloc(hexa_size, GFP_ATOMIC);
+	hexresult = kzalloc(hexa_size, GFP_ATOMIC);
 	if (hexresult == NULL)
 		return false;
 
-	memset(result, 0, sizeof(result));
-	memset(hexresult, 0, hexa_size);
-
 	epoch_min = get_seconds() / 60;
 
 	ret = crypto_shash_setkey(crypto.tfm, secret, secret_len);
-- 
2.28.0

