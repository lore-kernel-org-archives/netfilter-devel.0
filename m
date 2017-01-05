From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables 1.6.1 release
Date: Thu,  5 Jan 2017 12:30:29 +0100
Message-ID: <1483615829-3374-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968896AbdAELas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 06:30:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7755352309
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:30:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A286A7DB4
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:30:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 248F49EBC2
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 12:30:37 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 6ae63f83b084..eda7871405b3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,5 +1,5 @@
 
-AC_INIT([iptables], [1.6.0])
+AC_INIT([iptables], [1.6.1])
 
 # See libtool.info "Libtool's versioning system"
 libxtables_vcurrent=12
-- 
2.1.4

