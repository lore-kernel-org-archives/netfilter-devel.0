Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC9082897
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529084; cv=none; b=HIh/jWFMHkGlkxgrbuDvAr/fAsKs6vhhZYQPqFk9gKwtWFOMyD3bVT9uxW60WjiDWM/eYwWcxzoIQqkaiqQVW5mG3EhpWm1cyjX54TXUERBSomJ4VArZfsLoQiiBei/qKQSlhPAcZ3SUW2E9XPiqq4GyzBme1hEyFbpqZDMfxsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529084; c=relaxed/simple;
	bh=mgdR8pJzCzPAvakOIui/Ls1TJzSsk0zXbwfvZeEf5ZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YM/Bf7B3Zwn/2ul6WtRufCOsrX736VZqRSYhEWLiKH0Y10W92VLBXnkmeNhgw4QLgAK0ufINwfTz8wo8ZSBIn+OGYPWncmJKYJubVlO2DQJM3l+uS7xvtG2nWpPTEkHPEMgXdrAogGKXYiharxJ0E2hRIwgviEyVxwDxM06RU3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYeWj2/E; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYeWj2/E"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6f8ecafd28cso437377b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529082; x=1717133882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAhgVB0ZLE/4yJq9T4qIVU/e90vu9j7mTe/iLsept1A=;
        b=nYeWj2/E/2LBM+T4FNppknnicBuYfpBhNC6uZStucR0PqvIBipqnIwPNQxlrrYhUN8
         Ugaot7hCIiAerDNAU3Ih5Hf0m+keHXlNGBSb+BeStESTVixjfnwu6fh3jG3JESsFJvwP
         8rU3o0NxLmKOdfqNEXnZEOOiKfdmZkjcewk7fg69rA8lVrbfx5+4eRE6AnAA9ytoUr2C
         G5fZIWRIQyKXMOF8WcoGGjZhvfU8UvRcL9eB3WFN+h+hBE7sbWz8NLsq6xU2McLzmqNo
         VT8ux2JtFHEPuplsN6dFSOgQ5hjLbvvJAz+VZJ1nxsGctSuTWLfQFDTBgYldAq4ltyY0
         Vq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529082; x=1717133882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EAhgVB0ZLE/4yJq9T4qIVU/e90vu9j7mTe/iLsept1A=;
        b=IhuY8xJDExFE435OpM7ImP4pNvcDg6Ej+V4Vgk9Sq6Z3xtA3sGBJGH65MBnP4C79An
         nZfkutkjvFDRIP7zrL9OrakiywTn1c3g9HNVYwmT0D+DjA8C+cOQiLOQMMIREWDtqH4k
         J1PY6GUo25LS1rhC+8tpLLrqObQ+FJ9JmKOjsZ/w56YVqUd+zF5/P8/5pkF/DIlR93sI
         NTF3Qudw1ECw+fffABetIXwoiKhrZX2aRjAwqN/rznXRoaFfKbLJSjVC45Uurumg2/8t
         11u7rzZ6U7muKpa6ebx86c/um2rb8rzmxAqjBVK3Wr/jp7lMLeB5/eZ8NU49nk7m5Zef
         PiJg==
X-Gm-Message-State: AOJu0YxXnBLKhG9benCIPQMIs6VjSk48P1P09k+6sg1jqU66n1yS7i+h
	u+1riZ8umBQQKwZKy7QNicm6k3s7lex0KwKm564ubN8sq0Fg5ZjMin8bbQ==
X-Google-Smtp-Source: AGHT+IGrUXb5aaBiPNgelzXMPRf3csXgZt9ca/Fen7s17bxIXlDtethAAPnpus1Gqzq/Eajd6mOJaQ==
X-Received: by 2002:a05:6a00:2917:b0:6f8:c1b6:d06a with SMTP id d2e1a72fcca58-6f8f3d84ba1mr1181318b3a.29.1716529081929;
        Thu, 23 May 2024 22:38:01 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 08/15] src: Incorporate nfnl_rcvbufsiz() in libnetfilter_queue
Date: Fri, 24 May 2024 15:37:35 +1000
Message-Id: <20240524053742.27294-9-duncan_roe@optusnet.com.au>
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

nfnl_rcvbufsiz() is the first bullet point in the Performance section
of the libnetfilter_queue HTML main page.
We have to assume people have used it,
so supply a version that uses libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
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
@@ -585,6 +585,42 @@ out_free:
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

