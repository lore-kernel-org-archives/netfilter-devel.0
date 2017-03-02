From: Timothy Redaelli <tredaelli@redhat.com>
Subject: [PATCH nftables] tests: py: fix some typos in README
Date: Thu,  2 Mar 2017 16:15:18 +0100
Message-ID: <afedcefbb31e4c5774668921688e844f48aec1b3.1488466956.git.tredaelli@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbdCBRJg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 12:09:36 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D60872E6066
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2017 15:15:29 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Timothy Redaelli <tredaelli@redhat.com>
---
 tests/py/README | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/README b/tests/py/README
index 82d73a2..66f706f 100644
--- a/tests/py/README
+++ b/tests/py/README
@@ -40,21 +40,21 @@ families. Unless you specify the --force-family option.
 
 * Execute broken tests:
 
-./nft-test.sh -e
+./nft-test.py -e
 
 This runs tests for rules that need a fix: This mode runs the lines that
 that start with a "-" symbol.
 
 * Debugging:
 
-./nft-test.sh -d
+./nft-test.py -d
 
 This shows all the commands that the script executes, so you can watch
 its internal behaviour.
 
 * Keep testing all families on error.
 
-./nft-test.sh -f
+./nft-test.py -f
 
 Don't stop testing for more families in case of error.
 
-- 
2.9.3

