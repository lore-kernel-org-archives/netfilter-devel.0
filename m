From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 02/16] tests: files: Remove tests for ipv6
Date: Mon, 30 Oct 2017 02:19:17 +0530
Message-ID: <20171029204931.7792-2-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:55179 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdJ2Uts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:49:48 -0400
Received: by mail-pf0-f195.google.com with SMTP id n89so9213291pfk.11
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:49:48 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test cases for ipv6 family. As they are already
present in tests/shell file.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/family-ipv6 | 13 -------------
 1 file changed, 13 deletions(-)
 delete mode 100644 tests/files/family-ipv6

diff --git a/tests/files/family-ipv6 b/tests/files/family-ipv6
deleted file mode 100644
index cfc740c..0000000
--- a/tests/files/family-ipv6
+++ /dev/null
@@ -1,13 +0,0 @@
-#! nft -f
-
-add table ip6 filter
-add chain ip6 filter output { type filter hook output priority 0 ; }
-
-# IP address
-add rule ip6 filter output ip6 daddr 2001:6f8:974::1 counter
-
-# Next protocol
-add rule ip6 filter output ip6 nexthdr tcp
-
-# TCP ports
-add rule ip6 filter output tcp dport 22 counter
-- 
2.13.6

