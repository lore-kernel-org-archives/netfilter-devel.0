Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE13FC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A80552084A
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfFRSVd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbfFRSVd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:21:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F050804F2;
        Tue, 18 Jun 2019 18:21:33 +0000 (UTC)
Received: from egarver.remote.csb (ovpn-121-240.rdu2.redhat.com [10.10.121.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4EFE600D1;
        Tue, 18 Jun 2019 18:21:31 +0000 (UTC)
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        shekhar sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] nft-test.py: use tempfile module
Date:   Tue, 18 Jun 2019 14:21:27 -0400
Message-Id: <20190618182127.21110-1-eric@garver.life>
In-Reply-To: <CAN9XX2pWQY0Rz2cGv7V=v8+g0mUTNGWS4pf0FJwScmrNpC5Kjg@mail.gmail.com>
References: <CAN9XX2pWQY0Rz2cGv7V=v8+g0mUTNGWS4pf0FJwScmrNpC5Kjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 18 Jun 2019 18:21:33 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

os.tmpfile() is not in python3.
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

