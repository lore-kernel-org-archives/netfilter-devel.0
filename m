From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] tests: shell: Prevent lockout in nft-f/0008split_tables_0
Date: Tue, 21 Nov 2017 23:13:39 +0100
Message-ID: <20171121221339.32090-1-phil@nwl.cc>
References: <20171121170946.GB24866@breakpoint.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46356 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbdKUWNv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2017 17:13:51 -0500
In-Reply-To: <20171121170946.GB24866@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since packets traverse both tables, the accept rule in the first one is
ineffective due to the second table's drop policy. To prevent lockouts
when running the testsuite via SSH connection, set the second chain's
policy to accept as well.

Fixes: 337c7e0de3d9d ("tests: shell: make sure split table definition works via nft -f")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/nft-f/0008split_tables_0 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/nft-f/0008split_tables_0 b/tests/shell/testcases/nft-f/0008split_tables_0
index 2bc6e46c852a6..dd03545b172ac 100755
--- a/tests/shell/testcases/nft-f/0008split_tables_0
+++ b/tests/shell/testcases/nft-f/0008split_tables_0
@@ -19,7 +19,7 @@ RULESET="table inet filter {
 
 table inet filter {
 	chain input {
-		type filter hook input priority 1; policy drop;
+		type filter hook input priority 1; policy accept;
 	}
 }"
 
@@ -37,7 +37,7 @@ EXPECTED="table inet filter {
 	}
 
 	chain input {
-		type filter hook input priority 1; policy drop;
+		type filter hook input priority 1; policy accept;
 	}
 }"
 
-- 
2.13.1

