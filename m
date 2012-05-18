From: Florian Westphal <fw@strlen.de>
Subject: [PATCH][libnetfilter_conntrack] snprintf: print conntrack helper name, too
Date: Fri, 18 May 2012 13:35:59 +0200
Message-ID: <1337340959-15183-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49175 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697Ab2ERLeG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 May 2012 07:34:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack/snprintf_default.c |   11 +++++++++++
 src/conntrack/snprintf_xml.c     |   16 ++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 206b9c0..45d192d 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -282,6 +282,12 @@ __snprintf_timestamp_delta(char *buf, unsigned int len,
 			(unsigned long long)delta_time));
 }
 
+static int
+__snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *ct)
+{
+	return (snprintf(buf, len, "helper=%s ", ct->helper_name));
+}
+
 int __snprintf_conntrack_default(char *buf, 
 				 unsigned int len,
 				 const struct nf_conntrack *ct,
@@ -415,6 +421,11 @@ int __snprintf_conntrack_default(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_HELPER_NAME, ct->head.set)) {
+		ret = __snprintf_helper_name(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	/* Delete the last blank space */
 	size--;
 
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index 756d118..ad53075 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -239,6 +239,18 @@ __snprintf_deltatime(char *buf, unsigned int len, const struct nf_conntrack *ct)
 	return size;
 }
 
+static int
+__snprintf_helper_name(char *buf, unsigned int len, const struct nf_conntrack *ct)
+{
+	int ret;
+	unsigned int size = 0, offset = 0;
+
+	ret = snprintf(buf+offset, len, "<helper>%s</helper>", ct->helper_name);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	return size;
+}
+
 int
 __snprintf_localtime_xml(char *buf, unsigned int len, const struct tm *tm)
 {
@@ -522,6 +534,10 @@ int __snprintf_conntrack_xml(char *buf,
 		BUFFER_SIZE(ret, size, len, offset);
 	}
 
+	if (test_bit(ATTR_HELPER_NAME, ct->head.set)) {
+		ret = __snprintf_helper_name(buf+offset, len, ct);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
 err_out:
 	ret = snprintf(buf+offset, len, "</flow>");
 	BUFFER_SIZE(ret, size, len, offset);
-- 
1.7.3.4

