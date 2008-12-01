From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 13/18] Add SIGINT to list of terminal signal.
Date: Mon,  1 Dec 2008 22:36:11 +0100
Message-ID: <1228167376-22101-14-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39314 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752599AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies ulogd to intercept SIGINT signal
and quit nicely when this signal is received.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index d193b26..2f80913 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -980,7 +980,7 @@ static void stop_pluginstances()
 static void sigterm_handler(int signal)
 {
 
-	ulogd_log(ULOGD_NOTICE, "sigterm received, exiting\n");
+	ulogd_log(ULOGD_NOTICE, "Terminal signal received, exiting\n");
 
 	deliver_signal_pluginstances(signal);
 
@@ -1173,6 +1173,7 @@ int main(int argc, char* argv[])
 	}
 
 	signal(SIGTERM, &sigterm_handler);
+	signal(SIGINT, &sigterm_handler);
 	signal(SIGHUP, &signal_handler);
 	signal(SIGALRM, &signal_handler);
 	signal(SIGUSR1, &signal_handler);
-- 
1.5.6.3

