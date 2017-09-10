From: Rafael Buchbinder <rafi@rbk.ms>
Subject: [PATCH] extensions: libxt_bpf: fix missing __NR_bpf declaration
Date: Sun, 10 Sep 2017 10:44:53 +0300
Message-ID: <20170910074453.17462-1-rafi@rbk.ms>
Cc: Rafael Buchbinder <rafi@rbk.ms>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:37120 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIJHpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Sep 2017 03:45:05 -0400
Received: by mail-wr0-f173.google.com with SMTP id k20so9709214wre.4
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2017 00:45:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This include is needed to compile the bpf_obj_get function properly,
as it brings in the __NR_bpf declaration.
---
 extensions/libxt_bpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libxt_bpf.c b/extensions/libxt_bpf.c
index 92c445e8..9510c190 100644
--- a/extensions/libxt_bpf.c
+++ b/extensions/libxt_bpf.c
@@ -22,6 +22,8 @@
 #include <linux/bpf.h>
 #endif
 
+#include <linux/unistd.h>
+
 #define BCODE_FILE_MAX_LEN_B	1024
 
 enum {
-- 
2.14.1

