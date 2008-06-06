From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/5] Enable reading of hex or dec integer in config file.
Date: Fri,  6 Jun 2008 15:13:53 +0200
Message-ID: <1212758035-19538-4-git-send-email-eric@inl.fr>
References: <>
 <1212758035-19538-1-git-send-email-eric@inl.fr>
 <1212758035-19538-2-git-send-email-eric@inl.fr>
 <1212758035-19538-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43257 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753036AbYFFNME (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:12:04 -0400
In-Reply-To: <1212758035-19538-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The config file parsing was not able to parse integer given in hex notation.
This patch modify the parsing of configfile to be able to use different
integers notation.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/conffile.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index b74da68..075b867 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -115,6 +115,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 	int i;
 	char linebuf[LINE_LEN+1];
 	char *line = linebuf;
+	char *end;
 
 	pr_debug("%s: section='%s' file='%s'\n", __func__, section, fname);
 
@@ -192,7 +193,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 					}
 					break;
 				case CONFIG_TYPE_INT:
-					ce->u.value = atoi(args);
+					ce->u.value = strtoul(args, &end, 0);
 					break;
 				case CONFIG_TYPE_CALLBACK:
 					(ce->u.parser)(args);
-- 
1.5.4.3

