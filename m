Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC81BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiAIDRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiAIDRF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:17:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B32C06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:17:05 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so18116968pjj.2
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QwgfoEcXJhjxlLUF4vG9JfT42kKM60iuOKce6lGi9js=;
        b=aCJBxkuBcTEZ4d8g9Z/UC3dEKUZQ4y7y8/PmNavRNL2XHk9/1FkX0TGsrFbaz/NhZu
         GtAGvX3PK73dtfgnvOGL9vqagUHhppovGIycY7gGB991BvH0OQ6f8y1UoAvajIU2BLW2
         1EpDN9D8ax822sRtFz0MtOj4+AmG7IItSRaxS5co9JxlbMVCmJTPXx3cDIVbN1BLxQ/V
         AWnaIGwUFA0qYogMUMY7yG+oDBWoHJqUR3BRiJ7gc3RDLHXyZ9JISFJFQoij7LOfa8IL
         UZLBehgjMkCKGlD71QWYuySh+cIesYJgCiE4y3EamGkflQElsJ+JIbZeWPx1vmjv8sYq
         YiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QwgfoEcXJhjxlLUF4vG9JfT42kKM60iuOKce6lGi9js=;
        b=RsPRjVEA+6jLjP1iJh9TZHhIuxxifBb7gWet+KaNUS7oaoAjGuPhhTybQSiPJ27Dj6
         Rx3BtUzz+lHovUHGvOMisOGId0/rUyU2KDOzeCQRkVbbbXYkWUoMHMf3U212II452I6A
         hME3rPkEOvKPnf53YyBhwDFh/bzTfZlUsvf39+wmClGWNgIqxChkkcc/6rHgU2H8ZYTK
         0c8RYv4xg8WuhPkIC+YUOSF1rXFXFSXtuYKs9iF5mLhWqQcDaJuHAoOmTlcfH1pY5TmE
         3O3i4X7lLb3hexPXrT+xgo8Gejwx8vjqQvn8oYKIOfFoE5ueGvHqDu6PHbknCjidSgq6
         9hKQ==
X-Gm-Message-State: AOAM532kw/EV3gcw2UBtC+l11Z37xMFfxmbHcsfCdtj8DlCUbcnGX25J
        ac6cUV3WECCpFT8qaG/Jx/I=
X-Google-Smtp-Source: ABdhPJyIDy/tgiA9QLW1BxaUyhhR1iUiKoXVJOPQR7bykfzdyJ8b7fQE3JOMeWnLsSeQzk5EqHhQdA==
X-Received: by 2002:a17:903:2486:b0:149:2de5:96d6 with SMTP id p6-20020a170903248600b001492de596d6mr70738025plw.54.1641698224669;
        Sat, 08 Jan 2022 19:17:04 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:17:04 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 3/5] src: Use more meaningful name in callback.c
Date:   Sun,  9 Jan 2022 14:16:51 +1100
Message-Id: <20220109031653.23835-4-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace 'struct qwerty' with 'struct data_carrier'.
Also get rid of the typedef.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v3: New patch
 src/extra/callback.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/extra/callback.c b/src/extra/callback.c
index 057d55a..dee6fc2 100644
--- a/src/extra/callback.c
+++ b/src/extra/callback.c
@@ -21,32 +21,32 @@
 /* needed by local_cb(); absent that, pass them down through the data arg */
 /* ---------------------------------------------------------------------- */
 
-typedef struct qwerty
+struct data_carrier
 {
 	nfq_cb_t cb_func;
 	size_t buflen;
 	size_t bufcap;
 	void *data;
-} werty;
+};
 
 static int local_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct pkt_buff pktb_instance = { };
-	werty *w = (werty *)data;
+	struct data_carrier *d = (struct data_carrier *)data;
 
-	return w->cb_func(nlh, w->data, &pktb_instance, w->bufcap - w->buflen);
+	return d->cb_func(nlh, d->data, &pktb_instance, d->bufcap - d->buflen);
 }
 
 EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
 			     unsigned int portid, nfq_cb_t cb_func, void *data)
 {
 	const struct nlmsghdr *nlh = buf;
-	werty wert;
+	struct data_carrier dc;
 
-	wert.cb_func = cb_func;
-	wert.bufcap = bufcap;
-	wert.buflen = buflen;
-	wert.data = data;
+	dc.cb_func = cb_func;
+	dc.bufcap = bufcap;
+	dc.buflen = buflen;
+	dc.data = data;
 
 	/* Verify not multi-part */
 	if (nlh->nlmsg_flags & NLM_F_MULTI) {
@@ -55,5 +55,5 @@ EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
 	}
 
 
-	return mnl_cb_run(buf, buflen, 0, portid, local_cb, &wert);
+	return mnl_cb_run(buf, buflen, 0, portid, local_cb, &dc);
 }
-- 
2.17.5

