Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8951F14A85
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488063; cv=none; b=lWW7JcBSnRbPiuILq6V8P9kjo5tIefOzTbcElpfndUGu1L6gwU39NY3K2+3y7zWzBx0LD1IxrknNvTIaRnZASfbqVgZLTY2liLbSpOSix2bbOpC+Gt7d9hvSyiNkZgPeRlT+PiJ/UfkwMOmY21O/jm7dzf7L7PNLZVvykDrc6+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488063; c=relaxed/simple;
	bh=+unOQBAmyxJwAPAyHEXln646fHS1u8+SlXcWxPFvM2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NKYxgD4uBbVAa4ql9wX1/56MCoBcMvnPzH142Qjyh+QWrYPR2wfMN97o9S+Gv/LQmYoaUfpX6LHJ1Uhyp0zx4OmviRWqY4nRcBwNIri4DKulSHC7s00AjwHeowo4Wb709s9OKjg2jMSNSNG0nqNpFF7I/6a1Li4DhjXpeB0vgb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP6FUgyC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP6FUgyC"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dddaa02d22so10631515ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488061; x=1711092861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AyVHAJyPnrM/VoHLS8CGX/CCj2rQDTgEjo62/b140xU=;
        b=DP6FUgyC5FdKsSzbkM1eRi18yWehiOubR7Om8mkuiEjWH9S6yk/FFg8o4eZHlMGbXy
         nDmkJkX6pJWl4v7YgomnVcg+ZfvSZn01VDUtM6pV+ysc0WQ5571uMH5UdZX7A2kqsT+N
         9WLAqLPBE1J7LIcbYTrCJ76mmVTI0RzoCHI9irDWnu4wGh/szjKs5ea+ENxbCXoGaaGG
         79XK7Sm5lDCic3/kBkUSGtoKf80ySPlrFn4Z3KEpoOsxb7qnqm/mE/mB6Ja5iqCsIjlA
         ZKGzCwFIB5gcacJGlzWuLFzIBDmH3ZyhKSPWGeLv40cGwhed+tFuY0TloKykz3KvT0P3
         d+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488061; x=1711092861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AyVHAJyPnrM/VoHLS8CGX/CCj2rQDTgEjo62/b140xU=;
        b=J0njBQiQXBNFFoaJzYJV1r84szgUqdmYZK20khzB1OcGjlGb7UJrOp1SIplLtwVigv
         AYnC2tXXOcUh0aHEpDa24zHben4zr4aofGKw0IEWzHg0ed16TPRVOpTAYwEYO6natc3g
         nRFCBf0TAXolPYlSvuyD5CkRBBmKcpDf4YqacojqYIcjR6/J5rfMDQUMSrYVtdSjnOWe
         valSHap3zSGoB1MuEBASrX7UKHNkuI44J35x0FuQTM+pnvskyJa89FCLRSwqASGbO1Z7
         ZkPS/9XlYSraBx5Ta2KnBABPsHE1mGagpCHX9QkJ5Z06RZxdn3krVQluO7kLoNIoq5e5
         jc1Q==
X-Gm-Message-State: AOJu0Ywzc7gA/a4Do7Uy4XBIXG6pFdJzeFq/rwM/nY+SEbuyY8jVLqBE
	8faULSHOE2k+WoTaip50iNrkaZK7C4rGiajHETq7Fy4TujK2qXBqAg9DvV8D
X-Google-Smtp-Source: AGHT+IHgZ4TvC5B4lWDT8Fo7P/EWXJbQiatgdPxk9e9LKNimyeyYS3NoazzrHKiS8j/sGNQMDi5tyg==
X-Received: by 2002:a17:903:1c4:b0:1dc:df24:e321 with SMTP id e4-20020a17090301c400b001dcdf24e321mr2807020plh.6.1710488060872;
        Fri, 15 Mar 2024 00:34:20 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:20 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 16/32] doc: Eliminate doxygen warnings from iftable.c
Date: Fri, 15 Mar 2024 18:33:31 +1100
Message-Id: <20240315073347.22628-17-duncan_roe@optusnet.com.au>
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

Introduce some new doxygen content. Not yet converted to use libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am    |  1 +
 doxygen/doxygen.cfg.in |  2 ++
 src/iftable.c          | 53 +++++++++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 6135f25..aae1ccc 100644
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
index e69dcd7..c795df1 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -17,6 +17,8 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfnl_handle \
                          nfnl_subsys_handle \
                          mnl_socket \
+                         ifindex_node \
+                         nlif_handle \
                          nfnl_callback2 \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
diff --git a/src/iftable.c b/src/iftable.c
index aab59b3..22c3952 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -2,6 +2,7 @@
  *
  * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
  * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ * (C) 2024 by Duncan Roe <duncan_roe@optusnet.com.au>
  *
  * This software is Free Software and licensed under GNU GPLv2+.
  */
@@ -25,11 +26,14 @@
 #include "linux_list.h"
 
 /**
- * \defgroup iftable Functions in iftable.c [DEPRECATED]
- * This documentation is provided for the benefit of maintainers of legacy code.
+ * \defgroup iftable Functions to manage a table of network interfaces
+ * These functions maintain a database of the name and flags of each
+ * network interface.
  *
- * New applications should use
- * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/).
+ * mnl API programs may instead use
+ * [libmnl](https://netfilter.org/projects/libmnl/doxygen/html/)
+ * calls directly to maintain an
+ * interface table with more (or less!) data points, e.g. MTU.
  * @{
  */
 
@@ -52,8 +56,8 @@ struct nlif_handle {
 };
 
 /* iftable_add - Add/Update an entry to/in the interface table
- * @n:		netlink message header of a RTM_NEWLINK message
- * @arg:	not used
+ * \param n:	netlink message header of a RTM_NEWLINK message
+ * \param arg:	not used
  *
  * This function adds/updates an entry in the intrface table.
  * Returns -1 on error, 1 on success.
@@ -114,8 +118,8 @@ static int iftable_add(struct nlmsghdr *n, void *arg)
 }
 
 /* iftable_del - Delete an entry from the interface table
- * @n:		netlink message header of a RTM_DELLINK nlmsg
- * @arg:	not used
+ * \param n:	netlink message header of a RTM_DELLINK nlmsg
+ * \param arg:	not used
  *
  * Delete an entry from the interface table.  
  * Returns -1 on error, 0 if no matching entry was found or 1 on success.
@@ -148,9 +152,10 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
-/** Get the name for an ifindex
+/**
+ * nlif_index2name - get the name for an ifindex
  *
- * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param h pointer to nlif_handle created by nlif_open()
  * \param index ifindex to be resolved
  * \param name interface name, pass a buffer of IFNAMSIZ size
  * \return -1 on error, 1 on success 
@@ -182,9 +187,10 @@ int nlif_index2name(struct nlif_handle *h,
 	return -1;
 }
 
-/** Get the flags for an ifindex
+/**
+ * nlif_get_ifflags - get the flags for an ifindex
  *
- * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param h pointer to nlif_handle created by nlif_open()
  * \param index ifindex to be resolved
  * \param flags pointer to variable used to store the interface flags
  * \return -1 on error, 1 on success 
@@ -215,7 +221,8 @@ int nlif_get_ifflags(const struct nlif_handle *h,
 	return -1;
 }
 
-/** Initialize interface table
+/**
+ * nlif_open - initialize interface table
  *
  * Initialize rtnl interface and interface table
  * Call this before any nlif_* function
@@ -262,10 +269,10 @@ err:
 	return NULL;
 }
 
-/** Destructor of interface table
+/**
+ * nlif_close - free all resources associated with the interface table
  *
- * \param nlif_handle A pointer to a ::nlif_handle created 
- * via nlif_open()
+ * \param h pointer to nlif_handle created by nlif_open()
  */
 void nlif_close(struct nlif_handle *h)
 {
@@ -289,9 +296,12 @@ void nlif_close(struct nlif_handle *h)
 	h = NULL; /* bugtrap */
 }
 
-/** Receive message from netlink and update interface table
+/**
+ * nlif_catch - receive message from netlink and update interface table
+ *
+ * FIXME - elaborate a bit
  *
- * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param h pointer to nlif_handle created by nlif_open()
  * \return 0 if OK
  */
 int nlif_catch(struct nlif_handle *h)
@@ -316,7 +326,7 @@ static int nlif_catch_multi(struct nlif_handle *h)
 
 /** 
  * nlif_query - request a dump of interfaces available in the system
- * @h: pointer to a valid nlif_handler
+ * \param h: pointer to a valid nlif_handler
  */
 int nlif_query(struct nlif_handle *h)
 {
@@ -328,9 +338,10 @@ int nlif_query(struct nlif_handle *h)
 	return nlif_catch_multi(h);
 }
 
-/** Returns socket descriptor for the netlink socket
+/**
+ * nlif_fd - get file descriptor for the netlink socket
  *
- * \param nlif_handle A pointer to a ::nlif_handle created
+ * \param h pointer to nlif_handle created by nlif_open()
  * \return The fd or -1 if there's an error
  */
 int nlif_fd(struct nlif_handle *h)
-- 
2.35.8

