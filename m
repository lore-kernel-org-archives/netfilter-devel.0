Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E0AC4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 19:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjKITBn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 14:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjKITBk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 14:01:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92463C13
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 11:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699556446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o7yQ56DZ8rPR5bVWgTYop0r9yWMqRr0ZbjLK8xN+Ayg=;
        b=OB9SCKz9kzYeScn/OzY196IMSX+Ls/2M8gCq7DYNl5aodfmLFJQN9EfreLTnva8iNH4zIb
        rRujXLWero/aolYWRAyTL2UBKlZysunHKXvZDkwdcud6ilzk1mEwHZaLAHBbcL+2/yq4Kl
        W8yLV5aSRSZXt3nEKc6i+47UNXYLsog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-h4Q69GbGOtyZo82dgcp-Cg-1; Thu, 09 Nov 2023 14:00:43 -0500
X-MC-Unique: h4Q69GbGOtyZo82dgcp-Cg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D8CA80F8F7
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 19:00:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0B9640C6EB9;
        Thu,  9 Nov 2023 19:00:42 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/3] parser: remove "const" from argument of input_descriptor_destroy()
Date:   Thu,  9 Nov 2023 19:59:48 +0100
Message-ID: <20231109190032.669575-2-thaller@redhat.com>
In-Reply-To: <20231109190032.669575-1-thaller@redhat.com>
References: <20231109190032.669575-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's not a const pointer, as the destroy() function clearly
modifies/free is. Drop the const from the argument of
input_descriptor_destroy().

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/scanner.l | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 00a09485d420..31284d7358fa 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1258,11 +1258,11 @@ void *scanner_init(struct parser_state *state)
 	return scanner;
 }
 
-static void input_descriptor_destroy(const struct input_descriptor *indesc)
+static void input_descriptor_destroy(struct input_descriptor *indesc)
 {
 	if (indesc->name)
 		free_const(indesc->name);
-	free_const(indesc);
+	free(indesc);
 }
 
 static void input_descriptor_list_destroy(struct parser_state *state)
-- 
2.41.0

