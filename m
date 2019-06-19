Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FCDC31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 13:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA95721670
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 13:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbfFSNiv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 09:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFSNiv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 09:38:51 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 55ED03082B68;
        Wed, 19 Jun 2019 13:38:47 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C492719C6A;
        Wed, 19 Jun 2019 13:38:45 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        shekhar sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: use tempfile module
Date:   Wed, 19 Jun 2019 09:38:42 -0400
Message-Id: <20190619133842.8602-1-eric@garver.life>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 19 Jun 2019 13:38:51 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

os.tmpfile() is not in python3.

Signed-off-by: Eric Garver <eric@garver.life>
---
 tests/py/nft-test.py | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index f80517e67bfd..4da6fa650f6d 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -20,6 +20,7 @@ import argparse
 import signal
 import json
 import traceback
+import tempfile
 
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
@@ -771,7 +772,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
             unit_tests += 1
             table_flush(table, filename, lineno)
 
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule and check return code
             cmd = "add rule %s %s %s" % (table, chain, rule[0])
@@ -911,7 +912,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                               gotf.name, 1)
 
             table_flush(table, filename, lineno)
-            payload_log = os.tmpfile()
+            payload_log = tempfile.TemporaryFile(mode="w+")
 
             # Add rule in JSON format
             cmd = json.dumps({ "nftables": [{ "add": { "rule": {
-- 
2.20.1

