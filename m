From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] build: use simpler autoreconf in autogen
Date: Thu,  9 Sep 2010 01:32:39 +0200
Message-ID: <1283988763-1577-5-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab0IHXct (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:49 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Note: the use of -i seems required, otherwise autoreconf barfs about
missing tools (depcomp, etc.). Since they are provided in the tarballs
as files anyway rather than like previously as symlinks, I do not see a
problem using -i.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 07bd67f..4989ed9 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -34,8 +34,4 @@ run ()
 }
 
 [ "x$1" = "xdistrib" ] && include
-run aclocal
-run libtoolize -f
-#run autoheader
-run automake -a
-run autoconf
+autoreconf -fi
-- 
1.7.1

