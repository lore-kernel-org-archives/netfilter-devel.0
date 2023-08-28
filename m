Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97636C83F1C
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 14:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjH1OsE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 10:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjH1Orh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 10:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCD61A5
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 07:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693233986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXYSjtyA/HAHq0xQKUYKKlRmbeu5K4p7TPtybbqoa+c=;
        b=akMbJ3ykMSoC2bLb8XvGRHaHCvWQvtVaoJVh2Qb5mnBRrbX2yb68HeVsL/0vG2OsSNY3pI
        Hx3mcPk08lSIGHTQBBbHLViRLMuq/ur3JhotjUvbUpgkSIihSg+wdPlETnCQjkoPRzgZuQ
        NDjJPGlyCRRt2Gk7OOv1EiwG+JgVbHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-m8eAGXLDNfKYlvrWTpb-Sg-1; Mon, 28 Aug 2023 10:46:25 -0400
X-MC-Unique: m8eAGXLDNfKYlvrWTpb-Sg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2296858EED
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 14:46:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3214540D2839;
        Mon, 28 Aug 2023 14:46:24 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/8] datatype: avoid cast-align warning with struct sockaddr result from getaddrinfo()
Date:   Mon, 28 Aug 2023 16:43:54 +0200
Message-ID: <20230828144441.3303222-5-thaller@redhat.com>
In-Reply-To: <20230828144441.3303222-1-thaller@redhat.com>
References: <20230828144441.3303222-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With CC=clang we get

    datatype.c:625:11: error: cast from 'struct sockaddr *' to 'struct sockaddr_in *' increases required alignment from 2 to 4 [-Werror,-Wcast-align]
                    addr = ((struct sockaddr_in *)ai->ai_addr)->sin_addr;
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    datatype.c:690:11: error: cast from 'struct sockaddr *' to 'struct sockaddr_in6 *' increases required alignment from 2 to 4 [-Werror,-Wcast-align]
                    addr = ((struct sockaddr_in6 *)ai->ai_addr)->sin6_addr;
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    datatype.c:826:11: error: cast from 'struct sockaddr *' to 'struct sockaddr_in *' increases required alignment from 2 to 4 [-Werror,-Wcast-align]
                    port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix that by casting to (void*) first. Also, add an assertion that the
type is as expected.

For inet_service_type_parse(), differentiate between AF_INET and
AF_INET6. It might not have been a problem in practice, because the
struct offsets of sin_port/sin6_port are identical.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index a91b9cb793d5..4d0e44eeb500 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -622,7 +622,8 @@ static struct error_record *ipaddr_type_parse(struct parse_ctx *ctx,
 			return error(&sym->location,
 				     "Hostname resolves to multiple addresses");
 		}
-		addr = ((struct sockaddr_in *)ai->ai_addr)->sin_addr;
+		assert(ai->ai_addr->sa_family == AF_INET);
+		addr = ((struct sockaddr_in *) (void *) ai->ai_addr)->sin_addr;
 		freeaddrinfo(ai);
 	}
 
@@ -687,7 +688,9 @@ static struct error_record *ip6addr_type_parse(struct parse_ctx *ctx,
 			return error(&sym->location,
 				     "Hostname resolves to multiple addresses");
 		}
-		addr = ((struct sockaddr_in6 *)ai->ai_addr)->sin6_addr;
+
+		assert(ai->ai_addr->sa_family == AF_INET6);
+		addr = ((struct sockaddr_in6 *)(void *)ai->ai_addr)->sin6_addr;
 		freeaddrinfo(ai);
 	}
 
@@ -823,7 +826,12 @@ static struct error_record *inet_service_type_parse(struct parse_ctx *ctx,
 			return error(&sym->location, "Could not resolve service: %s",
 				     gai_strerror(err));
 
-		port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
+		if (ai->ai_addr->sa_family == AF_INET)
+			port = ((struct sockaddr_in *)(void *)ai->ai_addr)->sin_port;
+		else {
+			assert(ai->ai_addr->sa_family == AF_INET6);
+			port = ((struct sockaddr_in6 *)(void *)ai->ai_addr)->sin6_port;
+		}
 		freeaddrinfo(ai);
 	}
 
-- 
2.41.0

