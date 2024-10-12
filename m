Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928B91547CE
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774593; cv=none; b=uD4wC9/A/C3Y4Yz2eRTdt9EWFpLdYOiPHLivxrwQ6jI5Y8nohyaCvXSatMU0OOkWlV1QUxvdWN5WgAxHiwAXGO3Fe9yzvstuzoVMMZUrkCZznwHmqpn8B5uFLQreoO1uj3vQQ5cMGYwJLJF/8LPjuCHpcdgC3H8Pody2A645780=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774593; c=relaxed/simple;
	bh=yVcoUdHuNYoDoMCAStA1S9ZfW+JtshUmf3ZofciTkH4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WwEe2Wu2Tl/bxHaryujpV3m0iv/WyQpsIiireWJ0Y0ovhh6vhQdbnpC7VFvtBI7IPp/8mumyqD5yp8qy81GIFz7pKdgsPH/wi5GycTu+uDTbY+tntOtewT/izkqIyGehTW5xVH543puj+0rpqbRQIJLWWkKbzCF0jxGM1WT8cnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRdhRAoh; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRdhRAoh"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e4e481692so755544b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774591; x=1729379391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYQEoHeQdhC8793BkWJEFYVjrg7FB8ZMcZdvaI+WXNA=;
        b=lRdhRAohIdPYW0pDfUmZ5H7O0vUbmQV5VNNodOCHPJm6ffNyIgz0AvCC5taK9pP4em
         cdbX6d8Gxc0TpYurZLl06hLii7xjbRI29qxIaWK9MLixZzwmKi9QadhQHPB/XAfo/JQB
         Eu/+mo+YN2TfKCELVNa+nTVPgzNs6SvzpQ3Gcp5CFTOs/xhK44dCoUDmEYjKZUEgh+2M
         Ju7vQzgusws6KFeZQN1kh+lu1Jmc0eIuXalKV1GINAokn02HfeaVESrE7+hvdWZPYi2D
         HGq6xUAo76iNQZHckUqJ5rcywyXqto2wiZViKzR/jMd/DrofT2s/0VQTkDplSWWnolkk
         DBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774591; x=1729379391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rYQEoHeQdhC8793BkWJEFYVjrg7FB8ZMcZdvaI+WXNA=;
        b=ZoZMV5TfSJAVnDK3882AbjN6n2NtfwSpPnjuTpf4Qesr1crX+cITD1T6zCT+S5QGpI
         8KK6lV0oD1hY1r0JgIwHkKWjbf9nwbXQ9dPeLjAn4i0KqVWymbYg6oYPu4SM40m9ERD6
         gG9Cr0UKZegWyTYlPfOh9M1lM1nTJWkeX6A0mNQNlM0nNpo460jwX5LNqZia056cuxAb
         v0yW5DM6fVIymcToNAyoTM7qZfHN/0tktkIPXahz8Dsq5SVS8NjjBm+ntRlZY2cuAIUD
         Mv/85yDOuhaR+90fSN5HsXzwFMi2tIgm4ycpo4lsOk/seTMWMdE/Ze4ieVVh2yQaOp8i
         TFEQ==
X-Gm-Message-State: AOJu0YwHcn3hL12pD3FEnzMFSGLElnvvKbX2xu9tCZZfd70DxNUwuUDw
	M3h7oZ3dyE65ACz6WWXYVuWmwKSqR/37RvKIm8sm7zSSLS0fSqcX9sxsAQ==
X-Google-Smtp-Source: AGHT+IF3ZazmfmqeSBrecG+BGJXlsai/xFLn5wqyk/B3ZX/WArd8FUHgEDOBmHabwuFBCYJDvXOfQQ==
X-Received: by 2002:a05:6a00:23c7:b0:71e:695:41ee with SMTP id d2e1a72fcca58-71e4c139383mr6118919b3a.5.1728774590793;
        Sat, 12 Oct 2024 16:09:50 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:50 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 12/15] doc: Add iftable.c to the doxygen system
Date: Sun, 13 Oct 2024 10:09:14 +1100
Message-Id: <20241012230917.11467-13-duncan_roe@optusnet.com.au>
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

iftable.c has a usage description (moved from libnetfilter_queue.c),
but is not yet converted to use libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v3:
 - rebased
 - move doxygen.cfg patch from here to 11/15

 v2: Created from patches 14/32 & 16/32

 doxygen/Makefile.am      |  1 +
 src/iftable.c            | 49 ++++++++++++++++++++++++++++++++++++++++
 src/libnetfilter_queue.c | 38 ++++---------------------------
 3 files changed, 54 insertions(+), 34 deletions(-)

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

