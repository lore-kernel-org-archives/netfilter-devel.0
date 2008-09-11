From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 1/3] Suppress references to ulogd1 only variable.
Date: Thu, 11 Sep 2008 22:48:03 +0200
Message-ID: <1221166085-23435-2-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:47378 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbYIKUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:48:10 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'rmem' and 'bufsize' global variables are unherited from ulogd1
and are not used anymore. This patch suppresses them from the
example configuration file.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index a32234d..d2b18d4 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -14,13 +14,6 @@ logfile="/var/log/ulogd.log"
 # loglevel: debug(1), info(3), notice(5), error(7) or fatal(8)
 loglevel=1
 
-# socket receive buffer size (should be at least the size of the
-# in-kernel buffer (ipt_ULOG.o 'nlbufsiz' parameter)
-rmem=131071
-
-# libipulog/ulogd receive buffer size, should be > rmem
-bufsize=150000
-
 ######################################################################
 # PLUGIN OPTIONS
 ######################################################################
-- 
1.5.4.3

