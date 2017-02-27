From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] uapi: fix linux/netfilter/xt_hashlimit.h userspace compilation error
Date: Mon, 27 Feb 2017 12:35:39 +0100
Message-ID: <1488195342-2678-4-git-send-email-pablo@netfilter.org>
References: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751963AbdB0Lgl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 06:36:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8743FE645
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:35:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A491DA81A
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:35:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F207DA81C
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 12:35:55 +0100 (CET)
In-Reply-To: <1488195342-2678-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Dmitry V. Levin" <ldv@altlinux.org>

Include <linux/limits.h> like some of uapi/linux/netfilter/xt_*.h
headers do to fix the following linux/netfilter/xt_hashlimit.h
userspace compilation error:

/usr/include/linux/netfilter/xt_hashlimit.h:90:12: error: 'NAME_MAX' undeclared here (not in a function)
  char name[NAME_MAX];

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_hashlimit.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_hashlimit.h b/include/uapi/linux/netfilter/xt_hashlimit.h
index 3efc0ca18345..79da349f1060 100644
--- a/include/uapi/linux/netfilter/xt_hashlimit.h
+++ b/include/uapi/linux/netfilter/xt_hashlimit.h
@@ -2,6 +2,7 @@
 #define _UAPI_XT_HASHLIMIT_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #include <linux/if.h>
 
 /* timings are in milliseconds. */
-- 
2.1.4

