Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F357824B7
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529078; cv=none; b=cUkWzleJZXnEmpR2oDFpDgLtsdkwhu0vsLGgp3hZKaCJC5FQFuPb4F7TxKY7ZOcIsk2bT/M2H30Lm9fYLmN3RPl7l/4oMw10rQGI2ib5UQxszb2VGtBRS4lG7XUOYFhtqzyd+mmLA92o5d55DF7mJumuyDRF3Buox+rrrto3pro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529078; c=relaxed/simple;
	bh=UASo7kMUu9k0Eclj+3CRmX32DJU67MKe2MFsb2EjJVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G/xoimn5uuTbKcMlV8+JcILFrq0fUS0nLkiuILUW8B29maOvEwTAQrdXAoMI6Zyouu6jJORYzXPio7hx/ptO4lSPLM51fIufac8vgqIWd9NhfIt18/6k6GCeCvmdVJO0uoXcOcah2YO52IFM4Tm/lAP9eh036JF/yYgr35sku7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SSI8RG6Y; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSI8RG6Y"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6f8f34cb0beso334600b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529077; x=1717133877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfi02ckje3flkDOCPG+19u/w8HCjKsp7O9An+CfQ3cc=;
        b=SSI8RG6Y5nc4QY+pA9Er6U5YeHWkzssg0RcYL1p6SubUB9Mhqw5UCbDsoJUz/dWAnd
         88o7Zdn7lzm1R4IzV/ptDGIIwyWD9B3i/p19kiJRbt49t8QTNV6QCIydpKgujdvVtpbN
         kU8+pRGQnSa3KfMaMBakV7I9xeEF0wdX4lrFLkmFVcfR/Vtbxs6IAA6+tdNx60pA7wVL
         05sCFlf31lf6zLqoKZWWIEwG6org+leyPpVY+b/kzIuk3KSAKRf1JmubWig89bDDMCL0
         GVI+WaRbrGjTQHLdJPvEa8W9PJkHMZx6/hneg00sqwX03Kzf/jRPJhZ0A4St4xinH9Ir
         +ejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529077; x=1717133877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hfi02ckje3flkDOCPG+19u/w8HCjKsp7O9An+CfQ3cc=;
        b=g3k3dkXxWFxHSIGfOdkbEHVQFimFYvWh5zLG83/TPC1AI0oiX8RvkFMIjLCHcQiMKG
         G6RQOya24UVkYkfZsAZvscAPDZruUaO//uB8j7wyd23vMDsQvNWDANwsUDpggi1NW93r
         7Fq63Gk4mxT3oT8E7ZaQ4qqiLebRfKMbHIPRHnA3QD0YuQiGKgst/aD49WoMYwn8y7aE
         yGcAxxtGibErVmZm1ZnfUjkuBerhnfyaeIOokdrUGK9KV3IWR1Wzy97ZzkdIIyApXlPC
         6yWwQAQzioG+v7DevivXiFJa6BsL9oWF9t5L0v5HqwNlQBdiYqoJW33ahAArxCNaj90l
         O+2A==
X-Gm-Message-State: AOJu0Yw1VnBqYf5SmuemEIMLuHDmdYzD2biYoaZmIzaU1QOEu0cGewzx
	qB4RddfLxNh0Cap+YP0v7sLrRrqylk+XLJFnW3/ZX7oufmB4Ud8U5DPAAw==
X-Google-Smtp-Source: AGHT+IHtCusDucjF+opwF0EvmYLLmdnCx6LVTD4oC42834C+dfsoLW25XtMBQUkcmuMNRmugNVoVXw==
X-Received: by 2002:a05:6a20:9183:b0:1af:fff9:1c59 with SMTP id adf61e73a8af0-1b212ca7d99mr2133366637.2.1716529076603;
        Thu, 23 May 2024 22:37:56 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:56 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 05/15] src: Convert nfq_set_queue_flags(), nfq_set_queue_maxlen() & nfq_set_mode() to use libmnl
Date: Fri, 24 May 2024 15:37:32 +1000
Message-Id: <20240524053742.27294-6-duncan_roe@optusnet.com.au>
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

Use a buffer of MNL_SOCKET_BUFFER_SIZE; no union required.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v2:
 - Rename nfq_query to __nfq_query so as not to pollute Posix namespace
 - Also convert nfq_set_mode() here because of using the same strategy
 - rebase to account for updated patches 1 - 3

 src/libnetfilter_queue.c | 58 ++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index b64f14a..0ef3bd3 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -782,22 +782,21 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 EXPORT_SYMBOL
 int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_params params;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->id, NLM_F_ACK);
 
-	params.copy_range = htonl(range);
-	params.copy_mode = mode;
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
-			sizeof(params));
+	nfq_nlmsg_cfg_put_params(nlh, mode, range);
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	ret = mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(qh->h->nl, buf, sizeof(buf));
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(qh->h->nl),
+		    NULL, NULL);
+	return ret;
 }
 
 /**
@@ -871,23 +870,18 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 EXPORT_SYMBOL
 int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mask)
-			+NFA_LENGTH(sizeof(flags)))];
-		struct nlmsghdr nmh;
-	} u;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
 	mask = htonl(mask);
 	flags = htonl(flags);
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-		      NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->id, NLM_F_ACK);
 
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_FLAGS, flags);
-	nfnl_addattr32(&u.nmh, sizeof(u), NFQA_CFG_MASK, mask);
+	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, flags);
+	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, mask);
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return __nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -904,20 +898,14 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
 EXPORT_SYMBOL
 int nfq_set_queue_maxlen(struct nfq_q_handle *qh, uint32_t queuelen)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	uint32_t queue_maxlen = htonl(queuelen);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->id, NLM_F_ACK);
 
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
-			sizeof(queue_maxlen));
+	mnl_attr_put_u32(nlh, NFQA_CFG_QUEUE_MAXLEN, htonl(queuelen));
 
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	return __nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
-- 
2.35.8

