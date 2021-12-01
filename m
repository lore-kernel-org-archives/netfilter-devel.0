Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FA8C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhLARhP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351961AbhLARg2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:28 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E4BC061756
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:05 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d24so54074800wra.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqqMYbceZ2eH75Ze8ZVybOW04RtLI8SxCx0eJbaegJY=;
        b=UEaxupB5wYcnvtWMBGbstFVzU312pIOMxmLvcQGmzoJQV+vCMXut1BBF8ynu9PnyFW
         v7GhHBYCNNlIGcugLehjqABAD6rw45DZPA/S7M+S8TGMJMTV48dAdAK+i95tpLQ1SHB0
         BNRL1kUjMg7CSVAN9lN+xFvh2tgi5xgixzFGoO9YYwUoVEa2/lZEyaxCvbsuqj6E/yFS
         pexjF4Pza4EWqMUIceGYsfZBo0LyXXA7cmmaylnRb9ClY3gbxBpDZrSz8fpG79ZNNdaN
         TfyPYoLOYtM31RHOkFEbXXEk4+SId9nmFXFGP4S+UA1IwgijdgNsZxm1KJttFtxbn+q8
         r6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqqMYbceZ2eH75Ze8ZVybOW04RtLI8SxCx0eJbaegJY=;
        b=4y31VlR/F9970jUHSo9D3NsAGEH4BKPL1hHi4hBwid/6F989sH4W8ihVzpN7tuNahB
         rxGBfyY5wZzMCWvYy8xzU3t71I06KjX3wxXbJUCdJJS9fUdhs2V1aGwx2FzVO9jwdDiU
         eU+lQGZ5Kx2B++v6idsI9SzKiZcLDhF5OEJTCdBHBQJ/RlPkR+ZAiJ0QUrqSc2hfvzCp
         s9k1Tk3GPlBizC/vm325Tt5/odp3EWQ2JVoxzAnCqU7X8Z6+Yi8w/OhoPJlyVFuSnyOt
         OZ0g5+uv11jTXF793lQttPzIj5epCvREOEG29QtsMJd/gdd/QEV21/4Omo+3EL0K21v1
         h9Sg==
X-Gm-Message-State: AOAM533+1WP5mUSn3EflwfijVzqRjNrIopjmEcDOxCe3ukY3CI7Mh23R
        4Sd+33ELht92dFxRqYhWIULQ99NUbc55Yg==
X-Google-Smtp-Source: ABdhPJwOa2485WN6Q/e8gLoSMMjVclTfxQud1WVPa0zuA2GK2SWICKhxJBtpWQwqvkf43fagujBvzw==
X-Received: by 2002:a5d:5888:: with SMTP id n8mr8304528wrf.234.1638379983494;
        Wed, 01 Dec 2021 09:33:03 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:02 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/6] conntrack: generic nfct_mnl_call function
Date:   Wed,  1 Dec 2021 18:32:48 +0100
Message-Id: <20211201173253.33432-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation for using libmnl for ct entry creation
and other operations

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 55 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 5bd3cb5..d37f130 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2417,6 +2417,7 @@ static int nfct_mnl_socket_open(unsigned int events)
 
 static struct nlmsghdr *
 nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
+		      uint16_t flags,
 		      uint8_t family)
 {
 	struct nlmsghdr *nlh;
@@ -2424,7 +2425,7 @@ nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (subsys << 8) | type;
-	nlh->nlmsg_flags = NLM_F_REQUEST|NLM_F_DUMP;
+	nlh->nlmsg_flags = flags;
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
@@ -2441,15 +2442,28 @@ static void nfct_mnl_socket_close(void)
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
-	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
+nfct_mnl_call(uint16_t subsys, uint16_t type, uint16_t flags,
+	      const struct nf_conntrack *ct, uint8_t family,
+	      const struct nfct_filter_dump *filter_dump,
+	      mnl_cb_t cb, void* context)
 {
-	uint8_t family = cmd ? cmd->family : AF_UNSPEC;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	int res;
 
-	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
+	if (ct) {
+		family = nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO);
+		if (!family)
+			return -1;
+	}
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, flags, family);
+
+	if (ct) {
+		res = nfct_nlmsg_build(nlh, ct);
+		if (res < 0)
+			return res;
+	}
 
 	if (filter_dump)
 		nfct_nlmsg_build_filter(nlh, filter_dump);
@@ -2461,7 +2475,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
 	while (res > 0) {
 		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
-				 cb, cmd);
+				 cb, context);
 		if (res <= MNL_CB_STOP)
 			break;
 
@@ -2472,23 +2486,22 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 }
 
 static int
-nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
+	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
-	int res;
-
-	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
-
-	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
-	if (res < 0)
-		return res;
-
-	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
-	if (res < 0)
-		return res;
+	return nfct_mnl_call(subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
+		      NULL, cmd ? cmd->family : AF_UNSPEC,
+		      filter_dump,
+		      cb, cmd);
+}
 
-	return mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid, cb, NULL);
+static int
+nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+{
+	return nfct_mnl_call(subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
+		      NULL, family,
+		      NULL,
+		      cb, NULL);
 }
 
 #define UNKNOWN_STATS_NUM 4
-- 
2.25.1

