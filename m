From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [lnf-log PATCHv2 3/3] nlmsg: add printf function in conjunction with
 libmnl
Date: Fri, 21 Aug 2015 09:30:33 +0900
Message-ID: <20150821003033.GD11754@gmail.com>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
 <20150820181613.GA4227@salvia>
 <20150821002306.GA11754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36382 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbHUAaj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 20:30:39 -0400
Received: by pawq9 with SMTP id q9so39128705paw.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 17:30:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150821002306.GA11754@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To printf nflog netlink message in XML, nflog_snprintf_xml can be
used after converting nflog nlattrs to nflog_data, but we should not
have any code that mixes both new and old, which handles nflog_data,
APIs. The idea is to deprecate libnfnetlink and any client of that
library at some point, that will take quite time though since we'll
have to mark those old interfaces as deprecated.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/internal.h                          |  9 +++++
 include/libnetfilter_log/libnetfilter_log.h |  8 +++++
 src/libnetfilter_log.c                      |  6 +---
 src/nlmsg.c                                 | 53 +++++++++++++++++++++++++++++
 utils/nf-log.c                              |  7 ++++
 5 files changed, 78 insertions(+), 5 deletions(-)
 create mode 100644 include/internal.h

diff --git a/include/internal.h b/include/internal.h
new file mode 100644
index 0000000..7839fd8
--- /dev/null
+++ b/include/internal.h
@@ -0,0 +1,9 @@
+#ifndef _LIBNETFILTER_LOG_INTERNAL_H
+#define _LIBNETFILTER_LOG_INTERNAL_H
+
+struct nflog_data
+{
+	struct nfattr **nfa;
+};
+
+#endif
diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 5087f6f..46767eb 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -89,4 +89,12 @@ extern int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t
 extern int nflog_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd);
 extern int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 
+enum nflog_output_type {
+	NFLOG_OUTPUT_XML	= 0,
+};
+
+int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
+			 struct nlattr **attr, enum nflog_output_type type,
+			 uint32_t flags);
+
 #endif	/* __LIBNETFILTER_LOG_H */
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index e92576b..567049c 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -26,6 +26,7 @@
 #include <errno.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
+#include "internal.h"
 
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
@@ -78,11 +79,6 @@ struct nflog_g_handle
 	void *data;
 };
 
-struct nflog_data
-{
-	struct nfattr **nfa;
-};
-
 int nflog_errno;
 
 /***********************************************************************
diff --git a/src/nlmsg.c b/src/nlmsg.c
index a917a70..708e32d 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -9,6 +9,9 @@
 #include <arpa/inet.h>
 #include <linux/netfilter/nfnetlink_log.h>
 #include <libmnl/libmnl.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+#include <errno.h>
+#include "internal.h"
 
 /**
  * \defgroup nlmsg Netlink message helper functions
@@ -157,5 +160,55 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 }
 
 /**
+ * nflog_nlmsg_snprintf - print a nflog nlattrs to a buffer
+ * \param buf buffer used to build the printable nflog
+ * \param bufsiz size of the buffer
+ * \param nlh netlink message (to get queue num in the futuer)
+ * \param attr pointer to a nflog attrs
+ * \param type print message type in enum nflog_output_type
+ * \param flags The flag that tell what to print into the buffer
+ *
+ * This function supports the following type - flags:
+ *
+ *   type: NFLOG_OUTPUT_XML
+ *	- NFLOG_XML_PREFIX: include the string prefix
+ *	- NFLOG_XML_HW: include the hardware link layer address
+ *	- NFLOG_XML_MARK: include the packet mark
+ *	- NFLOG_XML_DEV: include the device information
+ *	- NFLOG_XML_PHYSDEV: include the physical device information
+ *	- NFLOG_XML_PAYLOAD: include the payload (in hexadecimal)
+ *	- NFLOG_XML_TIME: include the timestamp
+ *	- NFLOG_XML_ALL: include all the logging information (all flags set)
+ *
+ * You can combine this flags with an binary OR.
+ *
+ * this function returns -1 and errno is explicitly set in case of
+ * failure, otherwise the length of the string that would have been
+ * printed into the buffer (in case that there is enough room in
+ * it). See snprintf() return value for more information.
+ */
+int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
+			 struct nlattr **attr, enum nflog_output_type type,
+			 uint32_t flags)
+{
+	/* This is a hack to re-use the existing old API code. */
+	struct nflog_data nfad = {
+		.nfa	= (struct nfattr **)&attr[1],
+	};
+	int ret;
+
+	switch (type) {
+	case NFLOG_OUTPUT_XML:
+		ret = nflog_snprintf_xml(buf, bufsiz, &nfad, flags);
+		break;
+	default:
+		ret = -1;
+		errno = EOPNOTSUPP;
+		break;
+	}
+	return ret;
+}
+
+/**
  * @}
  */
diff --git a/utils/nf-log.c b/utils/nf-log.c
index d575b77..5f2a192 100644
--- a/utils/nf-log.c
+++ b/utils/nf-log.c
@@ -14,6 +14,7 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 	struct nfulnl_msg_packet_hdr *ph = NULL;
 	const char *prefix = NULL;
 	uint32_t mark = 0;
+	char buf[4096];
 	int ret;
 
 	ret = nflog_nlmsg_parse(nlh, attrs);
@@ -31,6 +32,12 @@ static int log_cb(const struct nlmsghdr *nlh, void *data)
 		prefix ? prefix : "", ntohs(ph->hw_protocol), ph->hook,
 		mark);
 
+	ret = nflog_nlmsg_snprintf(buf, sizeof(buf), nlh, attrs,
+				   NFLOG_OUTPUT_XML, NFLOG_XML_ALL);
+	if (ret < 0)
+		return MNL_CB_ERROR;
+	printf("%s (ret=%d)\n", buf, ret);
+
 	return MNL_CB_OK;
 }
 
-- 
2.1.4

