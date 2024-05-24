Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5132384A5A
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529081; cv=none; b=PeneE2h1/WGNC1ghmipITCy1if6okk7wj0c8osnQyGGIsr/MDuxum+VJdM5F7faEbhmJ+CsNvSCryFVmzj27j/6CYrjrPNADlxyQsKcIovg9EFyijxRkWgAGCSdyaKMn3BgIEc/OIkndHQMW4wVOmxTxWEs3cPEEBsd6RfNROuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529081; c=relaxed/simple;
	bh=7IRCxlpEncRUVmuk44QI5rTrdO/xOUDiCX89wQqKo44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TwkrNXMBH3dhbh1cs83qTa/7YA5iDwp8NJWvCy1g/PWZxU+z4XFb+9RMsGrCBVKjzDcqgpl/QBjwKoA8dr9DaCsvfZlXgAFdaPPIOSgGZej5pKzpf8p8RMHmbhkr45QVqEHQDqkdd7iavaIsM+LLPqD5lXaEBv1swwO2gswx5tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hEtsCgdj; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEtsCgdj"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-652fd0bb5e6so2800614a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529078; x=1717133878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OaO6jQT1HKaI1F1J8RyAPyeMG4oxFjFPipQT27FKAY=;
        b=hEtsCgdjbzeHuMp+oPz6R0leNzUr1y1ckx7zWJjeeaf1Nu7NL+sa8Fmw4Wtkd2IsZv
         CPlP/AzeEEUHczLrB/Cn5F+9EP+7+UDhGV0w5NQtmBX8blsMjGqtAPlLH46DjhjuyD2Z
         xeQUTIYWXa6JebJ2OVqgdDz9o52NWUB733IGi1hdeTKfPeT/nlXV4UN2s+hhUPujBuDH
         BMA6IO4ekQ85uEWP/6LztJi1gy6CrHsUOZgvxJncigh3LvU7zHJPNCtV6uZkmS6bTuUI
         2/Br7EQC4PjhrNn86IsZbXNQnisWvC3K0TL3SctVBrbqkQprMmoV8h05qLWIqyyQqGuA
         a+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529078; x=1717133878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7OaO6jQT1HKaI1F1J8RyAPyeMG4oxFjFPipQT27FKAY=;
        b=Yc+k3DLjVdHV1djv/AizUJ6SxU83H0tQBHI/xXpneA2OxJFtavLDufaEKjSSPl+B/V
         EpaLSF/yG+zZoq2NCSe/t//FIlxQUlUIDpR/Ul8QZiP49p9tJXuj2bx6bki5SxNinfI/
         i7O/akBX1TPwX6sAVSciJVXGBEZC/E8yrhEf8W3cFLgCla6yfN9ptYuy7ObPniZbJ+kk
         A80/lgpidd8vx9QJWhJVs07/PRb/7uuA7eMQ54lXzvBKRWaMx8Sfsv6/WAr+G6diFNzc
         L9RXmvKuSU68U5lyYN8gea/t9l2ai7YB5USQ2WeJ/CCz+hWkiAuhz7AXuYhE+sScwQzK
         t4XA==
X-Gm-Message-State: AOJu0YzatYerLFrQXJ++FzqE908rCbfOPBqcoJzk3hbR1SqOQ9+4Kl5H
	H4gzYNhjvFu/I2XKCVpgWbJeo4ZgFgAsrGh22i2zdRs6WNZaJHwUvhgyug==
X-Google-Smtp-Source: AGHT+IGFYz5z7EQci7Eyw+EiqiAe4HUAPUfoARURplVMQddMjUcgGnglMZhm91vEE0xvrDHA+2gRbQ==
X-Received: by 2002:a05:6a20:9188:b0:1af:b1c0:c9eb with SMTP id adf61e73a8af0-1b212e02f4bmr1917607637.45.1716529078375;
        Thu, 23 May 2024 22:37:58 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 06/15] src: Convert nfq_handle_packet(), nfq_get_secctx(), nfq_get_payload() and all the nfq_get_ functions to use libmnl
Date: Fri, 24 May 2024 15:37:33 +1000
Message-Id: <20240524053742.27294-7-duncan_roe@optusnet.com.au>
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
@@ -32,6 +32,13 @@
 #include <linux/netfilter/nfnetlink_queue.h>
 
 #include <libmnl/libmnl.h>
+
+/* Use the real header since libnfnetlink is going away. */
+/* nfq_pkt_parse_attr_cb only knows attribates up to NFQA_SECCTX */
+/* so won't try to validate higher-numbered attrs but will store them. */
+/* mnl API programs will then be able to access them. */
+#include <linux/netfilter/nfnetlink.h>
+
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_queue/libnetfilter_queue.h>
 #include "internal.h"
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
@@ -650,6 +664,25 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
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
@@ -761,7 +794,8 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 EXPORT_SYMBOL
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
-	return nfnl_handle_packet(h->nfnlh, buf, len);
+	return mnl_cb_run(buf, len, 0, mnl_socket_get_portid(h->nl),
+			  __nfq_handle_msg, h);
 }
 
 /**
@@ -930,7 +964,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
 	/* This must be declared here (and not inside the data
 	 * handling block) because the iovec points to this. */
-	struct nfattr data_attr;
+	struct nlattr data_attr;
 
 	memset(iov, 0, sizeof(iov));
 
@@ -951,15 +985,17 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
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
@@ -1123,8 +1159,10 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
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
@@ -1136,6 +1174,10 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
+	if (!nfad->data[NFQA_MARK])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
@@ -1152,11 +1194,12 @@ EXPORT_SYMBOL
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
 
@@ -1177,7 +1220,10 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
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
@@ -1191,7 +1237,10 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
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
@@ -1205,7 +1254,10 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
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
@@ -1221,7 +1273,10 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
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
@@ -1356,8 +1411,10 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
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
@@ -1405,10 +1462,10 @@ uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
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
 
@@ -1426,10 +1483,10 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
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
 
@@ -1447,14 +1504,13 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
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
@@ -1473,10 +1529,12 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
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

