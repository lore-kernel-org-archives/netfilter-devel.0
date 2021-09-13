Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6677BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 05:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AA0A60F4B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 05:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhIMF7K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 01:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbhIMF7K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 01:59:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587EDC061574
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Sep 2021 22:57:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n18so8392032pgm.12
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Sep 2021 22:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZiNMp5qcLWcCm82XEQykA+U/V8mXL05Hk8a2+DSGrI=;
        b=Y6UC0DzdSpqYn4RSabKMgS+AHtsk71zFNb4kF1f8hgMZGy0obo4zGCcp7SKdZJcomq
         yUhrrH5D7yX02XxdSbaKPdWRzJQjbhSq3hOs5eKT21uQQ6ITTjJLnQDZYcWOZp6o8lb8
         8mD44kbQYCNgV9qqa5Nbsnbh3J+zxtQ4mE018LExaRzLfH+APjaOmiep7NH6COPg3nls
         NJ58/1WIzIFlsQFBqhx+udn7PuF8Z9QAhywWfH79IPBQsirWoIxULvWenr6/sqxd3UA3
         NMdPeglDD7+GNrfvTFCNR3JXhmTi7fvFib3yCtJMecW0KbwUWsEKDI/IK55h6WJrFWBV
         VJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=OZiNMp5qcLWcCm82XEQykA+U/V8mXL05Hk8a2+DSGrI=;
        b=lir8hSeiZBcQSEZFLtASFEzFVZoF+K+We3AVimhrFRLzdzmbwn7Gy6HF5AJGxaY/xo
         ftXd//LtnxFM/9XHQwP9Fc9ElrLPLiJqM3MiiOSPspC9xf/5p/Kh+AORlVvbaCAwYjr0
         VnzPlzpCP3WnT+rnzkwlEkWxdH/kwZ+L8ms/+24APltoKMH6gwjH9ln2ToASg0vTgxjH
         QS7eq7JiWpaMeUVZWZKEFc8ASi0Hjsc9rFp1lHCJ5ZMXwCFbYQTieRmdYOPbJJOhnryb
         r76sobVTzys0jUnrQUci0MHBo6m87/VUaqzQOaBBCOsJHR9GyMqZVRTzUoTCbqPQ+GZ1
         RiWg==
X-Gm-Message-State: AOAM530b22bKXBvdniN841ZBOH4W5AT619ZpXsKeSLEnRhJmxb6AUDgO
        Rh5aslexrubkvJG14EST8LRSABn00Bc=
X-Google-Smtp-Source: ABdhPJzIiFCjHxqb8mjQp6+Dmg/XrNBmEiffY1aFcT63Ikwo1QjHXf0HbFpQJR7RD8icppeKIUQnDQ==
X-Received: by 2002:a62:5297:0:b0:3f4:263a:b078 with SMTP id g145-20020a625297000000b003f4263ab078mr9537107pfb.20.1631512674818;
        Sun, 12 Sep 2021 22:57:54 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id t68sm6617895pgc.59.2021.09.12.22.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 22:57:54 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] src: make nflog_open_nfnl() static
Date:   Mon, 13 Sep 2021 15:57:49 +1000
Message-Id: <20210913055749.24171-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nflog_open_nfnl() is neither documented nor used outside the source file
wherin it is defined.
(ulogd doesn't use this function either).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_log/libnetfilter_log.h | 1 -
 src/libnetfilter_log.c                      | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index c27149f..771d203 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -32,7 +32,6 @@ typedef int nflog_callback(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 
 
 extern struct nflog_handle *nflog_open(void);
-extern struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nflog_close(struct nflog_handle *h);
 
 extern int nflog_bind_pf(struct nflog_handle *h, uint16_t pf);
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 546d667..7eada15 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -233,7 +233,7 @@ int nflog_fd(struct nflog_handle *h)
  * @}
  */
 
-struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
+static struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
 {
 	struct nflog_handle *h;
 	int err;
-- 
2.17.5

