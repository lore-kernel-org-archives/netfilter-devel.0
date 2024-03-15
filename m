Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8466F9DE
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488041; cv=none; b=UV9jMQt4JUnL2N7dbN/dhuAi8aTrcK3K4OAD8sQKDPFbFBgWWefFIyoMSKaX6o7jDrTcX9NUrXfXAd+nVC0Is7uewIi/Ll1Xhb26Zzi4qRGbV38oM2ctSCv4VrkkuZYRueNFEDcDpsHo5wB4iLI/Ck18++pFBnBDCcWv5XcdqqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488041; c=relaxed/simple;
	bh=MIQRRvdeGoeNxhbQEmgM93/qBYw1kJntrSSyULrkSUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X54zIZB8tXyXs4QS0hz2RN99PCO5rX+xRGoujVzI9QDFriLr3SuUmjq4PDNBHQwJAcwvvACW4atjbWe51gB8hLGkxpkthVbKWkGBLen5kq801GPLSKljhOM2htnkH4ZoECV+8c5xl8adbEdMudm+hw4xk4Gh1JZZWIS/rpcjnbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtUdHBQt; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtUdHBQt"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1de0f92e649so11243715ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488039; x=1711092839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/e4AWSQBl3UvaHCZyH63Zn42GC0F+lFkXcLUJNiDc=;
        b=VtUdHBQtcwltwjrklWmnpDWkrLf7+JW88bSg8BkW0VVOgoWjpQqp/R4YyddCzntw2p
         QjZEYSjxrQm+gZaDCR5Q7jfrKylbdAiSAZ6K0kPq2qiTbnsFEKfHThJBTk0xCFPIc5GX
         22exsqCttbU0Kak4W4YFEAXty9/ynwG1oMBbBBiMQeWVgnZPf+P6IUq333X31l805/5B
         kRbuJoo3QbQBDC4xAhnEi7gkeUegfzYFjs4xzyXTUYcE8I1dqhRsxqbuRnfeuMuixpc6
         QWWQo1xcieuFlBtj5dBRbz2crT8iN0LacazkRnHCMTxYF69nPjwO+8j/T0iyDXwbJWZ5
         Xc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488039; x=1711092839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d1/e4AWSQBl3UvaHCZyH63Zn42GC0F+lFkXcLUJNiDc=;
        b=Tnyaoigblvow3kIpRIRO8zTz4E4pbB2tl8oZg6498OLpNwDY/GwqdEd9CUGgz8fhgN
         YQ+m7Bstmx3KtYPD8fhc6Ee/60Vw1wfZ9pJG0GIeBkVZH/CTC6GMQ64jLdrz/8SaLGnm
         QrLAkyif+v1TM8iJNCkG5sHazJtmrf6st3BcSqwLnBzVuXY6TZbATtpQlg8Pz6m/nL2Q
         NIW4SR73q62pnlJxhdLgzk5duxRBwRMEhXaPimTxC1sfTkOpeuagpw8VTDRAM9Nl5Qeo
         DH2gp6gwlsBrFvn3C31UPlEvil5yna67lGMBxcmhahaPiRzdcSCXLs0YS2hY4QsWbp1p
         UwNg==
X-Gm-Message-State: AOJu0Ywy9qYIk7Dw+SrmWIFuQ+ZwjB4whVluL9ol5DXJ3TAlnZLRAIQH
	PDbHUhabqdoyoAGvY81669tcDuTwcx3X7Z3IMm0SvTVeKy66wvyY
X-Google-Smtp-Source: AGHT+IHI5Smf+FI/PS4FWmlwes29u99CRUoFmeu9kna7s1Mzs0hqYvsyg7hwxxZoTvcG4ABt0RQFqQ==
X-Received: by 2002:a17:903:2d1:b0:1dc:62d1:c69c with SMTP id s17-20020a17090302d100b001dc62d1c69cmr4614228plk.67.1710488039387;
        Fri, 15 Mar 2024 00:33:59 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:33:59 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 04/32] src: Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl
Date: Fri, 15 Mar 2024 18:33:19 +1100
Message-Id: <20240315073347.22628-5-duncan_roe@optusnet.com.au>
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

Convert static function __build_send_cfg_msg() to use libmnl.
This by itself converts the 3 public functions.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index db31446..1ef6fb8 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -227,27 +227,33 @@ static struct nfq_q_handle *find_qh(struct nfq_handle *h, uint16_t id)
 	return NULL;
 }
 
+static int nfq_query(struct nfq_handle *h, struct nlmsghdr *nlh, char *buf,
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
+	return nfq_query(h, nlh, buf, sizeof(buf));
 }
 
 static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
-- 
2.35.8

