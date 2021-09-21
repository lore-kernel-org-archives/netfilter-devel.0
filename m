Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F59C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0050A61168
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhIUIyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhIUIyx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 04:54:53 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3D5C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w14so8317092pfu.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lSPDAcgKD6GbH+UvQXfcbgrv+Nf31voZWYX3naAQWbU=;
        b=pQ7f1q3bL/WCvPnS92jf4uVnEDR5r6N8/VY6rxW5oYqY5Kck2TxhQrx/ykynntoG8u
         Hm1sVDh02NklWmQAOwrLu0DhJ0qfZGxI9t10zNyiqKFBt8oiJ1zbVT77f3hcKmRJl8WN
         x96mdlAGx1FcqhA3cfnQPNfO8ivEldez/T/htGwlgGCHzKAZ0Njf4Kj80bbAs+6UYaNs
         Az8C8Zc5qbKIPLShmQ7hEDxuxXT7s+VxyhIezqOTc287eK4zt8Y6n5fUqwF4jkn68jLu
         PHG2CHjaCnbn/LGNlhcCOlX8qog5bqR5zwJhWWGDkoQDLI++EJ0X6CDBzVVzzEQ9k1ET
         S1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lSPDAcgKD6GbH+UvQXfcbgrv+Nf31voZWYX3naAQWbU=;
        b=4bvmJpfeM723aedeNNyYeVapyP8M24c3g0YxImoYRmrNWKNnRfZBIjQ0+GcPyY+aBN
         aLz77ruoQTqIDLXyxtqSm2lCxoa+Eh3ZuHyEHFPBJ4h6fn3uBh8XUPwQeJYitxchet/Y
         Wsd/SvTbUDJJ5RRFSf1584FOUK2ew2U4uha9AkoLl1YLXffgpAq0ZciVtcrACvuxTZb4
         i1lH5ytlK9LOAwSk77mk6tsq6LCEtXgpw+TAA1u/3icgkMfH0VP88iaHCUKH8uKAv30Y
         LgTRezNyNYkP4NH1p0aAWwQXtyy88LSq/oP6xsmZHWsRSM7/D5vQgSAbmNWeI+WHIM9a
         ZdGg==
X-Gm-Message-State: AOAM532hZ0/g55myOZP6m97h+oWhSEO/LDftaje6bHdrEWFmFvZvaxTz
        vnNdKmD18b0aPmuZPDWbLR4t2OtM5VU=
X-Google-Smtp-Source: ABdhPJzbWljimMXH09NJ1xt1TDDQt1ky2nZ4l84t+Jj5b1ePvJQ7Qb4eGdRHzCKmAbbJ8J+A5gs0Ig==
X-Received: by 2002:a63:8c4d:: with SMTP id q13mr27280061pgn.92.1632214404629;
        Tue, 21 Sep 2021 01:53:24 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w18sm4612202pff.39.2021.09.21.01.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 01:53:24 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 2/2] utils: nfulnl_test: Add rather extensive test of nflog_get_packet_hw()
Date:   Tue, 21 Sep 2021 18:53:15 +1000
Message-Id: <20210921085315.4340-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
References: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wasn't expecting length in NBO, so code caters for it being either way

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 utils/nfulnl_test.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index 237adc3..a07c100 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -15,6 +15,31 @@ static int print_pkt(struct nflog_data *nfad)
 	char *prefix = nflog_get_prefix(nfad);
 	char *payload;
 	int payload_len = nflog_get_payload(nfad, &payload);
+	struct nfulnl_msg_packet_hw *hw = nflog_get_packet_hw(nfad);
+
+	if (!hw)
+		puts("No struct nfulnl_msg_packet_hw returned");
+	else {
+		char *p = "";
+		int i;
+
+		if (hw->hw_addrlen > sizeof hw->hw_addr) {
+			i = htons(hw->hw_addrlen);
+			if (i <= sizeof hw->hw_addr) {
+				hw->hw_addrlen = i;
+				p = " (after htons)";
+			}
+		}
+		printf("hw_addrlen = %d%s\n", hw->hw_addrlen, p);
+		if (i && i <= sizeof hw->hw_addr) {
+			uint8_t *u = hw->hw_addr;
+
+			fputs("HW addr: ", stdout);
+			for (i--; i >=0; i--, u++)
+				printf("%02x%s", *u, i ? ":" : "");
+			puts("");
+		}
+	}
 
 	if (ph) {
 		printf("hw_protocol=0x%04x hook=%u ",
-- 
2.17.5

