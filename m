From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 15/18] Introduce config_stop() function
Date: Mon,  1 Dec 2008 22:36:13 +0100
Message-ID: <1228167376-22101-16-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39317 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752612AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the config_stop function which is in charge of releasing
ressources allocated for configuration file parsing.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/ulogd/conffile.h |    3 +++
 src/conffile.c           |    4 ++++
 src/ulogd.c              |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index 826d9d5..7431243 100644
--- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -67,4 +67,7 @@ int config_register_file(const char *file);
 /* parse the config file */
 int config_parse_file(const char *section, struct config_keyset *kset);
 
+/* release ressource allocated by config file handling */
+void config_stop();
+
 #endif /* ifndef _CONFFILE_H */
diff --git a/src/conffile.c b/src/conffile.c
index 0c1a2a4..b27187e 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -222,3 +222,7 @@ cpf_error:
 	return err;
 }
 
+void config_stop()
+{
+	free(fname);
+}
diff --git a/src/ulogd.c b/src/ulogd.c
index ae57a38..b079fd2 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1013,6 +1013,8 @@ static void sigterm_handler(int signal)
 	if (ulogd_logfile)
 		free(ulogd_logfile);
 
+	config_stop();
+
 	exit(0);
 }
 
-- 
1.5.6.3

