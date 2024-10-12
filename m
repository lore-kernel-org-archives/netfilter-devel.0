Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1A15530F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774572; cv=none; b=PIcCsd9DjJsMqCiKtDXiHl1hk3o5d3zsCXj0IKSdD7YhrT+KsPccuDQfPyLBL+P3iwnS84ndmr33Xyz8sZsGUcQoUzabBy9VgdbnaGEhk4UywNqum0VAQOTZCVB31mFOPf0KTo6g/OHleVh9nMQLio8WIQTIz0fznY/aCSdCl6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774572; c=relaxed/simple;
	bh=AioASHeBlmIQr6AY5nq51U2iezKDejGoonz3t2+/iGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d7edaj8pQidN99L8W+HNi4yO4f07dW3YWHAwaQ2jXnY5fQh3TMLsSP1cXnG6yamseY5oaAizJX0KJdltou6cxJA+gX2qs6sbKOeOiiw10VyzEnl3WQv2HsihoUQJlf8XcjYhJ34cs+zTqqCnaw+XfqxlCdqjb1oFL6IZ92XL21E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/eOyzZu; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/eOyzZu"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ea7d509e61so26897a12.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774570; x=1729379370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjCWNMDkBJZWtuQwdPiKVrwMEgyoiPeAXrU3EzyhAVs=;
        b=a/eOyzZuBc9dYCGTnkIaiGiw0FwK/0TQfOaodxD3WbJem+22rTpKLbdprQBbFfMLsM
         kZGGLZXDjZKY/Q162amfZ3JcY9pTL2f2ufAawpESTVsrE7NvEsRpGtmA85UP1Jcl5O1K
         cS/x80O7udkX6Wjsjpl53OCe1CYep4yAvF/q5dL6zt0PjscZ0O2hhERB2IhjOK9cLHRz
         cd1MdcpyRBy3dBtPUlNDfPHj4KtNEVTUKy7Nk9Ng7A1lJKKDWArv5ZRjpfgrT1pG5ej2
         Z+dhXBrW0rqGf3MF3BqfiTP8hZcyCWWSnEUganwAyJaYKhBzkyMAU0Qz8ESJejjQYTpt
         YeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774570; x=1729379370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BjCWNMDkBJZWtuQwdPiKVrwMEgyoiPeAXrU3EzyhAVs=;
        b=raichUvOdWKsbFiG+3BI/kb7/11Ow0Y4tM8DqlhpD864TX6MvvTAhO2R4idaEmHiVU
         21IKYcySqkE4baZqNxDOqKKB/imrCkS1fI+L+5EzGmIcPhJg/8HZ0UTkot+uVCNAiFhD
         iLQ9EnETmvzWIKveEpTqVKKoLN90SXblE5HtsKm+chxy048RvDsn3Qn9i25PaBNUVrmw
         CGYpJo+9dC9k3L/+tVLNxar3Ngx8x+v3RBS48pL8wU1n5WaH1XSzrFauj8mOTQm+za4+
         EDPovH2lFBm3iOiRumN1YDZbtd++yEnPojqaGLlAfKDF0bGF18wIheTEWHoPV6I0Z46e
         aTPg==
X-Gm-Message-State: AOJu0YxhJkhwskoLPA2VfLvSA4ytBAZHGmRMpNVBONg53wOfh5+rqJu7
	dIBzMt1CsAXf43WbcR1tDiu0vKlrhUk6LKHx4XnXjD4cPDY/6yOxQMtCgw==
X-Google-Smtp-Source: AGHT+IHqiuEh/XUNaqnoxGLppFIyMmN3NSkXRfknkQ+JnCzQSndhO+spHhZOdgIO0jhl/kLalQiTqg==
X-Received: by 2002:a05:6a21:e8b:b0:1cf:359b:1a3e with SMTP id adf61e73a8af0-1d8bcfaa393mr10251972637.32.1728774570143;
        Sat, 12 Oct 2024 16:09:30 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:28 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 03/15] src: Convert nfq_close() to use libmnl
Date: Sun, 13 Oct 2024 10:09:05 +1100
Message-Id: <20241012230917.11467-4-duncan_roe@optusnet.com.au>
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

Use mnl_close() and clean up the NFNL_SUBSYS_QUEUE subsystem as
nfnl_close() would have done

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3: manually merge f05b188f8b4c patch
 
 Changes in v2:
 - Propogate return from mnl_socket_close()
 - Don't free callbacks in the qh_list since nfq_close() didn't
   (reported as a bug)
 - Do a complete emulation of nfnl_close()
 - Add explanatory comments

 src/libnetfilter_queue.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index b3d1835..8698431 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -577,6 +577,7 @@ EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
 	int ret;
+	int i;
 	struct nfq_q_handle *qh;
 
 	while (h->qh_list) {
@@ -584,7 +585,29 @@ int nfq_close(struct nfq_handle *h)
 		h->qh_list = qh->next;
 		free(qh);
 	}
-	ret = nfnl_close(h->nfnlh);
+
+	ret = mnl_socket_close(h->nl);
+	h->nl = NULL;              /* mnl_socket_close() always frees it */
+
+	/* Replacement code for nfnl_close().
+	 * It seems unlikely that we need to go through all 16 subsystems
+	 * instead of only subsys[NFNL_SUBSYS_QUEUE] which h->nfnlssh
+	 * conveniently points to, but better safe than sorry.
+	 */
+	for (i = 0; i < NFNL_MAX_SUBSYS; i++) {
+		h->nfnlh->subsys[i].subscriptions = 0;
+		h->nfnlh->subsys[i].cb_count = 0;
+		if (h->nfnlh->subsys[i].cb) {
+			free(h->nfnlh->subsys[i].cb);
+			h->nfnlh->subsys[i].cb = NULL;
+		}
+	}
+	if (ret == 0)
+		free(h->nfnlh);
+
+	/* nfnl_close() didn't free nfnlh if close() returned an error.
+	 * Presumably that's why nfq_close() doesn't free h in that case.
+	 */
 	if (ret == 0)
 		free(h);
 	return ret;
-- 
2.39.4

