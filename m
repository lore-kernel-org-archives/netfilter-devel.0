Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E05EB64DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 10:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjGRKe2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 06:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjGRKe0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 06:34:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911681B6
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 03:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689676415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K21nMk6gvcMVYaHeaIUoOxXsNqYJraN6cOKR9CClPA0=;
        b=i+AL3pa9E9x0D/fXTUy78Q0INijvBEmQHRefvUwh1OvZ7Tq0CcdMuMKrOUu4uIRca1HpzZ
        6jg2zgO5rbVcKj6KMWyrtlA+Id1ELazPi+t4NQk3sYTAsejfv5nERg4YF0gOI/Wvm7ZhE9
        spJawk+5TPcHhzQkIp2zYUBXzabIFQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Jre-mH9FPbyVKTqYEZiPNw-1; Tue, 18 Jul 2023 06:33:34 -0400
X-MC-Unique: Jre-mH9FPbyVKTqYEZiPNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E914809F8F
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 10:33:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.198])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A64DD1454142;
        Tue, 18 Jul 2023 10:33:33 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH] py: return boolean value from Nftables.__[gs]et_output_flag()
Date:   Tue, 18 Jul 2023 12:33:09 +0200
Message-ID: <20230718103325.277535-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The callers of __get_output_flag() and __set_output_flag(), for example
get_reversedns_output(), are all documented to return a "boolean" value.

Instead, they returned the underlying, non-zero flags value. That number
is not obviously useful to the caller, because there is no API so that
the caller could do anything with it (except evaluating it in a boolean
context). Adjust that, to match the documentation.

The alternative would be to update the documentation, to indicate that
the functions return a non-zero integer when the flag is set. That would
preserve the previous behavior and maybe the number could be useful
somehow(?).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 py/nftables.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/py/nftables.py b/py/nftables.py
index 6daeafc231f4..68fcd7dd103c 100644
--- a/py/nftables.py
+++ b/py/nftables.py
@@ -154,7 +154,7 @@ class Nftables:
 
     def __get_output_flag(self, name):
         flag = self.output_flags[name]
-        return self.nft_ctx_output_get_flags(self.__ctx) & flag
+        return (self.nft_ctx_output_get_flags(self.__ctx) & flag) != 0
 
     def __set_output_flag(self, name, val):
         flag = self.output_flags[name]
@@ -164,7 +164,7 @@ class Nftables:
         else:
             new_flags = flags & ~flag
         self.nft_ctx_output_set_flags(self.__ctx, new_flags)
-        return flags & flag
+        return (flags & flag) != 0
 
     def get_reversedns_output(self):
         """Get the current state of reverse DNS output.
-- 
2.41.0

