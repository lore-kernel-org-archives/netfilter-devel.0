Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C914016
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488048; cv=none; b=pOCWUn0QmuMR4OnGcb5R8mVLJkpxjz65mYPI90Dxql/G6V7cHFhZJ/4XoVo1VwK9cLjqIXo8cbi+Ggz6RB7TiaBV0GJ6gJOtsda0FkGi981sSPz3PlYbWYUDyM/YFdtX3kcLAkxzafDKet45hsI+ueDhbQxsw5rgd8exjRi70Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488048; c=relaxed/simple;
	bh=TQh/c22uCPldxWtnPskqKBAZvYxs1ouvop4GB7Ukzq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a6hqUio7QCoK1y0b1atE6CJZFlZQHA9d00iKag2+NgyRIhsZCvFOIFasVj4V1SSdxEYGPICUiCHXjb/5AhNZdrPpSID2kybggC3i7TwCJPaflXMidQFbQb1tT4mr6kJGllf2Gu5KWGYAlrczxr5ErYRXSmTrrLTwi03dhVqQde0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bZ8fOFIr; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZ8fOFIr"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dee27acf7aso8417335ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488046; x=1711092846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NzGUVsSr/Zaoa+HKQno2pxQT2Wgt7ZOiBDBb/I4eAE=;
        b=bZ8fOFIrvF/Etg2PzIF88JAMjvYwiuigCu5/iZJnpJnwfKHIFztow7MEGgnF6uNBXD
         f/42VGVjV4CwCeEdbc+90RB9mBpetsv3856+Pe08BoClSrhERUqhSfHDBa16CbGH5vvo
         fOZDwzSoGVUesf61uidsYL++/6P2cfsmnf2W3nrku52Hcq40uLmGQNVXmbVlmY92IfTb
         lnoXWKjNh2WqDOWB5wZnN/pnuu1cCyPy4tRAhbYaqKbTXqlgtMlhQS1SmBeOjXxiSDWJ
         FFoBFDmebEeWUerr185Fv5stk5uYF/ax4CZ+rnlGHO5cpgpG2dm2RW7jC3dnKx3I7u+n
         Z1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488046; x=1711092846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7NzGUVsSr/Zaoa+HKQno2pxQT2Wgt7ZOiBDBb/I4eAE=;
        b=YbLNR5q+/0JU+V3bAJWzwN2kzXkPeFj3aUYqUVVY61PZLkmipgCKvtBqwg4Hc04fZp
         qAAEi9p9YWMVQoI6eQPFFx5J26TvrDFizumW571kbKJF3WgCyGwN40GSmHF23laWNSFw
         t7X05VRzDWKAjWIEeoNkRE6yg1VQkFFeRCgkTYgCTqUwGL2s41TLu65els5OS9/HuWr4
         jaD6U/0ydGffX4BfrZTWGDd5qCrf/AK9W5Oq2Rkb87r0uAfiZbDqbHCIiuc1wRWitgK8
         MFZpOZSbMxBjKLufLiCzTEJCqEWzMDuxceZibTYbcB0RZvRDm+DIkn8MS+vKmtonFG6l
         wnpw==
X-Gm-Message-State: AOJu0YwgfFV5cPYttkHWywoFkWKvGBSnbwggXbx19JSuoGU4NLtMuBjL
	SS156Dae3ehQarldliil+gshP3oWqgTEhA/ZjEPvGxPYsFYniPHX
X-Google-Smtp-Source: AGHT+IFQ5vEYKXcBDVhfbix6xFG2LGch52MxyyJrGUqJLnvpC13viPD+WoM99M9mbWmseCsU1SMIBA==
X-Received: by 2002:a17:902:e84e:b0:1dc:3c3f:c64b with SMTP id t14-20020a170902e84e00b001dc3c3fc64bmr2917338plg.24.1710488046434;
        Fri, 15 Mar 2024 00:34:06 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:06 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 08/32] src: Incorporate nfnl_rcvbufsiz() in libnetfilter_queue
Date: Fri, 15 Mar 2024 18:33:23 +1100
Message-Id: <20240315073347.22628-9-duncan_roe@optusnet.com.au>
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

nfnl_rcvbufsiz() is the first bullet point in the Performance section
of the libnetfilter_queue HTML main page.
We have to assume people have used it,
so supply a version that uses libmnl.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  2 ++
 src/libnetfilter_queue.c                      | 34 +++++++++++++++++++
 2 files changed, 36 insertions(+)

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
index 17fe879..2051aca 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -559,6 +559,40 @@ out_free:
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
+	 * maximum */
+	status = setsockopt(h->fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
+	if (status < 0) {
+		/* if this didn't work, we try at least to get the system
+		 * wide maximum (or whatever the user requested) */
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

