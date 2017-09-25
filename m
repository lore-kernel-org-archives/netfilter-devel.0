From: Stijn Tintel <stijn@linux-ipv6.be>
Subject: [PATCH] ipset: fix build with musl
Date: Mon, 25 Sep 2017 08:09:01 +0300
Message-ID: <20170925050901.31033-1-stijn@linux-ipv6.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tintel.eu ([54.36.12.13]:56044 "EHLO mail.tintel.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753121AbdIYFRh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2017 01:17:37 -0400
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 2DB9C437CC46
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 07:09:04 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id P82pTuA2m5XM for <netfilter-devel@vger.kernel.org>;
        Mon, 25 Sep 2017 07:09:03 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id AD0A1434FC55
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 07:09:03 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id rXPvpwON_G-Z for <netfilter-devel@vger.kernel.org>;
        Mon, 25 Sep 2017 07:09:03 +0200 (CEST)
Received: from taz (unknown [IPv6:2001:67c:21bc:24::adb])
        (Authenticated sender: stijn@linux-ipv6.be)
        by mail.tintel.eu (Postfix) with ESMTPSA id 733C5437CC46
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 07:09:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include sys/types.h for u_int8_t and define _GNU_SOURCE for musl to
expose it.

Fixes: 54802b2c2826 ("Report if the option is supported by a newer kernel release")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 src/ipset.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/ipset.c b/src/ipset.c
index 79f56b8..8d70abc 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -14,6 +14,8 @@
 #include <stdio.h>			/* fprintf, fgets */
 #include <stdlib.h>			/* exit */
 #include <string.h>			/* str* */
+#define _GNU_SOURCE
+#include <sys/types.h>			/* u_int8_t */
 
 #include <config.h>
 
-- 
2.13.5

