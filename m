Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2710E1429B
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488053; cv=none; b=uM31kMqkbM0saMlR2NLdj6UjaiEKxLRYAjRc9va6sYWZt2lVF3nUE27/vPASGvU3Mc40AGDAcrxioTjlRAkm80sTbp871k3nIg6XiMMe/Urab8v3ILllGSmkEgh3IU05sMXEWd0+7t6PTbhU/fWChSOTYdQtcSjKLSKzMs3o9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488053; c=relaxed/simple;
	bh=2FNxyVFdFVMbKABPFJVlMPeQ7DRLTaXjD1oXCsYQQT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rdigye681OaXNhIplYGtkU62V+GH3Ixy7Ji8JweQfxBqWtRJKAyesbyNV1e8vAuT/9at6Kpu8JXqBWfc/PHcJzH24fih5j5I7pBoeExMKRWraOVR9heSgVlFGyK1y5cXV7KKctT4Y4/QI2qxHwRHB5GUERxBF9pRI1AUmGgsPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S0olJtAk; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S0olJtAk"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dca3951ad9so12860365ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488051; x=1711092851; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cu0GSz2W4B+OP0Gey+nKNzyqy5mtk03q2pkKCSwAKKI=;
        b=S0olJtAk5xOfCqpfXcvP/MrpjHFcOr+wUvEZrFoHjefmHAwxE3W8VGSbkqtWBLIeFr
         3N643Vvw2B4lw4UtIXe9vleRt0O2hGMNDYu4vNS8FVcXMxF5iSVKQwHdxvgw8xlxr2XJ
         7h8e+NdKegCM8veMK3Eu/8kuZBexYGDpE+cLlrE/c8kgfalsP9vcQUA0/izgEErCnSqU
         Pje0vThDmGo6i6GqoI3UUQGF0V9reWh4ABOEmiJtI1A4F+qhmiMzigPB5K7LKP31O4z+
         2BHKuSX3ywQbs42PKe/ryCLyEsIado5aiZJLQJf5O/zbad0Lsv+qYoOP/lq62Ab0nGhF
         GDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488051; x=1711092851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cu0GSz2W4B+OP0Gey+nKNzyqy5mtk03q2pkKCSwAKKI=;
        b=k5TrTYl05UJHLInsRTTfTGnhH3qHxmxJRMpRVqQGKGJ3NqSdOIOOSPgz1a385tBgQy
         gnh+rvt7VsnmI3tNH79cQVrU6D1uq7HkJ6EOWYwvJdj1RW7b+Ayeum2ISt47bxmK9C5Q
         QPsfTLy0rYPREMGqaKT4fxZe04Xh5NC2hj655k3K8xP3e6WAn66X5Tv2icOVeb6QaISI
         xtcD3mAPQx1FrExsLm/Kewy7aXLxSLbEAqVe/7Mm0C4OCwoFdk4BzWrqGLvsHQeIA3gP
         MASASQtKKgpJCUymzyAAeDr/U2xBvION6RPt70Mz+bDRDra1Lk6bN2swW+YryYl31KG8
         3yhA==
X-Gm-Message-State: AOJu0YyrYmEBcYVC643f3X/R5tBIukunjujE7teRag7sxFuFJ/eDJUba
	pZwq89cJQADpyzPrgDVIRN3k+5r8UtboLyy9oGzXMhs2pmBsben3oudSHxa3
X-Google-Smtp-Source: AGHT+IFhcR4rHxCtYd45PTGcIvUCZdtHfzGgk2TE9dwXJEOeg58M/G1SIxstpd+aWcLx9w647+AV3g==
X-Received: by 2002:a17:903:40c3:b0:1dd:a134:5680 with SMTP id t3-20020a17090340c300b001dda1345680mr4420986pld.69.1710488051585;
        Fri, 15 Mar 2024 00:34:11 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:11 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 11/32] src: Fix checkpatch whitespace and block comment warnings
Date: Fri, 15 Mar 2024 18:33:26 +1100
Message-Id: <20240315073347.22628-12-duncan_roe@optusnet.com.au>
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

The original patchset changed as little as possible from the original.
Whitespace fixes in particular are confusing during patch review
so leave them until now.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 56d51ca..2f50b47 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -147,11 +147,11 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
 #define NFNL_MAX_SUBSYS 16
 
 struct nfnl_subsys_handle {
-	struct nfnl_handle 	*nfnlh;
+	struct nfnl_handle	*nfnlh;
 	uint32_t		subscriptions;
 	uint8_t			subsys_id;
 	uint8_t			cb_count;
-	struct nfnl_callback 	*cb;	/* array of callbacks */
+	struct nfnl_callback	*cb;	/* array of callbacks */
 };
 
 struct nfnl_handle {
@@ -163,13 +163,13 @@ struct nfnl_handle {
 	uint32_t		dump;
 	uint32_t		rcv_buffer_size;	/* for nfnl_catch */
 	uint32_t		flags;
-	struct nlmsghdr 	*last_nlhdr;
+	struct nlmsghdr		*last_nlhdr;
 	struct nfnl_subsys_handle subsys[NFNL_MAX_SUBSYS+1];
 };
 
 /* Copy of private libmnl structure */
 struct mnl_socket {
-	int 			fd;
+	int			fd;
 	struct sockaddr_nl	addr;
 };
 
@@ -581,11 +581,13 @@ unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
 
 	/* first we try the FORCE option, which is introduced in kernel
 	 * 2.6.14 to give "root" the ability to override the system wide
-	 * maximum */
+	 * maximum
+	 */
 	status = setsockopt(h->fd, SOL_SOCKET, SO_RCVBUFFORCE, &size, socklen);
 	if (status < 0) {
 		/* if this didn't work, we try at least to get the system
-		 * wide maximum (or whatever the user requested) */
+		 * wide maximum (or whatever the user requested)
+		 */
 		setsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &size, socklen);
 	}
 	getsockopt(h->fd, SOL_SOCKET, SO_RCVBUF, &read_size, &socklen);
@@ -658,7 +660,7 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * @}
  */
 
- static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
+static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
 {
 	struct nfq_handle *h = data;
 	struct nfq_q_handle *qh;
@@ -959,7 +961,8 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
 	/* Efficiency gain: when there is only 1 iov,
 	 * sendto() is faster than sendmsg() because the kernel only has
-	 * 1 userspace address to validate instead of 2. */
+	 * 1 userspace address to validate instead of 2.
+	 */
 	if (!data_len)
 		return mnl_socket_sendto(qh->h->nl, nlh, nlh->nlmsg_len);
 	{
@@ -967,7 +970,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 		struct nlattr *data_attr = mnl_nlmsg_get_payload_tail(nlh);
 		const struct msghdr msg = {
 			.msg_name = &snl,
-			.msg_namelen = sizeof snl,
+			.msg_namelen = sizeof(snl),
 			.msg_iov = iov,
 			.msg_iovlen = 2,
 			.msg_control = NULL,
-- 
2.35.8

