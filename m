Return-Path: <SRS0=8vd7=4K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AE9C35669
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 02:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E815206E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 02:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgBVCNa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 21:13:30 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:58240 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgBVCNa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 21:13:30 -0500
Received: from localhost ([::1]:43098 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j5KIK-0002C2-PY; Sat, 22 Feb 2020 03:13:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] iptables-test.py: Fix --host mode
Date:   Sat, 22 Feb 2020 03:13:20 +0100
Message-Id: <20200222021320.19751-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In some cases, the script still called repo binaries. Avoid this when in
--host mode to allow testing without the need to compile sources in
beforehand.

Fixes: 1b5d762c1865e ("iptables-test: Support testing host binaries")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index fdb4e6a3644e4..e986d7a318218 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -119,8 +119,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
         elif splitted[0] == EBTABLES:
             command = EBTABLES_SAVE
 
-    path = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE
-    command = path + " " + command
+    command = EXECUTEABLE + " " + command
 
     if netns:
             command = "ip netns exec ____iptables-container-test " + command
@@ -165,7 +164,7 @@ def execute_cmd(cmd, filename, lineno):
     '''
     global log_file
     if cmd.startswith('iptables ') or cmd.startswith('ip6tables ') or cmd.startswith('ebtables ') or cmd.startswith('arptables '):
-        cmd = os.path.abspath(os.path.curdir) + "/iptables/" + EXECUTEABLE + " " + cmd
+        cmd = EXECUTEABLE + " " + cmd
 
     print("command: {}".format(cmd), file=log_file)
     ret = subprocess.call(cmd, shell=True, universal_newlines=True,
-- 
2.25.1

