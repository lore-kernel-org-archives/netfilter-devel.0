Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0719A19B3F6
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774597; cv=none; b=AremH2/ijDOzwdSqumpUFCzSLJkApGCtxaUAsyxY/CeQOEcIFVFtLR8DDKW9Sz2rb1QHF4rwPNeG8zpEnZ5eFtJJQpUAYmzzAkbjaVsWEIY7iC4EqcdQOoLZmdFaPRWT7T97q2dZ+MPmSjGdOKeQf+XErmMfYA7PRJEQ5IsfDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774597; c=relaxed/simple;
	bh=LqL9DaQ7VQ+AgtvOv/X6xNTn+AwxOFExF80CiOHxa0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UAy61D05shpu2VbI6iKqomCNt2mmFU3dF5aUSEFUZsIXW7Jyb6ng+JLoEsqiiHuW1jwAY74LKBhkjC7Zq1I0tQ8qhqxEzAAc4DRNsA7CUnuoDZYjOM/5bb6pmV/VbYlgMOpoSU5qsbIPmjT/fk+Ln3n2zzPfnjPQooafe1jFqIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJXpDnd1; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJXpDnd1"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e06ba441cso2646784b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774595; x=1729379395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZHPjSpt6InkI2chKvTg3lHQRRTjz1vX3ht7WO8bTVs=;
        b=KJXpDnd1VueBn8h0kkmN0iu2kTtOsWU5NMHofkNsvJlpkwF+a+OF2v1W7bBvHFZxtW
         78auhmxMkAJxpw3Su//M49GtkdlYUpVtcAkll4SZGe4BS2ChU/joeCzrXCbmVwD0UCvh
         FG6H/ipFweooVDkLKC36jRgIkhZPVX7RtwU+KwQ8aFg8z+BgT/ZCN4+zL3g+JRuswpiz
         c/QCOCugwje/zWnWWeBuJY2CDiaobpaEVcq4d1MfRKulDND43fVaRYE7vYTzF9Q7cDRI
         NoBfHmeZ+50IFWKY0W/y28pgO4eTGSDkR6G2PGpFySytVDK1V7J+QLPr2jEl97f7wnv8
         qDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774595; x=1729379395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QZHPjSpt6InkI2chKvTg3lHQRRTjz1vX3ht7WO8bTVs=;
        b=J/LEk6E3nGHO+Ux2rdmhBeVYR4x17amPttm7MG2RjXVKEsMuOdDHz9IlVRb7GsZ6Xs
         xtwyeIs8RB/uh3DKWwYU81NXuMIPdHHZDlPuJJNgQu1ucOEJ26AYg1Nwy8DBiNaP2o9b
         XyKx1/FCmYNUcL1xSM5/qs9IbRhfNZY6t6Y5jyAsJfy6lwHoh8rzsX4WxAN8vJ8P/lk9
         9BIM+wkMI3qGkDIkfoGGlJCbItbXOTmkAXMMBJcu6DhD2ntyniU+5/sjU/S2sTMBxDXq
         WYsPZYXBNrfhMiNS77HAkYhfSM3Q3JHYkRWckHrpDxUpL4kPzKHyWt1tY1MEC7kRO4gt
         /9AA==
X-Gm-Message-State: AOJu0YzOr19V+o4cPJ770vGdT7seMmhucgWAU3dIgikvh3IL68Ohetgl
	MKsBPbZvc6AR44uQ/sxnjaBbaN/Hlfy3DfpiIoUAjgYnvlPMANiMaoQ+Ow==
X-Google-Smtp-Source: AGHT+IFMMqxn/V0TDsVrDy5qAUVQ9KA6J4VEU963143kSMiaFxBdDEZn0Yj+zk0PhIrabI81ih4xbA==
X-Received: by 2002:a05:6a00:8d0:b0:71e:1875:f16b with SMTP id d2e1a72fcca58-71e37ee1db5mr10994658b3a.16.1728774595376;
        Sat, 12 Oct 2024 16:09:55 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 14/15] include: Use libmnl.h instead of libnfnetlink.h
Date: Sun, 13 Oct 2024 10:09:16 +1100
Message-Id: <20241012230917.11467-15-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
References: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nlif_* prototypes and 64-bit converters to libnetfilter_queue.h.
Update (deprecated) include/libnetfilter_queue/linux_nfnetlink_queue.h
to not include linux/nfnetlink.h (no replacement required)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3:
 - Remove include of linux/nfnetlink.h (not needed)
 - Rebased

 Changes in v2:
 - This was patch 18 v1
 - Update commit message:
   - libnetfilter_queue.c has no libnfnetlink.h references
     (removed in patch 6 v2).
   - Incorporate patch 22 v1

 .../libnetfilter_queue/libnetfilter_queue.h   | 36 ++++++++++++++++++-
 .../linux_nfnetlink_queue.h                   |  3 +-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 9327f8c..46289f2 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -14,7 +14,7 @@
 #define __LIBCTNETLINK_H
 
 #include <sys/time.h>
-#include <libnfnetlink/libnfnetlink.h>
+#include <libmnl/libmnl.h>
 
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
@@ -25,6 +25,7 @@ extern "C" {
 struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
+struct nlif_handle;
 
 extern int nfq_errno;
 
@@ -155,8 +156,41 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
 struct nlmsghdr *nfq_nlmsg_put(char *buf, int type, uint32_t queue_num);
 struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_t flags);
 
+/*
+ * Network Interface Table API
+ */
+
+#ifndef IFNAMSIZ
+#define IFNAMSIZ 16
+#endif
+
+struct nlif_handle *nlif_open(void);
+void nlif_close(struct nlif_handle *orig);
+int nlif_fd(struct nlif_handle *nlif_handle);
+int nlif_query(struct nlif_handle *nlif_handle);
+int nlif_catch(struct nlif_handle *nlif_handle);
+int nlif_index2name(struct nlif_handle *nlif_handle, unsigned int if_index, char *name);
+int nlif_get_ifflags(const struct nlif_handle *h, unsigned int index, unsigned int *flags);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
 
+/*
+ * __be46 stuff - should be in libmnl.h maybe?
+ */
+
+#include <byteswap.h>
+#if __BYTE_ORDER == __BIG_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)     (x)
+#  endif
+# else
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  ifndef __be64_to_cpu
+#  define __be64_to_cpu(x)     __bswap_64(x)
+#  endif
+# endif
+#endif
+
 #endif	/* __LIBNFQNETLINK_H */
diff --git a/include/libnetfilter_queue/linux_nfnetlink_queue.h b/include/libnetfilter_queue/linux_nfnetlink_queue.h
index 6844270..82d8ece 100644
--- a/include/libnetfilter_queue/linux_nfnetlink_queue.h
+++ b/include/libnetfilter_queue/linux_nfnetlink_queue.h
@@ -8,7 +8,6 @@
 #endif
 
 #include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
 
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
-- 
2.35.8

