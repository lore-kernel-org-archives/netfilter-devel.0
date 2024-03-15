Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00C15E81
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488036; cv=none; b=N1E7Oi9eLaxnGhpBFkynGhmEBmLPpevQ+ubBd4uPVGNFHROQKEjGrd7rkSZ0L7NPS+hFPd9xikbt7j5awh3SqhRp2vKN6gIWsJY31Di4Bwml1N+15YRQQcTxnM06mMXif5/uA1lupgp24yHp9FEIAmBxU8IIEmg0e7OK98rLJow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488036; c=relaxed/simple;
	bh=0UUO0w2lzm3c0ow/rxlbNeEluEXcwEufuyZuHnDr8VU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I5v2Lv/fzW+ILt+RQ+dXQPN5L0StbVFV5YNSmO3wEzbE5irIMYY4F3IYijP0laQGEIzhW7fY2lRGvniRQakZP0coRJgXxhF9TnBBnWCPR0CdJUrcg/ItCsaViD79T6RRuFIpL7KyDOFJrKw6QwbipVfDgzlsV82n7YJz15Tz35A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXSkg6KB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXSkg6KB"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dc09556599so13748045ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488034; x=1711092834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=661M0TbqWbio7R8ySK0rFhw2EpdG8sodxFnNO16kmqg=;
        b=nXSkg6KBmvEZmdPjoxev7ZajMlq5TlgVg+ynx/tvl1M7qfkIlOcrDV8Y0XnRP/YcsJ
         4+1EQ1SgW2TvDZ9gPY/LbOip1TjN8l8/D4OYLPH2PDGAoZezXHMlo9rLVgSoqV/iRy9w
         XMKB6arpklRsJ92LEV4fDtBCEROcGHkZQTJnigWA/rRIA6XM8HOaxNSJwK+TU0Rw6lrD
         m9iHl1+gIoTKUN4sAHxIQcBVIRlcG6DgXTZ139QzXgacLHbn2pESQYQWj0seaXtouKgI
         GoayEbIwbGyxmnHN4UlR7RzXwHIFnDWqZRNxpM3nyzmF1WzDSraUcyjcyH66moU0h1Vi
         XJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488034; x=1711092834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=661M0TbqWbio7R8ySK0rFhw2EpdG8sodxFnNO16kmqg=;
        b=ihHadYLeZjiJUHMaxOd/XJd5zhhVMGuIm5k5r4ooLscEFi1ZV2ak57gX1TnySb/fXU
         u50fBMQBkXmIY/cuL4Lf4kF0ToNIStQuXEoVpujHZTZLexSHJH0EpQFt84DUbPGs79iP
         9H9xDj06lLA8pdjTsbmg6uqMA2dtgiGZWrrystUxrFI6GVBfa2OwAOEjE0rDDxhur2L2
         GI7JLH+9iypxjPtlKaUVL3keN75fGV/JBdtfsC/MKxoxYeOfCbrScYpY+rIyRETjNxJU
         QSe6jzjAJbrVAohSFG237SR6/w/k+xiPB1l4RBt5bjQir0pUzDErTYoWKiQzkE7GO9It
         7lrg==
X-Gm-Message-State: AOJu0Yy23ivw5fM4454mt5JfKBTL5Dpb38nAsbIosc7AuqRraYgV3fNO
	b1qPShGKl6hmqx6an/6G7QJgtPtawt0erjHtSAvgqLj7Fbc8F9mho4Y7GVjs
X-Google-Smtp-Source: AGHT+IEybHOIzDxpS5jFiBK++Rb2MMT2AgmE2T4DVbmAlo6Cpt+0HCV9++eN+ucbp3jCZzH2AUsEuA==
X-Received: by 2002:a17:902:dac9:b0:1dc:affb:1f50 with SMTP id q9-20020a170902dac900b001dcaffb1f50mr2847119plx.47.1710488034233;
        Fri, 15 Mar 2024 00:33:54 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:33:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 01/32] src: Convert nfq_open() to use libmnl
Date: Fri, 15 Mar 2024 18:33:16 +1100
Message-Id: <20240315073347.22628-2-duncan_roe@optusnet.com.au>
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

Add copies of nfnl_handle, nfnl_subsys_handle & mnl_socket to
libnetfilter_queue.c. After calling mnl_socket_open() & mnl_socket_bind(),
it fills in the libnfnetlink structs as if nfnl_open() had been called.
The rest of the system still uses libnfnetlink functions but they keep
working.
Where possible, code is copied exactly from libnfnetlink. checkpatch
warns about space before tabs but these warnings are addressed in a
later commit.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/doxygen.cfg.in   |  3 ++
 src/libnetfilter_queue.c | 88 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 82 insertions(+), 9 deletions(-)

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
index bf67a19..2aba68d 100644
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
+	struct nfnl_handle 	*nfnlh;
+	uint32_t		subscriptions;
+	uint8_t			subsys_id;
+	uint8_t			cb_count;
+	struct nfnl_callback 	*cb;	/* array of callbacks */
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
+	struct nlmsghdr 	*last_nlhdr;
+	struct nfnl_subsys_handle subsys[NFNL_MAX_SUBSYS+1];
+};
+
+/* Copy of private libmnl structure */
+struct mnl_socket {
+	int 			fd;
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
@@ -383,20 +416,57 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_handle *nfnlh = nfnl_open();
-	struct nfq_handle *qh;
+	struct nfnl_callback pkt_cb = {
+		.call		= __nfq_rcv_pkt,
+		.attr_count	= NFQA_MAX,
+	};
+	struct nfq_handle *h = malloc(sizeof(*h));
 
-	if (!nfnlh)
+	if (!h)
 		return NULL;
+	memset(h, 0, sizeof(*h));
 
-	/* unset netlink sequence tracking by default */
-	nfnl_unset_sequence_tracking(nfnlh);
+	h->nfnlh = malloc(sizeof(*h->nfnlh));
+	if (!h->nfnlh)
+		goto err_free;
+	memset(h->nfnlh, 0, sizeof(*h->nfnlh));
+
+	h->nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (!h->nl)
+		goto err_free2;
+
+	if (mnl_socket_bind(h->nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		goto err_close;
+
+	/* Fill in nfnl handle */
+	h->nfnlh->fd = h->nl->fd;
+	h->nfnlh->local = h->nl->addr;
+	h->nfnlh->peer.nl_family = AF_NETLINK;
+	//h->nfnlh->seq = time(NULL);
+	h->nfnlh->rcv_buffer_size = NFNL_BUFFSIZE;
+
+	/* Fill in nfnl subsys handle with code adapted from libnfnetlink */
+	h->nfnlssh = &h->nfnlh->subsys[NFNL_SUBSYS_QUEUE];
+	h->nfnlssh->cb = calloc(NFQNL_MSG_MAX, sizeof(*(h->nfnlssh->cb)));
+	if (!h->nfnlssh->cb)
+		goto err_close;
+
+	h->nfnlssh->nfnlh = h->nfnlh;
+	h->nfnlssh->cb_count = NFQNL_MSG_MAX;
+	h->nfnlssh->subscriptions = 0;
+	h->nfnlssh->subsys_id = NFNL_SUBSYS_QUEUE;
+	pkt_cb.data = h;
+	memcpy(&h->nfnlssh->cb[NFQNL_MSG_PACKET], &pkt_cb, sizeof(pkt_cb));
 
-	qh = nfq_open_nfnl(nfnlh);
-	if (!qh)
-		nfnl_close(nfnlh);
+	return h;
 
-	return qh;
+err_close:
+	mnl_socket_close(h->nl);
+err_free2:
+	free(h->nfnlh);
+err_free:
+	free(h);
+	return NULL;
 }
 
 /**
-- 
2.35.8

