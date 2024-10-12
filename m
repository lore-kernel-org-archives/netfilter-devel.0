Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5807A15530F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774576; cv=none; b=caoJi3k+UZjAacePtYLe1FC6z+n9TGhuzTBRNbDn/IFW2+4kVpBWzUkcg3u8uq7whdbxjnlitRnOPI67e8gN9wkLMgojaUOGuXVZ5YOfbCOZETSbIm5AyLsY10rvBMeZtfNdVxMcNxIBQQDVrgnejuQNxnBd8Lf0fSOtD2Kjlr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774576; c=relaxed/simple;
	bh=b1fhhiBGYzl4CF3GNP86oQExrichJEQTmn+2CjODYz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqs0Ka3ZiDbmN/MI2sF+EdimzIH/nHmD+jsiLy0363NhHpUnJ+XUuBdfr6Rq2dHV0Qu/zbCS8CLF2bRHq1q5uAE+ayR3p418mhYU9pS+C/H1Yr/Dh8bgSMMuvGiiB0EgUP6WOhusYqH6o1B2wFBu2988JiFQAKIg2s27CacEVnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hjs3F7RZ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hjs3F7RZ"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e053cf1f3so2874211b3a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774575; x=1729379375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfsnGPl4SLLCVoELpc7h4Ldtukm4MyYpcyZZE2WAyYk=;
        b=Hjs3F7RZrKy129UDhUFxIc6GVDF6sVA6gNN5JJVE0IPMKPTSHkK0lY0pXyOGh2SBvm
         08Uc6uiglXXiIqCkxGFbYdRt6YZvyiM6soQ9cm0LYYGFSviUcSp2LIomt8mmIOgTewVq
         OczfxEoyGzBg+/SQ6dcL5MVIBG4EpCfTzOQUzsvbquuGbj1FqYAwkk1pMZHBoQ6GY1ed
         aIXCxgZ1EjNcS7H1aZUIzX8ZcpOuxNl2WGSplCtDgw3SQ1+MCqjfMqQ4NnkG1nptJHPN
         LsG8hmsthwJoYfC3hPJS0OxzLIiakR4MdgNRVHw9joJBPdrceS07DZcindMR4/gYIcqD
         JlZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774575; x=1729379375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mfsnGPl4SLLCVoELpc7h4Ldtukm4MyYpcyZZE2WAyYk=;
        b=ka/KoXnoZXP2OnfuQ+sqPOBMkWAVaikcQUNKpPF6TaY4lNumPd2ij1SHZkC14Jr6vI
         JpCqE+PcQEta3bpjG3+KpumogkYKpjZiFN5JZi4fspXkWweqxrbTmgtc37t7RASv7xm3
         MfX/LruvpsIBZ29si57xtHuuzUBFKs4n1kzOKJAB02bokquX59cjlyoKRhE79qAHaaLy
         P7oLbXEMbDnLpsxT52znclb1nPcVdtJkrKX2MuOt7/LBEEEcTB2H/5N/62WeEkEv3HF1
         f/XL9WoJCZEiV7eWrKG0hX80O10hgtD8sV0mRF/kYRHhbyosUH4KVwrAyndT8RYCCZI/
         QkVQ==
X-Gm-Message-State: AOJu0YzQSZOzN5Tl6XCrO2GKlBey9iPiFHkLK0+FifTjH2ffHWHN0xV/
	3Efwk/BPN/Apkm+i9MPbJZWoICdt6OiNNWCT1bGwWL22q9sr0RhYehQxlQ==
X-Google-Smtp-Source: AGHT+IGfkdcsgqOecEpoktOAcPealnTdWpytZvafZkR06Z2QYCC2UpkbP7HxPJbTlPk0BQ0teHU9og==
X-Received: by 2002:a05:6a00:b4b:b0:71e:5e04:be9b with SMTP id d2e1a72fcca58-71e5e04bfc0mr292523b3a.12.1728774574578;
        Sat, 12 Oct 2024 16:09:34 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:33 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 05/15] src: Convert nfq_set_queue_flags(), nfq_set_queue_maxlen() & nfq_set_mode() to use libmnl
Date: Sun, 13 Oct 2024 10:09:07 +1100
Message-Id: <20241012230917.11467-6-duncan_roe@optusnet.com.au>
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

Use a buffer of MNL_SOCKET_BUFFER_SIZE; no union required.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3: rebased

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
@@ -789,22 +789,21 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
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
@@ -878,23 +877,18 @@ int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
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
@@ -911,20 +905,14 @@ int nfq_set_queue_flags(struct nfq_q_handle *qh, uint32_t mask, uint32_t flags)
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

