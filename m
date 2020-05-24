Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EFAC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51BFC20776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR307Jbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgEXNAV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgEXNAU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HRGX3HCN6bxCPSIaDE/qylqAsNr56GDc3FbjWrQo9mg=;
        b=KR307JbcfekUGgHJt8a5Zvn8K5Lr8343Smzhz2WRa2rMvHIDZCveWORXk5hhwvJSN5+OCo
        rBVItg846OvfXls/l7VBBUPugsgeScGsF3C2thnU7ozLd0PMm2iqjS5oYDK9zbyf227dgr
        E8r+fB1e9kjWDOj2WfUL0osrOSP/dYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-ZrB9ZQCvPWK4UMKZAHxFzw-1; Sun, 24 May 2020 09:00:16 -0400
X-MC-Unique: ZrB9ZQCvPWK4UMKZAHxFzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28FB51800D42;
        Sun, 24 May 2020 13:00:15 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1722A10013D9;
        Sun, 24 May 2020 13:00:13 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ana Rey <anarey@gmail.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: Actually use all available hooks in bridge/chains.t
Date:   Sun, 24 May 2020 15:00:07 +0200
Message-Id: <2b98ba50fa537d10dfb535aff4ad34b00ec53cdd.1590323965.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Despite being explicitly mentioned as available, prerouting and
postrouting hooks are not used, filter-pre and filter-post chains
are both built to hook on input.

Fixes: 25851df85e85 ("tests: regression: revisit chain tests")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 tests/py/bridge/chains.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/bridge/chains.t b/tests/py/bridge/chains.t
index 85dde73e8520..e071d9a3c971 100644
--- a/tests/py/bridge/chains.t
+++ b/tests/py/bridge/chains.t
@@ -1,8 +1,8 @@
 # filter chains available are: prerouting, input, output, forward, postrouting
-:filter-pre;type filter hook input priority 0
+:filter-pre;type filter hook prerouting priority 0
 :filter-output;type filter hook output priority 0
 :filter-forward;type filter hook forward priority 0
 :filter-input;type filter hook input priority 0
-:filter-post;type filter hook input priority 0
+:filter-post;type filter hook postrouting priority 0
 
 *bridge;test-bridge;filter-pre,filter-output,filter-forward,filter-input,filter-post
-- 
2.26.2

