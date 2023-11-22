Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546B2C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343654AbjKVMyt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343882AbjKVMyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E33DD52
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8FkQzjUrpaPvxneV9OnzQLsIVo2tydXssCId4Ed5F/M=; b=SzlcHSpU7LRWVB3d4vcfMCYlpI
        a45qAL8ZmlARsx0XlyFhUEdXF5PICqBzoGJHRvVd3aDNL7Bp/IBFCndRaNTo0yMsJJtNTqZ44XY1H
        SSJntw2K6D8O3dhLbLBASvDZ2sTQHfkhHGj2KlwzDFVob08JtIB2fyGgrWsoeo8M4HMNyEqPoFS1J
        MVf2bbVQy4By91VZGmCh5L2uE09onpPrZQUkD7MNMTlVJj4/eTi928BvF/wMo170fLlIS2mL3vkAV
        Z11T+TzwZfR3ukLGqO4/lWHYdfmowjywkWDl2c2NmQEpWAIOGfSFWwEGeOPG8GqboOk4qJ7tQWWAd
        t1V+ZsEg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkS-0005Ro-RW
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/12] tests: xlate: Print failing command line
Date:   Wed, 22 Nov 2023 14:02:17 +0100
Message-ID: <20231122130222.29453-8-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the command segfaults, 'error' variable is empty and the resulting
error message is even misleading as the called program may not have been
iptables-translate.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 xlate-test.py | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/xlate-test.py b/xlate-test.py
index ddd68b91d3a7e..b6a78bb250e27 100755
--- a/xlate-test.py
+++ b/xlate-test.py
@@ -41,9 +41,10 @@ xtables_nft_multi = 'xtables-nft-multi'
 
 
 def test_one_xlate(name, sourceline, expected, result):
-    rc, output, error = run_proc([xtables_nft_multi] + shlex.split(sourceline))
+    cmd = [xtables_nft_multi] + shlex.split(sourceline)
+    rc, output, error = run_proc(cmd)
     if rc != 0:
-        result.append(name + ": " + red("Error: ") + "iptables-translate failure")
+        result.append(name + ": " + red("Error: ") + "Call failed: " + " ".join(cmd))
         result.append(error)
         return False
 
-- 
2.41.0

