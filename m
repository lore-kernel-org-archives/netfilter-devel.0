From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] doc: fix compression parameter index
Date: Tue, 31 May 2016 21:16:32 +0200
Message-ID: <20160531191629.GA22706@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34330 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcEaTQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 15:16:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id n129so145541wmn.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 12:16:36 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id jq1sm41262069wjc.28.2016.05.31.12.16.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 31 May 2016 12:16:34 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the compression parameter index 'cpi' instead of 'cfi'.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 22d023e..0ebf51a 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1920,7 +1920,7 @@ filter output oif eth0
 								<entry>FIXME</entry>
 							</row>
 							<row>
-								<entry>cfi</entry>
+								<entry>cpi</entry>
 								<entry>Compression Parameter Index</entry>
 								<entry>FIXME</entry>
 							</row>
-- 
2.7.0

