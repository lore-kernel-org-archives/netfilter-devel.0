Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461EBC83F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjH2NAM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235905AbjH2M76 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36DC1BE
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rcA/vaH0phYCBY/ZOFv+sDiy44XDSGFTMd3VcTJN8EA=;
        b=froOAa+mocROYQ4PM4EgURYB8dw1f853TMpnSSsO/nO1uDt5+U5T2fxxwPy4JLyP/WhGNK
        ieX9N69Zs1oPULq82KQcPMzQBoRrMQcN+VTsC9gOY141PgV1vKlsZd6EWKyGyvATYJ+eHZ
        Q3tuFsrjkaay6Ggg9/8nZGGQ4msKpXk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-XHDpac9TMpGXONWhvoqj8Q-1; Tue, 29 Aug 2023 08:58:26 -0400
X-MC-Unique: XHDpac9TMpGXONWhvoqj8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FA3B80027F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E47C040C2063;
        Tue, 29 Aug 2023 12:58:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 8/8] include: drop "format" attribute from nft_gmp_print()
Date:   Tue, 29 Aug 2023 14:53:37 +0200
Message-ID: <20230829125809.232318-9-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_gmp_print() passes the format string and arguments to
gmp_vfprintf(). Note that the format string is then interpreted
by gmp, which also understand special specifiers like "%Zx".

Note that with clang we get various compiler warnings:

  datatype.c:299:26: error: invalid conversion specifier 'Z' [-Werror,-Wformat-invalid-specifier]
          nft_gmp_print(octx, "0x%Zx [invalid type]", expr->value);
                                 ~^

gcc doesn't warn, because to gcc 'Z' is a deprecated alias for 'z' and
because the 3rd argument of the attribute((format())) is zero (so gcc
doesn't validate the arguments). But Z specifier in gmp expects a
"mpz_t" value and not a size_t. It's really not the same thing.

The correct solution is not to mark the function to accept a printf format
string.

Fixes: 2535ba7006f2 ('src: get rid of printf')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/nftables.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 219a10100206..b9b2b01c2689 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -236,8 +236,7 @@ void realm_table_rt_exit(struct nft_ctx *ctx);
 
 int nft_print(struct output_ctx *octx, const char *fmt, ...)
 	__attribute__((format(printf, 2, 3)));
-int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
-	__attribute__((format(printf, 2, 0)));
+int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...);
 
 int nft_optimize(struct nft_ctx *nft, struct list_head *cmds);
 
-- 
2.41.0

