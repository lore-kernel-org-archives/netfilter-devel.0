From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 Syslog level is introduced by "level" not "syslog-level"
Date: Mon, 27 Nov 2017 10:30:29 +1100
Message-ID: <20171126233029.4059-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47447 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752069AbdKZXan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Nov 2017 18:30:43 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id A112F1071F2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2017 10:30:30 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The log synopsis line correctly documents that keyword "level" introduces
"syslog-level", but the keyword table entry did not.

Discovered on trying to use "syslog-level" in a script.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 432f1c4..a1bfecd 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -4350,7 +4350,7 @@ tcp flags syn tcp option maxseg size set rt mtu
 								<entry>quoted string</entry>
 							</row>
 							<row>
-								<entry>syslog-level</entry>
+								<entry>level</entry>
 								<entry>Syslog level of logging</entry>
 								<entry>string: emerg, alert, crit, err, warn [default], notice, info, debug</entry>
 							</row>
-- 
2.9.0

