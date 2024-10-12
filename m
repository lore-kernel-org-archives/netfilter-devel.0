Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1D019C557
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774567; cv=none; b=eOtjGbGJd9qn/eLv/4WcBhubxwMzLGdBIR8EeTYo6eWIMau9bP0okAwoCgS+yoegZBlqbV3cOh35NhN6hwBbvCDnfgm5u58MjIzoZpTuIJCXX1LAuIm3O6wNamaWtLuhETQIFSy4ULkBa8wCgkn0FYEUSyFXe9wUqP4gLsl84Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774567; c=relaxed/simple;
	bh=kKkcH8iuE595RLhmt/+T5DX8KikyUJwUF5gjg/dgK98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EydKPssPy3///eDhtcYMF2AVF4dCgfsH/udaz/bHqxvkX8bD93hGJOhkrBQAG5UeNQMKu6arlobGJ6ZCY66PlRKGGJdYWS50FjX0tevf31vzl17H2En/zdQkldeuISwreQ0DdvyHDxVyoVMUHSAplZIauejsQyVIwnOabZubS/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYYkhWsn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYYkhWsn"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71e03be0d92so2532136b3a.3
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774565; x=1729379365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMaYhZPmAYftpBoCVGQYD2yOx0YIU4mkNuj7lfx7uXU=;
        b=lYYkhWsnVDOAQxZyHaIHOc/z4Cb4iFh8u0Yj03YC4FbHQXMAh8QEGPhgZ4ZboVcjIX
         Unzyq1BoymoStwP4c0B2YvPbD0qZdat+oDTtkquA62uL/usf7cSwfgOBzhQMyMhuZr5i
         /lZu2w7hBVQz9JkresTTol8GiNUb3jlaW4mYeFp3G4hlDzNtkE+1bokJIkbi4lhqEMP2
         efRlWWpB9hm3MHpXnc5AFebKTwpxu7nPAKrGJEmvIfra3GShaqEKJEjEYh2gIEmF9EME
         ch7m6uA9y9q7K421gmfn0GuDS/988WCEt28pEtqkCiVw8mD93pl24SfaQm1CeG4+VO91
         vJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774565; x=1729379365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oMaYhZPmAYftpBoCVGQYD2yOx0YIU4mkNuj7lfx7uXU=;
        b=EP2bXfU77jmJ47hSbReskKlFlGKPdVNnHLedBLSylvko9yQU7pjT1dSbihjUcaoNYB
         nTWQBHNzvatmo2lXpormoJXNrQJzuP1jNnonYQYA/ZPFv7VYU4wrSnnINnk+4yowB+72
         /8o2+4fo7eWHknLMWcGWgis3BA2mptktVAot0LVupVchvDZ5WgEddq1s2SXkUW8OvUwQ
         5yRQR7Z9sJcMhx7CCQ7evf3PD1m0QbLWE88iJfVBPzE7CF7N+mfZYWKsCjztccxXR0cy
         7goJ20Q+G/kOeru+LrXAncUeVsXn4Ag/b5hQvvH+s8XzaC5Q9J5p1t0mm0aMwVarflxh
         4G/g==
X-Gm-Message-State: AOJu0YzCK3KXk2oyHDQlpd5jt1gLZaJeBrc6TXXqj1r2MeRrnEQzMnyW
	p3x/nHnhvKY6b7u589DPVLuKFm+Kw/V6FJrUZOybYEemQbFGoxBb9m38bw==
X-Google-Smtp-Source: AGHT+IHJtxHx4Hqebtti3IyyBDm0zK79sAYR+IXP2ib73K0JjsBB0sYujDqbPiDDFmYz89UydtEKUA==
X-Received: by 2002:a05:6a20:2d22:b0:1cf:ff65:22f4 with SMTP id adf61e73a8af0-1d8bcfc5946mr11155015637.41.1728774564601;
        Sat, 12 Oct 2024 16:09:24 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:24 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 01/15] src: Convert nfq_open() to use libmnl
Date: Sun, 13 Oct 2024 10:09:03 +1100
Message-Id: <20241012230917.11467-2-duncan_roe@optusnet.com.au>
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
 Changes in v3: (none)
 
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

