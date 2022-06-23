Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47583C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 09:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiFWJVj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 05:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiFWJVh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 05:21:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4296C4665D
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 02:21:34 -0700 (PDT)
Date:   Thu, 23 Jun 2022 11:21:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chander Govindarajan <mail@chandergovind.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nft: allow deletion of rule by full statement form
Message-ID: <YrQwmiXtaXBv2IqN@salvia>
References: <c8585f82-3cec-401a-534a-ee8d1252cdfd@chandergovind.org>
 <YqcjzMQ/LUf1cfSV@salvia>
 <d1711872-0d71-0e7a-fe2e-931b65c898d7@chandergovind.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vOzpEiQ/o6DxMk07"
Content-Disposition: inline
In-Reply-To: <d1711872-0d71-0e7a-fe2e-931b65c898d7@chandergovind.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--vOzpEiQ/o6DxMk07
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Thu, Jun 23, 2022 at 02:31:44PM +0530, Chander Govindarajan wrote:
> Hi Pablo,
> 
> Would it be possible to share your changes to tests/py? Would
> like to see how bad it is.
> 
> I would like to still go with the plain (non-json) approach if
> possible at all.

I'm attaching the patch... it's from 2017. It does not apply,
rule_add() in tests/py/nft-tests.py has changed quite a bit, since
there are tests for the netlink payload, json and so on.

I was basically checking if removing the rule that was possible to
make sure there is symmetry between add and delete.

I'm afraid you'll have to dig into tests/py file to update this.

--vOzpEiQ/o6DxMk07
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-tests-py-test-deletion-from-rule-definition.patch"

From 32e7cfa5dd683db33e757b46b4944c18a0f2826c Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 8 Jan 2017 19:55:20 +0100
Subject: [PATCH] tests: py: test deletion from rule definition

This patch checks that rule deletion works fine.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/nft-test.py | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 7bb5437805d5..1c1b430cc1fa 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -661,6 +661,7 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
         return [-1, warning, error, unit_tests]
 
     payload_expected = []
+    delete_error = False
 
     for table in table_list:
         try:
@@ -770,6 +771,19 @@ def rule_add(rule, filename, lineno, force_all_family_option, filename_path):
                             if not force_all_family_option:
                                 return [ret, warning, error, unit_tests]
 
+                if delete_error == True:
+                    continue
+
+                cmd = NFT_BIN + " delete rule " + table_info + \
+                      chain.name + " " + rule[0]
+                ret = execute_cmd(cmd, filename, lineno)
+                if ret != 0:
+                    reason = "Cannot delete rule: " + cmd
+                    print_error(reason, filename, lineno)
+                    ret = -1
+                    error += 1
+                    delete_error = True
+
     return [ret, warning, error, unit_tests]
 
 
-- 
2.30.2


--vOzpEiQ/o6DxMk07--
