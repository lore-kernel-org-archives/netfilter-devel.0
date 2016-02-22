From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] add JSON output format
Date: Mon, 22 Feb 2016 10:12:17 +0100
Message-ID: <1456132337-23426-1-git-send-email-laforge@gnumonks.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:57487 "EHLO
	ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbcBVJig (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Feb 2016 04:38:36 -0500
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.72)
	(envelope-from <laforge@gnumonks.org>)
	id 1aXma9-0005GO-3R
	for netfilter-devel@vger.kernel.org; Mon, 22 Feb 2016 10:15:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.86)
	(envelope-from <laforge@gnumonks.org>)
	id 1aXmXR-00066T-7i
	for netfilter-devel@vger.kernel.org; Mon, 22 Feb 2016 10:12:17 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the original output format looks a bit like JSON, but isn't.  The XML
output is useful if you deal with XML, but a lot of applications prefer
more lightweight formats like YAML/JSON.

This adds the JSON output format to libnetfilter_acct, which will
subsequently be used by a similar change in the nfacct utility.
---
 include/libnetfilter_acct/libnetfilter_acct.h |  1 +
 src/libnetfilter_acct.c                       | 46 +++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index c6ed858..647490f 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -41,6 +41,7 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
+#define NFACCT_SNPRINTF_T_JSON 2
 
 int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct, uint16_t type, uint16_t flags);
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index bb15c68..b0bcf67 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -297,6 +297,49 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 	return len;
 }
 
+static int
+nfacct_snprintf_json(char *buf, size_t rem, struct nfacct *nfacct,
+		     uint16_t flags)
+{
+	int ret = 0, offset = 0, len = 0;
+
+	if (flags & NFACCT_SNPRINTF_F_FULL) {
+		ret = snprintf(buf, rem,
+			"  { \"pkts\" : %"PRIu64", \"bytes\" : %"PRIu64"",
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES));
+		SNPRINTF_CHECK(ret, rem, offset, len);
+
+		if (nfacct->flags) {
+			uint32_t mode;
+			char *mode_name;
+
+			mode = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_FLAGS);
+			if (mode & NFACCT_F_QUOTA_PKTS)
+				mode_name = "packet";
+			else if (mode & NFACCT_F_QUOTA_BYTES)
+				mode_name = "byte";
+			else
+				mode_name = "unknown";
+
+			ret = snprintf(buf + offset, rem,
+				", \"quota\" : %"PRIu64", \"mode\" = \"%s\""\
+				", \"overquota\" = %u",
+				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_QUOTA),
+				mode_name,
+				mode & NFACCT_F_OVERQUOTA ? 1 : 0);
+			SNPRINTF_CHECK(ret, rem, offset, len);
+		}
+
+		ret = snprintf(buf + offset, rem, ", \"name\" : \"%s\" }",
+			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+	}
+	/* non-F_FULL doesn't seem to make sense in JSON */
+	SNPRINTF_CHECK(ret, rem, offset, len);
+
+	return len;
+}
+
 #define BUFFER_SIZE(ret, size, rem, offset)		\
 	size += ret;					\
 	if (ret > rem)					\
@@ -393,6 +436,9 @@ int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
 	case NFACCT_SNPRINTF_T_XML:
 		ret = nfacct_snprintf_xml(buf, size, nfacct, flags);
 		break;
+	case NFACCT_SNPRINTF_T_JSON:
+		ret = nfacct_snprintf_json(buf, size, nfacct, flags);
+		break;
 	default:
 		ret = -1;
 		break;
-- 
2.7.0

