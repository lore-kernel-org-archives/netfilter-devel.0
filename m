Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4835FCE79D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbjITObI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbjITObH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009E9DE
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=va5SmwycX8iA3d3rZyPKfEVB9DSFOxFvAVTor7HOtX4=;
        b=cD/bst2u5wT4XFnX6sz5MNoFPwFCCSWm/bNF/rQy6ubc5jfOyC2CSsJKHWRR+ESCZXBjuo
        8GgxphM8+OqpKG0Jm4pUP4oFApNl2HWIMaE41nrTWJZqK12axAADUQ9EJO4eLLj1HDkAD4
        F7EaiugT3ZjGpVQXQlTlTBuDoAei3Xc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-OTqJautyMRS54tOejpHoNQ-1; Wed, 20 Sep 2023 10:30:17 -0400
X-MC-Unique: OTqJautyMRS54tOejpHoNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 670F73C11A0F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAAB01004145;
        Wed, 20 Sep 2023 14:30:16 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 9/9] proto: add missing proto_definitions for PROTO_DESC_GENEVE
Date:   Wed, 20 Sep 2023 16:26:10 +0200
Message-ID: <20230920142958.566615-10-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While at it, make proto_definitions const. For global variables, this
allows the linker to mark the memory as read only. It's just good to do
by default.

Fixes: 156d22654003 ('src: add geneve matching support')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/proto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/proto.c b/src/proto.c
index b5cb0106dd7b..735e37f850c5 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -1281,7 +1281,7 @@ const struct proto_desc proto_netdev = {
 	},
 };
 
-static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
+static const struct proto_desc *const proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_AH]		= &proto_ah,
 	[PROTO_DESC_ESP]	= &proto_esp,
 	[PROTO_DESC_COMP]	= &proto_comp,
@@ -1300,6 +1300,7 @@ static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
 	[PROTO_DESC_VLAN]	= &proto_vlan,
 	[PROTO_DESC_ETHER]	= &proto_eth,
 	[PROTO_DESC_VXLAN]	= &proto_vxlan,
+	[PROTO_DESC_GENEVE]	= &proto_geneve,
 	[PROTO_DESC_GRE]	= &proto_gre,
 	[PROTO_DESC_GRETAP]	= &proto_gretap,
 };
-- 
2.41.0

