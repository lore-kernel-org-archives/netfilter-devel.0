From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH v3 ulogd 04/12] ipfix: add functions for ipfix dataset
 creation
Date: Tue, 3 Jun 2014 19:08:11 +0900
Message-ID: <20140603100811.GE24668@gmail.com>
References: <20140603100130.GA24668@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49582 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFCKIS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:08:18 -0400
Received: by mail-pd0-f180.google.com with SMTP id y13so4468598pdi.25
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Jun 2014 03:08:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140603100130.GA24668@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ulogd_key_putn() put key's value in network byteorder.
put_data_records() creates ipfix data records buffer.

Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_IPFIX.c | 87 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index a18b0d8..49efb54 100644
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
@@ -182,8 +195,6 @@ build_template_for_bitmask(struct ulogd_pluginstance *upi,
 	return tmpl;
 }
 
-
-
 static struct ulogd_ipfix_template *
 find_template_for_bitmask(struct ulogd_pluginstance *upi,
 			  struct nfct_bitmask *bm)
@@ -199,6 +210,78 @@ find_template_for_bitmask(struct ulogd_pluginstance *upi,
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
1.9.1

