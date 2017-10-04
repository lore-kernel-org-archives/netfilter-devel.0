From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] build: libnftnl 1.0.8 release
Date: Wed,  4 Oct 2017 15:23:18 +0200
Message-ID: <1507123398-2317-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752360AbdJDNX1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 09:23:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D04CB3066A5
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 15:23:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2F44DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 15:23:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E4A5DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 15:23:21 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 484F240584D1
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 15:23:21 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

907a9f8e5a93 ("src: get rid of aliases and compat") already updated
LIBVERSION when symbol aliases have been dropped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 2b74e522b930..f994ccd878a1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnftnl], [1.0.7])
+AC_INIT([libnftnl], [1.0.8])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.1.4

