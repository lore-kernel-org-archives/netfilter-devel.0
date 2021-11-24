Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03183C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbhKXR1p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR1o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02396C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:35 -0800 (PST)
Received: from localhost ([::1]:44910 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0X-0001B5-9g; Wed, 24 Nov 2021 18:24:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 01/15] tests/py: Avoid duplicate records in *.got files
Date:   Wed, 24 Nov 2021 18:22:37 +0100
Message-Id: <20211124172251.11539-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If payloads don't contain family-specific bits, they may sit in a single
*.payload file for all tested families. In such case, nft-test.py will
consequently write dissenting payloads into a single *.got file. To
avoid the duplicate entries, check if a matching record exists already
before writing it out.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index f8f9341c11515..04dac8d77b25f 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -809,17 +809,26 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             if state == "ok" and not payload_check(table_payload_expected,
                                                    payload_log, cmd):
                 error += 1
-                gotf = open("%s.got" % payload_path, 'a')
+
+                try:
+                    gotf = open("%s.got" % payload_path)
+                    gotf_payload_expected = payload_find_expected(gotf, rule[0])
+                    gotf.close()
+                except:
+                    gotf_payload_expected = None
                 payload_log.seek(0, 0)
-                gotf.write("# %s\n" % rule[0])
-                while True:
-                    line = payload_log.readline()
-                    if line == "":
-                        break
-                    gotf.write(line)
-                gotf.close()
-                print_warning("Wrote payload for rule %s" % rule[0],
-                              gotf.name, 1)
+                if not payload_check(gotf_payload_expected, payload_log, cmd):
+                    gotf = open("%s.got" % payload_path, 'a')
+                    payload_log.seek(0, 0)
+                    gotf.write("# %s\n" % rule[0])
+                    while True:
+                        line = payload_log.readline()
+                        if line == "":
+                            break
+                        gotf.write(line)
+                    gotf.close()
+                    print_warning("Wrote payload for rule %s" % rule[0],
+                                  gotf.name, 1)
 
             # Check for matching ruleset listing
             numeric_proto_old = nftables.set_numeric_proto_output(True)
-- 
2.33.0

