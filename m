Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825C13FE7
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488043; cv=none; b=Kri/VPQXlkpTNKAYGzz8VpaqaQSpZAW4xp1EyKskv8a4mfixqsGx3yuZ3+eqtxekuQ8Y4f7mvxEukrnqQJ/ay+XtGShTA8VRDGJmeRImsU/87qmtffcSLmLeCWTSl8RNik8tMZSotQDCiYKSDawsdo9OLjFmcWqYxN4f1p/0T0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488043; c=relaxed/simple;
	bh=lcapLHcUmDGrxyzBDa0+SClfQbI3/+Bsc/aYqmUekXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mMMdeLE8KTHaV96ntSUhsfrzrVg0gMnIpLKaMwdAUldiWAmrs3XCRC9yj32GP1Q8KzCdMcOKQ5Z0DegZC9Zd52dgxlwTdIdE/O+lETo3ju/2o2J048wel8FHZDCsuKECTqLYDPWrstDW9t6hBmvxoWc8WM39ZlIMREGx+09Oqns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNpzuDoN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNpzuDoN"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd8dd198d0so13271205ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488041; x=1711092841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VMWQO8f+1AWh55gVfTz0Kx2ZcjHjEXE4RlyK+v8I2BE=;
        b=PNpzuDoNNzeogqkkRavJlk/T+XDTCrXvsnKdQkhZfpQ+P+POijEE48kRv3IiB3hGlt
         7uHF5SLJgsFLOKlqSIsbJcMNJQWiRnlz2TTmSBjKvdwopmiGWUeE7qOg6cYttHJqJF2x
         gIZwPMsmMYhiGxRyubMkK42xSJVUNKtpD4D50GusmSru8T0nElSQFFDmVd/LC0+IMuSn
         aeH29j3fsDLeXA+LEMyw8LuuP9MN83ICmrzQb7/7dtJcmoBrGTnsRNd1HK+9gB7nAxkp
         YcAxV0JxjQHMjPD1Ef8FmaHA5wMDONCWONaw//vE7mMyWGgITJq7/oxN5Z4uS3sRmdVm
         j0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488041; x=1711092841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VMWQO8f+1AWh55gVfTz0Kx2ZcjHjEXE4RlyK+v8I2BE=;
        b=H9q1g5zVETp220eGSX9xxN5K+ya5jI3Ix+rIpRHG7tCVO5UWacVYxO1MTPO09Lmgkj
         ua6jP6CNPkHBuOApzIThAsz4ya2TN0seHN5Sjm9FvC/5zCdA+BvHhSdAj+gC4mitwHY5
         ZSD72lIugt7iIbAdfNZQPGg2PWmjGv6/4fI/U2ll4I0Kj6Exjwuykbawfbp/W7M+gnbL
         9FlCp6X5XIlAoQpLbpP/SavvP3A+SMxj0YTQF9V1QI6Ex5ZhAtNvpYwr+pOR7O6NWfyz
         cuo9xV4/lJuIVYdy+bE7BfmGspqprTJT9DDdCIS9ESGPvwqGYit3fJa1M3EDJsRSsZld
         9VBA==
X-Gm-Message-State: AOJu0YwYzA43jHaKwAr9yxtwz+cjqfa2us1nf5PSsyHMVLqhvxEQrcQ3
	PHMrnX+gMhmQFzAx1m94FnA0EHfmoVgJtPuCYSX2qQdgqylHyP5g2GS+CwML
X-Google-Smtp-Source: AGHT+IEGkwhpV0j2llX1mLrK4qQL+uE1Ta74OGmqvXTZfa+z17h+KEXV6vQ0ROY3WLpDLAxaZIDyFg==
X-Received: by 2002:a17:903:41c9:b0:1dd:998f:f21d with SMTP id u9-20020a17090341c900b001dd998ff21dmr3008160ple.22.1710488041073;
        Fri, 15 Mar 2024 00:34:01 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:00 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 05/32] src: Convert nfq_set_queue_flags() & nfq_set_queue_maxlen() to use libmnl
Date: Fri, 15 Mar 2024 18:33:20 +1100
Message-Id: <20240315073347.22628-6-duncan_roe@optusnet.com.au>
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

Use a buffer of MNL_SOCKET_BUFFER_SIZE; no union required.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 1ef6fb8..28aa771 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -831,23 +831,18 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
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
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
@@ -864,20 +859,14 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
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
+	return nfq_query(qh->h, nlh, buf, sizeof(buf));
 }
 
 /**
-- 
2.35.8

