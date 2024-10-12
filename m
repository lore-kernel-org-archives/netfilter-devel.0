Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BA19E7F9
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774588; cv=none; b=B7WFGRlX8IDEm4RFZwXMqI1EtTG20uP6pe8lCwxS4d5zNlP19lsGGAPU7xpmezuti8aR1NOPMnkxcWleMgLvSjLqikU1FQWAvbhmpU1kVcOFTQG9xHtpfEJjiZRUeHwNQVK00+teEGaYpB5lMi1DxKlfDsQaO4HkjgXKRtism54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774588; c=relaxed/simple;
	bh=8XbsdWtuVe+klRcqCB50FJ2VIMcPP8W+8tFUTTgUCPY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jYcohp8ZEu/CX6I3NJfCX7JD3zUU8LTcOsHINDNX3WkHeDlXx+Y6qPBUjQ6oOcRR7tby/ct8CoRJ4LH/0wYD1y2ovdrlSeQtNsghttNQTXC7kRhqkbNlUhNwc9Yo2TbAlcFXiHxmdVgvPAkat3iJyT+SNMi9th7FWNhiCGF/cWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=anzwQTZn; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anzwQTZn"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e5130832aso340533b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774586; x=1729379386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1KS8BWkVdM5sMjzMozGDoZUMWXHNUL/xg+9VjJpunE=;
        b=anzwQTZndAtYUfAwvsiPUSFN6jKlPiDszCXtL1U6aimXWxDdIpNCcjI+uLLlDpyCiu
         CJonlGWewDOHZ4f/967ng1LFxGUUvKmpIWtJYC4mrRAiz8BtvfrZoazDEEcIoeiO1LLM
         QtOnlMlZJPQsOaX8HlFSM/ChjQQrRP0XrQnkP/8ldHtVjrDovTj1lz4xBaKopexPF1nE
         M1gGyM0sE7eAlltN3yAgRLBxeTGk8PjUcIXB0mdMXT4B46o0/jYaDD6cjruA5t6tNbw5
         8D5ErTb98FzSrl1gcpSr2QvJ+zrSU7OPo5MIz0uFYi97eYp4KaezOzG5CFOgenx2tP0J
         +NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774586; x=1729379386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X1KS8BWkVdM5sMjzMozGDoZUMWXHNUL/xg+9VjJpunE=;
        b=mmVPKDeYxzNkWcbUjIFnzqSkjUbGOS7nf1Zy9J2GgdA//zNLNGvWUKXrI2f+6fq2ZV
         LT6HCskpVU7mYvtYd7MBFHs56ay0pN7TTJ19QyKl0zLLoQobmgQvtaXJlfI5v5tPvqrz
         Hx+trmJ+s9bCKdMiCI7FCPyHx5HQ1MzZ3nyyFZS/itUlhwRMy5atd96XB2A7AMeZlrGj
         s5Oy92XJTz6nSHSoDWgqpFfnBrBJnAVpgONKJHALnC3ufUxukCCWCINlvXRQ3ITX/I50
         ziakMbRsvXeT6IU9RDOUPXFpOSCudqFhpy8+ixFqv7XeNC+tpfb1pklo7HAyzEyY7WAU
         jmJw==
X-Gm-Message-State: AOJu0YzcijGRob/53aLLPS7piaSC2DTzz2gCJg3fcDOqm5ed8k3mRBNA
	gPG2F2G2b9GrRiOSDJD8VggJJj+KG3rVUvakN+7NMM4yCayPOkpaFRowTg==
X-Google-Smtp-Source: AGHT+IE85e2w0DD4JTrTyxsLD/mmM4KJesChcSfe0Z+Q5iMa+ruDdtuMM0Li8PFGgfV8o1As6fJ+QQ==
X-Received: by 2002:a05:6a21:99a2:b0:1d8:abc6:71a4 with SMTP id adf61e73a8af0-1d8c955c952mr6216599637.6.1728774585956;
        Sat, 12 Oct 2024 16:09:45 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:45 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 10/15] src: Convert remaining nfq_* functions to use libmnl
Date: Sun, 13 Oct 2024 10:09:12 +1100
Message-Id: <20241012230917.11467-11-duncan_roe@optusnet.com.au>
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

Converted: nfq_set_verdict2(), nfq_set_verdict_batch2(),
           nfq_set_verdict_mark(), nfq_get_nfmark() [again] &
           nfq_get_skbinfo()
We only use 2 iovecs instead of 3
by tacking the data attribute onto the end of the first iovec buffer.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3: (none)

 Changes in v2:
 - Move nfq_set_mode() conversion to patch 5
 - Rebase to account for updated patches

 src/libnetfilter_queue.c | 67 +++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 8a11f41..ecdd144 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -989,17 +989,9 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
+	static struct sockaddr_nl snl = {.nl_family = AF_NETLINK };
 
-	struct iovec iov[3];
-	int nvecs;
-
-	/* This must be declared here (and not inside the data
-	 * handling block) because the iovec points to this. */
-	struct nlattr data_attr;
-
-	memset(iov, 0, sizeof(iov));
-
-	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, qh->id);
+	nlh = nfq_nlmsg_put(buf, type, qh->id);
 
 	/* add verdict header */
 	nfq_nlmsg_verdict_put(nlh, id, verdict);
@@ -1013,26 +1005,38 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 	 */
 	if (!data_len)
 		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
+	{
+		struct iovec iov[2];
+		struct nlattr *data_attr = mnl_nlmsg_get_payload_tail(nlh);
+		const struct msghdr msg = {
+			.msg_name = &snl,
+			.msg_namelen = sizeof(snl),
+			.msg_iov = iov,
+			.msg_iovlen = 2,
+			.msg_control = NULL,
+			.msg_controllen = 0,
+			.msg_flags = 0,
+		};
+
+		mnl_attr_put(nlh, NFQA_PAYLOAD, 0, NULL);
+
+		iov[0].iov_base = nlh;
+		iov[0].iov_len = nlh->nlmsg_len;
+		/* The typecast here is to cast away data's const-ness: */
+		iov[1].iov_base = (unsigned char *)data;
+		iov[1].iov_len = data_len;
 
-	iov[0].iov_base = nlh;
-	iov[0].iov_len = NLMSG_TAIL(nlh) - (void *)nlh;
-	nvecs = 1;
-
-	if (data_len) {
-		/* Temporary cast until we get rid of nfnl_build_nfa_iovec() */
-		nfnl_build_nfa_iovec(&iov[1], (struct nfattr *)&data_attr,
-		//nfnl_build_nfa_iovec(&iov[1], &data_attr,
-				     NFQA_PAYLOAD, data_len,
-				     (unsigned char *) data);
-		nvecs += 2;
 		/* Add the length of the appended data to the message
-		 * header.  The size of the attribute is given in the
-		 * nla_len field and is set in the nfnl_build_nfa_iovec()
-		 * function. */
-		nlh->nlmsg_len += data_attr.nla_len;
-	}
+		 * header and attribute length.
+		 * No padding is needed: this is the end of the message.
+		 */
+
+		nlh->nlmsg_len += data_len;
 
-	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
+		data_attr->nla_len += data_len;
+
+		return sendmsg(qh->h->nfnlh->fd, &msg, 0);
+	}
 }
 
 /**
@@ -1121,7 +1125,7 @@ EXPORT_SYMBOL
 int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
 			   uint32_t verdict, uint32_t mark)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
+	return __set_verdict(qh, id, verdict, mark, 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
 
@@ -1144,7 +1148,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 			 uint32_t verdict, uint32_t mark,
 			 uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
+	return __set_verdict(qh, id, verdict, ntohl(mark), 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
 
@@ -1212,7 +1216,6 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 		return 0;
 
 	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
-	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
 /**
@@ -1476,10 +1479,10 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_SKB_INFO))
+	if (!nfad->data[NFQA_SKB_INFO])
 		return 0;
 
-	return ntohl(nfnl_get_data(nfad->data, NFQA_SKB_INFO, uint32_t));
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_SKB_INFO]));
 }
 
 /**
-- 
2.35.8

