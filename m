Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CD019E7F9
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774583; cv=none; b=KfcsCi9tcVBuG3DleiCWiiDO45HLK2iInMdYqa8D0IZzfUdjucK7nmlQ/mATZTWkoGLdo+Dqx5wUnZ0DZISG0qH7zZol4CsNlKv88YdgMM59GSAG2UBwGxF9aTRXMKB8UFi+ZmhlhUNtjN+vPDFviznXnfrGyrDbQlki4P9EBl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774583; c=relaxed/simple;
	bh=PiTvFyoqPPvRAohGQUnfZRFku/LY+6vFRFoHBPMDm0g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WqW+IRRlCWMNwPwyIu2QCE0IwkAHLkK7LzhMb0eb4PC1EwAslDqBvZMmu6jry8AS2hMnUgKKUjVjj9KBnUr78vNWI0zlmmTy3wot315ShB1aXGCXPjzzz8XfskeVS9KMZjqAFVzglDBre4W7X2uo4KWFSmhEzapR7B6p1Ct8taw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxDaK9sw; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxDaK9sw"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e038f3835so2833701b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774581; x=1729379381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnyxGVPxPXRhSsY6Sr4YYotX9Gd7NNLALEP+M3K0jVQ=;
        b=JxDaK9swkK52VwpBbeDNeKmIT9nKKppJMh2m5b5uiqhn70+39PfxX+fJ+KJwoLK0Hg
         Jd8pis4XaZ8waOGJqowD7/9njVuA6eN2ZISmFsNAyNkyuuoUpMlV7XVz55fUGN/oxr/g
         21Gh9KhOWPBFXNQ4HHKKa7Fy0l2bI0dsExbuGFD6QpggLjnKqN1IPRVIcuhkSkT5YmBc
         hnlcSmHwBJMrKXrQboyTJzRrV2kmFn9hfHT+mP2gvXtWQu+/W7lP52amvtTzdP7ZBaHE
         HtqKFc7ipopqLG4ZjKksQt9ksx9m6oEpZ3JnYqFeGCNcEV8R2YWyQSTelR1zHYM8EFXE
         L+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774581; x=1729379381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QnyxGVPxPXRhSsY6Sr4YYotX9Gd7NNLALEP+M3K0jVQ=;
        b=U5ANgLVc1g2wGHU3ztxNomWcEFFo7ACHrbpSno4trLwDlffRo1PmeXj88pgGlZCCFn
         7Lg4OoauuvmfSDAX8TQcAuedxZ0KZnO53Nf5AdTSyui/sMIKsDlA8G19yC8JFTsxzNHE
         muhLtgNDqWLG5QVW0K9ON8pDlVC2kLf42v57F2/K/JJEo00i6keQG1tUv1wcVeq4gTos
         xaLU8PmKasDvkT76vt769DVDTuP5pspQZSzbkvAC3o9te1wtusNyBNHEd1S2GwL26v5e
         NAV/rTneUv4Q5qpoWkGJGmOFqHUV2zuEyZtLDl7/LBPGSUBHOZLtrf84jM7b/Rk1cNDH
         EpeQ==
X-Gm-Message-State: AOJu0YyGm1BVpPmGXUxckArhOT9ZrL/uH9fDDAAl0xPaN25wk9DXPn7d
	wbUdclfnlIk3HUYiBL/oy6x47Qh8RrxJGm0Yhl3hzqQeBeHXOTNEbICueQ==
X-Google-Smtp-Source: AGHT+IEyYTdF4yaKrk8zqDeaEPBXlihU7w+Wuf4dCd2YMh8be/OYoKoa9fnTLbqbT0UT3s9/OHt1qQ==
X-Received: by 2002:a05:6a20:cfa9:b0:1d2:e458:4063 with SMTP id adf61e73a8af0-1d8bcfb26cbmr10166614637.33.1728774581431;
        Sat, 12 Oct 2024 16:09:41 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:40 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 08/15] src: Incorporate nfnl_rcvbufsiz() in libnetfilter_queue
Date: Sun, 13 Oct 2024 10:09:10 +1100
Message-Id: <20241012230917.11467-9-duncan_roe@optusnet.com.au>
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

nfnl_rcvbufsiz() is the first bullet point in the Performance section
of the libnetfilter_queue HTML main page.
We have to assume people have used it,
so supply a version that uses libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v3: rebased

 v2: rebase to account for updated patches

 .../libnetfilter_queue/libnetfilter_queue.h   |  2 ++
 src/libnetfilter_queue.c                      | 36 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index f7e68d8..9327f8c 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -35,6 +35,8 @@ typedef int  nfq_callback(struct nfq_q_handle *gh, struct nfgenmsg *nfmsg,
 		       struct nfq_data *nfad, void *data);
 
 
+extern unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h,
+				   unsigned int size);
 extern struct nfq_handle *nfq_open(void);
 extern struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nfq_close(struct nfq_handle *h);
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 3fa8d2d..f26b65f 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -578,6 +578,42 @@ out_free:
  * @{
  */
 
+/**
+ * nfnl_rcvbufsiz - set the socket buffer size
+ * \param h nfnetlink connection handle obtained via call to \b nfq_nfnlh()
+ * \param size size of the buffer we want to set
+ *
+ * This nfnl-API function sets the new size of the socket buffer.
+ * Use this setting
+ * to increase the socket buffer size if your system is reporting ENOBUFS
+ * errors.
+ *
+ * \return new size of kernel socket buffer
+ */
+
+EXPORT_SYMBOL
+unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
+{
+	int status;
+	socklen_t socklen = sizeof(size);
+	unsigned int read_size = 0;
+
+	/* first we try the FORCE option, which is introduced in kernel
+	 * 2.6.14 to give "root" the ability to override the system wide
+	 * maximum
+	 */
+	status = setsockopt(h->fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
+	if (status < 0) {
+		/* if this didn't work, we try at least to get the system
+		 * wide maximum (or whatever the user requested)
+		 */
+		setsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);
+	}
+	getsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &read_size, &socklen);
+
+	return read_size;
+}
+
 /**
  * nfq_close - close a nfqueue handler
  * \param h Netfilter queue connection handle obtained via call to nfq_open()
-- 
2.35.8

