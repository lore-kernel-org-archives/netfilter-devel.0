Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7072BC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiBLQ7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Feb 2022 11:59:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EABB240A0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Feb 2022 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=13pX//UZEYhK0YkSWP9HaA4DiHcFUGg/o/QQFvLxOEs=; b=c6g7thVLP2Pa18S/LX4a+mQWF+
        MgytH1HOPVTR5o+2G00BSMyJWruVyjnfqRFAalFmA4abD21OKdocOgd+8hWlf2jyuIbzECKSiuvHL
        tmr4iCGCLehQHGI+0U1tvKgZVI8miCKyxgMh7mlzUaTtwRkGeW5cLthSFlG7FiH2/UOQReVg6UN9w
        p/rb4Du7N9gaOCMCyFSpyubFFmqfXcIyCjg+FEk0Vh2FzTgSmj7VuVEgTSgOjJeFw9/Rz6Y7czD/R
        Po8pa8Nr+L1KlhUs84jUQNQXZRYXRgC90GtIKHBGvtOKl+G2A83J0MdH0H8LR5NS26It5yC4QTJST
        LvdFJJ+A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nIvjZ-001xVU-8H
        for netfilter-devel@vger.kernel.org; Sat, 12 Feb 2022 16:58:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [iptables PATCH 1/4] tests: iptables-test: rename variable
Date:   Sat, 12 Feb 2022 16:58:29 +0000
Message-Id: <20220212165832.2452695-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220212165832.2452695-1-jeremy@azazel.net>
References: <20220212165832.2452695-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"Splitted" hasn't been current since the seventeenth century.  Replace it with
"tokens".

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables-test.py | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index b49afcab3c40..91c77e3dc0e0 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -107,20 +107,20 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
             return -1
 
     matching = 0
-    splitted = iptables.split(" ")
-    if len(splitted) == 2:
-        if splitted[1] == '-4':
+    tokens = iptables.split(" ")
+    if len(tokens) == 2:
+        if tokens[1] == '-4':
             command = IPTABLES_SAVE
-        elif splitted[1] == '-6':
+        elif tokens[1] == '-6':
             command = IP6TABLES_SAVE
-    elif len(splitted) == 1:
-        if splitted[0] == IPTABLES:
+    elif len(tokens) == 1:
+        if tokens[0] == IPTABLES:
             command = IPTABLES_SAVE
-        elif splitted[0] == IP6TABLES:
+        elif tokens[0] == IP6TABLES:
             command = IP6TABLES_SAVE
-        elif splitted[0] == ARPTABLES:
+        elif tokens[0] == ARPTABLES:
             command = ARPTABLES_SAVE
-        elif splitted[0] == EBTABLES:
+        elif tokens[0] == EBTABLES:
             command = EBTABLES_SAVE
 
     command = EXECUTABLE + " " + command
@@ -128,7 +128,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     if netns:
             command = "ip netns exec ____iptables-container-test " + command
 
-    args = splitted[1:]
+    args = tokens[1:]
     proc = subprocess.Popen(command, shell=True,
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)
-- 
2.34.1

