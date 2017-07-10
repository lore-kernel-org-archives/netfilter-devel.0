From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] libnetfilter_conntrack: bump version to 1.0.7
Date: Mon, 10 Jul 2017 22:33:50 +0200
Message-ID: <20170710203350.29166-1-richard@nod.at>
Cc: pablo@netfilter.org, fw@strlen.de,
        Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
        mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbdGJUeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 16:34:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a maintenance release, so the version is just bumped to 1.0.7.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
Hi!

Can we please do a new release such that distros can pick it up?
My users suffer from issues which are solved by commit:
commit b0a7cf7f050fb99ead1d745a8c928310e3403bd0
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Nov 24 14:09:34 2016 +0100

    include: expose a copy of nf_conntrack_common.h

Thanks,
//richard
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 70dc23e84502..6304543eca7c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to create configure.
 
-AC_INIT([libnetfilter_conntrack], [1.0.6])
+AC_INIT([libnetfilter_conntrack], [1.0.7])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_HEADER([config.h])
-- 
2.12.3

