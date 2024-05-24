Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF467EEE7
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529072; cv=none; b=X3i5n44eTaOnsHNNNpnGBh9I8gjdPaeKCfuscw3myY1h955JPSZ1yP/4IQ4RKeTw9DBL9G0Xvc00hhq7feG3i6Ko19w7JBSmdnFo6eQKUng3icntUVRHrecJAadZkKywVThN/aJxTPZ+5Gkwjcwc76fLBrberCeyi0Muh2rc5O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529072; c=relaxed/simple;
	bh=8vHbraDJuBgaz96HXp4wRD3AtOePzw0z6u7h+Ugg75c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AQO25icH7iDAOSzVpAxrV5t5bTsqPukGKbGw8s7UCHheoddOofH9q3SiV/mji7RHy1hZa8y8IbCIz2PkEcohszdamxKezqfR4A7i1rltMTzMRgNmGpBy7c1nnJS0U0BNCF+83GOWE/y50zQkFAxDQll09jfJVlnxJZfxY+9Yleg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SZu4/hu6; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZu4/hu6"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f8e98760fcso479071b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529070; x=1717133870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qO6rCQBgYPlIMZwi7ywJLde9Snohe4MqyM6CiIF/pcE=;
        b=SZu4/hu674BsOuP4OAWlAKgiHe/BBqK4gNH2Ir3TQjY0TaauGys/KAqFplT+tvAAVA
         8rcRWnXuPJtmDys4ms3k0ne7DaniCWzpDc0MGrZQrH5yrP6tNbC3P+kb6bdtqnKH89Uj
         iYmLoS9X27N9kMa5p41vPDwjpVnWdbwQf96YY8MHQC6qIkMm0vp+ZtXNX2PQKtIYKSWb
         fbtIE4p4QGPAmgRUa2hYmMTwH9O6rjX0hmhOwc+aR0Ruu9kunNx1k4kaKjfT73Nr5VQ1
         dUXNH3EU2RQZspthJ3dBg1u0LIB28Y0nd5emwIraHs2XGdcCTN5HLM1N4Pcl0jmO/DRz
         zz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529070; x=1717133870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qO6rCQBgYPlIMZwi7ywJLde9Snohe4MqyM6CiIF/pcE=;
        b=tR6bZoPXAUx4krH9lk1VjdFeYWo19ZYdx5olhrEd7t8vmfGsysQPoSPonhe8U1qhWn
         ZjJYRrqutN3qKzIyyMh1JXwmlL2xLBA4mHWLj+uqJNgNbRQqh7nfj3Zo2gCU+zu9TjfI
         Gq9Hm7kIpW4i7iscnJagNQ4YNjHAf9QQkA7oLCH2q2mSGJb1M/1QSUVWHZPPJF4KaR0j
         o8aBkE7hP7eoRHWR9arFRIUtmzzzOUxinRzgNO16nxxC9h2yXFWsT7mh1frayovcX+ja
         yXOCn+bp9AjPoCdu9xkRcojyaykbJ4DOtt4Ca8LtZzeP7fR4RMFQfiz0hWoLJWGpcYuS
         S44Q==
X-Gm-Message-State: AOJu0YwereM2PUyZ+sQjv5MYx/wUqgolpTXhkVtTsflycHO80nnRtbKB
	c5Sc2paezQXvNGX19gpe+UrXPGqxe9JzWDryWrbBYgDW4xMSUp7Ymf6vgw==
X-Google-Smtp-Source: AGHT+IH5tGVL8w05RVQ5F+N7L6j5xw8RBG3iAnD64zxWIrkZ9JnEWOeQBdkAKXbOgtmBb1mMlH93nA==
X-Received: by 2002:a05:6a00:28cd:b0:6ed:5f64:2ffa with SMTP id d2e1a72fcca58-6f8f194abd8mr1914290b3a.0.1716529069617;
        Thu, 23 May 2024 22:37:49 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:49 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 01/15] src: Convert nfq_open() to use libmnl
Date: Fri, 24 May 2024 15:37:28 +1000
Message-Id: <20240524053742.27294-2-duncan_roe@optusnet.com.au>
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

Add copies of nfnl_handle, nfnl_subsys_handle & mnl_socket to
libnetfilter_queue.c. After calling mnl_socket_open() & mnl_socket_bind(),
fill in the libnfnetlink structs as if nfnl_open() had been called.
Call a static extended version of nfq_open_nfnl(), __nfq_open_nfnl() which
can tell how it was called via an extra argument: struct nfq_handle *qh.
nfq_open() passes the qh returned by mnl_open(). nfq_open_nfnl() passes
NULL.
__nfq_open_nfnl() creates and returns a qh if it wasn't given one.
Otherwise it returns the qh it was given or NULL on error (but the
passed-in qh is not freed).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v2:
 - Rather than inline nfnl subsys code, minimally modify nfq_open_nfnl()
   as per updated commit message
 - Replace NFNL_BUFFSIZE with MNL_SOCKET_BUFFER_SIZE
 - Use calloc instead of malloc + memset in new code
 - Don't rename struct nfq_handle *qh to *h
 - Fix checkpatch space before tab warnings in lines 143,147,159,165
 - Keep nfq_errno
 doxygen/doxygen.cfg.in   |  3 ++
 src/libnetfilter_queue.c | 86 ++++++++++++++++++++++++++++++++++------
 2 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 97174ff..6dd7017 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -13,6 +13,9 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         nfnl_handle \
+                         nfnl_subsys_handle \
+                         mnl_socket \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..f366198 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -31,6 +31,7 @@
 #include <sys/socket.h>
 #include <linux/netfilter/nfnetlink_queue.h>
 
+#include <libmnl/libmnl.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
@@ -134,11 +135,43 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * burst
  */
 
+/* Copy of private libnfnetlink structures */
+
+#define NFNL_MAX_SUBSYS 16
+
+struct nfnl_subsys_handle {
+	struct nfnl_handle	*nfnlh;
+	uint32_t		subscriptions;
+	uint8_t			subsys_id;
+	uint8_t			cb_count;
+	struct nfnl_callback	*cb;	/* array of callbacks */
+};
+
+struct nfnl_handle {
+	int			fd;
+	struct sockaddr_nl	local;
+	struct sockaddr_nl	peer;
+	uint32_t		subscriptions;
+	uint32_t		seq;
+	uint32_t		dump;
+	uint32_t		rcv_buffer_size;	/* for nfnl_catch */
+	uint32_t		flags;
+	struct nlmsghdr		*last_nlhdr;
+	struct nfnl_subsys_handle subsys[NFNL_MAX_SUBSYS+1];
+};
+
+/* Copy of private libmnl structure */
+struct mnl_socket {
+	int			fd;
+	struct sockaddr_nl	addr;
+};
+
 struct nfq_handle
 {
 	struct nfnl_handle *nfnlh;
 	struct nfnl_subsys_handle *nfnlssh;
 	struct nfq_q_handle *qh_list;
+	struct mnl_socket *nl;
 };
 
 struct nfq_q_handle
@@ -157,6 +190,9 @@ struct nfq_data {
 
 EXPORT_SYMBOL int nfq_errno;
 
+static struct nfq_handle *__nfq_open_nfnl(struct nfnl_handle *nfnlh,
+					  struct nfq_handle *qh);
+
 /***********************************************************************
  * low level stuff
  ***********************************************************************/
@@ -383,20 +419,41 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_handle *nfnlh = nfnl_open();
 	struct nfq_handle *qh;
+	struct nfq_handle *h;
 
-	if (!nfnlh)
-		return NULL;
-
-	/* unset netlink sequence tracking by default */
-	nfnl_unset_sequence_tracking(nfnlh);
-
-	qh = nfq_open_nfnl(nfnlh);
+	qh = calloc(1, sizeof(*qh));
 	if (!qh)
-		nfnl_close(nfnlh);
+		return NULL;
+	qh->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (!qh->nl)
+		goto err_free;
+
+	if (mnl_socket_bind(qh->nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		goto err_close;
+
+	/* Manufacture an nfnl handle */
+	qh->nfnlh = calloc(1, sizeof(*qh->nfnlh));
+	if (!qh->nfnlh)
+		goto err_close;
+	qh->nfnlh->fd = qh->nl->fd;
+	qh->nfnlh->local = qh->nl->addr;
+	qh->nfnlh->peer.nl_family = AF_NETLINK;
+	qh->nfnlh->rcv_buffer_size = MNL_SOCKET_BUFFER_SIZE;
+
+	h = __nfq_open_nfnl(qh->nfnlh, qh); /* Will return qh or NULL */
+	if (!h)
+		goto err_free2;
 
 	return qh;
+
+err_free2:
+	free(qh->nfnlh);
+err_close:
+	mnl_socket_close(qh->nl);
+err_free:
+	free(qh);
+	return NULL;
 }
 
 /**
@@ -415,6 +472,11 @@ struct nfq_handle *nfq_open(void)
  */
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
+{
+	return __nfq_open_nfnl(nfnlh, NULL);
+}
+static struct nfq_handle *__nfq_open_nfnl(struct nfnl_handle *nfnlh,
+					  struct nfq_handle *qh)
 {
 	struct nfnl_callback pkt_cb = {
 		.call		= __nfq_rcv_pkt,
@@ -423,11 +485,10 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 	struct nfq_handle *h;
 	int err;
 
-	h = malloc(sizeof(*h));
+	h = qh ? qh : calloc(1, sizeof(*h));
 	if (!h)
 		return NULL;
 
-	memset(h, 0, sizeof(*h));
 	h->nfnlh = nfnlh;
 
 	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
@@ -448,7 +509,8 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 out_close:
 	nfnl_subsys_close(h->nfnlssh);
 out_free:
-	free(h);
+	if (!qh)
+		free(h);
 	return NULL;
 }
 
-- 
2.35.8

