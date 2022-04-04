Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18DBC43217
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiDDMQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242127AbiDDMQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:16:30 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6406513D34
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e4tdn+El4S3PHWhh+cQiADiArdU5P+ZxjOYnOSiPDkc=; b=EBfS8PKBV3Nk3WTIgjEOM95HlD
        rQF4rfrqfSUA8SzP9cNDJKXCBqQiHMGStO68/SLMk9bvWYy1BvcppFIkKlUefON93mJ08zWCl/ZKk
        Hah9DHW55eZq4KFrT3oSIuQW5WIavF9/L+6S9Q4tT2/GPlS1VBvietGbeD/4wVWKBxSQdpQAkAaPx
        /cBn4hfrM5bhCFKiK+O4T/yap95zpG/nne9UwO5+HtjFF0iTVjPjYWM6n3ncp3XJiZjUcqBmTGtJp
        HU29d0vrxpXdYtwA9WNm2eZbiobcLrtgCwFYU5ymaAx8ufn0W1WGDzcj2u0DHecvon+vAO59lQ1HR
        udIyemkQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbI-007FTC-TF; Mon, 04 Apr 2022 13:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 05/32] ct: support `NULL` symbol-tables when looking up labels
Date:   Mon,  4 Apr 2022 13:13:43 +0100
Message-Id: <20220404121410.188509-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the symbol-table passed to `ct_label2str` is `NULL`, return `NULL`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/ct.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index e246d3039240..8c9ae7b0e04a 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -148,10 +148,11 @@ const char *ct_label2str(const struct symbol_table *ct_label_tbl,
 {
 	const struct symbolic_constant *s;
 
-	for (s = ct_label_tbl->symbols; s->identifier; s++) {
-		if (value == s->value)
-			return s->identifier;
-	}
+	if (ct_label_tbl != NULL)
+		for (s = ct_label_tbl->symbols; s->identifier; s++) {
+			if (value == s->value)
+				return s->identifier;
+		}
 
 	return NULL;
 }
-- 
2.35.1

