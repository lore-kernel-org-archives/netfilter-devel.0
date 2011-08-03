From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] build: abort autogen on subcommand failure
Date: Wed,  3 Aug 2011 17:37:19 +0200
Message-ID: <1312385840-32490-2-git-send-email-jengelh@medozas.de>
References: <1312385840-32490-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38449 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab1HCPhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:37:24 -0400
In-Reply-To: <1312385840-32490-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Needed to stop an automated build process when automake requirements
are not fulfilled.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 autogen.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 36b2a2a..f9c3a91 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -e
 
 autoreconf -fi;
 rm -Rf autom4te.cache;
-- 
1.7.3.4

