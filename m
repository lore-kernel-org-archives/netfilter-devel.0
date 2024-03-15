Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B480D14016
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488038; cv=none; b=fcM6TWKWuYIuB5wjh22H8u/LnMdr/ppHY8v19U1102EuStmknyzuLxIeAi3Seuok9CgkwtVw0wtR5j42ezs0zMqwVmu++9SHTYpCyd0iAdz/Q7lwLDgh0svsu4zUqJ4K2xTE2FExSY/+TcpFnei+cTROaNWRQ70cik54ClFsh5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488038; c=relaxed/simple;
	bh=OOjhM2o4LdoOghfAL7dL5yzLPUe4OYmP7uKUdRKkDzg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L+NqLOQnJklEI0h77Cl6y1c/C7g4dHJKeLhGQAOCBLFPFoIh5iyTQkPPE9Jzub+JczDpScL6Lq5+2bXxEkUTFkmXUzLO5fC5Q4pj1RWf+M0RDwUFMJyRuF5gnM//F10+vi4gbYbp/CtmzZi/DiLWqCBbKXMOHK9V3D3/plGUs2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+tW4+IR; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+tW4+IR"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dd10a37d68so15420005ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488036; x=1711092836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CcLXqtIQI9MvIYfAEdaerXdIX8fDMdnayfSiykdOJ4=;
        b=F+tW4+IRjP84fXJOoXqfIaq+x7ioEY+uvQSs3hcUdIE2da9OvUy5G54JKkJONKoHby
         ds9/7Bz0314gIV0TacOzwEQw8JhwEsp0EYnhuqfON7rONO3NuzBHg9eGuXILg2ZckTPV
         ywaOcOV/usvvtdQ0n4qbpcQ7zW80lccaA3Fy8p//Or4z4EQe8fZePvaM9LS1FnrIzDzk
         BtRPAUTkD0IP36Wgsuepnu39kgLrDLUFbqmr6mVXiKuSHOIN+shWIyYyrgJmxjvS7r2G
         W4IfYs/eIJztSVvJtXNPrXTKU9uVicJVZu8tUn8TTSRfGMeAbnarSHED3j6jOecy6pIm
         lfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488036; x=1711092836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4CcLXqtIQI9MvIYfAEdaerXdIX8fDMdnayfSiykdOJ4=;
        b=dj0U2x8Afx5O3YFZ/J1j1qoKRXUStwI5J92TOwqxsN7Kq1bhptGmJLnlpDy3jj4JL+
         EXTuQUzqeaFwieOLbKUD1+4rZ9PMKVSx01E5CYgJTJJVZHz0DA8okj1zcmm7UHx1gfDr
         P4cY3vwgBNF9Sfofn3e0FvxIPhG0hA30hrp+oCSEH2m1XTFAnEI6hncim3lgHbIMLzH/
         ioJVUl3jwwk0CsSfTThZxt7Ah1FyRnDXIZi3DsE+ehAhnnBAIzQ23slGHr1E3sXXP4io
         CZj1rRGOLdPSusGeWbn0SQVj6qbGWtbtkASObZ2VoYfovu3feIN8YK0HT6p6uHaAyS29
         a0Gw==
X-Gm-Message-State: AOJu0Yz4fktpSREd/L4tNZXLEynoVFmEWJxiwcrwQjAlGfEMhl018yQh
	iCjRzBWX+uEp/DyrkkMG+8iuB9/a2RFsuTTWzv2gM59NLp59X1Km
X-Google-Smtp-Source: AGHT+IEBnVWJHwHlmSIE7zYAClrXzNAhPamBhzTqI3vdIKfTJ/g7MIjR5kG+aAeEE+mFqsr5zkRkQw==
X-Received: by 2002:a17:903:2282:b0:1dc:ceb0:b00c with SMTP id b2-20020a170903228200b001dcceb0b00cmr5003260plh.35.1710488035918;
        Fri, 15 Mar 2024 00:33:55 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:33:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 02/32] src: Convert nfq_open_nfnl() to use libmnl
Date: Fri, 15 Mar 2024 18:33:17 +1100
Message-Id: <20240315073347.22628-3-duncan_roe@optusnet.com.au>
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

Use copies of private libnfnetlink and libmnl structs to move required info
from one to the other.
Move (now) common code in nfq_open() and nfq_open_nfnl() to static
fill_nfnl_subsys_handle().

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 64 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 2aba68d..03c56ca 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -403,6 +403,27 @@ int nfq_fd(struct nfq_handle *h)
  * @{
  */
 
+static bool fill_nfnl_subsys_handle(struct nfq_handle *h)
+{
+	struct nfnl_callback pkt_cb = {
+		.call		= __nfq_rcv_pkt,
+		.attr_count	= NFQA_MAX,
+	};
+
+	/* Fill in nfnl subsys handle with code adapted from libnfnetlink */
+	h->nfnlssh = &h->nfnlh->subsys[NFNL_SUBSYS_QUEUE];
+	h->nfnlssh->cb = calloc(NFQNL_MSG_MAX, sizeof(*(h->nfnlssh->cb)));
+	if (!h->nfnlssh->cb)
+		return false;
+	h->nfnlssh->nfnlh = h->nfnlh;
+	h->nfnlssh->cb_count = NFQNL_MSG_MAX;
+	h->nfnlssh->subscriptions = 0;
+	h->nfnlssh->subsys_id = NFNL_SUBSYS_QUEUE;
+	pkt_cb.data = h;
+	memcpy(&h->nfnlssh->cb[NFQNL_MSG_PACKET], &pkt_cb, sizeof(pkt_cb));
+	return true;
+}
+
 /**
  * nfq_open - open a nfqueue handler
  *
@@ -416,10 +437,6 @@ int nfq_fd(struct nfq_handle *h)
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open(void)
 {
-	struct nfnl_callback pkt_cb = {
-		.call		= __nfq_rcv_pkt,
-		.attr_count	= NFQA_MAX,
-	};
 	struct nfq_handle *h = malloc(sizeof(*h));
 
 	if (!h)
@@ -442,22 +459,11 @@ struct nfq_handle *nfq_open(void)
 	h->nfnlh->fd = h->nl->fd;
 	h->nfnlh->local = h->nl->addr;
 	h->nfnlh->peer.nl_family = AF_NETLINK;
-	//h->nfnlh->seq = time(NULL);
 	h->nfnlh->rcv_buffer_size = NFNL_BUFFSIZE;
 
-	/* Fill in nfnl subsys handle with code adapted from libnfnetlink */
-	h->nfnlssh = &h->nfnlh->subsys[NFNL_SUBSYS_QUEUE];
-	h->nfnlssh->cb = calloc(NFQNL_MSG_MAX, sizeof(*(h->nfnlssh->cb)));
-	if (!h->nfnlssh->cb)
+	if (!fill_nfnl_subsys_handle(h))
 		goto err_close;
 
-	h->nfnlssh->nfnlh = h->nfnlh;
-	h->nfnlssh->cb_count = NFQNL_MSG_MAX;
-	h->nfnlssh->subscriptions = 0;
-	h->nfnlssh->subsys_id = NFNL_SUBSYS_QUEUE;
-	pkt_cb.data = h;
-	memcpy(&h->nfnlssh->cb[NFQNL_MSG_PACKET], &pkt_cb, sizeof(pkt_cb));
-
 	return h;
 
 err_close:
@@ -473,6 +479,7 @@ err_free:
  * @}
  */
 
+#define NFNL_F_SEQTRACK_ENABLED             (1 << 0)
 /**
  * nfq_open_nfnl - open a nfqueue handler from a existing nfnetlink handler
  * \param nfnlh Netfilter netlink connection handle obtained by calling nfnl_open()
@@ -486,12 +493,7 @@ err_free:
 EXPORT_SYMBOL
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
-	struct nfnl_callback pkt_cb = {
-		.call		= __nfq_rcv_pkt,
-		.attr_count	= NFQA_MAX,
-	};
 	struct nfq_handle *h;
-	int err;
 
 	h = malloc(sizeof(*h));
 	if (!h)
@@ -499,24 +501,22 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 
 	memset(h, 0, sizeof(*h));
 	h->nfnlh = nfnlh;
+	h->nfnlh->seq = 0;
+	h->nfnlh->flags &= ~NFNL_F_SEQTRACK_ENABLED;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
-				      NFQNL_MSG_MAX, 0);
-	if (!h->nfnlssh) {
-		/* FIXME: nfq_errno */
+	h->nl = malloc(sizeof(*h->nl));
+	if (!h->nl)
 		goto out_free;
-	}
+	memset(h->nl, 0, sizeof(*h->nl));
+	h->nl->fd = h->nfnlh->fd;
+	h->nl->addr = h->nfnlh->local;
 
-	pkt_cb.data = h;
-	err = nfnl_callback_register(h->nfnlssh, NFQNL_MSG_PACKET, &pkt_cb);
-	if (err < 0) {
-		nfq_errno = err;
+	if (!fill_nfnl_subsys_handle(h))
 		goto out_close;
-	}
 
 	return h;
 out_close:
-	nfnl_subsys_close(h->nfnlssh);
+	mnl_socket_close(h->nl);
 out_free:
 	free(h);
 	return NULL;
-- 
2.35.8

