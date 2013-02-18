From: Eric Leblond <eric@regit.org>
Subject: [PATCH 4/7] Fix typo in comments.
Date: Mon, 18 Feb 2013 09:37:45 +0100
Message-ID: <1361176668-22661-5-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48542 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3BRIie (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:34 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/conffile.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index 09eb8cf..0b8ac0e 100644
--- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -20,13 +20,13 @@ enum {
 	ERRSECTION,	/* section not found */
 };
 
-/* maximum line lenght of config file entries */
+/* maximum line length of config file entries */
 #define LINE_LEN 		255
 
-/* maximum lenght of config key name */
+/* maximum length of config key name */
 #define CONFIG_KEY_LEN		30
 
-/* maximum lenght of string config value */
+/* maximum length of string config value */
 #define CONFIG_VAL_STRING_LEN	225
 
 /* valid config types */
-- 
1.7.10.4

