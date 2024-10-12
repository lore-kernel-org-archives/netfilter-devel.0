Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399915530F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774579; cv=none; b=HtRicjJvYiyXndRLpEf9HFI4aAl3I5gJ9X2OnKHl1kNZL/p3T7yBgw34PFw1trEDBdDp+be75Pnt49c1q9U0JYb+k6HzYcOyebHouwc44uKMA/FoLn5TVX+MTNmoHhQUl5aMsgi067G1mABhM40McxOUHjHKfB7DwTHFiW8II74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774579; c=relaxed/simple;
	bh=Vqgx2359CItaGZs+PO52Ftgqjk0u1KL54LJH8N/jDAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E3c9eSRapXoHjYqNliu9Gl6t3S/GHPCWiaLAon83SvAG2zrHfIKDqUBGN77/lpwzfhOND090m0EN20f2CX63Ed0wf0hoJbSkS6qAhEjnpKJ1ulHbMFB8LjQGdZO4LCyjvILd+tzawC8zn/axo6QRPjdFlo4uwe2uGbJ54+SwqkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COTy0Q8P; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COTy0Q8P"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71e5ae69880so155891b3a.2
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774577; x=1729379377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NE50aRDeE21puYla3y9hkCqQqzi9pRq7xNtXkJ7i6Wc=;
        b=COTy0Q8PNxDamk76ZeuSFKBadFohWj+RAm3/bcPKSImRkYaeGNyS3Md35Tep75jnw9
         oAqTIiGQYmHSG8HQDActso/IDCNsL6xh9mylHtcXzgg41gEEsxlqKrnZ0exMmIeRN6f+
         r20mgmcYWnnnNlRVUEqGPLUo5OfMvPt5oIh71XnhZK2hCPgpX8mLWp+DEuYfFX/41nXf
         IkC7l/mOzRKcQ5Qp5+hwuo2UjhtIROM3I4JFu0jYm3D3wsM8jmpml3leeZIFac3iRufG
         nzHdbiPAPq7HlizDiz8YAmXJu8h3u1cm7esOg4eCj7S44vJ15RxBo42Y6Vd1jegdat6d
         HKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774577; x=1729379377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NE50aRDeE21puYla3y9hkCqQqzi9pRq7xNtXkJ7i6Wc=;
        b=w9wW+yZrFTat+4bWvWO20fbumv3RhBwPdcPmVRYtXmBbVt4TrRgUvYd3+o3I3dtCbG
         RNhywMhO8OVtGFmY+Ymbrun4Yll/2tupfJso2CPQS+fxUApteIqr+TLJjIQsAQ2VGJbT
         lybwbU1CeWEFitJA1hRgi8rV+9ioiYfkmaew9GLSRoePW1ppvYuAHu5M0SVmaEmvMyRa
         sS0LvPIPhcXluC+zX/9K/f+mPDGTDe01YlNzw/yijRRpiHbmglvH7rawvbNJuNSHvrhW
         q0mLii/e1YbqezNlRXhxoxnIoUWYXrXoF+XEWntND1xLSO4eGhkybOR3gMc0Y8V5IKG3
         QFYw==
X-Gm-Message-State: AOJu0YzOr1VyfpTgiDwtcVe5qXEHw/UkKeiWNa60dTcGyQ87qXIz1Q2E
	GuTpUk+owlmfWoSro/jhc5nX/7rqv+9kCvKYUX01tnFWAzB0bl2OQTf3oQ==
X-Google-Smtp-Source: AGHT+IGAAYaP4qRIymho+aGGebgtAlgC+5H+3f93M9RFUenBKAt18IX0kKJEzU+C7fdvC7gsVJd16Q==
X-Received: by 2002:a05:6a00:1818:b0:717:87af:fca0 with SMTP id d2e1a72fcca58-71e37c542cbmr13222711b3a.0.1728774576835;
        Sat, 12 Oct 2024 16:09:36 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 06/15] src: Convert nfq_handle_packet(), nfq_get_secctx(), nfq_get_payload() and all the nfq_get_ functions to use libmnl
Date: Sun, 13 Oct 2024 10:09:08 +1100
Message-Id: <20241012230917.11467-7-duncan_roe@optusnet.com.au>
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

The opaque struct nfq_data is now an array of struct nlattr instead of
struct nfattr.

Because of using mnl_attr_parse(), the first array element is for
attribute 0 instead of attribute 1 as previously. Because of this,
all the nfq_get_ functions have to be converted for this commit.

Functions now using libmnl exclusively: nfq_get_msg_packet_hdr(),
nfq_get_nfmark(), nfq_get_timestamp(), nfq_get_indev(),
nfq_get_physindev(), nfq_get_outdev(), nfq_get_physoutdev(),
nfqnl_msg_packet_hw(), nfq_get_uid() & nfq_get_gid().

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 Changes in v3:
 - rebased
 - Don't include a kernel header (don't need it anyway)

 Changes in v2:
 - Fix spelling error in commit message
 - Fix checkpatch warning re space before __nfq_handle_msg declaration
 - rebase to account for updated patches

 doxygen/doxygen.cfg.in   |   1 +
 src/libnetfilter_queue.c | 124 ++++++++++++++++++++++++++++-----------
 2 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 6dd7017..fcfc045 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -16,6 +16,7 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfnl_handle \
                          nfnl_subsys_handle \
                          mnl_socket \
+                         nfnl_callback2 \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 0ef3bd3..6500fec 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -144,7 +151,7 @@ struct nfnl_subsys_handle {
 	uint32_t		subscriptions;
 	uint8_t			subsys_id;
 	uint8_t			cb_count;
-	struct nfnl_callback	*cb;	/* array of callbacks */
+	struct nfnl_callback2	*cb; /* array of callbacks with struct nlattr* */
 };
 
 struct nfnl_handle {
@@ -166,6 +173,13 @@ struct mnl_socket {
 	struct sockaddr_nl	addr;
 };
 
+/* Amended callback prototype */
+struct nfnl_callback2 {
+	int (*call)(struct nlmsghdr *nlh, struct nlattr *nfa[], void *data);
+	void *data;
+	uint16_t attr_count;
+};
+
 struct nfq_handle
 {
 	struct nfnl_handle *nfnlh;
@@ -185,7 +199,7 @@ struct nfq_q_handle
 };
 
 struct nfq_data {
-	struct nfattr **data;
+	struct nlattr **data;
 };
 
 EXPORT_SYMBOL int nfq_errno;
@@ -259,7 +273,7 @@ __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 	return __nfq_query(h, nlh, buf, sizeof(buf));
 }
 
-static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
+static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nlattr *nfa[],
 		void *data)
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
@@ -484,7 +498,7 @@ struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 static struct nfq_handle *__nfq_open_nfnl(struct nfnl_handle *nfnlh,
 					  struct nfq_handle *qh)
 {
-	struct nfnl_callback pkt_cb = {
+	struct nfnl_callback2 pkt_cb = {
 		.call		= __nfq_rcv_pkt,
 		.attr_count	= NFQA_MAX,
 	};
@@ -657,6 +671,25 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * @}
  */
 
+static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfq_handle *h = data;
+	struct nfq_q_handle *qh;
+	struct nlattr *nfa[NFQA_MAX + 1] = {};
+	struct nfq_data nfad = {nfa};
+	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
+
+	if (nfq_nlmsg_parse(nlh, nfa) < 0)
+		return MNL_CB_ERROR;
+
+	/* Find our queue handler (to get CB fn) */
+	qh = find_qh(h, ntohs(nfmsg->res_id));
+	if (!qh)
+		return MNL_CB_ERROR;
+
+	return qh->cb(qh, nfmsg, &nfad, qh->data);
+}
+
 /**
  * \addtogroup Queue
  * @{
@@ -768,7 +801,8 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 EXPORT_SYMBOL
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
-	return nfnl_handle_packet(h->nfnlh, buf, len);
+	return mnl_cb_run(buf, len, 0, mnl_socket_get_portid(h->nl),
+			  __nfq_handle_msg, h);
 }
 
 /**
@@ -937,7 +971,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
 	/* This must be declared here (and not inside the data
 	 * handling block) because the iovec points to this. */
-	struct nfattr data_attr;
+	struct nlattr data_attr;
 
 	memset(iov, 0, sizeof(iov));
 
@@ -958,15 +992,17 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 	nvecs = 1;
 
 	if (data_len) {
-		/* The typecast here is to cast away data's const-ness: */
-		nfnl_build_nfa_iovec(&iov[1], &data_attr, NFQA_PAYLOAD,
-				data_len, (unsigned char *) data);
+		/* Temporary cast until we get rid of nfnl_build_nfa_iovec() */
+		nfnl_build_nfa_iovec(&iov[1], (struct nfattr *)&data_attr,
+		//nfnl_build_nfa_iovec(&iov[1], &data_attr,
+				     NFQA_PAYLOAD, data_len,
+				     (unsigned char *) data);
 		nvecs += 2;
 		/* Add the length of the appended data to the message
 		 * header.  The size of the attribute is given in the
-		 * nfa_len field and is set in the nfnl_build_nfa_iovec()
+		 * nla_len field and is set in the nfnl_build_nfa_iovec()
 		 * function. */
-		u.nmh.nlmsg_len += data_attr.nfa_len;
+		u.nmh.nlmsg_len += data_attr.nla_len;
 	}
 
 	return nfnl_sendiov(qh->h->nfnlh, iov, nvecs, 0);
@@ -1130,8 +1166,10 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_PACKET_HDR,
-					struct nfqnl_msg_packet_hdr);
+	if (!nfad->data[NFQA_PACKET_HDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_PACKET_HDR]);
 }
 
 /**
@@ -1143,6 +1181,10 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
+	if (!nfad->data[NFQA_MARK])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
@@ -1159,11 +1201,12 @@ EXPORT_SYMBOL
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;
-	qpt = nfnl_get_pointer_to_data(nfad->data, NFQA_TIMESTAMP,
-					struct nfqnl_msg_packet_timestamp);
-	if (!qpt)
+
+	if (!nfad->data[NFQA_TIMESTAMP])
 		return -1;
 
+	qpt = mnl_attr_get_payload(nfad->data[NFQA_TIMESTAMP]);
+
 	tv->tv_sec = __be64_to_cpu(qpt->sec);
 	tv->tv_usec = __be64_to_cpu(qpt->usec);
 
@@ -1184,7 +1227,10 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 EXPORT_SYMBOL
 uint32_t nfq_get_indev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_INDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_INDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_INDEV]));
 }
 
 /**
@@ -1198,7 +1244,10 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_physindev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSINDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSINDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSINDEV]));
 }
 
 /**
@@ -1212,7 +1261,10 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_outdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_OUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_OUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_OUTDEV]));
 }
 
 /**
@@ -1228,7 +1280,10 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_physoutdev(struct nfq_data *nfad)
 {
-	return ntohl(nfnl_get_data(nfad->data, NFQA_IFINDEX_PHYSOUTDEV, uint32_t));
+	if (!nfad->data[NFQA_IFINDEX_PHYSOUTDEV])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_IFINDEX_PHYSOUTDEV]));
 }
 
 /**
@@ -1363,8 +1418,10 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
 EXPORT_SYMBOL
 struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad)
 {
-	return nfnl_get_pointer_to_data(nfad->data, NFQA_HWADDR,
-					struct nfqnl_msg_packet_hw);
+	if (!nfad->data[NFQA_HWADDR])
+		return NULL;
+
+	return mnl_attr_get_payload(nfad->data[NFQA_HWADDR]);
 }
 
 /**
@@ -1412,10 +1469,10 @@ uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
 EXPORT_SYMBOL
 int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_UID))
+	if (!nfad->data[NFQA_UID])
 		return 0;
 
-	*uid = ntohl(nfnl_get_data(nfad->data, NFQA_UID, uint32_t));
+	*uid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_UID]));
 	return 1;
 }
 
@@ -1433,10 +1490,10 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
 EXPORT_SYMBOL
 int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_GID))
+	if (!nfad->data[NFQA_GID])
 		return 0;
 
-	*gid = ntohl(nfnl_get_data(nfad->data, NFQA_GID, uint32_t));
+	*gid = ntohl(mnl_attr_get_u32(nfad->data[NFQA_GID]));
 	return 1;
 }
 
@@ -1454,14 +1511,13 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
 EXPORT_SYMBOL
 int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 {
-	if (!nfnl_attr_present(nfad->data, NFQA_SECCTX))
+	if (!nfad->data[NFQA_SECCTX])
 		return -1;
 
-	*secdata = (unsigned char *)nfnl_get_pointer_to_data(nfad->data,
-							NFQA_SECCTX, char);
+	*secdata = mnl_attr_get_payload(nfad->data[NFQA_SECCTX]);
 
 	if (*secdata)
-		return NFA_PAYLOAD(nfad->data[NFQA_SECCTX-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_SECCTX]);
 
 	return 0;
 }
@@ -1480,10 +1536,12 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
 EXPORT_SYMBOL
 int nfq_get_payload(struct nfq_data *nfad, unsigned char **data)
 {
-	*data = (unsigned char *)
-		nfnl_get_pointer_to_data(nfad->data, NFQA_PAYLOAD, char);
+	if (!nfad->data[NFQA_PAYLOAD])
+		return -1;
+
+	*data = mnl_attr_get_payload(nfad->data[NFQA_PAYLOAD]);
 	if (*data)
-		return NFA_PAYLOAD(nfad->data[NFQA_PAYLOAD-1]);
+		return mnl_attr_get_payload_len(nfad->data[NFQA_PAYLOAD]);
 
 	return -1;
 }
-- 
2.35.8

