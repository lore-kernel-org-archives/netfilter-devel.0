Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C27EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EECD6023F
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbhJLLTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 07:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbhJLLTY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 07:19:24 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E73DC061570
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:17:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id t15so3609337pfl.13
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zlS3EeH/DRtMXxGzvpKesCel8HEHjvt/og8TH99kgCA=;
        b=qE/Cd8u0Lt0ZCGLRQj4KsnoNRmmZhJtr8EMR8Y3ftmbyzNJgR4QZ2RxVTdOLxfXodF
         1CzSZDNmE0/lsRyNS1Wp6Av+ADS6fTDQ0gGsrrKfyZtVXnZXx1Grh625WIKJr5rv6AX6
         zeFdkcg4f8hwg1vs86FExYeGoFr+aUnXl6rVKjAy+cj9TJLdYmPw1431h6PKUuiqraO4
         PqSRSmoxA1q6oQhZbguB9X9mfT6lUC3f4IDW0FOrUwJpDGMQyXpOpVYLDNaV5iemMU7L
         k40wDVjwLGt2L2/7+jE6YI5PoljPJgnA9Y/YvA60C48AaOt+2F0W3OrbeAXmVu/jEnRV
         OOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=zlS3EeH/DRtMXxGzvpKesCel8HEHjvt/og8TH99kgCA=;
        b=5EQIBZmf34hHnfhOx9y8oMg4MKOfiQicauPkt51Ej2rt0RfVjqxQfy07Rx5UDX/lCI
         WTmIqEF9EZr6v/pUp5ryqoUm+L/rxsL/FlKZRKEeS1Q6BPNAZZPGdhsza1PvRq05aIIc
         a0fQm0zd7fMuA+F5fUdFbItg32KEZwD0qYdDyKRM7l53d1HYYH/MN+i3kpMjotgGP3e4
         rEEFfZJX31RPza7d1u9l+PQoKGjg1mwXc4AgDfjh06l+oMg8oHDSB489kRGpq6xxCjIX
         FpNb6WRBlkQh3JOUHGhjKjU4RpqaRVXvr8WAjdaSfWF2W1h+SKCVI/c1eshTO3rgrQBF
         RAHg==
X-Gm-Message-State: AOAM530UyVtyRtZ/vlgfTW1m4yA4VqaAAJWZ1jvsfEGTs/dQSEjDrMT8
        2KiHABIeMIfXR7wMxUwVWfNsknZAeOg=
X-Google-Smtp-Source: ABdhPJwV3JbDCXr6EMf6xwJXX2Alh40u0s9iiEVr5qhm+mMsBstfL+O9vzMCjEVk7oDh3Qw6dBxBgg==
X-Received: by 2002:aa7:9099:0:b0:44c:a3b5:ca52 with SMTP id i25-20020aa79099000000b0044ca3b5ca52mr30735763pfa.85.1634037442934;
        Tue, 12 Oct 2021 04:17:22 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id p2sm2293397pja.51.2021.10.12.04.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:17:22 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH ulogd] XML: show both nflog packet and conntrack
Date:   Tue, 12 Oct 2021 20:17:07 +0900
Message-Id: <20211012111706.81484-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch enables to show "ct" as well as "raw" if output type is
ULOGD_DTYPE_RAW and "ct" input exists.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 output/ulogd_output_XML.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index ea7ed96..44af596 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -109,7 +109,7 @@ xml_output_flow(struct ulogd_key *inp, char *buf, ssize_t size)
 	if (tmp < 0 || tmp >= size)
 		return -1;
 
-	return 0;
+	return tmp;
 #else
 	return -1;
 #endif
@@ -126,7 +126,7 @@ xml_output_packet(struct ulogd_key *inp, char *buf, ssize_t size)
 	if (tmp < 0 || tmp >= size)
 		return -1;
 
-	return 0;
+	return tmp;
 #else
 	return -1;
 #endif
@@ -143,7 +143,7 @@ xml_output_sum(struct ulogd_key *inp, char *buf, ssize_t size)
 						 NFACCT_SNPRINTF_F_TIME);
 	if (tmp < 0 || tmp >= size)
 		return -1;
-	return 0;
+	return tmp;
 #else
 	return -1;
 #endif
@@ -155,14 +155,25 @@ static int xml_output(struct ulogd_pluginstance *upi)
 	struct ulogd_key *inp = upi->input.keys;
 	struct xml_priv *opi = (struct xml_priv *) &upi->private;
 	static char buf[4096];
-	int ret = -1;
-
-	if (pp_is_valid(inp, KEY_CT))
-		ret = xml_output_flow(inp, buf, sizeof(buf));
-	else if (pp_is_valid(inp, KEY_PCKT))
-		ret = xml_output_packet(inp, buf, sizeof(buf));
-	else if (pp_is_valid(inp, KEY_SUM))
-		ret = xml_output_sum(inp, buf, sizeof(buf));
+	int ret = -1, tmp = 0;
+
+	if (pp_is_valid(inp, KEY_PCKT)) {
+		ret = xml_output_packet(inp, buf + tmp, sizeof(buf) - tmp);
+		if (ret < 0)
+			return ULOGD_IRET_ERR;
+		tmp += ret;
+	}
+	if (pp_is_valid(inp, KEY_CT)) {
+		ret = xml_output_flow(inp, buf + tmp, sizeof(buf) - tmp);
+		if (ret < 0)
+			return ULOGD_IRET_ERR;
+		tmp += ret;
+	}
+	if (pp_is_valid(inp, KEY_SUM)) {
+		ret = xml_output_sum(inp, buf + tmp, sizeof(buf) - tmp);
+		if (ret < 0)
+			return ULOGD_IRET_ERR;
+	}
 
 	if (ret < 0)
 		return ULOGD_IRET_ERR;
-- 
2.30.2

