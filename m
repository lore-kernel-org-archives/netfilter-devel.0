From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] build: use sh -e, remove autom4te.cache
Date: Sun, 31 Oct 2010 00:08:16 +0200
Message-ID: <1288476502-18721-3-git-send-email-jengelh@medozas.de>
References: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46344 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0J3WJE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:09:04 -0400
In-Reply-To: <1288476502-18721-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sh -e (-x) will provide the same functionality as the run function
previously.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 4989ed9..3b111ce 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -e
 
 include ()
 {
@@ -35,3 +35,4 @@ run ()
 
 [ "x$1" = "xdistrib" ] && include
 autoreconf -fi
+rm -Rf autom4te.cache
-- 
1.7.1

