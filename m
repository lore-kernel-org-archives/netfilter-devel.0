Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2923C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FB160F4F
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhI0DzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Sep 2021 23:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhI0DzP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Sep 2021 23:55:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2025BC061570
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id me1so11444446pjb.4
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yvXrDFABFpyOIkiJurgEyTizo2AgC2GlA1VnpCD9LMs=;
        b=OctkiEmZqpurqaIX/bTlvn3MDgLToLbkqGWSGg3xbLZTLcBzDEOOZHcy99Re4oY/QD
         cUDXDe2QY4v3utWaxLT8sB0HP8WSF/AsW9R+AqZcLeEuObaNhmvughqvG2F5GBv1fTDv
         4btIhKlGFcXqeKcncr3TKFADx/9kKWJtjuxamfS95CEOpWHR+JcbdSWpwuw/FhijLhxR
         Ducnuqc2EfH7H4PTcn8GgfyvQZzZXMlAfq109AhNJhR7SZUOMDxVtlXI87JvD1+MsEDA
         eUzn6Ex9RHE8B2KgA6MZD7m811CuIglGzgpqZQIod0lC8EibItyTom7MYDBG2qSemLrN
         RZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yvXrDFABFpyOIkiJurgEyTizo2AgC2GlA1VnpCD9LMs=;
        b=zkkSc5/ZR+D57zyq5G0920QQ4APeb6ygGJ5fvRPQZaxxNqstBoc0WlLpi4c53936It
         WugG42wssNkpfPzu1tpe4/XyCLkUJR+Y8poePQUJ3O8VoNg34X+tEj8L6g8Duw4mRWEy
         X4rk8g7iRJOcldsNQ83q8DaGPXVjD03kZ8ghMIAkzVObiWM2zvUOeNyElngSswf0HwUS
         NKhoUImWdlRIZatT/DhDDRWBCTAeJJ6JNcx/faeGi7aQD7cj4bvYowqZZ87TQLDE3AW9
         kS9IH3LdnZ3KL46VlsW+0AWTIFMqSd9HBuMxNTrUpyO8+npaCBouZp0hXS86y1KhCPN5
         /CBw==
X-Gm-Message-State: AOAM531Re73I5umz2iXBY2a8zrfZnEMTZT/mXEDgjiDel9UfLNhTspVv
        KdDK2HTkiOHBamvXZ9/X6ARGiO3Y4/Y=
X-Google-Smtp-Source: ABdhPJyqph5cKmcwHciNZTnZsvY3q+FoESyvinHUhEoJBkMfU9d/dIW7ah2s5j+fOvB/j5ZrXQeORg==
X-Received: by 2002:a17:90a:4618:: with SMTP id w24mr16417984pjg.142.1632714817627;
        Sun, 26 Sep 2021 20:53:37 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e14sm16429926pga.23.2021.09.26.20.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:53:37 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 2/4] src: doc: Insert SYNOPSIS sections for man pages
Date:   Mon, 27 Sep 2021 13:53:28 +1000
Message-Id: <20210927035330.11390-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
References: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also a few more minor native English corrections

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_log.c | 37 ++++++++++++++++++++++++++++++-------
 src/nlmsg.c            |  7 +++++++
 2 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 8124a30..581f612 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -221,6 +221,11 @@ functions.
 \fBParsing\fP man page (\fBman nflog_get_gid\fP)
 .RE
 .PP
+.SH SYNOPSIS
+.nf
+\fB
+#include <stddef.h>
+#include <libnetfilter_log/libnetfilter_log.h>
 \endmanonly
  * @{
  */
@@ -338,6 +343,13 @@ int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
  * When the program has finished with libnetfilter_log, it has to call
  * the nflog_close() function to release all associated resources.
  *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <netinet/in.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+\endmanonly
  * @{
  */
 
@@ -634,6 +646,13 @@ int nflog_set_flags(struct nflog_g_handle *gh, uint16_t flags)
 
 /**
  * \defgroup Parsing Message parsing functions
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <stddef.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+\endmanonly
  * @{
  */
 
@@ -748,6 +767,7 @@ uint32_t nflog_get_indev(struct nflog_data *nfad)
 
 /**
  * nflog_get_physindev - get the physical interface that the packet was received
+ * through
  * \param nfad Netlink packet data handle passed to callback function
  *
  * \return The index of the physical device the packet was received via.
@@ -760,10 +780,10 @@ uint32_t nflog_get_physindev(struct nflog_data *nfad)
 }
 
 /**
- * nflog_get_outdev - gets the interface that the packet will be routed out
+ * nflog_get_outdev - gets the interface that the packet will be routed to
  * \param nfad Netlink packet data handle passed to callback function
  *
- * \return The index of the device the packet will be sent out.  If the
+ * \return The index of the device the packet will be sent to.  If the
  * returned index is 0, the packet is destined for localhost or the output
  * interface is not yet known (ie. PREROUTING?).
  */
@@ -773,15 +793,12 @@ uint32_t nflog_get_outdev(struct nflog_data *nfad)
 }
 
 /**
- * nflog_get_physoutdev - get the physical interface that the packet output
+ * nflog_get_physoutdev - get the physical interface for packet output
  * \param nfad Netlink packet data handle passed to callback function
  *
- * The index of the physical device the packet will be sent out. If the
+ * \return Index of physical device the packet will be routed to. If the
  * returned index is 0, the packet is destined for localhost or the
  * physical output interface is not yet known (ie. PREROUTING?).
- *
- * \return The index of physical interface that the packet output will be
- * routed out.
  */
 uint32_t nflog_get_physoutdev(struct nflog_data *nfad)
 {
@@ -938,6 +955,12 @@ do {								\
 
 /**
  * \defgroup Printing Printing
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_log/libnetfilter_log.h>
+\endmanonly
  * @{
  */
 
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 98c6768..587a046 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -14,6 +14,13 @@
 
 /**
  * \defgroup nlmsg Netlink message helper functions
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <netinet/in.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+\endmanonly
  * @{
  */
 
-- 
2.17.5

