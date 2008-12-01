From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 18/18] Add valgrind compilation option.
Date: Mon,  1 Dec 2008 22:36:16 +0100
Message-ID: <1228167376-22101-19-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39324 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752702AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Valgrind messages are obscur when the plugins are unloaded. This patch
adds a macro that can be used to desactivate unloading. To use it, you
have to specify 'CPPFLAGS=-DDEBUG_VALGRIND' on configure line.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 1a1f6af..badd7bd 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -985,6 +985,7 @@ static void stop_pluginstances()
 	}
 }
 
+#ifndef DEBUG_VALGRIND
 static void unload_plugins()
 {
 	struct ulogd_plugin_handle *ph, *nph;
@@ -993,6 +994,7 @@ static void unload_plugins()
 		free(ph);
 	}
 }
+#endif
 
 static void stop_stack()
 {
@@ -1015,7 +1017,9 @@ static void sigterm_handler(int signal)
 
 	stop_stack();
 
+#ifndef DEBUG_VALGRIND
 	unload_plugins();
+#endif
 
 	if (logfile != NULL  && logfile != stdout) {
 		fclose(logfile);
-- 
1.5.6.3

