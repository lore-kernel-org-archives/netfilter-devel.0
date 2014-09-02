From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] src: meta: Fix the size of cpu attribute.
Date: Tue,  2 Sep 2014 20:13:25 +0200
Message-ID: <1409681605-8277-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:41770 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaIBSK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:10:59 -0400
Received: by mail-la0-f45.google.com with SMTP id pn19so8331287lab.32
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2014 11:10:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the size of cpu attribute in meta_template struct.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 src/meta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index 1f7217f..bf41ac4 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -394,7 +394,7 @@ static const struct meta_template meta_templates[] = {
 						BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_CPU]		= META_TEMPLATE("cpu",  &integer_type,
-						BITS_PER_BYTE,
+						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
 };
 
-- 
1.7.10.4

