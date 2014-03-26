From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [ulogd PATCH 4/8] ipfix: add functions for ipfix dataset creation
Date: Wed, 26 Mar 2014 21:23:34 +0900
Message-ID: <20140326122333.GE24689@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <1395600620.23474.18.camel@ice-age2.regit.org>
 <20140326121122.GA24689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43221 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaCZMXl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:23:41 -0400
Received: by mail-pa0-f41.google.com with SMTP id fa1so1865832pad.28
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:23:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140326121122.GA24689@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ulogd_key_putn() put key's value in network byteorder.
put_data_records() creates ipfix data records buffer.

# fixed that ipv4 address value was put by htonl() in ulogd_key_putn()

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 87 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 7ba8712..f032b50 100644
--- a/output/ulogd_output_IPFIX.c
+++ b/output/ulogd_output_IPFIX.c
@@ -63,6 +63,19 @@ struct sctp_sndrcvinfo {
 };
 #endif
 
+#include <byteswap.h>
+#if __BYTE_ORDER == __BIG_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)	(x)
+#  endif
+# else
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)	__bswap_64(x)
+#  endif
+# endif
+#endif
+
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 #include <ulogd/linuxlist.h>
@@ -195,8 +208,6 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 	return tmpl;
 }
 
-
-
 static struct ulogd_ipfix_template *
 find_template_for_bitmask(struct ulogd_pluginstance *upi,
 			  struct nfct_bitmask *bm)
@@ -212,6 +223,78 @@ find_template_for_bitmask(struct ulogd_pluginstance *upi,
 	return NULL;
 }
 
+static int ulogd_key_putn(struct ulogd_key *key, void *buf)
+{
+	int ret;
+
+	switch (key->type) {
+	case ULOGD_RET_INT8:
+	case ULOGD_RET_UINT8:
+	case ULOGD_RET_BOOL:
+		*(u_int8_t *)buf = ikey_get_u8(key);
+		ret = 1;
+		break;
+	case ULOGD_RET_INT16:
+	case ULOGD_RET_UINT16:
+		*(u_int16_t *)buf = htons(ikey_get_u16(key));
+		ret = 2;
+		break;
+	case ULOGD_RET_INT32:
+	case ULOGD_RET_UINT32:
+		*(u_int32_t *)buf = htonl(ikey_get_u32(key));
+		ret = 4;
+		break;
+	case ULOGD_RET_IPADDR:
+		*(u_int32_t *)buf = ikey_get_u32(key);
+		ret = 4;
+		break;
+	case ULOGD_RET_INT64:
+	case ULOGD_RET_UINT64:
+		*(u_int64_t *)buf = __be64_to_cpu(ikey_get_u64(key));
+		ret = 8;
+		break;
+	case ULOGD_RET_IP6ADDR:
+		memcpy(buf, ikey_get_u128(key), 16);
+		ret = 16;
+		break;
+	case ULOGD_RET_STRING:
+		ret = strlen(key->u.value.ptr);
+		memcpy(buf, key->u.value.ptr, ret);
+		break;
+	case ULOGD_RET_RAW:
+		ulogd_log(ULOGD_NOTICE, "put raw data in network byte order "
+			  "`%s' type 0x%x\n", key->name, key->type);
+		ret = key->len;
+		memcpy(buf, key->u.value.ptr, ret);
+		break;
+	default:
+		ulogd_log(ULOGD_ERROR, "unknown size - key "
+			  "`%s' type 0x%x\n", key->name, key->type);
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static int put_data_records(struct ulogd_pluginstance *upi,
+			    struct ulogd_ipfix_template *tmpl, void *buf)
+{
+	int ret;
+	unsigned int i, len = 0;
+
+	for (i = 0; i < upi->input.num_keys; i++) {
+		if (!nfct_bitmask_test_bit(tmpl->bitmask, i))
+			continue;
+		ret = ulogd_key_putn(&upi->input.keys[i], buf + len);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+
+	return len;
+}
+
 static int output_ipfix(struct ulogd_pluginstance *upi)
 {
 	struct ipfix_instance *ii = (struct ipfix_instance *) &upi->private;
-- 
1.8.5.3

