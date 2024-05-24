Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AFD84DEB
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529095; cv=none; b=EI4QNlS92/768/2MO3fUXe19PzD6xVmEyoasUTQnFeTjFGKZHGQziLsRYHZsziFafBlZxnXc3R3oBqw8FKH88S0s6ZJeVcylAtHDzgTymx52FtmJDROIILpqoMUNSbaeIp/UOusII997JD0P6XwMqyfSRiyWXgCDvAc67LzYtDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529095; c=relaxed/simple;
	bh=x3KcHBcdax96IN/Tjz5Tf0+Dt5SKrQFAdQngqMcC/0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W+4DdvNBrCVoE+iMSSgcrSMzz3wTL7Y+H4TVG/myZEk+ZZTFTZ+SKqoH7m44qgX2O08b35A3D0+IxLCaeBC7zmVHO/Zc8fdg3HfbbMId3QjRvqz9SpSBsRA9R5WwXfWsndHPlmQbtyIOxC6cCHqgyBMCZ055SuLqGIsELsTNCnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EM4/6rEg; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EM4/6rEg"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f8ec7e054dso358760b3a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529093; x=1717133893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6MOJ7at8deTEk7SDAya3sab5LrvfIJZTyOavfIVR2E=;
        b=EM4/6rEg5Hzlg7p32IIBe6vpdGKiZrMy/1dnKPLc22B+n23kM3awCO7i5W0hzuiGBb
         o0x9RaDEF5BCgLc5guKmUKM64wZJxWQcWeOOwbWwaSSIiSIiuc/ttmGrX1HB4w2M0iGT
         umDsrafSRuqiX1HVTLYo0TZYiL4nKRPxLT9y10E+IXJCoHuxRBbT6szbRzCwsxWF6uqa
         /u8bk+exJNkq7HLk7rsj7MaZA/Mv/BToxfL5Ys82gmam2HFauXPoghsJfVzX/BC1x1ix
         CxErlI8+TJ3DPeyzEzwYO7KvpT7rAmjnE6D7NS4NW4rkALqs9b0Z1y07fs0VrxfndPFe
         ob1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529093; x=1717133893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J6MOJ7at8deTEk7SDAya3sab5LrvfIJZTyOavfIVR2E=;
        b=gLfAhzpNXDn92FeIhePS/lK2Pr+xj07ip4q0ABc6eCHg3oiQ9e77vv487hL+dWNL6L
         IRI0J9t+VpVW0Twemj15QPtiWYwypx6V2JEut4zOmHfM/cNAWSKKXZkbuRFVKv5hiFe3
         HGuj6jAPGvjoz2ohpy22ZYdKdUUyGTcZWCz/McHhF9Ner8UEiSbkvtABObkK1+2q7wl2
         XQKJWCWVhd11BliHsA9WM+pYwwVblltm6+dE84coacH0Tqmr5ohyP/da6/lyFMBOTUPp
         47mdx/FuMiP1rwYu7bCk9ObdRvf8OJ1km7/gLsdbXupjcuhnchn9E7ZMp7l2cI1/cIys
         bUzQ==
X-Gm-Message-State: AOJu0YwwArxds48sD5Vhxvu1Oc/v62CLRisdimcrF1IcOaOqEuwmujdF
	I7HKJngb+6GMDybKEmHjnJxthJ/62QxDS/2z/XiL41Ido9vH8XDPpxc/TQ==
X-Google-Smtp-Source: AGHT+IHSd1OnKzrUTyXumbKafz2KmQy1Z9Kn+q1+5oYyzsJPp17StkutzqKnFrJk1yHU5/VRO8XTig==
X-Received: by 2002:a05:6a00:4c8b:b0:6ea:9252:435 with SMTP id d2e1a72fcca58-6f8f3d70f73mr1845891b3a.30.1716529093021;
        Thu, 23 May 2024 22:38:13 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:12 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 14/15] include: Use libmnl.h instead of libnfnetlink.h
Date: Fri, 24 May 2024 15:37:41 +1000
Message-Id: <20240524053742.27294-15-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
References: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nlif_* prototypes and 64-bit converters to libnetfilter_queue.h.
Update (deprecated) include/libnetfilter_queue/linux_nfnetlink_queue.h
to use /usr/include/linux/nfnetlink.h
instead of libnfnetlink/linux_nfnetlink.h
As an aside, everything compiles fine with this line removed
(i.e library, utils and examples all compile),
so maybe we can do without it.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
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
@@ -8,7 +8,8 @@
 #endif
 
 #include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
+/* Use the real header since libnfnetlink is going away. */
+#include <linux/nfnetlink.h>
 
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
-- 
2.35.8

