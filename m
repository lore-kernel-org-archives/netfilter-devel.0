Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84827C83F1B
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjH1OsB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjH1Orf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC23613D
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5lBKzBe0uosZW+EhC+FeSfCr673pkk4U9J6Y1dd7o0Y=;
        b=JRKaAc/kivIEDohVtKsC3IZksDX9n7BJJiimIEqjWb2zYqM9qSTYU7i4WokH3FlErNdIGU
        Rj+b98/n3DQ65RVJalJdsckrkdKNEQVTMcGLwVV66bACxhmN5vzahf5YfKPY0qvr36PgQX
        16y6uz1RkYW+xL7Ff20bl6zzF2WR5B4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-9xvi1kJ5MF2z6HjtsVy6cg-1; Mon, 28 Aug 2023 10:46:23 -0400
X-MC-Unique: 9xvi1kJ5MF2z6HjtsVy6cg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D998101A528
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2B0940C6F4E;
        Mon, 28 Aug 2023 14:46:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/8] netlink: avoid "-Wenum-conversion" warning in parser_bison.y
Date:   Mon, 28 Aug 2023 16:43:52 +0200
Message-ID: <20230828144441.3303222-3-thaller@redhat.com>
In-Reply-To: <20230828144441.3303222-1-thaller@redhat.com>
References: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clang warns:

    parser_bison.y:3658:83: error: implicit conversion from enumeration type 'enum nft_nat_types' to different enumeration type 'enum nft_nat_etypes' [-Werror,-Wenum-conversion]
                                            { (yyval.stmt) = nat_stmt_alloc(&(yyloc), NFT_NAT_SNAT); }
                                                             ~~~~~~~~~~~~~~           ^~~~~~~~~~~~
    parser_bison.y:3659:83: error: implicit conversion from enumeration type 'enum nft_nat_types' to different enumeration type 'enum nft_nat_etypes' [-Werror,-Wenum-conversion]
                                            { (yyval.stmt) = nat_stmt_alloc(&(yyloc), NFT_NAT_DNAT); }
                                                             ~~~~~~~~~~~~~~           ^~~~~~~~~~~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/parser_bison.y | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5637829332ce..9e7f5c829c54 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3655,8 +3655,8 @@ reject_opts		:       /* empty */
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
-nat_stmt_alloc		:	SNAT	{ $$ = nat_stmt_alloc(&@$, NFT_NAT_SNAT); }
-			|	DNAT	{ $$ = nat_stmt_alloc(&@$, NFT_NAT_DNAT); }
+nat_stmt_alloc		:	SNAT	{ $$ = nat_stmt_alloc(&@$, __NFT_NAT_SNAT); }
+			|	DNAT	{ $$ = nat_stmt_alloc(&@$, __NFT_NAT_DNAT); }
 			;
 
 tproxy_stmt		:	TPROXY TO stmt_expr
-- 
2.41.0

