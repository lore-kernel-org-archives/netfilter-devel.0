From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 11/11] Add option to CFLAGS to avoid useless warning.
Date: Sun, 27 Jul 2008 15:51:26 +0200
Message-ID: <1217166686-28508-12-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43809 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the "-Wno-unused-parameter" option to CFLAGS. This suppress
gcc warning that can not be fixed due to the usage of generic system like
callback where function definition has to be standardized.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 configure.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index 96cc2d0..8889575 100644
--- a/configure.in
+++ b/configure.in
@@ -30,7 +30,7 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
-CFLAGS="$CFLAGS -Wall -Wextra"
+CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"
 
 dnl Check for the right nfnetlink version
 LIBNFNETLINK_REQUIRED=0.0.39
-- 
1.5.4.3

