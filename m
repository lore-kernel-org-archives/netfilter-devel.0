Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE584E1D
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529077; cv=none; b=ObV/pk5ESa4pJfX9BZWUIka+jdWc7RV5DWsy6nTmrB+oYOb3Y/huq9kkxGWIeDguiUg55x9nSmBJNmS/1XwGNlReNl7Nxbu3Yq/+jWLCiRw4uvssvWTPxF3sqde22UG98zduH7MGRRs437Do1rj853RqlJxDpid4a/MiDf03EbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529077; c=relaxed/simple;
	bh=HIoS6CMhAaPf2ci+MSA2ecWmDFfCJUVSo5TL2dIP1bE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dRNM64kkSgNYEA5KvBbBJRaO5+VMh2+xOxVY0rG3A/AYhCh5Hg7KssSVPKpBGrHIaRp4k0k6pF28r4LXATTPnmODbniqqcouCgMKEj3s9Mb4sek55j7mMrdqAWtABTEVimlM5KvJq1KYrHH2pYrYl2BdeCxpYl3X+k9cNK+ELYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C07hfKKw; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C07hfKKw"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f662252c7eso1559626a34.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529075; x=1717133875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnTLtFIDzBp4+fJ0vM730nicNBooRKH3wY3PGFn9AvI=;
        b=C07hfKKw23wD5Cmiz2oFYfR8MFJsa/yPWIPBwvjW0G3/CCi0g9ELCqfTpJc90SkDD4
         ENn4rDnx/GDB8wBtkAcC1rZimyAA2mAINjwAF13ZNtrQUvZiDkNEVwMB9w6JTBOwslhO
         TiPGcJxwBQEw9xIbqZRJAoykNPyRbMe71W+LUMp2D/lDyPC2haGtUSzS8Zz2Dtqe2shT
         34gb1uXF/4a29p9CBT3afbzEVr2+jMVM6zLFK3nPFWDh8CILfjUhha1BXzZwKoVW/N4D
         ijQPlRkEcPmAl19QjAqqOKmraTGGdUeSRDt5iTm8PqyL3MdGXRkMHc6Cs6NbeNqqKCMb
         JYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529075; x=1717133875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hnTLtFIDzBp4+fJ0vM730nicNBooRKH3wY3PGFn9AvI=;
        b=Mcd06eRHYvaIKaJcXpD6j5saCc+I3Qhin1UnBuhPGhziIdcO4scWGJ989A69uSYyEK
         Ex7JsprJwxVyzXfnrNywsOhZbqDmZNvg/TkaYAvOv/vmoRPYVGz9yr0jEaiTvV4qI6Cx
         yfQJzY588VKETrrbuCAh5jaoXQ3usjRicxtnTIpFHEL43I7vSePjWFdZzI0ht8Q4fkPc
         MpLOEOSNrGhZInyzGTs1fsIutFz1WVuwJSYuisAHON/GiqwBglOFPs2tTFecApAPTyNI
         8HUHpqLyiR4EsmCKn/yJZeXqVxffmYGLqzPXscybUpQG5P0gdgItdVpyL5QfWiWR+Xfv
         iFxQ==
X-Gm-Message-State: AOJu0Ywsk01Pl4YHAioW+Jr6WHZpxEvZZaxDsThvkISamBstFy3zUZWS
	NR/Ewy1CFbxGAXkB6s+DG9VoqvTIDhT/dccQX8GDlu018Z/6VzX//GoFBw==
X-Google-Smtp-Source: AGHT+IF/oxWh3uHlixxui5ZZskHDVdl4ACEI1u5VZhP3PuvOCQuH34FmnPsvl8KCT/CqLAeOODEISQ==
X-Received: by 2002:a05:6870:71cf:b0:24c:a74c:47c1 with SMTP id 586e51a60fabf-24ca74c96a2mr1005080fac.34.1716529074850;
        Thu, 23 May 2024 22:37:54 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 04/15] src: Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Date: Fri, 24 May 2024 15:37:31 +1000
Message-Id: <20240524053742.27294-5-duncan_roe@optusnet.com.au>
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

Convert static function __build_send_cfg_msg() to use libmnl.
This by itself converts the 3 public functions.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v2:
 - Rename  nfq_query to __nfq_query so as not to pollute Posix namespace
 - rebase to account for updated patches 1 - 3

 src/libnetfilter_queue.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 0483780..b64f14a 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -230,27 +230,33 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 	return NULL;
 }
 
+static int __nfq_query(struct nfq_handle *h, struct nlmsghdr *nlh, char *buf,
+		      size_t bufsiz)
+{
+	int ret;
+
+	ret = mnl_socket_sendto(h->nl, nlh, nlh->nlmsg_len);
+	if (ret != -1)
+		ret = mnl_socket_recvfrom(h->nl, buf, bufsiz);
+	if (ret != -1)
+		ret = mnl_cb_run(buf, ret, 0, mnl_socket_get_portid(h->nl),
+				 NULL, NULL);
+	return ret;
+}
+
 /* build a NFQNL_MSG_CONFIG message */
 	static int
 __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 		uint16_t queuenum, uint16_t pf)
 {
-	union {
-		char buf[NFNL_HEADER_LEN
-			+NFA_LENGTH(sizeof(struct nfqnl_msg_config_cmd))];
-		struct nlmsghdr nmh;
-	} u;
-	struct nfqnl_msg_config_cmd cmd;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
 
-	nfnl_fill_hdr(h->nfnlssh, &u.nmh, 0, AF_UNSPEC, queuenum,
-			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+	nlh = nfq_nlmsg_put2(buf, NFQNL_MSG_CONFIG, queuenum, NLM_F_ACK);
 
-	cmd._pad = 0;
-	cmd.command = command;
-	cmd.pf = htons(pf);
-	nfnl_addattr_l(&u.nmh, sizeof(u), NFQA_CFG_CMD, &cmd, sizeof(cmd));
+	nfq_nlmsg_cfg_put_cmd(nlh, AF_UNSPEC, command);
 
-	return nfnl_query(h->nfnlh, &u.nmh);
+	return __nfq_query(h, nlh, buf, sizeof(buf));
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
-- 
2.35.8

