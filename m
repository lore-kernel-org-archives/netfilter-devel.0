Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDD684DE2
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529085; cv=none; b=VPFqb1aSer6/7r+/LkbidF+d3Ij3FAIfcqkKU9WsM04vbo6ddQjCVned5WEFVmPIgRE+wF0T2aQPJmN4Kt1gxGQJ5v91Eft/KrGhJzln9ShIb1spqgCDKmTg0iqCXGeBzFYkIHl6x8IsHLxk6TM2wX5f2vRI8UR68o5DFf218LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529085; c=relaxed/simple;
	bh=VKZYRGyJ9ohREfhYERKvpCKF8Q4FeTbQ5UddWd4r25E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lxx3+qOmtYTnY7s214JrT4mRfpVE1kUZ9fNh1UGQ95DzC8CPV9A7x+nTvpgGcJOjXiauISrtAdxaneO/J8O+Ol6TYJl6WsEdAE2t/8y/rlckPeGKb5ZjXZ2VbXv3COSV5tVJUS2PcVtvWsmHljTPvm8x/72/YOfB6ixEYAh3rwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=micXriR4; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="micXriR4"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f6a045d476so2871660b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529080; x=1717133880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fb23lW6Tbx5slj7A8cVV+7QXbCSRdIw3TQ3U/wjF6/M=;
        b=micXriR4g5RLECdC10N3AooFXh9aT89NCoJSCVzBGHn4ur6GA/ERu448o0FjrC992L
         J6afTSkGdlFqhRgZ91fhx6lmNRdvKfOCVFSM0XwvSa/1FFx90saCTM/Xj3RqaB4lgo9i
         8Vr2XUdWzLY3nx+6tLrPhv1LgsWRonTIvwzfjfDfRl61QGlB2zT6h57E2Rz+COGiO7HF
         i2jENem/Jd2Err32XcWVsR2S8A4ylGczXr/xblaeqwQsSHBybs1WfouicZgVbvrB9IpN
         qE4qxje01dO7mw3CKtGLtphS64gXja1Ddqd9YzEW9BZ+yZJFvpxofrN8AU7qUKr1aTl9
         JT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529080; x=1717133880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fb23lW6Tbx5slj7A8cVV+7QXbCSRdIw3TQ3U/wjF6/M=;
        b=LMWVc+GiIRlHNlwMpiXmCfcYDpEznw8o/t9qoRDLaKs5IZrlKn5a/F20WHaQEkNCDb
         pl5W9EjRQdNteqcdWNGS48JVUpyWnqf4LV+yYbxhzDhft9bZgsyHbft9I+AEh2osbOHD
         x6iE0LwJmzfWVZp2Le3q8z9lxvSRchFD/sh5Mi9VmRV2Zkpq2erCtNhYKr+Ww+t4t7Rd
         AtinANglJH1wtG0HELZ6od8JQnxSr2b67y8UX2Jrqe+tZGseKbjE7ilmi7ST+ev4u+Ke
         k2zjt4w0egAySktXe0Oxm9RW+MARfC3qg0g9/53tf8fSBKbZBWTDFKDz5L3scg+PeHdQ
         UGYw==
X-Gm-Message-State: AOJu0YzCD+iFckFvqquClHwlh6cgZCKKQrpkXrOafWTyj6AyD+y2bKiC
	liOstU9b/AjpC9sp8XPBuQ6yAj5+GFaOT8X320wVRPeFlJo01ftrPbdvsw==
X-Google-Smtp-Source: AGHT+IHK/GgLSp7caEqz+OpbHK/ERVmATIIdMKUMkI/USvmVFMIqUanDsFxVdTSZm30XEIQdNfFn1A==
X-Received: by 2002:a05:6a00:4390:b0:6f8:ddfe:8fcf with SMTP id d2e1a72fcca58-6f8f34ac923mr1517013b3a.13.1716529080131;
        Thu, 23 May 2024 22:38:00 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:59 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 07/15] src: Convert nfq_set_verdict() and nfq_set_verdict2() to use libmnl if there is no data
Date: Fri, 24 May 2024 15:37:34 +1000
Message-Id: <20240524053742.27294-8-duncan_roe@optusnet.com.au>
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

static __set_verdict() uses mnl-API calls in enough places that the path
for no (mangled) data doesn't use any nfnl-API functions.
With no data, __set_verdict() uses sendto() (faster than sendmsg()).
nfq_set_verdict2() must not use htonl() on the packet mark.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 v2:
 - rebase to account for updated patches 1 - 3
 - fix checkpatch warning re block comment termination

 src/libnetfilter_queue.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 6500fec..3fa8d2d 100644
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

