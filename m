Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070FF15530F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774574; cv=none; b=iIKgeYnrbgaW9wmYIxBmoXzvTRBF+5mIqywQKn+aSvDsVhcGVbaEMpR0bD4HDRmB11SAChmk/o145gA2JpBg1u0zQDZlnOLkIl6s5jcCLP31us683Hgo2X36qSgeJCk91repKDyJjU67+75Mf+97WqyPg7mwpyWuzNfeATM4KZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774574; c=relaxed/simple;
	bh=J+7VcLdXp5/DS88Ion8LOz0cSK/u6e3P3Dh2scq0UqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iKEOqPZcTcmHJG3Q1GEUG+ONFo7l8kRPKMvCo39rBoTWVZEUwh4BtHRVrlZdnTFpft5o+uoBQ273IxA7Bz+Iqf0EqT0n7gtvyLbHj8YIeI0rKWN/T0LxoVgCJ6FeRrHi9zSHl1Tqf54mBTyezCsj6UfSPrTB53Ao4SxCKdBjM3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MihGl3Zc; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MihGl3Zc"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea6a4f287bso577850a12.3
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774572; x=1729379372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jw4EFRae7Les8LbFrziAwH/AwSSmWFfwkyisug8XZY8=;
        b=MihGl3ZciuYwUMIABsCY8gbcK8azcxv35DJ10yrBd7jxlnQIFQDf5LxMqJfAla1yD+
         ayxlYBE9ElvKN4+yvhzU7JWWe6NzEGaQpGoeL7DDbPyBpjUGu6QFuZGrplTbDtyo2nCR
         Y7Ckg5S74e1o3Al1Zg+oJTR9e3SyVUQ6Fda+crUd3SjwvIgRGGNAYSeXSkKSGk2zjYIP
         TbTlVtMUfzeKiT4pW+oxjesspqYBYP1+C5HiWHaAdRb4RjIT/BCrGjCp7QrE2l6g87rx
         q2ybGNTmQi+0LY4VbBi8hKj+tILhPbOSI5F91hnNO68cUuM5iMUwMSG8Ly+2MdSBmcjR
         w5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774572; x=1729379372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jw4EFRae7Les8LbFrziAwH/AwSSmWFfwkyisug8XZY8=;
        b=eVhuhVbAAhQdIKdH5yEDAIQFKq+wTPbHYekgUEeShJmbVSkA/EUW/U0JhTlKApCmQV
         iUJ4gW+GneQT6ZFXlZlSZTqqVyTl8xWAld3rPnxgn2tyKlVXae7cFYIibJ08oAPm/sZp
         t/kwI5ss9JF4G+Pf6xPHUHYCe+aBNyK0Ys3a/bYmeJwOn8bhzgh+R45tA7HPH2pdlXJ8
         vwvfrGhX/v3huK6YadC16HK+FGDpIJhDMse9SOnXFuQG1aazUQ6ygDhbd4dKO0ME3kYQ
         2RUbc4f9OKHIsgLJi/uuJLrArzvIbhRkS53lFH14Z58SXWmmZJmsyG4fWjLSx2FySOQw
         M3mg==
X-Gm-Message-State: AOJu0YwpiZQZT1egvhmirGTdOyZPklh2VVljzST2XWaB8N9ta26nSn47
	g+73ZhvWjATiLz8R9IVoVR+hfOWeMci1px9XsJ9Bq5ZSETiWIxsI1l9xKQ==
X-Google-Smtp-Source: AGHT+IGkn3zbfJrbfMaTiVjkc+blSsw8iRqPaj3Phg7sekedYOF/4iyIE9WH76MFj2Xho0AYZx4oaw==
X-Received: by 2002:a05:6a21:31c8:b0:1d8:ae90:c651 with SMTP id adf61e73a8af0-1d8c96c4746mr5760538637.47.1728774572291;
        Sat, 12 Oct 2024 16:09:32 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:31 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 04/15] src: Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Date: Sun, 13 Oct 2024 10:09:06 +1100
Message-Id: <20241012230917.11467-5-duncan_roe@optusnet.com.au>
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

Convert static function __build_send_cfg_msg() to use libmnl.
This by itself converts the 3 public functions.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3: (none)

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

