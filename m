From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 12/12] ipfix: add debug symbol for yafscii
Date: Tue, 3 Jun 2014 19:18:34 +0900
Message-ID: <20140603101833.GM24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:48194 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaFCKSk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:18:40 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so4530095pde.28
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:18:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

http://tools.netsa.cert.org/yaf/yafscii.html
To see the file by yafscii
yafscii --in /tmp/ulogd.yaf and see /tmp/ulogd.yaf.txt

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index f10a82b..e552a3c 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -38,6 +38,12 @@
 #include <sys/socket.h>
 #include <netdb.h>
 
+#define DEBUG_YAFSCII_FILE "/tmp/ulogd.yaf"
+#ifdef DEBUG_YAFSCII_FILE
+#include <sys/stat.h>
+#include <sys/fcntl.h>
+#endif
+
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 #include <ulogd/linuxlist.h>
@@ -143,6 +149,10 @@ struct ipfix_instance {
 	struct llist_head template_list;
 	struct nfct_bitmask *valid_bitmask;	/* bitmask of valid keys */
 	u_int32_t seq;
+
+#ifdef DEBUG_YAFSCII_FILE
+	int yaf_fd;
+#endif
 };
 
 #define ULOGD_IPFIX_TEMPL_BASE 1024
@@ -469,6 +479,9 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 	ipfix_fprintf_header(stdout, ipfix_msg);
 	fprintf(stdout, "\n");
 
+#ifdef DEBUG_YAFSCII_FILE
+	write(ii->yaf_fd, ipfix_msg, ntohs(ipfix_msg->length));
+#endif
 	return ULOGD_IRET_OK;
 }
 
@@ -565,6 +578,10 @@ static int start_ipfix(struct ulogd_pluginstance *pi)
 	if (ret < 0)
 		goto out_bm_free;
 
+#ifdef DEBUG_YAFSCII_FILE
+	ii->yaf_fd = open(DEBUG_YAFSCII_FILE, O_CREAT|O_WRONLY|O_TRUNC, S_IWUSR);
+#endif
+
 	return 0;
 
 out_bm_free:
@@ -578,6 +595,9 @@ static int stop_ipfix(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
 
+#ifdef DEBUG_YAFSCII_FILE
+	close(ii->yaf_fd);
+#endif
 	close(ii->fd);
 
 	nfct_bitmask_destroy(ii->valid_bitmask);
-- 
1.9.1

