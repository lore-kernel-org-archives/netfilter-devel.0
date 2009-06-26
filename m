From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/10] COMMIT_NOTES: notice to check for soversion bumps
Date: Fri, 26 Jun 2009 21:19:52 +0200
Message-ID: <1246043992-379-11-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39677 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329AbZFZTUN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:13 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 COMMIT_NOTES |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/COMMIT_NOTES b/COMMIT_NOTES
index 7583fac..592808c 100644
--- a/COMMIT_NOTES
+++ b/COMMIT_NOTES
@@ -11,5 +11,9 @@ A quick list of rules for committing stuff into netfilter git:
 
 - If you touch any parts of libxtables (xtables.c, include/xtables.h.in),
   make sure the so-version is updated _appropriately_ (i.e. read the
-  libtool manual about Versioning:: first if need be) in configure.ac.
+  libtool manual about Versioning:: first, if need be) in configure.ac.
   Adding fields to a struct always entails a vcurrent bump.
+
+  - Check, whether a bump (vcurrent,vage) has already been made since the
+    last release (no more than one per release), e.g.:
+            git log v1.4.4.. configure.ac
-- 
1.6.3.2

