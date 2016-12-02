From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH] systemd: fix missing log.h include
Date: Fri, 02 Dec 2016 11:29:38 +0100
Message-ID: <148067457876.19755.4897734997943160784.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60451 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757553AbcLBK3t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 05:29:49 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 4CF8A51F349
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 10:29:46 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 78SySjYgdqCM for <netfilter-devel@vger.kernel.org>;
        Fri,  2 Dec 2016 11:29:41 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id EBDDE51F299
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 11:29:39 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Produces this:
 warning: implicit declaration of function 'dlog'

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/systemd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/systemd.c b/src/systemd.c
index c6253cc..64bfc66 100644
--- a/src/systemd.c
+++ b/src/systemd.c
@@ -19,6 +19,7 @@
 #include "systemd.h"
 #include "conntrackd.h"
 #include "alarm.h"
+#include "log.h"
 #include <systemd/sd-daemon.h>
 #include <sys/types.h>
 #include <unistd.h>

