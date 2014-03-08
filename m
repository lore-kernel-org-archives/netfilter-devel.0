From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH 4/8] ipfix: add functions for ipfix dataset creation
Date: Sat, 8 Mar 2014 10:12:16 +0900
Message-ID: <20140308011210.GE4415@gmail.com>
References: <20140308010344.GA4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56992 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaCHBMZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:12:25 -0500
Received: by mail-pa0-f50.google.com with SMTP id kq14so4883999pab.37
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 17:12:25 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by mx.google.com with ESMTPSA id om6sm42264380pbc.43.2014.03.07.17.12.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Fri, 07 Mar 2014 17:12:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140308010344.GA4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ulogd_key_putn() put key's value in network byteorder.
put_data_records() creates ipfix data records buffer.
---
 output/ulogd_output_IPFIX.c | 84 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
index 7ba8712..16cae74 100644
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
@@ -212,6 +223,75 @@ find_template_for_bitmask(struct ulogd_pluginstance *upi,
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
+	case ULOGD_RET_IPADDR:
+		*(u_int32_t *)buf = htonl(ikey_get_u32(key));
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
+		ulogd_log(ULOGD_ERROR, "don't know sizeof unknown key "
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

