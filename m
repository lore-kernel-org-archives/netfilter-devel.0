Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0C2C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822FE61168
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 08:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhIUIyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhIUIyu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 04:54:50 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DD6C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q23so16731764pfs.9
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Sep 2021 01:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uZloTX8q005+BdSO1FSu9fm8H8yHlIBpcrr0CuLnnDU=;
        b=GXpo/Kk7NvtQEN732p391twu7sx5VomX7+gHfs2LBbKodDNyssXvOSd7Ya3U6+TeMG
         17t0mbhvjMaXuPsbZFuT75tknfiqkcwmtzL+6udnRSYTtkVQmauE7LBXj6pOCKfwzH6z
         7At+KxeC+Whrn8qubNjjCD0Q95tI0/dye1GP4uwHxD1/f7SpQYaXbtBl+Z7olzsHnR45
         rO+/e+Cv0PwOs2MKiD9863cQIPNpujI5VfAxK3NDGTN4Rj7zZAd2ZsV9Mh4LzsRSfbcT
         zeEnCf4Ie+585rODYxsZhxYgTO/hveY2XBfV003WH5h1JAvTT+Aros3dmK32EwO4TXtH
         f+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=uZloTX8q005+BdSO1FSu9fm8H8yHlIBpcrr0CuLnnDU=;
        b=DpdF7hIiKRRtvPjoNRWTtIKv8uphv9bmhC8jtT6Mby2y+ySdkd/6UO5GfBZafJBQAg
         CsjkewNsORdiRGeklfHk9qEDa0l0yakL1LN9jt106KzYfpnNClNjybAm125qeaQK4Hey
         f+HI5Oa3hXaVFaVULxA7LDEnt3OnTXTveF86BJauNtamYsPfNKMHi71uacqO0C0UdzR7
         Br6kw9PsZDZUHuamGzluoMElqbzohtuhhNN5xJzz0tII7UUjYp3pGIJ/XzrzN50qvZH6
         VggZs0S8OkoNUQBFkxBFo41DCh7CVdpThjKf6DEmgvaYggfs2Mi0JyJGOuqm6H9N9PuV
         SVPg==
X-Gm-Message-State: AOAM530oSCtWK1OJIKc2C9sZOlTfrIZ0ugQjT5eP5yZWsO5ifEaCy3FZ
        jlsAGMbmnq5pp6gilbBvn5M=
X-Google-Smtp-Source: ABdhPJw5ggEngQJTeYw97zoK1lcbO8iC2oXS0RjqUGsvdvnWstB4GA1+63tEpt346Xri1TWHB8w5gA==
X-Received: by 2002:a63:ec45:: with SMTP id r5mr27505113pgj.440.1632214402511;
        Tue, 21 Sep 2021 01:53:22 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w18sm4612202pff.39.2021.09.21.01.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 01:53:22 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 1/2] utils: nfulnl_test: Agree with man pages
Date:   Tue, 21 Sep 2021 18:53:14 +1000
Message-Id: <20210921085315.4340-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
References: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the same variable name as the man pages / html for functions in the Parsing
module (e.g. nflog_get_msg_packet_hdr(nfad)).

Rationale: make it easier for users to follow the code
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 utils/nfulnl_test.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index 05ddc6c..237adc3 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -6,15 +6,15 @@
 
 #include <libnetfilter_log/libnetfilter_log.h>
 
-static int print_pkt(struct nflog_data *ldata)
+static int print_pkt(struct nflog_data *nfad)
 {
-	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(ldata);
-	uint32_t mark = nflog_get_nfmark(ldata);
-	uint32_t indev = nflog_get_indev(ldata);
-	uint32_t outdev = nflog_get_outdev(ldata);
-	char *prefix = nflog_get_prefix(ldata);
+	struct nfulnl_msg_packet_hdr *ph = nflog_get_msg_packet_hdr(nfad);
+	uint32_t mark = nflog_get_nfmark(nfad);
+	uint32_t indev = nflog_get_indev(nfad);
+	uint32_t outdev = nflog_get_outdev(nfad);
+	char *prefix = nflog_get_prefix(nfad);
 	char *payload;
-	int payload_len = nflog_get_payload(ldata, &payload);
+	int payload_len = nflog_get_payload(nfad, &payload);
 
 	if (ph) {
 		printf("hw_protocol=0x%04x hook=%u ",
-- 
2.17.5

