Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCCEC7EE32
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjE1OBi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjE1OBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DF3DC
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8DlbrMbCJacsHewu+hV6NLyfV8LWfuNyvK8qvCEvcOw=; b=mKSoooXSFFk7t6PDj7+vfUWPmH
        eAG1PjzljdRCI9JVmWRwETNNHGPpoMv+4uGUm3OpGgtlhNIjAKAYwyyxmipz+1R5EP2lzB5//xYvo
        DnQgGaZI7p32vjidg5etViQRfaSNMYFl6cvY/M0G/NGfm1HHib9TNJjVfFryy6lWt9OqZzdDmtiWT
        2I+Ghuaat4gN1zLV41530L/GeBohlIKKsPeXOGN2n6Q9G8La+FRj/OtJeuRw5t4fB1yugyt7YddiA
        mwFXHJJxVdT1XqYb/pSbORJSVer78DgxjgPWV/inJyMHp7YRIsonSiTe2/NU2MZhoYj9FtX9jwTY8
        9gVJ4pfg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-Gb; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 7/8] parser_json: allow RHS mark and payload expressions
Date:   Sun, 28 May 2023 15:00:57 +0100
Message-Id: <20230528140058.1218669-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>
References: <20230528140058.1218669-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for binops with variable RHS's will make it possible to have
ct and meta mark and payload expressions in the RHS.  Relax the JSON
parser accordingly.

Fix a typo in an adjacent comment.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_json.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index ad31b4e0365f..c6abd42f8ebb 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1454,20 +1454,20 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		{ "concat", json_parse_concat_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_DTYPE | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP },
 		{ "set", json_parse_set_expr, CTX_F_RHS | CTX_F_STMT }, /* allow this as stmt expr because that allows set references */
 		{ "map", json_parse_map_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS },
-		/* below three are multiton_rhs_expr */
+		/* below two are multiton_rhs_expr */
 		{ "prefix", json_parse_prefix_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
 		{ "range", json_parse_range_expr, CTX_F_RHS | CTX_F_SET_RHS | CTX_F_STMT | CTX_F_CONCAT },
-		{ "payload", json_parse_payload_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "payload", json_parse_payload_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "exthdr", json_parse_exthdr_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "tcp option", json_parse_tcp_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "ip option", json_parse_ip_option_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
 		{ "sctp chunk", json_parse_sctp_chunk_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_CONCAT },
-		{ "meta", json_parse_meta_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "meta", json_parse_meta_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "osf", json_parse_osf_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "ipsec", json_parse_xfrm_expr, CTX_F_PRIMARY | CTX_F_MAP | CTX_F_CONCAT },
 		{ "socket", json_parse_socket_expr, CTX_F_PRIMARY | CTX_F_CONCAT },
 		{ "rt", json_parse_rt_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
-		{ "ct", json_parse_ct_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "ct", json_parse_ct_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_MANGLE | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "numgen", json_parse_numgen_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		/* below two are hash expr */
 		{ "jhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
-- 
2.39.2

