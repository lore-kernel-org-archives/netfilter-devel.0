Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB761426E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488052; cv=none; b=WvODZNu8tVclypKDvcCsYPyQ94VkMOrJX0Ru3xL2pH7yG3VNw57DvQ1MRjLrxPdpUzM3kSjLIBvE3Aop12SMz2xIQ7BRHm+vOqIrpBS86l0kzN9mgE3ggauNII8huMIx1J6SeQ+mDMJSyfgM9Bt4ds3qIVZ9EsY+uXwB4HCezaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488052; c=relaxed/simple;
	bh=OzrpapOf3iK8jrvpOfne3uvltbv5sWeg8RF18WsnsoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qp+hH6fAvAi2UkbjL81NMX8eWz7dy/9i8PzbO0mHr02vKiXuNO56LtrnQo7GOlveV0J2a5e1mtHPLYjyzNchSDs5zV6aQlxCsDsp04obyTgq4A0ZD1iQoOzu9u/qW0EiBnnKriYFHBxZOKZbRF0wx0gU5ENdXBOI1ugysmV33JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yn6VYMqk; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yn6VYMqk"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dd8dd198d0so13271895ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488050; x=1711092850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nx9nZzVFA6VxTD2OvS2/V913kVcLtwJK0Cr6Ihrh01U=;
        b=Yn6VYMqkrVa0shml5YA6DGT+ZxROGPXW+7GvSVppw+kycG/Tisp6ZXvWZz49aPG9fk
         pwS/WyWE5wTTrji6aC49IHhUXnsVEqkfxjItMukq5HIxwY0k80Y63Cy6vsHOWQdfCQpH
         1Uzbmd42EpM/pvAoNbqHOfqEq3H7UF7h4U2XFQggDwRgefFeDWE6zeF0wsSvaLJrdL4B
         iat+UNkeirSNcdxhT3r2U0sot8lpu3IMfJRI5vTFFkbgyEyowtsXJN0etrqFqQQzgoDP
         EOhZJZtCDLnDlxjedQPZ/BJDVBnilNK10tmZ1GDAmfJajCK96fsH+mZR+ARxAQExp7DI
         vg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488050; x=1711092850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nx9nZzVFA6VxTD2OvS2/V913kVcLtwJK0Cr6Ihrh01U=;
        b=R/yDeCe+iReNPGRfI4DywleD+6KYizqM4Y0lD1Gm9Qwhe/APcA64HryzIWY8VhnzsB
         nHUkU2ZOWl597bIO/QyJzQENkfmTzEJTcSLtKsPM/mcu2jw3wVvRMTQJ2cw6WqAFpsp/
         OMM/wZMwYR/EN24m971MRILFfSSdTN5oWEl71YGsjz2ilbi86VUxoYTLpMxdSKLTgPvJ
         Kr3XJ/8mVj/sBQSGEXiXmRcIYluuUdDflLJ/3iS2y2Yvs8PRWaMg3+3UlwQ2biOduMEp
         CGfl4sgmih5UAAQnK2zz94ah2zl2w+UTflhyXEHCbejR4/5dBx+k5du8SiPj4yoDrhrE
         ny7g==
X-Gm-Message-State: AOJu0YyjwPbAbX3/eRdpRZVNlwpzqZEY/NXnp+6IMKXvmy8IdSH2M8DN
	10z4s2g3tGqRyzkYY+n/IM3FRW0F2TLrkrVIipWhMasZB5gRwXkfiKmx5Uqj
X-Google-Smtp-Source: AGHT+IFR5+oeUZnNNJZL/D6Wr+yjh5gtxmNY9Qndvtzb2H6lGL23j7jaec60OXjLPvPEen6A/pM5cA==
X-Received: by 2002:a17:902:d4c1:b0:1dd:b67b:21c0 with SMTP id o1-20020a170902d4c100b001ddb67b21c0mr3059469plg.2.1710488049857;
        Fri, 15 Mar 2024 00:34:09 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:09 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 10/32] src: Convert remaining nfq_* functions to use libmnl
Date: Fri, 15 Mar 2024 18:33:25 +1100
Message-Id: <20240315073347.22628-11-duncan_roe@optusnet.com.au>
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

Converted: nfq_set_verdict2(), nfq_set_verdict_batch2(),
	   nfq_set_verdict_mark(), nfq_get_nfmark() [again],
	   nfq_get_skbinfo() & nfq_set_mode().
We only use 2 iovecs instead of 3
by tacking the data attribute onto the end of the first iovec buffer.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 98 ++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 48 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 5e09eb7..56d51ca 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -810,22 +810,21 @@ int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 EXPORT_SYMBOL
 int nfq_set_mode(struct nfq_q_handle *qh, uint8_t mode, uint32_t range)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_params params;
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
-
-	params.copy_range = htonl(range);
-	params.copy_mode = mode;
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_PARAMS, &params,
-			sizeof(params));
-
-	return nfnl_query(qh->h->nfnlh, &u.nmh);
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int ret;
+
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, qh->id, NLM_F_ACK);
+
+	nfq_nlmsg_cfg_put_params(nlh, mode, range);
+
+	ret = mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(qh->h->nl, buf, sizeof(buf));
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(qh->h->nl),
+		    NULL, NULL);
+	return ret;
 }
 
 /**
@@ -948,17 +947,9 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
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
@@ -971,26 +962,38 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 	 * 1 userspace address to validate instead of 2. */
 	if (!data_len)
 		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
+	{
+		struct iovec iov[2];
+		struct nlattr *data_attr = mnl_nlmsg_get_payload_tail(nlh);
+		const struct msghdr msg = {
+			.msg_name = &snl,
+			.msg_namelen = sizeof snl,
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
@@ -1079,7 +1082,7 @@ EXPORT_SYMBOL
 int nfq_set_verdict_batch2(struct nfq_q_handle *qh, uint32_t id,
 			   uint32_t verdict, uint32_t mark)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, 0,
+	return __set_verdict(qh, id, verdict, mark, 1, 0,
 				NULL, NFQNL_MSG_VERDICT_BATCH);
 }
 
@@ -1102,7 +1105,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 			 uint32_t verdict, uint32_t mark,
 			 uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, data_len, buf,
+	return __set_verdict(qh, id, verdict, ntohl(mark), 1, data_len, buf,
 						NFQNL_MSG_VERDICT);
 }
 
@@ -1170,7 +1173,6 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 		return 0;
 
 	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
-	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
 /**
@@ -1434,10 +1436,10 @@ struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
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

