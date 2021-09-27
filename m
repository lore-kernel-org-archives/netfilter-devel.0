Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774CAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58EC760F4F
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhI0DzT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Sep 2021 23:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhI0DzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Sep 2021 23:55:19 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E70C061570
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:42 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n2so10804905plk.12
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p36eAGJ0KlTV2uwm5XGw5VXXWJr6iigaVH3Hr5HYYd8=;
        b=FOnTmAynCiKuv5d+pIZsJntQ+XM6JXNc23WxMD9mmqw+U+c7ObEeiGyHtmXzRJfnm3
         zXALczcrn+YtgK5YIOBRY0EGauDAoSexjWeCYXYxCek27jlmj2EJ4yC/k7kUn44vXY3H
         R1yN0A+23NzalVUz3R8vP58nLall/UezQ11h5hPM55K/5sSfG7gZJHIT+Xuiakslk9Ws
         yigOQuDXsdTJuOHc8yTlvLuEC38EZ9IJjbyuMEWN1E0DctCsOlLIirecurA1FNe7TKxu
         PI+A8PE12NdhKtEMxyoVpQ37hagega8zzQJE4DkbmiTuFWVPeod2vWi4OHXvpo2i8+M5
         pX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=p36eAGJ0KlTV2uwm5XGw5VXXWJr6iigaVH3Hr5HYYd8=;
        b=Ky8U/ISSY68hdxxuex30awtxUpiEIDmc7IvbmqozAeKMFB7hBEWv6xSecoY3lMMEax
         6kPckRhMRKjIDVKoXzVdyhWg+CF3ftKerJw0Ia1YChXz0K3//Mr6cGJlYrW5CctCqJy0
         Z2P26Jzzu97EWSnu9jisxfuR2brcwtN6tZLMb0fbbmwmRmmz9B1rYFnrrggKnDKveK1D
         k4HMBgSRiK3f6djtO4NlVC1g6Ob/b4R6O5SB/PSMXmCP3+kgauktM1ZO6dbet1HVV9WW
         FGizYhHKeAH25ZVpJEb4sPEOoepJqaOAS9aK1q+o2At7TTnfv+DHw1Sew5ZnXCUyKkJ0
         hMJw==
X-Gm-Message-State: AOAM530hvFgmNkqD11/RH36J2mArkElRnZ0DlAUogl6O1vl+0NLXltfP
        uRSyVzJm38mhcDgAdCxNBf8H132xPBU=
X-Google-Smtp-Source: ABdhPJwLapi8r4MtQPk8SdYxJCGfps5oMjzag6qh5y6/+9/QU3djZ3QmQIVTPdV22wyvuPiy81CvMg==
X-Received: by 2002:a17:90b:1c10:: with SMTP id oc16mr17253758pjb.245.1632714821784;
        Sun, 26 Sep 2021 20:53:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e14sm16429926pga.23.2021.09.26.20.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:53:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 4/4] src: doc: Document nflog_callback_register() and nflog_handle_packet()
Date:   Mon, 27 Sep 2021 13:53:30 +1000
Message-Id: <20210927035330.11390-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
References: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

utils/nfulnl_test.c uses these functions

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_log.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 66669af..27a6a2d 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -323,6 +323,20 @@ struct nflog_handle *nflog_open(void)
  * @}
  */
 
+/**
+ * \addtogroup Log
+ * @{
+ */
+
+/**
+ * nflog_callback_register - register function to process packets
+ *
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group()
+ * \param cb callback function to call for each logged packet
+ * \param data custom data to pass to the callback function
+ \return 0
+ */
+
 int nflog_callback_register(struct nflog_g_handle *gh, nflog_callback *cb,
 			     void *data)
 {
@@ -332,11 +346,29 @@ int nflog_callback_register(struct nflog_g_handle *gh, nflog_callback *cb,
 	return 0;
 }
 
+/**
+ * nflog_handle_packet - handle a packet received from the nflog subsystem
+ * \param h Netfilter log handle obtained via call to nflog_open()
+ * \param buf nflog data received from the kernel
+ * \param len length of packet data in buffer
+ *
+ * Triggers an associated callback for each packet contained in \b buf.
+ * Data can be read from the queue using nflog_fd() and \b recv().
+ * See example code in the Detailed Description.
+ * \return 0 on success, -1 if either the callback returned -ve or \b buf
+ * contains corrupt data. \b errno is not reliably set:
+ * caller should zeroise first if interested.
+ */
+
 int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
 {
 	return nfnl_handle_packet(h->nfnlh, buf, len);
 }
 
+/**
+ * @}
+ */
+
 /**
  * \addtogroup LibrarySetup
  *
-- 
2.17.5

