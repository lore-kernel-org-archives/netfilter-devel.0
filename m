From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 11/16] tests: files: Remove prefix file.
Date: Mon, 30 Oct 2017 02:19:26 +0530
Message-ID: <20171029204931.7792-11-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44678 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:10 -0400
Received: by mail-pg0-f65.google.com with SMTP id j3so9699787pga.1
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:10 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test rules in prefix file are not required, so remove it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/prefix | 5 -----
 1 file changed, 5 deletions(-)
 delete mode 100644 tests/files/prefix

diff --git a/tests/files/prefix b/tests/files/prefix
deleted file mode 100644
index bada850..0000000
--- a/tests/files/prefix
+++ /dev/null
@@ -1,5 +0,0 @@
-add rule filter OUTPUT meta mark 123/0x000000ff
-add rule filter OUTPUT ip daddr 192.168.0.0/24
-add rule filter OUTPUT ip daddr 192.168.0.0/255.255.255.0
-add rule filter OUTPUT ip saddr . ip daddr 192.168.0.0/24 . 192.168.0.0/24
-add rule filter OUTPUT ip daddr { 192.168.0.0/24, 192.168.1.0/24}
-- 
2.13.6

