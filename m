Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616F7C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C58611F2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhIJQMZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232271AbhIJQKs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631290176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3JcZxurh8O2U9fI938LFsN6VYOmjxJCQvlLjsLsZzS8=;
        b=ZXZzoMFy4088/Ch6zUvNX9CwLdXCgEjW80rq3gOQoK0Riw+T8Nre29wNeV2pAI7m4Bb1F3
        mhCCQEa3EAj5Gitn9q6XF2KRgtgrxDHeft6EI2s2cPqge6BMXeYz2xOps+kuc8PosT3/HW
        OhU8tyOflpEFM5hlUWSjuohXUMqZOA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-mWL1tA4OMxCHfCG9WbM4sw-1; Fri, 10 Sep 2021 12:09:35 -0400
X-MC-Unique: mWL1tA4OMxCHfCG9WbM4sw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 307D91006AA1;
        Fri, 10 Sep 2021 16:09:34 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4578A5C1A1;
        Fri, 10 Sep 2021 16:09:31 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     horms@verge.net.au, ja@ssi.bg
Subject: [PATCH nf] ipvs: check that ip_vs_conn_tab_bits is between 8 and 20
Date:   Fri, 10 Sep 2021 18:08:39 +0200
Message-Id: <86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ip_vs_conn_tab_bits may be provided by the user through the
conn_tab_bits module parameter. If this value is greater than 31, or
less than 0, the shift operator used to derive tab_size causes undefined
behaviour.

Fix this checking ip_vs_conn_tab_bits value to be in the range specified
in ipvs Kconfig. If not, simply use default value.

Fixes: 6f7edb4881bf ("IPVS: Allow boot time change of hash size")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index c100c6b112c8..2c467c422dc6 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1468,6 +1468,10 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
+		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
+	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
-- 
2.31.1

