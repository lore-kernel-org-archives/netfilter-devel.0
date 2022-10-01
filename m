Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6970C43217
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 09:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJAJnt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJAJnm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 05:43:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFEE48C8F
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 02:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8JcpG/X1UJR2MwjG7u2jm2Qnxya+aApRNEYAaYgdJjU=; b=lt+kiyizsLjLGQbm6Bsz28KXVj
        7FOBflVb1z6wi1td4B7WThJp/1Jyg7B/MnGP2hpxH7adSsy2n5eRfzWG2/yd7qIyHeEYVQg53Y0il
        HGokTJR/l9VZMRBw8RbQgrebZ7nvyxacy/GDwfcF5RZd4UG2NXTOp6MA5fneJKP/SZasJFs3g6ftc
        D8fkk/J7VwW1+nUFM+CDkNvnxQf4j6ge8h8LVQE6/BbBbEdyiCYgL8abFNGp9JoSS+cXkhRyP4Mol
        /ZFAHcPepeyEg1duMZzWFpWBKSF7sids53QzqyY+woMSyGDbin7900MS+U4ZY4nMqYbA94wXdMlc2
        yAmQEqRw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeZ24-0006Re-Eh
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 11:43:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] tests: iptables-test: Simplify execute_cmd() calling
Date:   Sat,  1 Oct 2022 11:43:08 +0200
Message-Id: <20221001094310.29452-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001094310.29452-1-phil@nwl.cc>
References: <20221001094310.29452-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Default 'lineno' parameter to zero,

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 69c96b79927b5..25561bc9ba971 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -168,7 +168,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
 
     return delete_rule(iptables, rule, filename, lineno)
 
-def execute_cmd(cmd, filename, lineno):
+def execute_cmd(cmd, filename, lineno = 0):
     '''
     Executes a command, checking for segfaults and returning the command exit
     code.
@@ -264,7 +264,7 @@ def run_test_file(filename, netns):
     total_test_passed = True
 
     if netns:
-        execute_cmd("ip netns add " + netns, filename, 0)
+        execute_cmd("ip netns add " + netns, filename)
 
     for lineno, line in enumerate(f):
         if line[0] == "#" or len(line.strip()) == 0:
@@ -336,7 +336,7 @@ def run_test_file(filename, netns):
             passed += 1
 
     if netns:
-        execute_cmd("ip netns del " + netns, filename, 0)
+        execute_cmd("ip netns del " + netns, filename)
     if total_test_passed:
         print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
 
-- 
2.34.1

