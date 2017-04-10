From: Khem Raj <raj.khem@gmail.com>
Subject: [libnetfilter_queue][PATCH 1/2] Correct typo in the location of internal.h in #include
Date: Mon, 10 Apr 2017 12:58:03 -0700
Message-ID: <20170410195804.18238-1-raj.khem@gmail.com>
Cc: Khem Raj <raj.khem@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36541 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdDJT6N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 15:58:13 -0400
Received: by mail-pf0-f195.google.com with SMTP id i5so7646555pfc.3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 12:58:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Khem Raj <raj.khem@gmail.com>

%% original patch: 0001-Correct-typo-in-the-location-of-internal.h-in-includ.patch
---
 src/libnetfilter_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 211a8ba..065d618 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -32,7 +32,7 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
-#include "src/internal.h"
+#include "internal.h"
 
 /**
  * \mainpage
-- 
2.12.2

