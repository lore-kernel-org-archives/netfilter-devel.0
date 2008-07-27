From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 09/11] Fix some initialisation.
Date: Sun, 27 Jul 2008 15:51:24 +0200
Message-ID: <1217166686-28508-10-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43805 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes some improper initialization in ulogd.c.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 429f472..e69079d 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -97,7 +97,6 @@ static struct config_keyset ulogd_kset = {
 			.key = "logfile",
 			.type = CONFIG_TYPE_CALLBACK,
 			.options = CONFIG_OPT_NONE,
-			.u.string = ULOGD_LOGFILE_DEFAULT,
 			.u.parser = &logfile_open,
 		},
 		{
@@ -1022,7 +1021,7 @@ static struct option opts[] = {
 	{ "configfile", 1, NULL, 'c'},
 	{ "uid", 1, NULL, 'u' },
 	{ "info", 1, NULL, 'i' },
-	{ 0 }
+	{NULL, 0, NULL, 0}
 };
 
 int main(int argc, char* argv[])
-- 
1.5.4.3

