Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57F4C88CB7
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 17:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjFLRfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 13:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbjFLRfY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 13:35:24 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5044A2717
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 10:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fliJTigqgB+27V00TewwkpobhGSwVY0St+zvp8U8h9c=; b=jkqT8jlRiGuovJmctx1thmKHBE
        OZjvXuN7Rn76MeM0Ty1ScJTcdQxw17y3hD32W0b5Wkw3+yF+8EAXhYrZfWMnvwp4R2Z3yTQk0uQpo
        WgNsb4TasjQlRoW6jkPR0ApvoPHEHlyDQwKTYc4Zzuzqr7c/IbN619YsbRKNZMzojBKHd8OXn/trP
        KcYJHUq5COQFlYgGcXj15wEUe/imyfV968kigETne16KET+gH7YGqI+gH8MQ4Rl9ge0TV1zI2KOkF
        ePtLjNT02iB3LcdVApWXgvoUXWu3vxr27T+D6lWtn9cmQEWpIhHMMo/tFTFLsI3phC61HI2ddHd3R
        vLoPkmKg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1q8lPS-000wtJ-1K
        for netfilter-devel@vger.kernel.org;
        Mon, 12 Jun 2023 18:32:54 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons] xt_ipp2p: change text-search algo to KMP
Date:   Mon, 12 Jun 2023 18:31:33 +0100
Message-Id: <20230612173133.795980-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel's Boyer-Moore text-search implementation may miss matches in
non-linear skb's, so use Knuth-Morris-Pratt instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 2962909930df..eba0b5581273 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -18,6 +18,8 @@
 #define get_u16(X, O)  get_unaligned((const __u16 *)((X) + O))
 #define get_u32(X, O)  get_unaligned((const __u32 *)((X) + O))
 
+#define TEXTSEARCH_ALGO "kmp"
+
 MODULE_AUTHOR("Eicke Friedrich/Klaus Degner <ipp2p@ipp2p.org>");
 MODULE_DESCRIPTION("An extension to iptables to identify P2P traffic.");
 MODULE_LICENSE("GPL");
@@ -1326,55 +1328,57 @@ static int ipp2p_mt_check(const struct xt_mtchk_param *par)
 	struct ipt_p2p_info *info = par->matchinfo;
 	struct ts_config *ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "\x20\x22", 2,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "\x20\x22", 2,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_return;
 	info->ts_conf_winmx = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "info_hash=", 10,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "info_hash=", 10,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_winmx;
 	info->ts_conf_bt_info_hash = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "peer_id=", 8,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "peer_id=", 8,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_bt_info_hash;
 	info->ts_conf_bt_peer_id = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "passkey", 8,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "passkey", 8,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_bt_peer_id;
 	info->ts_conf_bt_passkey = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "\r\nX-Gnutella-", 13,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "\r\nX-Gnutella-", 13,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_bt_passkey;
 	info->ts_conf_gnu_x_gnutella = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "\r\nX-Queue-", 10,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, "\r\nX-Queue-", 10,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_gnu_x_gnutella;
 	info->ts_conf_gnu_x_queue = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "\r\nX-Kazaa-Username: ", 20,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO,
+				     "\r\nX-Kazaa-Username: ", 20,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_gnu_x_queue;
 	info->ts_conf_kz_x_kazaa_username = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", "\r\nUser-Agent: PeerEnabler/", 26,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO,
+				     "\r\nUser-Agent: PeerEnabler/", 26,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_kazaa_x_kazaa_username;
 	info->ts_conf_kz_user_agent = ts_conf;
 
-	ts_conf = textsearch_prepare("bm", ":xdcc send #", 12,
+	ts_conf = textsearch_prepare(TEXTSEARCH_ALGO, ":xdcc send #", 12,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))
 		goto err_ts_destroy_kazaa_user_agent;
-- 
2.39.2

