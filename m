Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D727514A85
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488066; cv=none; b=LBrexdZIMZc/wEAKlvYIgAbLV49Os92VsiODy6XASRaQnw98ToHHYote1B1+7Rr+9DsoawsTS1r2ryx2qx9H2s5UfQ8wroU6CihdHj6DA9OSKaZFXjASLQdE0n9ZOIpWUwhyAVA61xu/0PgtyOLKYE2OgEBWq13S43oT/QTptPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488066; c=relaxed/simple;
	bh=jaR3wjc2OgZOShylmLGfdXFuWpq8oWtjTe0ycI8e5cs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vl1nbyeYUDucuzO4+6eAKYAKubTz1k+qjhm4sB6plz1cOGqRaz78vVX+cNeBsTSq540HqQJsLIIkoYk0Z7AMZA7ly6As4Npvq4eV2lLCI5efeKs1AX+d44W2tjU7H2rFOcfX0mqjBRgkdZHctNHT3rH04odOSRhI4/I37CRNkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AL/Uj7o4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AL/Uj7o4"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dc09556599so13750605ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488064; x=1711092864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/DdjvB+Mkwzkbfzaj9UathWQckK32XWY8+QILj3yjw=;
        b=AL/Uj7o4j0cBtfcTxNomM/WlANzcLwYeFD2UKENyl4CmwaSIIOpSkqlVHePQCN5JTZ
         5O7Bz1LPzXF6tNUHpno0jdJOTG4mFlqszm0gLo3w9eAIaChspfH2pAGbOnXnclSl8fdn
         qvB/9N0a6lY2RUyO3eFmYP/O+JkaaLVUw35mG5FFHcQS0eLWeu1ZrcStCGPdoudVYj1P
         njxjvhYnrqIiq/CniVhL7lEQU0wwdyDabn9raLdPxOOk24gxKCmvmGm1VhO7OJRN28SR
         1hAIGSDgfZrVGfCmJvXdzhPBNv9H+VjearxElfXpnz1ol+/2WPfWoc/mcbuRL4ppF4uW
         WaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488064; x=1711092864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z/DdjvB+Mkwzkbfzaj9UathWQckK32XWY8+QILj3yjw=;
        b=rOyFa3ooI2EPewQVh3sYsvbLLWgrWkXkpe2z11cX1NsVGgGCGnHpp1tO6F4EJOXvsL
         JMn5aUjldHMEdzH7pKugQQ0qSkaWHeXb0OujztkqNt0k147p8TXgH+au+zyXd4jgIqLZ
         L3jMRM3hMOhj6ObOG7Gkhoh+wzyRH4U/bJltMuJFX6qKnsIzIcTl3WRtR8k1XkUBgAAW
         2jWMd2j51ieu+cKdt2HJ/NQ9DngKnV4XcMtJcd5fcnITNfh99NNUjThAKxmtKkN7K4aP
         FcRgg5pQg9jgpyrGqnNdJXgElgj9TskcoGwv3ftC0I6NMaxF5AJ8B0Fb5rlgKF2wedg7
         FmuQ==
X-Gm-Message-State: AOJu0YzCfbLKXkWs5ZYpp61nba/PkbDzQij5NI4VHyFm4VHZsY7NdTe7
	uMt66FqnCPFooVcLYyj69U4u4dLx6+gv29dyETtcfNF31z4Yc5AuhkGjXSnT
X-Google-Smtp-Source: AGHT+IGIfABN1sBF6I0G41UWRcbggKGoOJ1YWZbSgKNKPNBHWQd5kGUc0SvZfG7fh1Nr5RLET8h9vw==
X-Received: by 2002:a17:902:7488:b0:1de:dd0d:69e with SMTP id h8-20020a170902748800b001dedd0d069emr2542939pll.35.1710488064359;
        Fri, 15 Mar 2024 00:34:24 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:24 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 18/32] include: Use libmnl.h instead of libnfnetlink.h
Date: Fri, 15 Mar 2024 18:33:33 +1100
Message-Id: <20240315073347.22628-19-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nlif_* prototypes and 64-bit converters to libnetfilter_queue.h.
Fix a couple of libnfnetlink.h references still in libnetfilter_queue.c.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   | 36 ++++++++++++++++++-
 src/libnetfilter_queue.c                      |  4 +--
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 9bd9c43..84a8a7e 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -14,7 +14,7 @@
 #define __LIBCTNETLINK_H
 
 #include <sys/time.h>
-#include <libnfnetlink/libnfnetlink.h>
+#include <libmnl/libmnl.h>
 
 #include <libnetfilter_queue/linux_list.h>
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
@@ -26,6 +26,7 @@ extern "C" {
 struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
+struct nlif_handle;
 
 extern int nfq_errno;
 
@@ -156,8 +157,41 @@ int nfq_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
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
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 2f50b47..3c3f951 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -151,7 +151,7 @@ struct nfnl_subsys_handle {
 	uint32_t		subscriptions;
 	uint8_t			subsys_id;
 	uint8_t			cb_count;
-	struct nfnl_callback	*cb;	/* array of callbacks */
+	struct nfnl_callback2	*cb; /* Not an exact copy: array of callbacks */
 };
 
 struct nfnl_handle {
@@ -479,7 +479,7 @@ struct nfq_handle *nfq_open(void)
 	h->nfnlh->fd = h->nl->fd;
 	h->nfnlh->local = h->nl->addr;
 	h->nfnlh->peer.nl_family = AF_NETLINK;
-	h->nfnlh->rcv_buffer_size = NFNL_BUFFSIZE;
+	h->nfnlh->rcv_buffer_size = MNL_SOCKET_BUFFER_SIZE;
 
 	if (!fill_nfnl_subsys_handle(h))
 		goto err_close;
-- 
2.35.8

