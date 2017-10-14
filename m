From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] update INSTALL to add library libnfnetlink
Date: Sat, 14 Oct 2017 18:21:45 +0530
Message-ID: <20171014125145.8336-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:56389 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbdJNMx5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Oct 2017 08:53:57 -0400
Received: by mail-pg0-f67.google.com with SMTP id m18so3291877pgd.13
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Oct 2017 05:53:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

configure.ac checks for libnfnetlink(>=1.0) library

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 INSTALL | 1 +
 1 file changed, 1 insertion(+)

diff --git a/INSTALL b/INSTALL
index d62b428c..d28ea5c1 100644
--- a/INSTALL
+++ b/INSTALL
@@ -11,6 +11,7 @@ iptables uses the well-known configure(autotools) infrastructure.
 Prerequisites
 =============
 
+	* libnfnetlink
 	* no kernel-source required
 
 	* but obviously a compiler, glibc-devel and linux-kernel-headers
-- 
2.11.0

