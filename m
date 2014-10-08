From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] tests: regression: nft-test.py: Delete an unnecessary whitespace in an output messages.
Date: Wed,  8 Oct 2014 14:52:10 +0200
Message-ID: <1412772730-29161-2-git-send-email-anarey@gmail.com>
References: <1412772730-29161-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56427 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaJHMwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:52:14 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so10612844wid.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2014 05:52:13 -0700 (PDT)
In-Reply-To: <1412772730-29161-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the script is run with -e options,output messages show an unnecessary
white-space. This path fixes this mistake.

sudo ./nft-test.py -e
[...] "line 34: nft add rule -nnn arp test-arp  input arp plen != {33-55} " [...]
                                             ^^^^

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/regression/nft-test.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
index d4929f0..00c33f3 100755
--- a/tests/regression/nft-test.py
+++ b/tests/regression/nft-test.py
@@ -694,7 +694,7 @@ def run_test_file(filename, force_all_family_option, specific_file):
             if line[1:].find("*") != -1:
                 continue
             if need_fix_option:
-                rule[0] = rule[0].rstrip()[1:]
+                rule[0] = rule[0].rstrip()[1:].strip()
                 result = rule_add(rule, table_list, chain_list, filename,
                                   lineno, force_all_family_option)
                 tests += 1
-- 
1.7.10.4

