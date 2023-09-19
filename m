Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99F6CD54B5
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 11:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjISL3R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 07:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjISL3Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 07:29:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A863100
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 04:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695122904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PY0gJhOybbeFQLrK8uXK3ET6Sd/0zg8wAsBD6G5q0y4=;
        b=WeGx65oy2d8h3YTolKTKCIhd3dMqtVY9WS6SYbzF/xHedN3jxL7T+b4heeCtvyXedeRnbP
        cZAPik/A9JZ5As4xIw0SgB4v7eSLuIxJxG2/lLAEoIvSPKR3DIcLCPRNdQ572U0tSbZlnu
        mxMWP9wFUsbOYoQ3GmoLitUqX2HtX3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-EoVzmLV2PnC5HzL6tj-3_A-1; Tue, 19 Sep 2023 07:28:23 -0400
X-MC-Unique: EoVzmLV2PnC5HzL6tj-3_A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E87A6185A79B
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 11:28:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66B4B2904;
        Tue, 19 Sep 2023 11:28:22 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] datatype: explicitly set missing datatypes for TYPE_CT_LABEL,TYPE_CT_EVENTBIT
Date:   Tue, 19 Sep 2023 13:28:03 +0200
Message-ID: <20230919112811.2752909-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's not obvious that two enum values are missing (or why). Explicitly
set the values to NULL, so we can see this more easily.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 70c84846f70e..bb0c3cf79150 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -65,6 +65,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_CT_DIR]		= &ct_dir_type,
 	[TYPE_CT_STATUS]	= &ct_status_type,
 	[TYPE_ICMP6_TYPE]	= &icmp6_type_type,
+	[TYPE_CT_LABEL]		= NULL,
 	[TYPE_PKTTYPE]		= &pkttype_type,
 	[TYPE_ICMP_CODE]	= &icmp_code_type,
 	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
@@ -72,8 +73,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_DEVGROUP]		= &devgroup_type,
 	[TYPE_DSCP]		= &dscp_type,
 	[TYPE_ECN]		= &ecn_type,
-	[TYPE_FIB_ADDR]         = &fib_addr_type,
+	[TYPE_FIB_ADDR]		= &fib_addr_type,
 	[TYPE_BOOLEAN]		= &boolean_type,
+	[TYPE_CT_EVENTBIT]	= NULL,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
 	[TYPE_TIME_DATE]	= &date_type,
-- 
2.41.0

