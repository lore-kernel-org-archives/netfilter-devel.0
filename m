Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE31C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DB2E20859
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 11:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfE0Lgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 07:36:51 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:34802 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfE0Lgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 07:36:51 -0400
Received: from localhost ([::1]:47888 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVDvs-0005oH-L2; Mon, 27 May 2019 13:36:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: [nft PATCH v4 2/2] tests/py: Support JSON validation
Date:   Mon, 27 May 2019 13:36:42 +0200
Message-Id: <20190527113642.8434-3-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527113642.8434-1-phil@nwl.cc>
References: <20190527113642.8434-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a new flag -s/--schema to nft-test.py which enables validation
of any JSON input and output against our schema.

Make use of traceback module to get more details if validation fails.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Complain if --schema was given but not --json.

Changes since v1:
- Adjust commit message to changes from RFC.

Changes since RFC:
- Import builtin traceback module unconditionally
---
 tests/py/nft-test.py | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 1c0afd0ec0eb3..09d00dba1510a 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -18,6 +18,7 @@ import os
 import argparse
 import signal
 import json
+import traceback
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
@@ -687,6 +688,13 @@ def json_dump_normalize(json_string, human_readable = False):
     else:
         return json.dumps(json_obj, sort_keys = True)
 
+def json_validate(json_string):
+    json_obj = json.loads(json_string)
+    try:
+        nftables.json_validate(json_obj)
+    except Exception:
+        print_error("schema validation failed for input '%s'" % json_string)
+        print_error(traceback.format_exc())
 
 def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
     '''
@@ -912,6 +920,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                     "expr": json.loads(json_input),
             }}}]})
 
+            if enable_json_schema:
+                json_validate(cmd)
+
             json_old = nftables.set_json_output(True)
             ret = execute_cmd(cmd, filename, lineno, payload_log, debug="netlink")
             nftables.set_json_output(json_old)
@@ -945,6 +956,9 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             nftables.set_numeric_proto_output(numeric_proto_old)
             nftables.set_stateless_output(stateless_old)
 
+            if enable_json_schema:
+                json_validate(json_output)
+
             json_output = json.loads(json_output)
             for item in json_output["nftables"]:
                 if "rule" in item:
@@ -1341,12 +1355,17 @@ def main():
                         dest='enable_json',
                         help='test JSON functionality as well')
 
+    parser.add_argument('-s', '--schema', action='store_true',
+                        dest='enable_schema',
+                        help='verify json input/output against schema')
+
     args = parser.parse_args()
-    global debug_option, need_fix_option, enable_json_option
+    global debug_option, need_fix_option, enable_json_option, enable_json_schema
     debug_option = args.debug
     need_fix_option = args.need_fix_line
     force_all_family_option = args.force_all_family
     enable_json_option = args.enable_json
+    enable_json_schema = args.enable_schema
     specific_file = False
 
     signal.signal(signal.SIGINT, signal_handler)
@@ -1364,6 +1383,10 @@ def main():
               "You need to build the project."
         return
 
+    if args.enable_schema and not args.enable_json:
+        print_error("Option --schema requires option --json")
+        return
+
     global nftables
     nftables = Nftables(sofile = 'src/.libs/libnftables.so')
 
-- 
2.21.0

