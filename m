Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37254C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 11:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiGKLWk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 07:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiGKLWN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 07:22:13 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D551211
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 03:47:17 -0700 (PDT)
Received: from localhost (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 852A5F8C99F;
        Mon, 11 Jul 2022 12:47:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1657536431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XBpwVlpoHk04+mGra6QZudiA+x7JsX5wD9Aif/f8oPI=;
        b=VwZx9yxe9sRaQvDhYpNxWnpsvQLx64IQjCKwaqcxAr+zXlNeOCNmlvsagXBalSjBRIpdYT
        zmlx0J+PsB2nr474HbuqPGsyJN2vlnVWcVFbuoaNxOmbpoh8X8cuREoBfHWOMAoCiG56sW
        OU8NBbhJBNdclEpShC5LxRX1NoC+ja4=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Loganaden Velvindron <logan@cyberstorm.mu>
Subject: [PATCH v2] src: proto: support DF, LE PHB, VA for DSCP
Date:   Mon, 11 Jul 2022 12:47:09 +0200
Message-Id: <20220711104709.256302-1-oleksandr@natalenko.name>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a couple of aliases for well-known DSCP values.

As per RFC 4594, add "df" as an alias of "cs0" with 0x00 value.

As per RFC 5865, add "va" for VOICE-ADMIT with 0x2c value.

As per RFC 8622, add "lephb" for Lower-Effort Per-Hop Behavior with 0x01 value.

tc-cake(8) in diffserv8 mode would benefit from having "lephb" defined since
it corresponds to "Tin 0".

Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 src/proto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index a013a00d..905adad3 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -684,7 +684,9 @@ static const struct symbol_table dscp_type_tbl = {
 		SYMBOL("cs5",	0x28),
 		SYMBOL("cs6",	0x30),
 		SYMBOL("cs7",	0x38),
+		SYMBOL("df",	0x00),
 		SYMBOL("be",	0x00),
+		SYMBOL("lephb",	0x01),
 		SYMBOL("af11",	0x0a),
 		SYMBOL("af12",	0x0c),
 		SYMBOL("af13",	0x0e),
@@ -697,6 +699,7 @@ static const struct symbol_table dscp_type_tbl = {
 		SYMBOL("af41",	0x22),
 		SYMBOL("af42",	0x24),
 		SYMBOL("af43",	0x26),
+		SYMBOL("va",	0x2c),
 		SYMBOL("ef",	0x2e),
 		SYMBOL_LIST_END
 	},
-- 
2.37.0

