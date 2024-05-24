Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4048184D11
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529091; cv=none; b=Va0HPCZ2UHJy8+HHGZAT+ZqrkKKWjkzpHhkWoIJQxslGOg8lgKfwxnsmrzGwSKcujQ+9OssxVy8NuPPJF9EA0XtxP6TA9G63C141vctuahcTigOHgHVwO/eB83xnYW/jXT9I9H2J4K5Rp82OkmmNrnlIEoH0gXxxq7wAcRm9RCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529091; c=relaxed/simple;
	bh=fJs6ADc0gKqH0TlYdqzQxOJ5vlyVgunekpTcL2WwgpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ibeA/cxT46vGu8Cfdmkn2iCSM3GPm/fJKaO7RBNmqMZ0n6ce3G94p6ujs0H/rFlrUS/c0z2oBzs4xfZAAHJQ9tJu3YSH5OvOjeXeVfYlKm7m7Nv+WzNlUl4C3pbGV9glQV3BmEx/Q66tHbx0kFYxdaCL2DCVrQHqfXqFuSnI1TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxBWBzxA; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxBWBzxA"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-681953ad4f2so416734a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529089; x=1717133889; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzY2N2YVmt4iIeyenqo1Ylmjm4TD7eVnSjs8ysjF1Io=;
        b=hxBWBzxAnSxJZJLd5SuZjN86b7gNQmTICPbmISbU64Goj/Ea06c3Tb3SS7I2Qrl5cU
         seebRsI+OqWq2h981Cen86m8IgIV+YQhQwKNqiqvabCiF+M1TXBvJA6Fg7y0ioztWdqw
         xopKZ7j2jZs518zMk/A5AeQsM6EbhDcbZK5KY+IgkrANOHD/ZUt/Ymj/4pHj7Qd8m1+k
         sPC6Yyw7lRJBHzB5VQrQzLa4jnb9GFB+U56qG+MnBjrFPsEWRQo1wCJOq/NxFNAV+5fL
         YtHec716HLUJgxE654C42LzAk6p6F6yuOmx8SonwpwGPZAFIkyJ8r+IE/hZyltyt+8VD
         fR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529089; x=1717133889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jzY2N2YVmt4iIeyenqo1Ylmjm4TD7eVnSjs8ysjF1Io=;
        b=izjU8PtYPRX5YTV2h9W7ast6OlEIff+7CWX3EbJ6MkMmCzhN5MiDwB/fNJ+tTjzcZm
         V5qORwA+sS+J5EZJ6nQOUvnHwmYrRH3TrHFIZQJv/6zzexge+biI4O8xo+QF7y/LBRIa
         d7bzzodF92ztwXjvGeHxz6nCvSwIibXts8pegU22VsM6Ffj8AklLoLNK1dTR/bdW+Zfp
         wbSNnq7N7OLYWLwmsQVmMj6VYEQRn84qYcuHgkAgzBMJdtpu8TcwdlHvj81pHbQvgDOy
         V4FOb/3gTy2fiDpFhmLTO0YnBZAy5Dav2okxlcx7EMmyan6ezBArtQQsjboLf7QDizNd
         k3Nw==
X-Gm-Message-State: AOJu0YyWZMGk3BEyqLkyK5nfRvufj2orO6/Dm9qkB/UqrFp9EBkbFdLn
	baEOT+XK95J0UkJvMudpRg5oPdbTgIpn6KnnGRait3kb1yBS8yDaFXTIRQ==
X-Google-Smtp-Source: AGHT+IEY1Zt2aLJ1QPfA+8IosLQKCrgxyUDI+KoxkC4oW/I/kUCAAHHVk/IAgqlArUx3W2mIVGKFUw==
X-Received: by 2002:a05:6a21:1693:b0:1b2:184d:c19d with SMTP id adf61e73a8af0-1b2184dc329mr337379637.20.1716529089328;
        Thu, 23 May 2024 22:38:09 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:09 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 12/15] doc: Add iftable.c to the doxygen system
Date: Fri, 24 May 2024 15:37:39 +1000
Message-Id: <20240524053742.27294-13-duncan_roe@optusnet.com.au>
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

iftable.c has a usage description (moved from libnetfilter_queue.c),
but is not yet converted to use libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v2: Created from patches 14/32 & 16/32

 doxygen/Makefile.am      |  1 +
 doxygen/doxygen.cfg.in   |  2 ++
 src/iftable.c            | 49 ++++++++++++++++++++++++++++++++++++++++
 src/libnetfilter_queue.c | 38 ++++---------------------------
 4 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 68be963..a6cd83a 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -2,6 +2,7 @@ if HAVE_DOXYGEN
 
 doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c\
            $(top_srcdir)/src/nlmsg.c\
+           $(top_srcdir)/src/iftable.c\
            $(top_srcdir)/src/extra/checksum.c\
            $(top_srcdir)/src/extra/ipv4.c\
            $(top_srcdir)/src/extra/pktbuff.c\
diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index fcfc045..bf6cba8 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -16,6 +16,8 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfnl_handle \
                          nfnl_subsys_handle \
                          mnl_socket \
+                         ifindex_node \
+                         nlif_handle \
                          nfnl_callback2 \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
diff --git a/src/iftable.c b/src/iftable.c
index 4673001..9884a52 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -29,6 +29,55 @@
  * \defgroup iftable Functions to manage a table of network interfaces
  * These functions maintain a database of the name and flags of each
  * network interface.
+ *
+ * Programs access an nlif database through an opaque __struct nlif_handle__
+ * interface resolving handle. Call nlif_open() to get a handle:
+ * \verbatim
+	h = nlif_open();
+	if (h == NULL) {
+		perror("nlif_open");
+		exit(EXIT_FAILURE);
+	}
+\endverbatim
+ * Once the handler is open, you need to fetch the interface table at a
+ * whole via a call to nlif_query.
+ * \verbatim
+	nlif_query(h);
+\endverbatim
+ * libnetfilter_queue is able to update the interface mapping
+ * when a new interface appears.
+ * To do so, you need to call nlif_catch() on the handler after each
+ * interface related event. The simplest way to get and treat event is to run
+ * a **select()** or **poll()** against the nlif and netilter_queue
+ * file descriptors.
+ * E.g. use nlif_fd() to get the nlif file descriptor, then give this fd to
+ * **poll()** as in this code snippet (error-checking removed):
+ * \verbatim
+	if_fd = nlif_fd(h);
+	qfd = mnl_socket_get_fd(nl); // For mnl API or ...
+	qfd = nfq_fd(qh);            // For nfnl API
+	. . .
+	fds[0].fd = ifd;
+	fds[0].events = POLLIN;
+	fds[1].fd = qfd;
+	fds[1].events = POLLIN;
+	for(;;)
+	{
+		poll((struct pollfd *)&fds, 2, -1);
+		if (fds[0].revents & POLLIN)
+			nlif_catch(h);
+\endverbatim
+ * Don't forget to close the handler when you don't need the feature anymore:
+ * \verbatim
+	nlif_close(h);
+\endverbatim
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
  * @{
  */
 
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ecdd144..970aea2 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1324,34 +1324,7 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  * \return -1 in case of error, >0 if it succeed.
- *
- * To use a nlif_handle, You need first to call nlif_open() and to open
- * an handler. Don't forget to store the result as it will be used
- * during all your program life:
- * \verbatim
-	h = nlif_open();
-	if (h == NULL) {
-		perror("nlif_open");
-		exit(EXIT_FAILURE);
-	}
-\endverbatim
- * Once the handler is open, you need to fetch the interface table at a
- * whole via a call to nlif_query.
- * \verbatim
-	nlif_query(h);
-\endverbatim
- * libnfnetlink is able to update the interface mapping when a new interface
- * appears. To do so, you need to call nlif_catch() on the handler after each
- * interface related event. The simplest way to get and treat event is to run
- * a select() or poll() against the nlif file descriptor. To get this file
- * descriptor, you need to use nlif_fd:
- * \verbatim
-	if_fd = nlif_fd(h);
-\endverbatim
- * Don't forget to close the handler when you don't need the feature anymore:
- * \verbatim
-	nlif_close(h);
-\endverbatim
+ * \sa __nlif_open__(3)
  *
  */
 EXPORT_SYMBOL
@@ -1370,9 +1343,8 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
  * \return  -1 in case of error, > 0 if it succeed.
+ * \sa __nlif_open__(3)
  */
 EXPORT_SYMBOL
 int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
@@ -1390,9 +1362,8 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
  * \return  -1 in case of error, > 0 if it succeed.
+ * \sa __nlif_open__(3)
  */
 EXPORT_SYMBOL
 int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
@@ -1410,9 +1381,8 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
  * \param name pointer to the buffer to receive the interface name;
  *  not more than \c IFNAMSIZ bytes will be copied to it.
  *
- * See nfq_get_indev_name() documentation for nlif_handle usage.
- *
  * \return  -1 in case of error, > 0 if it succeed.
+ * \sa __nlif_open__(3)
  */
 
 EXPORT_SYMBOL
-- 
2.35.8

