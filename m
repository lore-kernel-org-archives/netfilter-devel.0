From: Eric Leblond <eric@regit.org>
Subject: [PATCH 6/7] logemu: return error if configuration is invalid.
Date: Mon, 18 Feb 2013 09:37:47 +0100
Message-ID: <1361176668-22661-7-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48544 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3BRIie (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:34 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/ulogd_output_LOGEMU.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index 26f139b..bb27209 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -177,11 +177,8 @@ static int fini_logemu(struct ulogd_pluginstance *pi) {
 static int configure_logemu(struct ulogd_pluginstance *pi,
 			    struct ulogd_pluginstance_stack *stack)
 {
-	/* FIXME: error handling */
 	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	config_parse_file(pi->id, pi->config_kset);
-
-	return 0;
+	return config_parse_file(pi->id, pi->config_kset);
 }
 
 static struct ulogd_plugin logemu_plugin = { 
-- 
1.7.10.4

