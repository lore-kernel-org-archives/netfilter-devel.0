Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CC4C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 08:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37EC26103A
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 08:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhIAIXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243147AbhIAIXu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Sep 2021 04:23:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F3AC061575
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Sep 2021 01:22:54 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t1so2020866pgv.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2021 01:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mIZuSjaQ6NFu7kTJStgnTRxm5Xhs26Ld8/jXnYx0GDI=;
        b=M1lW7rkaGNm0WhATPvFGMLkSloEacM6I2319M+WfMLM1SBsmexbcu+G2j6ClqWLUYX
         ZAmjXHFB+h0Ssg1qdEuupoTZqlJJ15r7CK4/Ct52QLxT4v2kmG4IjFvD5HiP3QnwAaf3
         qc5RqMbNUpdq8ByzXEhc+hbTaXqjSTmatiN57n+Rf8YpuxMiVtGXjzKKkFeBqmJhVClN
         rURKcTZt74ZgiG7m3eF7A1dDBJouZms+oNE1w68xYnNqC1Eu/l5h6drS8Sg03RtNGT0+
         uYA94u8Ua0Z/hIM56gdN7EOhGmBbWl6d9JlxPngXUH6sqawEl3oUzM7roZ6cTVo1pgTv
         L4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=mIZuSjaQ6NFu7kTJStgnTRxm5Xhs26Ld8/jXnYx0GDI=;
        b=tpDOXeO/KLEcvov7rTzbJOPSwJfdDcJeIrU3wnbVDrk3Xwt2HiCQe4tE0znlQBxueF
         C1oGHdi6FwYmroRcr09ty3JZRcEpDoN8WDJuYDU+qEB43A0wfVHEVUj9LX9eoecy++Zl
         fcsuFBvZC717epTnjjt/s4bUS0l0zvgklf6tbdJIbsHFLeCSbldRApPf7todtgt/Jv6I
         1PtavkQ6UWZyCvdr9I9ZYQFtt08dmnSQMVFgdTmRe2UpmQ1jl0xqHwY3bbWnWB9/DfIy
         ayjs8d2ecWwp38w1y6JucQHtNE9M8XwBnnxE4YS0y7ApSIZHKwAs42vIVE+uuPFKxWbx
         Bpdg==
X-Gm-Message-State: AOAM5322us/G1Bs0QQj5aHXG3C7LSM5z47K6BSqzlKnV0kXmKNqXF5ak
        voxRsO0JYJYlhk2Maa7uZhIxAAkD4EI=
X-Google-Smtp-Source: ABdhPJwFdBPWaw3xaj5xjcxo6eTNH+X5ytOos8VhYItvcUQfisGLmTovpQ7zE9uXXGSw6qiHUs1CXw==
X-Received: by 2002:a63:1a61:: with SMTP id a33mr30625472pgm.55.1630484574082;
        Wed, 01 Sep 2021 01:22:54 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id a21sm5447600pjo.14.2021.09.01.01.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:22:50 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 1/1] src: doc: Eliminate doxygen warnings
Date:   Wed,  1 Sep 2021 18:22:12 +1000
Message-Id: <20210901082212.20830-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210901082212.20830-1-duncan_roe@optusnet.com.au>
References: <20210901082212.20830-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Most of these are functions that return a requested datum in an arg now,
but when the documentation was written they returned the datum directly.
Now these functions return 0 for success otherwise -1, so insert the new arg
and fix the \return

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_log.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index db051b1..a7554b5 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -214,7 +214,7 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
 
 /**
  * nflog_fd - get the file descriptor associated with the nflog handler
- * \param log handler obtained via call to nflog_open()
+ * \param h handler obtained via call to nflog_open()
  *
  * \return a file descriptor for the netlink connection associated with the
  * given log connection handle. The file descriptor can then be used for
@@ -441,7 +441,7 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
 
 /**
  * nflog_set_mode - set the amount of packet data that nflog copies to userspace
- * \param qh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log handle obtained by call to nflog_bind_group().
  * \param mode the part of the packet that we are interested in
  * \param range size of the packet that we want to get
  *
@@ -806,10 +806,13 @@ char *nflog_get_prefix(struct nflog_data *nfad)
 }
 
 /**
- * nflog_get_uid - get the UID of the user that has generated the packet
+ * nflog_get_uid - get the UID of the user that generated the packet
  * \param nfad Netlink packet data handle passed to callback function
+ * \param uid UID of the user that generated the packet,
+ * if the function returns zero
  *
- * \return the UID of the user that has genered the packet, if any.
+ * \return 0 on success or -1 if UID was unavailable (\b uid
+ * is then invalid)
  */
 int nflog_get_uid(struct nflog_data *nfad, uint32_t *uid)
 {
@@ -823,8 +826,11 @@ int nflog_get_uid(struct nflog_data *nfad, uint32_t *uid)
 /**
  * nflog_get_gid - get the GID of the user that has generated the packet
  * \param nfad Netlink packet data handle passed to callback function
+ * \param gid GID of the user that generated the packet,
+ * if the function returns zero
  *
- * \return the GID of the user that has genered the packet, if any.
+ * \return 0 on success or -1 if GID was unavailable (\b gid
+ * is then invalid)
  */
 int nflog_get_gid(struct nflog_data *nfad, uint32_t *gid)
 {
@@ -838,10 +844,13 @@ int nflog_get_gid(struct nflog_data *nfad, uint32_t *gid)
 /**
  * nflog_get_seq - get the local nflog sequence number
  * \param nfad Netlink packet data handle passed to callback function
+ * \param seq local nflog sequence number,
+ * if the function returns zero
  *
  * You must enable this via nflog_set_flags().
  *
- * \return the local nflog sequence number.
+ * \return 0 on success or -1 if sequence number was unavailable (\b seq
+ * is then invalid)
  */
 int nflog_get_seq(struct nflog_data *nfad, uint32_t *seq)
 {
@@ -855,10 +864,13 @@ int nflog_get_seq(struct nflog_data *nfad, uint32_t *seq)
 /**
  * nflog_get_seq_global - get the global nflog sequence number
  * \param nfad Netlink packet data handle passed to callback function
+ * \param seq global nflog sequence number,
+ * if the function returns zero
  *
  * You must enable this via nflog_set_flags().
  *
- * \return the global nflog sequence number.
+ * \return 0 on success or -1 if sequence number was unavailable (\b seq
+ * is then invalid)
  */
 int nflog_get_seq_global(struct nflog_data *nfad, uint32_t *seq)
 {
@@ -885,7 +897,7 @@ do {								\
 } while (0)
 
 /**
- * \defgroup Printing
+ * \defgroup Printing Printing
  * @{
  */
 
-- 
2.17.5

