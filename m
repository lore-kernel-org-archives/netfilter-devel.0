Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC284D2E
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529088; cv=none; b=osPsNZCLfVyM22tTq5EA3PCfSVYJBryGDrMtxHp3jO99LLDP6VDydhh/koqxZHgg6v/MN08hQIKGN9YWa5vTMDI/ZYE+b1HTKe2H1sqbuDg8v2rroKYSOSmZ1oRURLhHhYPnDgVcxoQ5tj+tfAInt7T+b2DTmX3XKiy5N4QWqcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529088; c=relaxed/simple;
	bh=sB4f39WMsrlBTLSL/f6EWFeBq2INt09jq/8icgjo+Ek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fjpAYxwIH2sxRsjlDwFTJL1c3IKqqSwIX18Dv96GEauJMrUNBYQv6kEIdtwVXBYlhPzqO5e5PqMneJ5AK8eyGj7MslRQa9fIMMHa1WUcrSr+fOSmSYABH5MaOZdktILFW9Wy3Ytfdo1oYWdHM3lqwXdmUMA9CiK/JFW8Gb4JRTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcINqD0c; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcINqD0c"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-681ad26f277so394005a12.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529086; x=1717133886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6XSwwMmkvr8JlszR7APJDaTCdV0Jy/wL5BBM79yxPeI=;
        b=mcINqD0cH4xkiNlwBt5lnbVjQ+g+6o+JqYfg0XcCldGC7Ah9Ro2veKzFlE4W59DI9L
         Rp3qjbWxWU99GGVxsyh0XNRw9HgU/J+cW7OA30LmI8sBdCVIl+YGKO0XzeVPatEgWRX8
         EFDkCJQ3huuhQVcbOYcdmpBmSBnMq0bSnzx2TePbZq7zkXLiq8oN3NwKWrK6G7ee27Ie
         ECeEwWcIyb3MPWqgH772L6UQxu5X0wivYsSCOzk62UyDRsbiBpxEQKW8hToY0RZcuqfE
         2ZaeU+YExJeTJYRPEEZuZaIoNAkvpx5alRB5lA4tHbiCliMQgWcbj0O3MKsRoMSrJwok
         z3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529086; x=1717133886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6XSwwMmkvr8JlszR7APJDaTCdV0Jy/wL5BBM79yxPeI=;
        b=Jf4fuwCmDZ+QvuEgnRh8/HNhxBFNX/ycurrNrjzC5qS1sdfmCAaluj0iLuWHM7drlu
         mfr1QKshoDU8lrqK7mGnyNVBk4yepZ8jTzJRTPCoY+FYg4Uqmh/R2rW+kXE+xfpo6I1c
         RMVXLrkW03s8ahiQEKirmQnwFpDFrg3zHmYX1kqC89B4bDkpudnn1KU+K70yqveN4nU/
         F60XdPgdqdqsebYIpUCOrK97eT3JiAPvyR8D5/ZUbxDjviBqPozbcB5EJgkIVc8sVOXq
         QgSvH0WcE4KIwWzUWnTDsbc7WzailFA6PqI0xzWl/7jEQWiDsD450QEhiBJ8IYC6euKt
         P7tA==
X-Gm-Message-State: AOJu0Yx4XFCZ8wWcKFYoE8wN7CiBX437LQnPWBazehkszix1mA9sC9fe
	dScZFQjG61njBu2ySFovCBSm9Swpo9hOFrZAh6/ytU7gLXYlmSJRRVdLdA==
X-Google-Smtp-Source: AGHT+IFMAJQmzAOEvlMHkcOCZ6mm408pr15OBu+C4+xhkW28PnqMLg0sJ/Yzog9Kh4upUuE++GckPw==
X-Received: by 2002:a05:6a21:8193:b0:1af:ac96:f4bf with SMTP id adf61e73a8af0-1b212d1e48cmr1445019637.15.1716529085458;
        Thu, 23 May 2024 22:38:05 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:38:05 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 10/15] src: Convert remaining nfq_* functions to use libmnl
Date: Fri, 24 May 2024 15:37:37 +1000
Message-Id: <20240524053742.27294-11-duncan_roe@optusnet.com.au>
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

Converted: nfq_set_verdict2(), nfq_set_verdict_batch2(),
           nfq_set_verdict_mark(), nfq_get_nfmark() [again] &
           nfq_get_skbinfo()
We only use 2 iovecs instead of 3
by tacking the data attribute onto the end of the first iovec buffer.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
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

