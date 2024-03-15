Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FC11401B
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488045; cv=none; b=Mfji0yJmsf61c5kYLTB0wp+LHdVKdhvEEs7dAaOJ+mr4KbQdXETS7UGhfF7XUkpsqDA1gpCux+Vn/1if5oSc6eigjWQ94dDwUAqwnIV48InQzU1DXkNUCDvhUMgB2jntFgAUBZp4r70sJ0Xxv9X7EFfju8uOKXijIxoB6qKxkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488045; c=relaxed/simple;
	bh=xRtUx/Lvgwz4uWcUYOB+2uCYg8cGuEDg6VUsEREM7+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOyzXbga+kCW7jcW/9cc7jGNkdf5BPExjaNS4sVuWulG0T2MQGlbR3ldkynHVFWd9tAm5TO0Z3xVL966ueYctidQw9pMnTctoGc0TWB0FiKpMO1vCNi+kiAdV6cCSklMfS7016Zj+DKYk/Az0vnW9HZBnfDB11p8kBdKp6Urp2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCipipMg; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCipipMg"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dedb92e540so10477735ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488043; x=1711092843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKbHL3tMPVB9UbX8K7t/MzwCvP48Kz1kypdn3KoQVIY=;
        b=TCipipMgsBr+qC6ak+rIJgVttOF6wb5uK/bqJ+bbW45ntPsttJ1rgnh/RKMfpcyeIf
         p/FMsXh+gAeHNLzmJPf5K9TCMYg6BpsNvU5Lspb+5U+OQ6U9NOGMhkCcY9WYYt1pJTxR
         BcUkThu3AzxWJIIipn/v3Rt2hJiakOEpWYq9h0T2tVo3XeRdbyZ8pL2KMpRnZ2DIXdLe
         Xq7/BzupcMNDMSXGk00D7Yc3fGX/pG/QEcjtrJZ/Q1q7albu7C7FS5kI1AZyJdknEI4u
         mA0A41OgHIcfRyvOFRqrB1sDR8qhlhGPpqRfo0DegRvIaJMcqnhtGwDl1r7tyQpDLlTS
         3mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488043; x=1711092843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hKbHL3tMPVB9UbX8K7t/MzwCvP48Kz1kypdn3KoQVIY=;
        b=a96WFj/y4ArtuBNwmNLO882IXJ4Yey0vqYCTIgFRgctUf2xCDRiylGjJIdQgl/Uire
         uSQUlaYbvGk6VZGWjzSHifcKtzaxudhW9Wz8LuC2geJ3IE+1ashiHpfBqHVMeZWlT/DM
         nxvPFJ3w0v4uvKdJ6yLSUrXEwwdBIn1P+ddnoQd9SJif1DDGVupveJ5OtHplXlkDZSwq
         wry8WDe3A1f/84fGk0IDKpDm1RLQZQWR87JHqlD/REQCkANQCVwoTQGUDXq/uyS8X/fJ
         wCTyIqGm/cj5CwspnBJEHpn3fKNVeC0o68WgCo41RH/c7BJQsufLrBDdIXI1y0pknSl3
         MEew==
X-Gm-Message-State: AOJu0YzOlSYNJHIi31dD65Mt5lz2FhTmekd5nfGRvepvDf1jCJYii8fW
	OmJ6C4T6kXXDM7u9RDsGPJEuZhmRPmkgMW+lbDLBCe8UTyhYrbEKyFhP+0rM
X-Google-Smtp-Source: AGHT+IGbHo7MfiEOE5JomxYrR+I3C4HQsv2y/OXi6Qc+UN4bwp+824+SC7l11Gy18h8phxiKPxvQEQ==
X-Received: by 2002:a17:902:e88e:b0:1dd:4cb:cc57 with SMTP id w14-20020a170902e88e00b001dd04cbcc57mr6611702plg.0.1710488042832;
        Fri, 15 Mar 2024 00:34:02 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:34:02 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 06/32] src: Convert nfq_handle_packet(), nfq_get_secctx(), nfq_get_payload() and all the nfq_get_ functions to use libmnl
Date: Fri, 15 Mar 2024 18:33:21 +1100
Message-Id: <20240315073347.22628-7-duncan_roe@optusnet.com.au>
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

The opaque struct nfq_data is now an array of struct nlattr instead of
struct nfattr.

Because of using mnl_attr_parse(), the first array element is for
attribute 0 instaed of attribute 1 as previously. Because of this,
all the nfq_get_ functions have to be converted for this commit.

Functions now using libmnl exclusively: nfq_get_msg_packet_hdr(),
nfq_get_nfmark(), nfq_get_timestamp(), nfq_get_indev(),
nfq_get_physindev(), nfq_get_outdev(), nfq_get_physoutdev(),
nfqnl_msg_packet_hw(), nfq_get_uid() & nfq_get_gid().

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/doxygen.cfg.in   |   1 +
 src/libnetfilter_queue.c | 122 +++++++++++++++++++++++++++++----------
 2 files changed, 91 insertions(+), 32 deletions(-)

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
index 28aa771..58875b1 100644
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
@@ -256,7 +270,7 @@ __build_send_cfg_msg(struct nfq_handle *h, uint8_t command,
 	return nfq_query(h, nlh, buf, sizeof(buf));
 }
 
-static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
+static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nlattr *nfa[],
 		void *data)
 {
 	struct nfgenmsg *nfmsg = NLMSG_DATA(nlh);
@@ -411,7 +425,7 @@ int nfq_fd(struct nfq_handle *h)
 
 static bool fill_nfnl_subsys_handle(struct nfq_handle *h)
 {
-	struct nfnl_callback pkt_cb = {
+	struct nfnl_callback2 pkt_cb = {
 		.call		= __nfq_rcv_pkt,
 		.attr_count	= NFQA_MAX,
 	};
@@ -610,6 +624,25 @@ int nfq_unbind_pf(struct nfq_handle *h, uint16_t pf)
  * @}
  */
 
+ static int __nfq_handle_msg(const struct nlmsghdr *nlh, void *data)
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
@@ -721,7 +754,8 @@ int nfq_destroy_queue(struct nfq_q_handle *qh)
 EXPORT_SYMBOL
 int nfq_handle_packet(struct nfq_handle *h, char *buf, int len)
 {
-	return nfnl_handle_packet(h->nfnlh, buf, len);
+	return mnl_cb_run(buf, len, 0, mnl_socket_get_portid(h->nl),
+			  __nfq_handle_msg, h);
 }
 
 /**
@@ -891,7 +925,7 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
 
 	/* This must be declared here (and not inside the data
 	 * handling block) because the iovec points to this. */
-	struct nfattr data_attr;
+	struct nlattr data_attr;
 
 	memset(iov, 0, sizeof(iov));
 
@@ -912,15 +946,17 @@ static int __set_verdict(struct nfq_q_handle *qh, uint32_t id,
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
@@ -1084,8 +1120,10 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
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
@@ -1097,6 +1135,10 @@ struct nfqnl_msg_packet_hdr *nfq_get_msg_packet_hdr(struct nfq_data *nfad)
 EXPORT_SYMBOL
 uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 {
+	if (!nfad->data[NFQA_MARK])
+		return 0;
+
+	return ntohl(mnl_attr_get_u32(nfad->data[NFQA_MARK]));
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
@@ -1113,11 +1155,12 @@ EXPORT_SYMBOL
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
 
@@ -1138,7 +1181,10 @@ int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
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
@@ -1152,7 +1198,10 @@ uint32_t nfq_get_indev(struct nfq_data *nfad)
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
@@ -1166,7 +1215,10 @@ uint32_t nfq_get_physindev(struct nfq_data *nfad)
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
@@ -1182,7 +1234,10 @@ uint32_t nfq_get_outdev(struct nfq_data *nfad)
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
@@ -1317,8 +1372,10 @@ int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
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
@@ -1366,10 +1423,10 @@ uint32_t nfq_get_skbinfo(struct nfq_data *nfad)
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
 
@@ -1387,10 +1444,10 @@ int nfq_get_uid(struct nfq_data *nfad, uint32_t *uid)
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
 
@@ -1408,14 +1465,13 @@ int nfq_get_gid(struct nfq_data *nfad, uint32_t *gid)
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
@@ -1434,10 +1490,12 @@ int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata)
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

