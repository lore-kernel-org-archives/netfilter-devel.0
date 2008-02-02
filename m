From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 14/34]  Request at least autoconf 2.50 (needed for large file support macro).
Date: Sat,  2 Feb 2008 22:24:09 +0100
Message-ID: <12019874704067-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46026 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762168AbYBBWPo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:44 -0500
In-Reply-To: <12019874703504-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 b09c43b... 086e4cb... M	configure.in
 configure.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index b09c43b..086e4cb 100644
--- a/configure.in
+++ b/configure.in
@@ -1,4 +1,5 @@
 dnl Process this file with autoconf to produce a configure script.
+AC_PREQ(2.50)
 AC_INIT
 
 AM_INIT_AUTOMAKE(ulogd, 2.0.0beta2)
-- 
1.5.2.5

