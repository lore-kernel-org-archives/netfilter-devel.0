From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH iptables] configure: Fix logic to show connlabel support
Date: Wed, 22 Jun 2016 19:40:37 +0530
Message-ID: <1466604637-26536-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36754 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbcFVOKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 10:10:52 -0400
Received: by mail-pf0-f195.google.com with SMTP id i123so4160935pfg.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 07:10:51 -0700 (PDT)
Received: from localhost.localdomain ([116.202.32.104])
        by smtp.gmail.com with ESMTPSA id v62sm187348pfv.50.2016.06.22.07.10.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 Jun 2016 07:10:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the earlier logic, when libnfnetlink and libnetfilter_conntrack
were not installed, all the warnings showed up correctly but the final
configuration showed:

            connlabel support:                      yes

which was faulty.
This was happening because connlabel module was blacklisted first and
then set to "no" if package requirements were not met.
After this patch, iptables configuration shows up correctly.

Fixes commit 3b7a227 (configure: Show support for connlabel)

Tested before and after installing the dependencies.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c91e9e7..131bc8b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -173,9 +173,9 @@ if test "x$enable_connlabel" = "xyes"; then
 		[nfconntrack=1], [nfconntrack=0])
 
 	if test "$nfconntrack" -ne 1; then
+		enable_connlabel="no";
 		blacklist_modules="$blacklist_modules connlabel";
 		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
-		enable_connlabel = "no";
 	fi;
 else
 	blacklist_modules="$blacklist_modules connlabel";
-- 
2.7.4

