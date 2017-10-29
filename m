From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 13/16] tests: files: Remove test for meta expression.
Date: Mon, 30 Oct 2017 02:19:28 +0530
Message-ID: <20171029204931.7792-13-rvarsha016@gmail.com>
References: <cover.1509305217.git.rvarsha016@gmail.com>
 <20171029204931.7792-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46277 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdJ2UuQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Oct 2017 16:50:16 -0400
Received: by mail-pf0-f195.google.com with SMTP id p87so9230090pfj.3
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Oct 2017 13:50:15 -0700 (PDT)
In-Reply-To: <20171029204931.7792-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch removes test cases for meta expression. As new test is added
to tests/shell.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 tests/files/expr-meta | 40 ----------------------------------------
 1 file changed, 40 deletions(-)
 delete mode 100644 tests/files/expr-meta

diff --git a/tests/files/expr-meta b/tests/files/expr-meta
deleted file mode 100644
index 360caa7..0000000
--- a/tests/files/expr-meta
+++ /dev/null
@@ -1,40 +0,0 @@
-#! nft -f
-
-add table ip filter
-add chain ip filter output { type filter hook output priority 0 ; }
-
-# meta: skb len
-add rule ip filter output meta length 1000 counter
-
-# meta: skb protocol
-add rule ip filter output meta protocol 0x0800 counter
-
-# meta: skb mark
-add rule ip filter output meta mark 0 counter
-
-# meta: skb iif
-add rule ip filter output meta iif lo counter
-
-# meta: skb iifname
-add rule ip filter output meta iifname "eth0" counter
-
-# meta: skb oif
-add rule ip filter output meta oif lo counter
-
-# meta: skb oifname
-add rule ip filter output meta oifname "eth0" counter
-
-# meta: skb sk uid
-add rule ip filter output meta skuid 1000 counter
-
-# meta: skb sk gid
-add rule ip filter output meta skgid 1000 counter
-
-# meta: nftrace
-add rule ip filter output meta nftrace 1 counter
-
-# meta: rtclassid (see /etc/iproute2/rt_realms)
-add rule ip filter output meta rtclassid cosmos counter
-
-# meta: secmark
-add rule ip filter output meta secmark 0 counter
-- 
2.13.6

