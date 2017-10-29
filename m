From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 10/16] tests: files: Remove test for ct expression.
Date: Mon, 30 Oct 2017 02:19:25 +0530
Message-ID: <20171029204931.7792-10-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:47677 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:08 -0400
Received: by mail-pf0-f195.google.com with SMTP id z11so9228949pfk.4
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:07 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test cases for ct expression.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/expr-ct | 26 --------------------------
 1 file changed, 26 deletions(-)
 delete mode 100644 tests/files/expr-ct

diff --git a/tests/files/expr-ct b/tests/files/expr-ct
deleted file mode 100644
index 1dfc7ac..0000000
--- a/tests/files/expr-ct
+++ /dev/null
@@ -1,26 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0 ; }
-
-# ct: state
-add rule ip filter output ct state new,established counter
-
-# ct: direction original/reply
-add rule ip filter output ct direction original counter
-add rule ip filter output ct direction reply counter
-
-# ct: status
-add rule ip filter output ct status expected counter
-
-# ct: mark
-add rule ip filter output ct mark 0 counter
-
-# ct: secmark
-add rule ip filter output ct secmark 0 counter
-
-# ct: expiration
-add rule ip filter output ct expiration 30 counter
-
-# ct: helper ftp
-add rule ip filter output ct helper "ftp" counter
-- 
2.13.6

