From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH iptables] configure: Fix assignment statement
Date: Thu, 23 Jun 2016 01:11:39 +0530
Message-ID: <1466624499-10503-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33750 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbcFVTly (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 15:41:54 -0400
Received: by mail-pa0-f66.google.com with SMTP id ts6so4625765pac.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 12:41:54 -0700 (PDT)
Received: from localhost.localdomain ([116.202.36.37])
        by smtp.gmail.com with ESMTPSA id c8sm1617056pfb.33.2016.06.22.12.41.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 Jun 2016 12:41:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The assignment statement was interpreted as executing enable_connlabel
command with the argument "no". This was due to the whitespaces in the
assignment.

Fixes the trivial bug introduced in commit 3b7a227 (configure: Show
support for connlabel)

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index c91e9e7..b47516b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -175,7 +175,7 @@ if test "x$enable_connlabel" = "xyes"; then
 	if test "$nfconntrack" -ne 1; then
 		blacklist_modules="$blacklist_modules connlabel";
 		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
-		enable_connlabel = "no";
+		enable_connlabel="no";
 	fi;
 else
 	blacklist_modules="$blacklist_modules connlabel";
-- 
2.7.4

