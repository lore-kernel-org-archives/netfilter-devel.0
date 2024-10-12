Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B003719CC25
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774570; cv=none; b=EucIcbk9gL67sEMzOpMY6jJsEifbX1BM8bHVzjqhXzrbQ9+mhiW5oT90moFnqyRAh/uAEi9HBwQYPzbSTXnsTVlQheWqiQOyLYZPAHUQhlv9YJeEza3EybUlYG2NldDS1sGWZ6oOQpxY94bGYzX65fVcW0WRNx1Tb3jD63VJW0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774570; c=relaxed/simple;
	bh=Tnja4z7mKISn7j88gvHcN8MRxXIVuqW14vgtfqd+M7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nzq2RsOzlMTMQr5YZ5pgd89EydPHIBixd26NR9FnYzZO23p3AcfPxJZzdLa3vRW4CghF7JJ56MTBR3+S0zYAb4rma5pMpvZNvYyNPMxX8YaCDe2vv5GzMoyYt5CxqsPqH7BbX93aUwD0l/GILqGV5dsSWnsBGszTUuN5nkN+NxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LeWcJJEb; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeWcJJEb"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71e3fce4a60so1099804b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774567; x=1729379367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVTwAdalhzDndSJVPJ2g6UNWS4gcZv4toBrasYb+7Do=;
        b=LeWcJJEbWlr3FfI4JSE6ml2uGsrq1h1bI3NMEhpGqu+K9LMRBWC7aPh5lsDJS4GbF1
         PsSmo2eS/yDfGtMn/EWci5zatRuMNXFQqMWyaIdZDAsyFlLjdF5D9BvaaL0P+a5EGx2G
         XwZKM1SntcpO8XOaYtWlWVvK46T4hsOsfEDP7weiTchg6EUyZPlf89fVWMuNLeK2Pc1P
         PxHzmKx9GcywIc5IAjVH3JRvjE+nfwIcrhpk1lNTwZ0LBOno48RjhEe/fH4G1xOlgfiq
         v7PfeWLJ0WNdIJZ9JtLXx8I+obbdbXZ2NHC41V347wEWo4ZsdIYBITtxZMjzuRZY6I6q
         7TYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774567; x=1729379367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dVTwAdalhzDndSJVPJ2g6UNWS4gcZv4toBrasYb+7Do=;
        b=i9SLDyXwsNJikN34+FwzmKBKShzvEueqnW232g6febOHyNxSL9JB8WKfsgI73qMppi
         eRmADiLBL3pQTHSaDcXmADvYpvc6R+TVlgk7JcBxdUymfTm1kqVUTiZnhGtFwL6QCZvS
         b1fyMBLrkeOol6GROCB8OkLRrldCJXbdl7YcVzjp+YmF+DoVp5Iwdj8YMOKIYH2eXV67
         0tDNxQS6T63imr3NHdoDayGEPY6GiJemX66xE6I2fH395LE1pEKn0bIZsJ9FSQhcO5A0
         xUcjxBwpQXLCEEdvcnBGge4PTqG64DAG9Q9efoji8t1UqfcdecqKig4ipk0Fx57bbt2O
         g0SQ==
X-Gm-Message-State: AOJu0YxSmO4T/7pqGbMehuH1IBAk0FeG4aSf7tvbAGhuzoumo6HWz2Up
	UotUnskiCqmnelnlcS01Dq/wsRcV2PwlYxqRbI5LpYdGr0XP2lim0vZsTA==
X-Google-Smtp-Source: AGHT+IEDMOwytsmd+/oghOxbpLSgajrGsqCQGKK5yzW2t/GDffax4d15QXrNc95uhkY7ZmlUYTT+dg==
X-Received: by 2002:a05:6a21:e8d:b0:1d8:a260:fd75 with SMTP id adf61e73a8af0-1d8bcf00c49mr11656742637.7.1728774566833;
        Sat, 12 Oct 2024 16:09:26 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:26 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 02/15] src: Convert nfq_open_nfnl() to use libmnl
Date: Sun, 13 Oct 2024 10:09:04 +1100
Message-Id: <20241012230917.11467-3-duncan_roe@optusnet.com.au>
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

__nfq_open_nfnl() manufactures a libmnl handle if called by
nfq_open_nfnl().
Replace calls to nfnl_subsys_open() and nfnl_callback_register() with
inline code.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3: (none)
 
 Changes in v2:
 - Pretty much re-written as per updated commit message. In particular:
   - Don't clear message sequencing - original didn't do that.
   - Don't close the socket in any error path since it was open on entry.
 src/libnetfilter_queue.c | 56 ++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index f366198..bfb6482 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -484,33 +484,67 @@ static struct nfq_handle *__nfq_open_nfnl(struct nfnl_handle *nfnlh,
 	};
 	struct nfq_handle *h;
 	int err;
+	int i;
+	uint32_t new_subscriptions;
 
 	h = qh ? qh : calloc(1, sizeof(*h));
 	if (!h)
 		return NULL;
 
+	if (!qh) {
+		/* Manufacture the libmnl handle */
+		h->nl = calloc(1, sizeof(*h->nl));
+		if (!h->nl)
+			goto out_free;
+		h->nl->fd = nfnlh->fd;
+		h->nl->addr = nfnlh->local;
+	}
 	h->nfnlh = nfnlh;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_QUEUE,
-				      NFQNL_MSG_MAX, 0);
-	if (!h->nfnlssh) {
+	/* Replace nfnl_subsys_open() with code adapted from libnfnetlink */
+	h->nfnlssh = &h->nfnlh->subsys[NFNL_SUBSYS_QUEUE];
+	if (h->nfnlssh->cb) {
+		errno = EBUSY;
+		goto out_free;
+	}
+	h->nfnlssh->cb = calloc(NFQNL_MSG_MAX, sizeof(*(h->nfnlssh->cb)));
+	if (!h->nfnlssh->cb) {
 		/* FIXME: nfq_errno */
 		goto out_free;
 	}
+	h->nfnlssh->nfnlh = h->nfnlh;
+	h->nfnlssh->cb_count = NFQNL_MSG_MAX;
+	h->nfnlssh->subsys_id = NFNL_SUBSYS_QUEUE;
+
+	/* Replacement code for recalc_rebind_subscriptions() */
+	new_subscriptions = nfnlh->subscriptions;
+	for (i = 0; i < NFNL_MAX_SUBSYS; i++)
+		new_subscriptions |= nfnlh->subsys[i].subscriptions;
+	nfnlh->local.nl_groups = new_subscriptions;
+	err = bind(nfnlh->fd, (struct sockaddr *)&nfnlh->local,
+		   sizeof(nfnlh->local));
+	if (err == -1) {
+		free(h->nfnlssh->cb);
+		h->nfnlssh->cb = NULL;
+		goto out_free;
+	}
+	h->nfnlssh->subscriptions = new_subscriptions;
 
 	pkt_cb.data = h;
-	err = nfnl_callback_register(h->nfnlssh, NFQNL_MSG_PACKET, &pkt_cb);
-	if (err < 0) {
-		nfq_errno = err;
-		goto out_close;
-	}
+	/* Replacement code for nfnl_callback_register()
+	 * The only error return from nfnl_callback_register() is not possible
+	 * here: NFQNL_MSG_PACKET (= 0) will be less than h->nfnlssh->cb_count
+	 * (set to NFQNL_MSG_MAX (= 4) a few lines back).
+	 */
+	memcpy(&h->nfnlssh->cb[NFQNL_MSG_PACKET], &pkt_cb, sizeof(pkt_cb));
 
 	return h;
-out_close:
-	nfnl_subsys_close(h->nfnlssh);
 out_free:
-	if (!qh)
+	if (!qh) {
+		if (h->nl)
+			free(h->nl);
 		free(h);
+	}
 	return NULL;
 }
 
-- 
2.35.8

