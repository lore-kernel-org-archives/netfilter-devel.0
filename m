From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 1/4] Modify CFLAGS to have useful gcc warnings.
Date: Wed, 23 Jul 2008 13:33:52 +0200
Message-ID: <1216812835-9851-2-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43431 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751625AbYGWLd5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:33:57 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies CFLAGS to add -Wall and -Wextra flags to gcc
compilation flag. This will help to detect some stupid problems.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index f902792..8e0f6a3 100644
--- a/configure.in
+++ b/configure.in
@@ -30,6 +30,8 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
+CFLAGS="$CFLAGS -Wall -Wextra"
+
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.39
 LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
-- 
1.5.4.3

