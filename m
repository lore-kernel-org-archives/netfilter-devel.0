Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554E4763E4
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529074; cv=none; b=MdmuDhOs2xPq/543QbYkDLbxWZoP0oM7fAlmfapk/Yf8BqPf4TIvET64YjIOtbCSKCSy6VTV+dqJAnmS9IlQauSnhnRNtas3mA/wWtJwU0OLVa7q5uUtc9TZ92ahwSdbCW6VBNsHMrN+xuR2hMZEXdk0/6flxicWesQ3z4dvaZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529074; c=relaxed/simple;
	bh=Oh8zNklnrHCIPh6h/aZy99Yq8fh43WB7e2ptDoGXIuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WkCzta8Z3nbEytQrLPuODQbQKpjK4OgtFZm75RtbC/BbHDg555FTP2AgtdxmD+WEn/4B73jVcjUFYc/V3RVxI+amoS57ysIu27RSWniK8vMUMK8PVRJsm0GCw1aZbVQOBPI36jPfUHd+8VICkAqNOBo0xxFrdsva6cRiEWLdxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hAeZr/Jo; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hAeZr/Jo"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6f69422c090so3675998b3a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529071; x=1717133871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1nAYecjGKZaGuQ3erB/Q7TcmpN1h09QlkqlyC1w/NE=;
        b=hAeZr/JooLsGgVj8+Xz9li8wKFDByCPSIh8foNLOpBwGyAqPIbkHlf9pM6gMn6CyQ/
         oCHJZQWqgzgNIETSkKfTLG96nYdSS+33ykKuBKA92zuFQsQ0zdMunENN84wMOItT5ihI
         OezemBaidITEb+3M8YGR61+k/32DYsH9DjK4Hil7c9h0vWoFSK4cYZiO5bUOzbsRXImv
         AKSmDVBKzfvX+B5CVVE+Q2TIKhNkLtlEMFo6DxaQfhmUNUyoGshhbZ1QYf96VqqMSpkh
         mJukU88hY2HroPy3eBOcdSqO4f0jfB+zcacN6p5gzzb1bsNvInV35ZBMqPKFQeNMzJT3
         2WLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529071; x=1717133871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1nAYecjGKZaGuQ3erB/Q7TcmpN1h09QlkqlyC1w/NE=;
        b=KpMHJqX2YySPzVn12d83oeAAie16E4t1+jmBCh7NcRVTrWaqh5u/fyeah2VAwLS0Au
         vHeeGeNwMEfgpZGzCKDdH91PKhmkavASaUkzUUHczTUuhBeyf2SYnAB/5vOiUVb+OySm
         EwQXsx9QiufGYp0O2Ybz+0xGFx76bl/ysNM00gx8e+oejx1UrgsvL/LGy3k0TSSNxNjX
         WEzDLz4TugvSILiO9yUAocTlZwvolDKt+T1L9MAQJsD+4u/HfuiGWuOpxFNBoSg03rMR
         cEpO3z1xYddufpo6psuxMGomVJaAOIDM69LMV1CbonPeLEdG65xuAaxnqetXVb2JuOzT
         S/7A==
X-Gm-Message-State: AOJu0Yy3hMZfa17hPt//7ZhLvOdK2+k8zAZ6x/PsBvUEK3m6/a+piXis
	2CA1pKXVkxmgJ3yE8sYSL5Qt0GvgkBMjQz/wuOgC/mq0UXMqIUi+9MVyFQ==
X-Google-Smtp-Source: AGHT+IHH2qaV+pRN2xsT3Hh3LTFGLOvnWNpGMdkTYc60FGas8R9Cm8Ed/Z7eNJXKxPKjXEIzcfEWig==
X-Received: by 2002:a05:6a00:2a0f:b0:6ea:c43c:a650 with SMTP id d2e1a72fcca58-6f8f41a95a0mr1050240b3a.32.1716529071334;
        Thu, 23 May 2024 22:37:51 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:51 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 02/15] src: Convert nfq_open_nfnl() to use libmnl
Date: Fri, 24 May 2024 15:37:29 +1000
Message-Id: <20240524053742.27294-3-duncan_roe@optusnet.com.au>
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

__nfq_open_nfnl() manufactures a libmnl handle if called by
nfq_open_nfnl().
Replace calls to nfnl_subsys_open() and nfnl_callback_register() with
inline code.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
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

