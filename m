Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FC019C55D
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774583; cv=none; b=FZdLgKZt0clihEXIsTcPT/Xb2oXquC2pssPR0sEukH6dz/4JRJNQr/7yoxzIEeTY9ei9mlrfL1fCvzlMTzs5XKdCoAGOcfQNhKJQlkuaD8UMi0w3vyJTW/YkQbB8bsF4VGDaSfiPwyoP13Kh6kKiCfRY+XExZlX2hW/gLCOzAUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774583; c=relaxed/simple;
	bh=1hEHnl/BFFfHoLF2zo53x2JLpg0CCYCgKA7EnejJKIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nfWI9uZcYGV5VAbcaKL5E4fIJ3Fm7cwJZVULrUMdZ/GWCqiVUHbifBdR+8UG5cbr84pHOpSbfSGqBkARVSzV9V+wxYFakjH1S24fuuufw3xN62jXLRAhWhLjI8fkwoPaCMtt3qgD596OYDf4xh5A9uc1u8BCDAKHUDbz5NMe/kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRKsvPQ4; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRKsvPQ4"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so795856b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774579; x=1729379379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ka4qhUTCvvBOtkFjA90jCWVdIrdm9csG92ooZ5YHLL0=;
        b=JRKsvPQ4HXsMtqNgYsPnd8ZYGpOmiOUc2wTW3hcQGp+3jev7IFg94sJ/mcnzOhU2D2
         +YkT+C2yfkQ9vOjM1Ui61Mvl9dKt/MRWr57lKkV0pYAH0HP3zBYOEAxz74kAOZhrlxDQ
         uXkFS9JXZvNL2LyRmn29fK38a3BOG5jbTQku0nUJZG1W76ZTL37/IlLbxmaOevV1YScG
         F+4/Rcd6RKT7pOf5K3EJC4FghxpunL/h+Lu1msWRcvE2/DfHmgLQuDI5zMMQiXsJMnHg
         5JovfvvIlvpGNu+ceyRJpu9HCfYg5pULQ9aiw0kPLgArBnL7o5eGVKSnZymLBsj2EHmF
         ekBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774579; x=1729379379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ka4qhUTCvvBOtkFjA90jCWVdIrdm9csG92ooZ5YHLL0=;
        b=Zvb4lPxQqHFGuXIkUPhqg4b5ZRM/fRL44yBw5JaYDcRypakor5Qbb78NVX/GD+yXgz
         wKfJjryExq+S48xcZ6SZGlMM64s+bjzW3LaT4sColRqPIPSc8mngx4bA+vZl6fwvJxI2
         VEOEn6wz+5BvRSjfKL87O6qmuvcF/fO+0zBv243jYISJSZetzkuxWFUmZeEL3g8VESAE
         nQysIpUFZKYy621SeSuRtLkrun56lIrfzmZJfug30OQIS0R8EfT3jH8xga9sOKnpGWiQ
         ACpT0jzMBsGqL1d8Qz3fp8SYP7Xp0v6nC6iDSWD7b8DM8nL8q5qOY9sdeMnZ3z1rlolB
         ipZw==
X-Gm-Message-State: AOJu0Yy0nPaHdcxhwEos1cGIficX+nz0S1qWfvg5xgllf6gbBCw/1qvU
	YgKrufZtWa1pbx1dqXSlI5SYV4WWcc/ZFoFpBCPykyCw2SvcwqDy0UfM+w==
X-Google-Smtp-Source: AGHT+IHB1TEyc62ieKOCsXB7i4ygbO3RNZfijI0TNKcJNFJJ7U5LY3TaBhVSZOwy8JGVxbGv09w4tg==
X-Received: by 2002:a05:6a20:c997:b0:1cf:499c:f918 with SMTP id adf61e73a8af0-1d8bcf2bf22mr11676004637.18.1728774579122;
        Sat, 12 Oct 2024 16:09:39 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 07/15] src: Convert nfq_set_verdict() and nfq_set_verdict2() to use libmnl if there is no data
Date: Sun, 13 Oct 2024 10:09:09 +1100
Message-Id: <20241012230917.11467-8-duncan_roe@optusnet.com.au>
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

static __set_verdict() uses mnl-API calls in enough places that the path
for no (mangled) data doesn't use any nfnl-API functions.
With no data, __set_verdict() uses sendto() (faster than sendmsg()).
nfq_set_verdict2() must not use htonl() on the packet mark.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v3:
 - rebased
 - defer removal of libnfnetlink/libnfnetlink.h include to 13/15

 v2:
 - rebase to account for updated patches 1 - 3
 - fix checkpatch warning re block comment termination

 src/libnetfilter_queue.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 6500fec..3fa8d2d 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -951,13 +951,8 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		uint32_t data_len, const unsigned char *data,
 		enum nfqnl_msg_types type)
 {
-	struct nfqnl_msg_verdict_hdr vh;
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(mark))
-			+NFA_LENGTH(sizeof(vh))];
-		struct nlmsghdr nmh;
-	} u;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
 	struct iovec iov[3];
 	int nvecs;
@@ -968,20 +963,23 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
 	memset(iov, 0, sizeof(iov));
 
-	vh.verdict = htonl(verdict);
-	vh.id = htonl(id);
-
-	nfnl_fill_hdr(qh->h->nfnlssh, &u.nmh, 0, AF_UNSPEC, qh->id,
-				type, NLM_F_REQUEST);
+	nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, qh->id);
 
 	/* add verdict header */
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_VERDICT_HDR, &vh, sizeof(vh));
+	nfq_nlmsg_verdict_put(nlh, id, verdict);
 
 	if (set_mark)
-		nfnl_addattr32(&u.nmh, sizeof(u), NFQA_MARK, mark);
+		nfq_nlmsg_verdict_put_mark(nlh, mark);
+
+	/* Efficiency gain: when there is only 1 iov,
+	 * sendto() is faster than sendmsg() because the kernel only has
+	 * 1 userspace address to validate instead of 2.
+	 */
+	if (!data_len)
+		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
 
-	iov[0].iov_base = &u.nmh;
-	iov[0].iov_len = NLMSG_TAIL(&u.nmh) - (void *)&u.nmh;
+	iov[0].iov_base = nlh;
+	iov[0].iov_len = NLMSG_TAIL(nlh) - (void *)nlh;
 	nvecs = 1;
 
 	if (data_len) {
@@ -995,7 +993,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		 * header.  The size of the attribute is given in the
 		 * nla_len field and is set in the nfnl_build_nfa_iovec()
 		 * function. */
-		u.nmh.nlmsg_len += data_attr.nla_len;
+		nlh->nlmsg_len += data_attr.nla_len;
 	}
 
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
@@ -1052,7 +1050,7 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
 		     uint32_t verdict, uint32_t mark,
 		     uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
+	return __set_verdict(qh, id, verdict, mark, 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
 
-- 
2.35.8

