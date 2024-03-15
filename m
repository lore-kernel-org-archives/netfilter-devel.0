Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6461429A
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488048; cv=none; b=VZT/uOCFo+H3BjiqgqOdYsQHuecVOd6ZR2e3YyrrWvxD3xh74vIX+gyCPpYIKooECE89mfaVM9ChHDTZhjyNn0w4Lo/MG1gQMOI+P0pAMw4/BUl98GXIw06VtXLKzAQlccignPbSrcU0mzyNzDypHqkkssVLCVx1Qbjb06cDBGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488048; c=relaxed/simple;
	bh=cCxaPso5DNoMKUN09bc9ZJxj2WkLRdlw0veNGzi8H9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pt58lk0VuxjMZWhPjE+HpST5jOXJrI33ixrgVf0qri+DiQc1CswYGyGH1Xp5FzZF3RzrU+vKr1LF66Hnr8aJLCzFOXyHw95DcXDLeNYWk5+2y6VIVNjoVUxhF9cjtGZW3b/liOfw4CaLt8pxjqhI5I4y29/vlrRm20GA4dK910Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLclmOv1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLclmOv1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dee5ef2a7bso7417075ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488045; x=1711092845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRnTDDwk1udB5q58rFETPDslpxHpUb+B0mOH6lV3kSg=;
        b=nLclmOv1mGfhnpDeClGEafUt6wfimC81FqT9qBzwQimiz8B2304IFi5OytXz7DkpvF
         1HKpnJ9d/qTtffp9CmG4seNf+4xU72uQPC1igQMMu22JFXOCBsCxehHIRPmciAJFanj4
         H8cT5EN2iudvQAb3w4WJjpWdFbxboVAumSc/CJU1H5/XzWwvqITZYol/udd8Fslfd+S7
         Bh/G/9sMvwSv7ZUnMl+Q5Iey9J7dKtPvlKAB815sRkzg5L4SRr4RL3r1iEhhzbwMwedc
         HgF6f+xgP3aF39PdBJbSRz1LM9+V3Mrc/AJuRBzYwaNNzSCw39xf4CRTFYnBJ5oVuiTH
         ijMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488045; x=1711092845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iRnTDDwk1udB5q58rFETPDslpxHpUb+B0mOH6lV3kSg=;
        b=ifoFJbiXycZF17q7zmDvoyKoI/l0tykkJjuuoCQ9A9AYQJwD/rVn8+kzY+GLjrButL
         iWkhM/9sj4aOFaj25JnKrlqrETilX42D2Jj9b11FAu3GFrY/gaqgfV8818W18eXc9uAa
         Ahp/rig2VO4gHOM9/hrvz4JnnAhGim5So25OYIJWaguiyL+ISuJcsoS5oliUI9hVGRjn
         NqjE6kr2TUdthtgoaAW8xIyq2ewOEQi5USApk7qp8rxFpNbMUlCxXcuVmtND6mWUvadf
         /6/hgHT6jsqcSIAPB8rdVoEpCBeNC5ibag6zm++NLNFSZv/8eS/GtTmtVI7IhrbxIv6Z
         a45w==
X-Gm-Message-State: AOJu0Yx0SlKXLEeu6zzF9NWkIwB7Fx8Ks+GTAPUcQHqMzZpyu61HqSYi
	H1ZqBTnCVjQ3l2AD9TiSw+vevL0PQZ64FZBkoxOlqaarIW27LSMI
X-Google-Smtp-Source: AGHT+IFi4UobZANYWtQNKa6dqXIt9GCKdKVwYvDtcZFhaeG5T7p/uxLVqU7Lhh1mj3+h8NPLcphYyA==
X-Received: by 2002:a17:902:ea09:b0:1dd:999d:557f with SMTP id s9-20020a170902ea0900b001dd999d557fmr5564360plg.4.1710488044739;
        Fri, 15 Mar 2024 00:34:04 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:04 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 07/32] src: Convert nfq_set_verdict() and nfq_set_verdict2() to use libmnl if there is no data
Date: Fri, 15 Mar 2024 18:33:22 +1100
Message-Id: <20240315073347.22628-8-duncan_roe@optusnet.com.au>
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

static __set_verdict() uses mnl-API calls in enough places that the path
for no (mangled) data doesn't use any nfnl-API functions.
With no data, __set_verdict() uses sendto() (faster than sendmsg()).
nfq_set_verdict2() must not use htonl() on the packet mark.
checkpatch Block comments warning is fixed in a later commit.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 58875b1..17fe879 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -38,8 +38,8 @@
 /* so won't try to validate higher-numbered attrs but will store them. */
 /* mnl API programs will then be able to access them. */
 #include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_compat.h>
 
-#include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
 
@@ -912,13 +912,8 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
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
@@ -929,20 +924,22 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
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
+	 * 1 userspace address to validate instead of 2. */
+	if (!data_len)
+		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
 
-	iov[0].iov_base = &u.nmh;
-	iov[0].iov_len = NLMSG_TAIL(&u.nmh) - (void *)&u.nmh;
+	iov[0].iov_base = nlh;
+	iov[0].iov_len = NLMSG_TAIL(nlh) - (void *)nlh;
 	nvecs = 1;
 
 	if (data_len) {
@@ -956,7 +953,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		 * header.  The size of the attribute is given in the
 		 * nla_len field and is set in the nfnl_build_nfa_iovec()
 		 * function. */
-		u.nmh.nlmsg_len += data_attr.nla_len;
+		nlh->nlmsg_len += data_attr.nla_len;
 	}
 
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
@@ -1013,7 +1010,7 @@ int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
 		     uint32_t verdict, uint32_t mark,
 		     uint32_t data_len, const unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, htonl(mark), 1, data_len,
+	return __set_verdict(qh, id, verdict, mark, 1, data_len,
 						buf, NFQNL_MSG_VERDICT);
 }
 
-- 
2.35.8

