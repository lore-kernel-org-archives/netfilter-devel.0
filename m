Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0022C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 19:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiF2TbI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 15:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiF2TbI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 15:31:08 -0400
X-Greylist: delayed 392 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 12:31:03 PDT
Received: from mail.yonan.net (mail.yonan.net [54.244.116.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649721402F
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 12:31:03 -0700 (PDT)
Received: from unless.localdomain (unknown [76.130.91.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.yonan.net (Postfix) with ESMTPSA id 18A9C3E947;
        Wed, 29 Jun 2022 19:24:31 +0000 (UTC)
From:   James Yonan <james@openvpn.net>
To:     netfilter-devel@vger.kernel.org
Cc:     James Yonan <james@openvpn.net>
Subject: [PATCH] netfilter: in nf_nat_initialized(), use const struct nf_conn *
Date:   Wed, 29 Jun 2022 13:22:10 -0600
Message-Id: <20220629192210.541840-1-james@openvpn.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_nat_initialized() doesn't modify passed struct nf_conn,
so declare as const.

This is helpful for code readability and makes it possible
to call nf_nat_initialized() with a const struct nf_conn *.

Signed-off-by: James Yonan <james@openvpn.net>
---
 include/net/netfilter/nf_nat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 987111ae5240..e9eb01e99d2f 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -104,7 +104,7 @@ unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
 
-static inline int nf_nat_initialized(struct nf_conn *ct,
+static inline int nf_nat_initialized(const struct nf_conn *ct,
 				     enum nf_nat_manip_type manip)
 {
 	if (manip == NF_NAT_MANIP_SRC)
-- 
2.25.1

