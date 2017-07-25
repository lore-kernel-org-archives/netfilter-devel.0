From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/3] tests/monitor: Simplify testcases
Date: Tue, 25 Jul 2017 20:39:43 +0200
Message-ID: <20170725183944.9377-3-phil@nwl.cc>
References: <20170725183944.9377-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50165 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdGYSkD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 14:40:03 -0400
In-Reply-To: <20170725183944.9377-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By introducing 'O -' indicating that output should be identical as
input, testcases can be simplified quite a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/run-tests.sh             |  4 ++++
 tests/monitor/testcases/set-maps.t     |  7 +++----
 tests/monitor/testcases/set-mixed.t    | 10 +++-------
 tests/monitor/testcases/set-multiple.t |  7 ++-----
 tests/monitor/testcases/set-simple.t   | 21 ++++++++-------------
 5 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index e21ed6880bc13..de19462438d64 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -20,6 +20,10 @@ cmd_append() {
 	echo "$*" >>$command_file
 }
 output_append() {
+	[[ "$*" == '-' ]] && {
+		cat $command_file >>$output_file
+		return
+	}
 	echo "$*" >>$output_file
 }
 run_test() {
diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
index 6ea36cb9d11d6..3d86720ec8136 100644
--- a/tests/monitor/testcases/set-maps.t
+++ b/tests/monitor/testcases/set-maps.t
@@ -1,11 +1,10 @@
 # first the setup
 I add table ip t
-O add table ip t
 I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
-O add map ip t portip { type inet_service : ipv4_addr;flags interval; }
+O -
 
 I add element ip t portip { 80-100: 10.0.0.1 }
-O add element ip t portip { 80-100 : 10.0.0.1 }
+O -
 
 I add element ip t portip { 1024-65535: 10.0.0.1 }
-O add element ip t portip { 1024-65535 : 10.0.0.1 }
+O -
diff --git a/tests/monitor/testcases/set-mixed.t b/tests/monitor/testcases/set-mixed.t
index 2eb35b5aa1efb..9c1c5323f2e4e 100644
--- a/tests/monitor/testcases/set-mixed.t
+++ b/tests/monitor/testcases/set-mixed.t
@@ -1,19 +1,15 @@
 # first the setup
 I add table ip t
-O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval; }
 I add set ip t ports { type inet_service; }
-O add set ip t ports { type inet_service;}
+O -
 
 # make sure concurrent adds work
 I add element ip t portrange { 1024-65535 }
 I add element ip t ports { 10 }
-O add element ip t portrange { 1024-65535 }
-O add element ip t ports { 10 }
+O -
 
 # delete items again
 I delete element ip t portrange { 1024-65535 }
 I delete element ip t ports { 10 }
-O delete element ip t portrange { 1024-65535 }
-O delete element ip t ports { 10 }
+O -
diff --git a/tests/monitor/testcases/set-multiple.t b/tests/monitor/testcases/set-multiple.t
index ce919125a593f..ad91fac047fe8 100644
--- a/tests/monitor/testcases/set-multiple.t
+++ b/tests/monitor/testcases/set-multiple.t
@@ -1,13 +1,10 @@
 # first the setup
 I add table ip t
-O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval; }
 I add set ip t portrange2 { type inet_service; flags interval; }
-O add set ip t portrange2 { type inet_service;flags interval; }
+O -
 
 # make sure concurrent adds work
 I add element ip t portrange { 1024-65535 }
 I add element ip t portrange2 { 10-20 }
-O add element ip t portrange { 1024-65535 }
-O add element ip t portrange2 { 10-20 }
+O -
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
index e44cce08f575c..ebff7cbda0c8b 100644
--- a/tests/monitor/testcases/set-simple.t
+++ b/tests/monitor/testcases/set-simple.t
@@ -1,14 +1,13 @@
 # first the setup
 I add table ip t
-O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval; }
+O -
 
 # adding some ranges
 I add element ip t portrange { 1-10 }
-O add element ip t portrange { 1-10 }
+O -
 I add element ip t portrange { 1024-65535 }
-O add element ip t portrange { 1024-65535 }
+O -
 I add element ip t portrange { 20-30, 40-50 }
 O add element ip t portrange { 20-30 }
 O add element ip t portrange { 40-50 }
@@ -22,26 +21,22 @@ O delete element ip t portrange { 1-10 }
 
 # make sure lower scope boundary works
 I add element ip t portrange { 0-10 }
-O add element ip t portrange { 0-10 }
+O -
 
 # make sure half open before other element works
 I add element ip t portrange { 1024-65535 }
 I add element ip t portrange { 100-200 }
-O add element ip t portrange { 1024-65535 }
-O add element ip t portrange { 100-200 }
+O -
 
 # make sure deletion of elements works
 I delete element ip t portrange { 0-10 }
-O delete element ip t portrange { 0-10 }
+O -
 I delete element ip t portrange { 100-200 }
 I delete element ip t portrange { 1024-65535 }
-O delete element ip t portrange { 100-200 }
-O delete element ip t portrange { 1024-65535 }
+O -
 
 # make sure mixed add/delete works
 I add element ip t portrange { 10-20 }
 I add element ip t portrange { 1024-65535 }
 I delete element ip t portrange { 10-20 }
-O add element ip t portrange { 10-20 }
-O add element ip t portrange { 1024-65535 }
-O delete element ip t portrange { 10-20 }
+O -
-- 
2.13.1

