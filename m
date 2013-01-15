From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] parser: workaround glibc-2.3.2 bug 358
Date: Tue, 15 Jan 2013 19:20:02 +0100
Message-ID: <1358274002-6042-3-git-send-email-jengelh@inai.de>
References: <1358274002-6042-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38866 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246Ab3AOSUG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:20:06 -0500
In-Reply-To: <1358274002-6042-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

glibc-2.3.2 has a bug whereby it would reject looking up services by
port number without a socket type specification. In iptables, this
manifests as:

	# iptables -A INPUT -p udp --sport 67
	iptables v1.4.16.3: Port "67" does not resolve to anything.

(The bug was found to be fixed in glibc-2.3.6.)
References: http://sourceware.org/bugzilla/show_bug.cgi?id=358
References: http://marc.info/?l=netfilter&m=135826543809613&w=2
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libxtables/xtoptions.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 452e0fe..0654cb6 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -562,6 +562,20 @@ static int xtables_getportbyname(const char *name)
 	int ret;
 
 	ret = getaddrinfo(NULL, name, NULL, &res);
+	if (ret == EAI_SERVICE) {
+		/*
+		 * glibc-2.3.2 has a bug that yields EAI_SERVICE when
+		 * name is a number in string format, e.g. "67".
+		 * (http://sourceware.org/bugzilla/show_bug.cgi?id=358)
+		 * Fall back to strtoul if it is such a plain number.
+		 */
+		char *end;
+
+		ret = strtoul(name, &end, 10);
+		if (name != end && *end == '\0')
+			return ret;
+		return -1;
+	}
 	if (ret < 0)
 		return -1;
 	ret = -1;
-- 
1.7.10.4

