Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35ABBC10F03
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0423B208E4
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 20:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="CiWr7oDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfDWUSX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:18:23 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44807 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfDWUSX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 16:18:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id s10so6886957qtc.11
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Apr 2019 13:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=from:to:subject:date:message-id;
        bh=5bzgaYfvZjsBDMaWI9zHAUZ+xjsjwVfLwQWqFRE06BM=;
        b=CiWr7oDMB1w0mlO9ETn01l/rFKghrzuH1Z8Lkq9rmbC8Eu9PhVeIMvTesBJe4J/kLk
         NEmVJhvEZlnp1pY+Z90WeuQCfskpIwrRsAHG29JBiCB3FCIwNnmhWR7QOj6oIpOkqXc7
         6TLtFOkJ47PLX0FDFTvht6Tr4HFRsiLkE/u2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=5bzgaYfvZjsBDMaWI9zHAUZ+xjsjwVfLwQWqFRE06BM=;
        b=iex0QMrloU4VHfKOoEViiwDA9YTN5I7iWlwe0Str7k3NxxtYFMIQL4/eFBLUbJ/Nu/
         w+uBx/v8CI4nyspOEzuQC9Y5CDXlimRVXWEEdNBjOJJt9P7iy+MMHyPB4+TSuL/ahP3g
         /97+AVq+iIw15qDaLGzto8DBUnLMHYTx8PKkOFNUgtPEXToOP6LWJ1TSfYHAeYpvBOE+
         ZITM4VhtX8Wl0Eo/hUOMBy/ne6/woiLNFJweDFRoXxpsZxnBshbuggmSZEynUymPOPhT
         iN4BL1HjlqrUm1r/BKvtV2aZqVXj4H5w8xwjHPgoopwopXPaBrjvoX5PtnSGXye+bdxH
         9u+Q==
X-Gm-Message-State: APjAAAUBrbrgwG0NXiaV75OzEGOSqnbSi+sOkEEPe1x6I2ALIQBqQqT3
        gg3iE/oJ3YsAcjcf6HwOy/L5pPobSuo=
X-Google-Smtp-Source: APXvYqy2t8REHGBsU5TPQYmyFkiZaJ8PFpOVjRrTgzM/p6KdV1+looUjWJWVljm+KSQjNKEFYPWS5g==
X-Received: by 2002:a0c:f805:: with SMTP id r5mr9061978qvn.98.1556050702640;
        Tue, 23 Apr 2019 13:18:22 -0700 (PDT)
Received: from osboxes.example.com (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id e4sm4248382qkl.80.2019.04.23.13.18.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 13:18:22 -0700 (PDT)
From:   Brett Mastbergen <bmastbergen@untangle.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] src: Add ct id support
Date:   Tue, 23 Apr 2019 16:18:17 -0400
Message-Id: <20190423201817.8493-1-bmastbergen@untangle.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 'id' key returns the id of the connection entry

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/ct.c                       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index fd38cdc..6da0bf5 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -978,6 +978,7 @@ enum nft_osf_attributes {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
+ * @NFT_CT_ID: conntrack id
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -1004,6 +1005,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_TIMEOUT,
+	NFT_CT_ID,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/src/expr/ct.c b/src/expr/ct.c
index b9ca2dc..124de9d 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -172,6 +172,7 @@ static const char *ctkey2str_array[NFT_CT_MAX + 1] = {
 	[NFT_CT_DST_IP]		= "dst_ip",
 	[NFT_CT_SRC_IP6]	= "src_ip6",
 	[NFT_CT_DST_IP6]	= "dst_ip6",
+	[NFT_CT_ID]		= "id",
 };
 
 static const char *ctkey2str(uint32_t ctkey)
-- 
2.11.0

