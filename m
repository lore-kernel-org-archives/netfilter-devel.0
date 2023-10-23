Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C5BC0032E
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 02:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjJWC0F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Oct 2023 22:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjJWC0E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Oct 2023 22:26:04 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697C919E
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Oct 2023 19:26:00 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6b20a48522fso2163939b3a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Oct 2023 19:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698027960; x=1698632760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=UJLwrsVY6XmyAIP1SnoymnbfQYmOGrLFkHuYsXveVxo=;
        b=AX5bqqJi3LsLGMmI5wp8i2SZeF2z9t/gXlHYBF8MIpwoA9fQmyRlE6i6GJqui/O326
         2CV96v1u1yyHe39zWfH3t48Hgu5vKlFejblP3p5WLMDkCIyU06gBUYkrFnEXgnhjVi+4
         8NiNSy0Wd7aS+uqdiJWXxSKW1LsidGPujZIqtuElrceI68kwzlLkYoWj96/2Rg7MMBS8
         EIhukF+Pj2tGGvt1s2VUeEeWCJOYIPGiuJVknmk9YLdNNynqIQ47hLCVh+qRHazyf4Q9
         6JmHeG56VSxwYf67JdJhpqGks6QVWXdaNyH6rGL99Fvc8XyF/ZDI7m94RITMSlzwEjV3
         8/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698027960; x=1698632760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJLwrsVY6XmyAIP1SnoymnbfQYmOGrLFkHuYsXveVxo=;
        b=ZuSH1A9abow8P6wMe81n8f11qwbhiWEqkjGeYh1UWZ+NGwNyQ9OHGLb2d1Nc8PukJC
         Yn5Ur+oGAC+36sqbO4qGXib553xdmWS+lZTnMlZvLu4x2nGVclvBjUero19bsxhXY3RR
         SgpKMMpkHzI9GybEIsmqfPOZg5QXBs605isYmgo2b/e6UYlewu3wXZteyxx3DRVwUtVe
         05Le0DUFQL6Cqds/hxGodXFBnd7+Fz8UQU46ia0kR6QBaueqlI18GdT6DRGbUEwijzoL
         qxpPGipj3djt4eD/HzI1JzaZAKYK6xO3gWlkAG/Jf460QT+B7eeMpmrOeiqMBdQ4Jja6
         vwQg==
X-Gm-Message-State: AOJu0YymAozrpZQLJmfF5obZUkIa/OCkkQe/ALX3OJDIOXr0tjHeI8/Q
        f2SoMyams2hq6Mwb6hC1pt//eXXYXh4=
X-Google-Smtp-Source: AGHT+IHPMcHufaE7DlZlQHIzlGzCLxcNV6Qxmf4v0b8Y0lluDK38g/rFNc0nMa2SDuCzL39kqZF6/w==
X-Received: by 2002:a05:6a00:1788:b0:6b5:86c3:ccaf with SMTP id s8-20020a056a00178800b006b586c3ccafmr7063501pfg.22.1698027959675;
        Sun, 22 Oct 2023 19:25:59 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id y10-20020aa79e0a000000b006875df4773fsm5111251pfq.163.2023.10.22.19.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 19:25:59 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] include: all: remove trailing spaces
Date:   Mon, 23 Oct 2023 13:25:55 +1100
Message-Id: <20231023022555.18740-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also use as many leading tabs as posssible.

Fixes: c5bcd787a6a5 ("src: Always use pktb as formal arg of type struct pkt_buff")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 include/libnetfilter_queue/libnetfilter_queue.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index a19122f..ec727fc 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -3,9 +3,9 @@
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
  *
  *
- * Changelog : 
+ * Changelog :
  * 	(2005/08/11)  added  parsing function (Eric Leblond <regit@inl.fr>)
- * 
+ *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  */
@@ -82,7 +82,7 @@ extern int nfq_set_verdict_batch2(struct nfq_q_handle *qh,
 			    uint32_t mark);
 
 extern __attribute__((deprecated))
-int nfq_set_verdict_mark(struct nfq_q_handle *qh, 
+int nfq_set_verdict_mark(struct nfq_q_handle *qh,
 			 uint32_t id,
 			 uint32_t verdict,
 			 uint32_t mark,
@@ -111,7 +111,7 @@ extern int nfq_get_secctx(struct nfq_data *nfad, unsigned char **secdata);
 extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
 			      struct nfq_data *nfad, char *name);
 extern int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
-			          struct nfq_data *nfad, char *name);
+				  struct nfq_data *nfad, char *name);
 extern int nfq_get_outdev_name(struct nlif_handle *nlif_handle,
 			       struct nfq_data *nfad, char *name);
 extern int nfq_get_physoutdev_name(struct nlif_handle *nlif_handle,
-- 
2.35.8

