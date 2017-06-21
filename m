From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] bump version to 1.0.3
Date: Wed, 21 Jun 2017 23:18:46 +0200
Message-ID: <20170621211846.20630-1-richard@nod.at>
Cc: pablo@netfilter.org, fw@strlen.de,
        Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdFUVTO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2017 17:19:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Time to make a new version such that distros can pick this version.
Many distros ship only 1.0.2 which is almost five years old and
does not support recent netfilter features such as NFQA_CT.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
Hi!

As discussed with Florian on IRC, it is time for a new version.
I think we don't have to change the API version, so just increment
the release version.

Thanks,
//richard
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 289868fad5d2..0c0845950275 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnetfilter_queue], [1.0.2])
+AC_INIT([libnetfilter_queue], [1.0.3])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
-- 
2.12.3

