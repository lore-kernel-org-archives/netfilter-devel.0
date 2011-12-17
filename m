From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] Sentence ordering
Date: Sat, 17 Dec 2011 22:02:19 +0100
Message-ID: <1324155743-25999-3-git-send-email-jengelh@medozas.de>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50756 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1LQVC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:02:29 -0500
In-Reply-To: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"this" refers to a near object (cf. "that" for far), so s/by doing
this/by doing that/, or just move the subclause to the front.
---
 secure-conntrack-helpers.rst |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index cbd5fd5..1acaf2e 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -190,8 +190,8 @@ modules by setting the port number for the module to 0. For example ::
 
  modprobe nf_conntrack_$PROTO ports=0
 
-The following modules will be deactivated on all flows by default by doing
-this:
+By doing this, the following modules will be deactivated on all flows
+by default:
 
  - ftp
  - irc
@@ -199,7 +199,7 @@ this:
  - sip
  - tftp
 
-Some modules will not work due to the absence of ports parameter:
+Due to the absence of a "ports" parameter, some modules will not work:
 
  - amanda
  - h323
-- 
1.7.3.4

