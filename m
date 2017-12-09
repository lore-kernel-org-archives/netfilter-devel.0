From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] tests/py: trivial: Fix error message
Date: Sat,  9 Dec 2017 16:53:10 +0100
Message-ID: <20171209155310.21920-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49414 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdLIPxV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 10:53:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The error message for failed chain creation quotes the chain's name but
lacked the closing tick.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 9ad97714a3b56..6aedfb09e9729 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -248,7 +248,7 @@ def chain_create(chain, table, filename):
 
     ret = execute_cmd(cmd, filename, chain.lineno)
     if ret != 0:
-        reason = "I cannot create the chain '" + chain.name
+        reason = "I cannot create the chain '" + chain.name + "'"
         print_error(reason, filename, chain.lineno)
         return -1
 
-- 
2.13.1

