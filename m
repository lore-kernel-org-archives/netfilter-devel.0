From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] build: abort autogen on subcommand failure
Date: Mon,  8 Aug 2011 02:42:22 +0200
Message-ID: <1312764144-23849-7-git-send-email-jengelh@medozas.de>
References: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44413 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1HHAmd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:42:33 -0400
In-Reply-To: <1312764144-23849-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed to stop an automated build process when automake requirements
are not fulfilled.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 62a89e1..a0c4395 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh -e
 
 autoreconf -fi;
 rm -Rf autom4te*.cache;
-- 
1.7.3.4

