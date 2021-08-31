Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E502BC432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11F060F3A
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Aug 2021 08:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbhHaIDI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbhHaIDD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 04:03:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03D6C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so1555183pje.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2021 01:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rmq04cFMR2r+uo49lfB+xbGERG4sy2JFZ/cgRPG9t3o=;
        b=TSPC37+XlN8+X1lsUGWk5Ta/ua15BS77aaezCs/QueimUnEYUKodx5rpj/KgkOU2nu
         cqFjVztKe18sLGGL/BiRrR9crcPo7UjkxLJD+y8VPcZXfebub3HMtPQKkTYj93tSgplh
         xVclqQ9HJuyfOoTbKXcXSY4fBz3fBhRox3r1GIpjoKx6mkd1waPBWHb8827SAIwbOoOq
         X/FOFx84byiOTSH2zG35Zju9gztc0p1sod+QcWziq0MqLMt6bwV7wXRDf/7tRX+2Bve9
         To4jUCO9nCSnfYheDIFoWT/9XROhsEL/Ufdt5VlNVnC18uQuQSfQXaO4GxUPc/5zd/2Q
         TvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Rmq04cFMR2r+uo49lfB+xbGERG4sy2JFZ/cgRPG9t3o=;
        b=JuiDDxXM7rJqqjWLDKirl2fB+5i9Fqw3P7TRd5pC2MCAWuj54ItAmozYtdU4g48OgA
         Bgj/owHXEp0VrsXQv8zL0894Zap8ilrV/YvItJKsEXRzhJidpSt8t5hHfGFb1ubWGbOT
         eSY5JeyXCoxAUVkca+iU5MHdT4XmnVsVoSrc3SObgRKhx1vaIujJmTmZ+utFTIjaY5GF
         Nnb1ogbg3LPDP/PxJr3TTMzWSTZNxHbxZjoJFPu9N6y8sOK9yQkLlvCOrv2Gl7ZTNXFr
         dgxoYR5JRSrckiitRLvQ/T6qtyqnx6V7ZB3T2jOUPhP597QvwlBMA3fX9i1fIsjKxWOF
         G5Og==
X-Gm-Message-State: AOAM532GvdxJDsH/plKfZfnJFXtLMrRahn+5cRqZJMvg+wlyPmeov1ZO
        X3t3WOBH9YAAMlvE1RJRAUNVvKjaG0E=
X-Google-Smtp-Source: ABdhPJwDmeUwm7GqMxel6yTcKZtBoc8TT1lP0xPygveGS9c0uLtF1BiFAgDSHMVfbhlejMhtxyOa9Q==
X-Received: by 2002:a17:90a:5411:: with SMTP id z17mr3926627pjh.67.1630396928292;
        Tue, 31 Aug 2021 01:02:08 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id r2sm1459047pgn.8.2021.08.31.01.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 01:02:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 1/3] src: whitespace: Remove trailing whitespace and inconsistent indents
Date:   Tue, 31 Aug 2021 18:01:58 +1000
Message-Id: <20210831080200.19566-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
References: <20210831080200.19566-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All .c and .h files now have no lines with trailing whitespace.
All .c and .h files now indent with tabs followed by <8 spaces.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_log/libipulog.h        |  4 ++--
 include/libnetfilter_log/libnetfilter_log.h |  2 +-
 src/libipulog_compat.c                      |  8 +++----
 src/libnetfilter_log.c                      | 24 ++++++++++-----------
 utils/nfulnl_test.c                         |  4 ++--
 utils/ulog_test.c                           |  8 +++----
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
index 4d87913..8fba03a 100644
--- a/include/libnetfilter_log/libipulog.h
+++ b/include/libnetfilter_log/libipulog.h
@@ -12,7 +12,7 @@ extern "C" {
 #endif
 
 /* FIXME: glibc sucks */
-#ifndef MSG_TRUNC 
+#ifndef MSG_TRUNC
 #define MSG_TRUNC	0x20
 #endif
 
@@ -55,7 +55,7 @@ const char *ipulog_strerror(int errcode);
 
 void ipulog_perror(const char *s);
 
-enum 
+enum
 {
 	IPULOG_ERR_NONE = 0,
 	IPULOG_ERR_IMPL,
diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 6192fa3..c27149f 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -49,7 +49,7 @@ extern int nflog_set_flags(struct nflog_g_handle *gh, uint16_t flags);
 extern int nflog_set_qthresh(struct nflog_g_handle *gh, uint32_t qthresh);
 extern int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz);
 
-extern int nflog_callback_register(struct nflog_g_handle *gh, 
+extern int nflog_callback_register(struct nflog_g_handle *gh,
 				    nflog_callback *cb, void *data);
 extern int nflog_handle_packet(struct nflog_handle *h, char *buf, int len);
 
diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index 85f7cf5..a0de3cb 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -32,7 +32,7 @@ static const struct ipulog_errmap_t
 {
 	int errcode;
 	const char *message;
-} ipulog_errmap[] = 
+} ipulog_errmap[] =
 {
 	{ IPULOG_ERR_NONE, "No error" },
 	{ IPULOG_ERR_IMPL, "Not implemented yet" },
@@ -99,7 +99,7 @@ struct ipulog_handle *ipulog_create_handle(uint32_t gmask,
 	h->nfulh = nflog_open();
 	if (!h->nfulh)
 		goto out_free;
-	
+
 	/* bind_pf returns EEXIST if we are already registered */
 	rv = nflog_bind_pf(h->nfulh, AF_INET);
 	if (rv < 0 && rv != -EEXIST)
@@ -146,7 +146,7 @@ next_msg:	printf("next\n");
 
 	nfnl_parse_attr(tb, NFULA_MAX, NFM_NFA(NLMSG_DATA(nlh)),
 			NFM_PAYLOAD(nlh));
-	
+
 	if (!tb[NFULA_PACKET_HDR-1])
 		goto next_msg;
 
@@ -207,7 +207,7 @@ next_msg:	printf("next\n");
 		h->upmsg.data_len = NFA_PAYLOAD(tb[NFULA_PAYLOAD-1]);
 	} else
 		h->upmsg.data_len = 0;
-	
+
 	return &h->upmsg;
 }
 
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 7d37570..db051b1 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -4,7 +4,7 @@
  * (C) 2005, 2008-2010 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 
+ *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation (or any later at your option)
  *
  *  This program is distributed in the hope that it will be useful,
@@ -82,7 +82,7 @@ struct nflog_g_handle
 int nflog_errno;
 
 /***********************************************************************
- * low level stuff 
+ * low level stuff
  ***********************************************************************/
 
 static void del_gh(struct nflog_g_handle *gh)
@@ -244,7 +244,7 @@ struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
 
 	h->nfnlh = nfnlh;
 
-	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_ULOG, 
+	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_ULOG,
 				      NFULNL_MSG_MAX, 0);
 	if (!h->nfnlssh) {
 		/* FIXME: nflog_errno */
@@ -393,10 +393,10 @@ struct nflog_g_handle *
 nflog_bind_group(struct nflog_handle *h, uint16_t num)
 {
 	struct nflog_g_handle *gh;
-	
+
 	if (find_gh(h, num))
 		return NULL;
-	
+
 	gh = calloc(1, sizeof(*gh));
 	if (!gh)
 		return NULL;
@@ -610,8 +610,8 @@ int nflog_set_flags(struct nflog_g_handle *gh, uint16_t flags)
  * The nfulnl_msg_packet_hdr structure is defined in libnetfilter_log.h as:
  *\verbatim
 	struct nfulnl_msg_packet_hdr {
-	        uint16_t       hw_protocol;    // hw protocol (network order)
-	        uint8_t        hook;           // netfilter hook
+		uint16_t       hw_protocol;    // hw protocol (network order)
+		uint8_t        hook;           // netfilter hook
 		uint8_t        _pad;
 	} __attribute__ ((packed));
 \endverbatim
@@ -760,11 +760,11 @@ uint32_t nflog_get_physoutdev(struct nflog_data *nfad)
  *
  * The nfulnl_msg_packet_hw structure is defined in libnetfilter_log.h as:
  * \verbatim
-        struct nfulnl_msg_packet_hw {
-                uint16_t       hw_addrlen;
-                uint16_t       _pad;
-                uint8_t        hw_addr[8];
-        } __attribute__ ((packed));
+	struct nfulnl_msg_packet_hw {
+		uint16_t       hw_addrlen;
+		uint16_t       _pad;
+		uint8_t        hw_addr[8];
+	} __attribute__ ((packed));
 \endverbatim
  */
 struct nfulnl_msg_packet_hw *nflog_get_packet_hw(struct nflog_data *nfad)
diff --git a/utils/nfulnl_test.c b/utils/nfulnl_test.c
index dd3091b..da140b4 100644
--- a/utils/nfulnl_test.c
+++ b/utils/nfulnl_test.c
@@ -15,9 +15,9 @@ static int print_pkt(struct nflog_data *ldata)
 	char *prefix = nflog_get_prefix(ldata);
 	char *payload;
 	int payload_len = nflog_get_payload(ldata, &payload);
-	
+
 	if (ph) {
-		printf("hw_protocol=0x%04x hook=%u ", 
+		printf("hw_protocol=0x%04x hook=%u ",
 			ntohs(ph->hw_protocol), ph->hook);
 	}
 
diff --git a/utils/ulog_test.c b/utils/ulog_test.c
index 20f6163..213a2bf 100644
--- a/utils/ulog_test.c
+++ b/utils/ulog_test.c
@@ -22,7 +22,7 @@ void handle_packet(ulog_packet_msg_t *pkt)
 {
 	unsigned char *p;
 	int i;
-	
+
 	printf("Hook=%u Mark=%lu len=%zu ",
 	       pkt->hook, pkt->mark, pkt->data_len);
 	if (strlen(pkt->prefix))
@@ -34,7 +34,7 @@ void handle_packet(ulog_packet_msg_t *pkt)
 	if (pkt->timestamp_sec || pkt->timestamp_usec)
 		printf("Timestamp=%ld.%06lds ",
 		       pkt->timestamp_sec, pkt->timestamp_usec);
-	
+
 	if (pkt->mac_len)
 	{
 		printf("mac=");
@@ -63,7 +63,7 @@ int main(int argc, char *argv[])
 	buf = malloc(MYBUFSIZ);
 	if (!buf)
 		exit(1);
-	
+
 	/* create ipulog handle */
 	h = ipulog_create_handle(ipulog_group2gmask(atoi(argv[2])), 65535);
 	if (!h)
@@ -87,7 +87,7 @@ int main(int argc, char *argv[])
 			handle_packet(upkt);
 		}
 	}
-	
+
 	/* just to give it a cleaner look */
 	ipulog_destroy_handle(h);
 	return 0;
-- 
2.17.5

