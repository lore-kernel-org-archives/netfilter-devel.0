From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] xtables: improve get_modprobe handling
Date: Mon, 27 May 2013 12:55:11 -0400
Message-ID: <20130527165511.GA5397@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34764 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3E0QzU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 12:55:20 -0400
Received: by mail-ie0-f169.google.com with SMTP id u16so19289820iet.28
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2013 09:55:20 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In bug #455, Dmitry V. Levin proposed a more robust get_modprobe
implementation.  The patch below is a version of his patch,
updated to apply to current git.

This closes bug #455.

Signed-off-by: Phil Oester <kernel@linuxace.com>

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-455

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 009ab91..ebc77b6 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -305,8 +305,8 @@ static char *get_modprobe(void)
 {
 	int procfile;
 	char *ret;
+	int count;
 
-#define PROCFILE_BUFSIZ	1024
 	procfile = open(PROC_SYS_MODPROBE, O_RDONLY);
 	if (procfile < 0)
 		return NULL;
@@ -316,19 +316,19 @@ static char *get_modprobe(void)
 		exit(1);
 	}
 
-	ret = malloc(PROCFILE_BUFSIZ);
+	ret = malloc(PATH_MAX);
 	if (ret) {
-		memset(ret, 0, PROCFILE_BUFSIZ);
-		switch (read(procfile, ret, PROCFILE_BUFSIZ)) {
-		case -1: goto fail;
-		case PROCFILE_BUFSIZ: goto fail; /* Partial read.  Wierd */
+		count = read(procfile, ret, PATH_MAX);
+		if (count > 0 && count < PATH_MAX)
+		{
+			if (ret[count - 1] == '\n')
+				ret[count - 1] = '\0';
+			else
+				ret[count] = '\0';
+			close(procfile);
+			return ret;
 		}
-		if (ret[strlen(ret)-1]=='\n') 
-			ret[strlen(ret)-1]=0;
-		close(procfile);
-		return ret;
 	}
- fail:
 	free(ret);
 	close(procfile);
 	return NULL;

--0F1p//8PRICkK4MW--
