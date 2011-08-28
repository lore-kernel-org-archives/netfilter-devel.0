From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: abort autogen on subcommand failure
Date: Sun, 28 Aug 2011 19:32:47 +0200
Message-ID: <1314552769-19143-3-git-send-email-jengelh@medozas.de>
References: <1314552769-19143-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58008 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1H1Rcx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Aug 2011 13:32:53 -0400
In-Reply-To: <1314552769-19143-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed to stop an automated build process when automake requirements
are not fulfilled.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index d0d5d98..9c0f327 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -e
 
 aclocal -I m4
 autoreconf -fi
-- 
1.7.3.4

