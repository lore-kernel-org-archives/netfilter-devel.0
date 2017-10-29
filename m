From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 01/16] tests: files: Remove tests for ipv4
Date: Mon, 30 Oct 2017 02:19:16 +0530
Message-ID: <20171029204931.7792-1-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44635 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdJ2Utq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:46 -0400
Received: by mail-pg0-f66.google.com with SMTP id j3so9699363pga.1
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:46 -0700 (PDT)
In-Reply-To: <cover.1509305217.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test cases for ipv4 family. As they are already
present in tests/shell file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/family-ipv4 | 14 --------------
 1 file changed, 14 deletions(-)
 delete mode 100644 tests/files/family-ipv4

diff --git a/tests/files/family-ipv4 b/tests/files/family-ipv4
deleted file mode 100644
index 0700e16..0000000
--- a/tests/files/family-ipv4
+++ /dev/null
@@ -1,14 +0,0 @@
-#! nft -f
-
-flush chain ip filter output
-delete chain ip filter output
-delete table filter
-
-add table ip filter
-add chain ip filter output { type filter hook input priority 0; }
-
-# IP address
-add rule ip filter output ip daddr 192.168.0.1 counter
-
-# TCP ports
-add rule ip filter output tcp dport 22 counter
-- 
2.13.6

