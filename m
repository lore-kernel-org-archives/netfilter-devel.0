From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 13/13] ipfix: add debug symbol for yafscii
Date: Mon, 28 Apr 2014 20:57:42 +0900
Message-ID: <20140428115742.GN12523@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47769 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaD1L5t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:57:49 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so5698155pab.40
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2014 04:57:48 -0700 (PDT)
Received: from gmail.com (softbank220009032006.bbtec.net. [220.9.32.6])
        by mx.google.com with ESMTPSA id ir10sm34559493pbc.59.2014.04.28.04.57.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 04:57:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140428113936.GA12523@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

http://tools.netsa.cert.org/yaf/yafscii.html
To see flow created by yafscii
yafscii --in /tmp/ulogd.yaf and see /tmp/ulogd.yaf.txt

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 2c77264..e0495d2 100644
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
@@ -486,6 +496,9 @@ static int output_ipfix(struct ulogd_pluginstance *upi)
 	ipfix_fprintf_header(stdout, ipfix_msg);
 	fprintf(stdout, "\n");
 
+#ifdef DEBUG_YAFSCII_FILE
+	write(ii->yaf_fd, ipfix_msg, ntohs(ipfix_msg->length));
+#endif
 	return ULOGD_IRET_OK;
 }
 
@@ -582,6 +595,10 @@ static int start_ipfix(struct ulogd_pluginstance *pi)
 	if (ret < 0)
 		goto out_bm_free;
 
+#ifdef DEBUG_YAFSCII_FILE
+	ii->yaf_fd = open(DEBUG_YAFSCII_FILE, O_CREAT|O_WRONLY|O_TRUNC, S_IWUSR);
+#endif
+
 	return 0;
 
 out_bm_free:
@@ -595,6 +612,9 @@ static int stop_ipfix(struct ulogd_pluginstance *pi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &pi->private;
 
+#ifdef DEBUG_YAFSCII_FILE
+	close(ii->yaf_fd);
+#endif
 	close(ii->fd);
 
 	nfct_bitmask_destroy(ii->valid_bitmask);
-- 
1.9.1

