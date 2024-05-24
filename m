Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F17EEE7
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529075; cv=none; b=AL2zTRMdllLtt2pxKkPPrhnGVOtEccjCwXbghn/CmGzKrRNsEWSCpB6Yo9WG2yvX63ku7sxFFPpqELU8PgVNpfafSI96GZmiYuNqyIXzxHRTKsh/nCuVSlo5wfZf9O4hT+oQm3yYMy8xcC9qqOfU+AzS9FCEaGcabuGFiFlsvkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529075; c=relaxed/simple;
	bh=z1d1Wv7Zj6gm4LsgD4203CpIa4zuGW0jcrG/Jp2RMCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=on/A5DdmHuoH6rLaQv9m3huvM4cWDirdC8XvbGgUeDZkJ4drVfApYbuNbAsvI2ojpqGid1t8IGF3AjJrGWGFuuL+1rj0BYvhKlz1ulsg8rrvqcL9KV3I9prq4Ay2q9ydY1NqlfMOJMsStS5dSbRM1tjILUtjWS5isyRvug7Maus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RKSwq82r; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKSwq82r"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c9a1d294cfso3457162b6e.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529073; x=1717133873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Z9ZCtK9oqQsR7hnLa8cDuGx0kEt1T+HoU9aLmKbkr8=;
        b=RKSwq82rNwCkR2Q+M8Rip/2t4rZ9IB+TdfOYdVc/eAXmbpyrliQzZMjkLvxNQN5/vg
         f98cZn7fMNsYJ8zocGAhjQqSZsYtSY6PCHUaiEJUxIn5T2no78vPXQPQSVrwQebpLVjd
         4AImAWu5wBoqK4BjiFIdakwRw77vmKLSQeDMDdv6+Ct/JNMh30gaal+cz6wcYFEkHsf8
         rUSTZStoMu2+CNzlESVoNAiAq4yck/0MNy27K513H4J9VXILH/BTfMJFm437UxV/GTCj
         c2pnxZsUwVgjNIeRP+9CjlZlxxKAK4nSLig4c60S/Z5/P8cgWA9xSeAmdslBWmiuw0ao
         TyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529073; x=1717133873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Z9ZCtK9oqQsR7hnLa8cDuGx0kEt1T+HoU9aLmKbkr8=;
        b=bBbdDoPZb6I7M8LBLxKEYPKWm80k+0ofDeeH6+frykYTurT4ht66GhOK0SA5F47+8x
         FhHzNvK/1bKrw2QSIgBCrpD1A3gJtb3HgylBoctF1vDCMazv3UtPrfLm8dvAzZYw1x0u
         +Y66NFGVQHoS4Xo6JHktQ4qRJo/vuuOiQ6hWzGdMy/AKA9FEGDTHDcv0OZqKeLVsE2Df
         cN0GmQl+mnXS2kT2ilwdhxt07+XDdgLtE59gMzhJUhE3FEtkeo28arYSOApFjcC64ST/
         xb+r1++m6mp01/VOl7NyLuUnlDydYEH2iXeASkSXFGe3p0RsE+V/8QfgyfVpaoVlf0a2
         nNEQ==
X-Gm-Message-State: AOJu0YwRywtcPVoCuCxhaQONrLAQXNbH1ww4w74XXFWDWVFz0HU8EQpV
	heInFlpGqQntYNCY8AvV/0mDULFsqDZG4Z0PhLa8z4t2b3u2tTfQdi5t7A==
X-Google-Smtp-Source: AGHT+IHDcQ4BcQnvt+vJM3GiIGbTJTg9czNIQOg+5zpNE0lSY+JsbmUznrWc5WciLo27XcZ6f/R9XA==
X-Received: by 2002:a54:4807:0:b0:3c9:63d1:6fce with SMTP id 5614622812f47-3d1a726a37cmr1245705b6e.40.1716529073079;
        Thu, 23 May 2024 22:37:53 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 03/15] src: Convert nfq_close() to use libmnl
Date: Fri, 24 May 2024 15:37:30 +1000
Message-Id: <20240524053742.27294-4-duncan_roe@optusnet.com.au>
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

Use mnl_close() and clean up the NFNL_SUBSYS_QUEUE subsystem as
nfnl_close() would have done

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v2:
 - Propogate return from mnl_socket_close()
 - Don't free callbacks in the qh_list since nfq_close() didn't
   (reported as a bug)
 - Do a complete emulation of nfnl_close()
 - Add explanatory comments

 src/libnetfilter_queue.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bfb6482..0483780 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -577,8 +577,30 @@ EXPORT_SYMBOL
 int nfq_close(struct nfq_handle *h)
 {
 	int ret;
+	int i;
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
 
-	ret = nfnl_close(h->nfnlh);
+	/* nfnl_close() didn't free nfnlh if close() returned an error.
+	 * Presumably that's why nfq_close() doesn't free h in that case.
+	 */
 	if (ret == 0)
 		free(h);
 	return ret;
-- 
2.35.8

