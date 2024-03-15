Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E8714AA7
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488078; cv=none; b=hzWTxTa09tXd37Gg9GPY7f6kY4NbGCiQTfzxwoErt82LN8tbk4an+EiL48XrebwobfpGELTeSrbHLaUa2kKeYzmJTZCg8sdSJEbOULnYr+QI9/JoiIezmknGtRIpYAgpLlcnuU0Pi1i2yk89O+9UKNmlzfuAnd71S1NwS6zE7+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488078; c=relaxed/simple;
	bh=x7BNHLetHczviLxxlsaORuVUR2Za6OYBcoOdeod3+PI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m57MWfhbOwUJSxPjFNLtiNAeLdL7q3AueCQEOr/0dDYvLd+8rCI/e9p5GT3to5x2m/+Af/zHV48DF3/9jcS+ZPKX0bgZfF2F39woQJXk4Cy1fT1j+/fFHJncKHz/i8pfS+e0joZw/VXCYjsqmkLuzi5dKuoZQcR0+q0Ax+qb68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNLoOQ9k; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNLoOQ9k"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ddbad11823so17130805ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488076; x=1711092876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kwzj5vrP70LsoBkoE62ahnND2nSVRU+qwpH3l30vyLc=;
        b=UNLoOQ9kQkytWM8jsFeapchnOaYDkPiYheHySDco/4ZlumYUjDBh5Dg61MmOHqQKYh
         EFqRJqitdb9F66sSN8EmrZbUuaJWAv66bP12oCIjE4LtHIpB476gCT7bLCd2C+kgSIb4
         e7gLMAvwXJtMgntiakd5cUnL5SwqZsH7VQXAsow9VsoHnvJ8y451lca3vMtFf0V3xy/w
         vuSLU8ca2ZTjpa88K4kx5WGPwOObCFlyhYXayLOzLZQ6S+vAHpT2htKS82yTZlhdB49q
         sTAldCJuYmep60yZi/qat07iPcUmESYLgepswqtpjwY0hodGPawtGPkccieTBWwdMY8A
         dF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488076; x=1711092876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kwzj5vrP70LsoBkoE62ahnND2nSVRU+qwpH3l30vyLc=;
        b=K0xziuNEHV7N9SvjcWPKbxUbmjzzg+TX+hhanMJPe7H9lOfikssXv600ijb4eyqfFt
         35Itotf38ZZDoZuS8yO1WRZAjofVcxiCNDzb01DFVOnKHLHpiuaqzCx6TVC8isx2xmOr
         eXrgcfKh6jl8D6KPJ5KxrWurl2uGQ3wy3vEKhJm/eCAd/K0DsmJGZ12Mn4lF5JwT8F3J
         iRn9lnmDGMeq3LsDn7iYTPwHxnoGnrp0oBVR9oSR777XttBNMvYF/RvVyD2upbsVO7N0
         qUZMfoZBZ+zE8i8nNfnQ4wlZG+I03owJPhQg6evuwfvCNeF6bE3AgT/cY5CtX44BmFbM
         BqrA==
X-Gm-Message-State: AOJu0YznYynnPIvcZID2x2qF1u/w8TbttTWYA8gte+TDzYCkLGPPGu2M
	UXYvindvJ5enAk2aDnqd6apNZJNnimF6j1z3Y8ruYZS6CaQ5EnZpznxKFGn4
X-Google-Smtp-Source: AGHT+IGHNUEpaJVEuqDmWp81j3w9YhjJ0E3pIFavrdtQZ5yEnxJ6a9XtmwjD/OxA4cKc8DBu48NxTA==
X-Received: by 2002:a17:903:1205:b0:1dc:b16c:63fd with SMTP id l5-20020a170903120500b001dcb16c63fdmr4713353plh.65.1710488076351;
        Fri, 15 Mar 2024 00:34:36 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 25/32] doc: Move nlif usage description from libnetfilter_queue.c to iftable.c
Date: Fri, 15 Mar 2024 18:33:40 +1100
Message-Id: <20240315073347.22628-26-duncan_roe@optusnet.com.au>
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

Also in iftable.c:
 - Expand usage description to cover nlif_catch.
 - Add SYNOPSIS.
 - Fix some doc typos.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/iftable.c            | 57 ++++++++++++++++++++++++++++++++++++----
 src/libnetfilter_queue.c | 38 +++------------------------
 2 files changed, 56 insertions(+), 39 deletions(-)

diff --git a/src/iftable.c b/src/iftable.c
index 76a6cad..1a53893 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -42,6 +42,55 @@ static int data_cb(const struct nlmsghdr *nlh, void *data);
  * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/)
  * calls directly to maintain an
  * interface table with more (or less!) data points, e.g. MTU.
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
 
@@ -128,8 +177,8 @@ int nlif_get_ifflags(const struct nlif_handle *h,
 /**
  * nlif_open - initialize interface table
  *
- * Open a netlink socket and initialize interface table
- * Call this before any nlif_* function
+ * Open a netlink socket and initialise interface table.
+ * Call this before any other nlif_* function
  *
  * \return NULL on error, else valid pointer to an nlif_handle structure
  */
@@ -191,8 +240,6 @@ void nlif_close(struct nlif_handle *h)
 /**
  * nlif_catch - receive message from netlink and update interface table
  *
- * FIXME - elaborate a bit
- *
  * \param h pointer to nlif_handle created by nlif_open()
  * \return 0 if OK
  */
@@ -218,7 +265,7 @@ int nlif_catch(struct nlif_handle *h)
 /**
  * nlif_query - request a dump of interfaces available in the system
  * \param h: pointer to a valid nlif_handler
- * \return -1 on err with errno set, else >=0
+ * \return -1 on error with errno set, else >=0
  */
 EXPORT_SYMBOL
 int nlif_query(struct nlif_handle *h)
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 3c3f951..1be2333 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1284,34 +1284,7 @@ uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
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
@@ -1330,9 +1303,8 @@ int nfq_get_indev_name(struct nlif_handle *nlif_handle,
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
@@ -1350,9 +1322,8 @@ int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
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
@@ -1370,9 +1341,8 @@ int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
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

