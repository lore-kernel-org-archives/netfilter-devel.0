From: Eric Leblond <eric@regit.org>
Subject: [PATCH 5/7] Add handling of too long arguments.
Date: Mon, 18 Feb 2013 09:37:46 +0100
Message-ID: <1361176668-22661-6-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48543 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3BRIie (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:34 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When an argument is too long, it can not be store into ulogd
configuration and this must results in a error.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/conffile.h |    1 +
 src/conffile.c           |    5 ++++-
 src/ulogd.c              |    5 +++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index 0b8ac0e..69a6f70 100644
--- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -18,6 +18,7 @@ enum {
 	ERRMAND,	/* mandatory option not found */
 	ERRUNKN,	/* unknown config key */
 	ERRSECTION,	/* section not found */
+	ERRTOOLONG,	/* string too long */
 };
 
 /* maximum line length of config file entries */
diff --git a/src/conffile.c b/src/conffile.c
index 616d7a9..9a73406 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -197,7 +197,10 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 					if (strlen(args) < 
 					    CONFIG_VAL_STRING_LEN ) {
 						strcpy(ce->u.string, args);
-						/* FIXME: what if not ? */
+					} else {
+						config_errce = ce;
+						err = -ERRTOOLONG;
+						goto cpf_error;
 					}
 					break;
 				case CONFIG_TYPE_INT:
diff --git a/src/ulogd.c b/src/ulogd.c
index f8c8ed0..6c0df8a 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -989,6 +989,11 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
 			ulogd_log(ULOGD_ERROR,
 				"section \"%s\" not found\n", section);
 			break;
+		case -ERRTOOLONG:
+			ulogd_log(ULOGD_ERROR,
+				"too long string value for key \"%s\"\n",
+				config_errce->key);
+			break;
 	}
 	return 1;
 }
-- 
1.7.10.4

