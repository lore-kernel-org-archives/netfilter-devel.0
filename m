From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 change "Native Address Translation" to "Network Address Translation"
Date: Thu, 12 Oct 2017 18:24:11 +1100
Message-ID: <20171012072411.5339-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49757 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbdJLHYY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 03:24:24 -0400
Received: from dimstar.local.net (c220-239-36-238.eburwd6.vic.optusnet.com.au [220.239.36.238])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id A3A78428E2B
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2017 18:24:12 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A Google search for "Native Address Translation" found 1 entry
(http://encyclopedia2.thefreedictionary.com/Native+address+translation) which
redirects to .../Network+address+translation. All other matches are to entries
about "Network Address Translation".

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index c7e12c9..86b4bd9 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -782,7 +782,7 @@ filter input iif $int_ifs accept
 							<entry>nat</entry>
 							<entry>ip, ip6</entry>
 							<entry>prerouting, input, output, postrouting</entry>
-							<entry>Chains of this type perform Native Address Translation based on conntrack entries. Only the first packet of a connection actually traverses this chain - its rules usually define details of the created conntrack entry (NAT statements for instance).</entry>
+							<entry>Chains of this type perform Network Address Translation based on conntrack entries. Only the first packet of a connection actually traverses this chain - its rules usually define details of the created conntrack entry (NAT statements for instance).</entry>
 						</row>
 						<row>
 							<entry>route</entry>
-- 
2.9.0

