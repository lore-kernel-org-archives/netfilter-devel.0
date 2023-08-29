Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF62C83F19
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbjH2M7m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 08:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbjH2M7M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 08:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268001B7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 05:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693313904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYpQ0+QcJ+GNFdKXloa/amyKBRzjG+1VoD3RfI/XlTw=;
        b=M+d8EtA3tGvMi11gH1EpJWniR8KZcl783k5a9CAmLdHJSpG7DoK9ALpcCirVpa8hZD11ux
        eeJzVDjwN/0GLhe1e9pSIY1sCN51cdc2FJrVB8DxvIwqaDShn2zKpXFdyvS3UN/j7OEsxY
        umofCo5P5qdFcNMuJyjCbN/FA8xROEM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-S8QPEpYFOsWSZMYaB5C5YQ-1; Tue, 29 Aug 2023 08:58:22 -0400
X-MC-Unique: S8QPEpYFOsWSZMYaB5C5YQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC2D985CBE7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 12:58:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A27040C2063;
        Tue, 29 Aug 2023 12:58:20 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/8] netlink: avoid "-Wenum-conversion" warning in dtype_map_from_kernel()
Date:   Tue, 29 Aug 2023 14:53:30 +0200
Message-ID: <20230829125809.232318-2-thaller@redhat.com>
In-Reply-To: <20230829125809.232318-1-thaller@redhat.com>
References: <20230829125809.232318-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clang warns:

    netlink.c:806:26: error: implicit conversion from enumeration type 'enum nft_data_types' to different enumeration type 'enum datatypes' [-Werror,-Wenum-conversion]
                    return datatype_lookup(type);
                           ~~~~~~~~~~~~~~~ ^~~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index e1904a99d3ba..1afe162ec79b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -803,7 +803,7 @@ static const struct datatype *dtype_map_from_kernel(enum nft_data_types type)
 	default:
 		if (type & ~TYPE_MASK)
 			return concat_type_alloc(type);
-		return datatype_lookup(type);
+		return datatype_lookup((enum datatypes) type);
 	}
 }
 
-- 
2.41.0

