Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0091FC25B67
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 00:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjJXAvV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjJXAvU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 20:51:20 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FAE120
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:51:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6ba54c3ed97so3806403b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 17:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698108676; x=1698713476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xt6qNSsoCW9YBbQTEu0uQpIfNcgo0hJWffk7MVc0DFY=;
        b=b965qZGafCB95WS1SZG+PwpofflWOKOqTYvAiX8ZRgIZ1+oqipJk+dyt9KNXOjmNSy
         oAwiKKm64fyN1dWFsVAsGwIAY6zLKaPLle0xTVE+Vd/Eh4NhheSJcN8AC0KwaV5wi5+R
         w6tz3J38lpomIbcGtaIgEF0gEC7pqOlWgPtR/RXG4Opwq0xups8ckS9jnOocxjDXqltr
         IGiLIoyKsoYMLdLEHk+s+dP9lcO+HBDaAnvZmAPk/oLpH1Sl+NZ5vldbkZCxlTjQLysP
         nN4H0XvkIOvr3/28237i/BjxbBevuN0EZS+a7Q+XKKJNUOFHg8W6fzDjE1walPsxG1Cp
         IpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698108676; x=1698713476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xt6qNSsoCW9YBbQTEu0uQpIfNcgo0hJWffk7MVc0DFY=;
        b=dg3SEO6BPgO2k33GQBLsW8YzGmbZ0+7RovXj3hWxnfj88T62C9bMJqArcZi7B1Hydy
         skSX+XPoQJCRP6oI55JeU4U6UXUe2V+J4zLNcCrqLSKEnn4D+xhnL56r4y4p3lh8rf66
         W5Lbp/S6IJ09KIeuopNAirD0mcqxWCbtlF4MeWU/XA4MDiW04DPNQq3vRkc1ZPg8NP2c
         j8bVjcVCzgAfZRF9rW7Fdfxtg4mYAzApq/igrqGZ3gUylSC1Y1Qo/TcgoD0uBFquElCT
         tz/ne8ON64KnnYLRgGRsznVSK0yvipYht7HeUirtatHR1Fpsmk6L16tr26t45L5fEwoM
         9+Jw==
X-Gm-Message-State: AOJu0Yw/Pb5pNixJD1SSR21G98QbM6YNyy3SV62oTYtp719BjSCmggiL
        gP9LLti2N2Fj4PrDLPJF+h8=
X-Google-Smtp-Source: AGHT+IH7vpzKAXUBAVIQV2Dhe3ivVq7jCO86dROfAlCwzuca7WITNM+IPU0kY+hHvZybp3cBYN3omg==
X-Received: by 2002:a05:6a00:13a6:b0:68a:5395:7aa5 with SMTP id t38-20020a056a0013a600b0068a53957aa5mr13447054pfg.17.1698108676338;
        Mon, 23 Oct 2023 17:51:16 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id q12-20020aa7982c000000b006bfb91ac2afsm1809497pfl.140.2023.10.23.17.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 17:51:16 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] Retire 2 libnfnetlink-specific functions
Date:   Tue, 24 Oct 2023 11:51:10 +1100
Message-Id: <20231024005110.19686-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231024005110.19686-1-duncan_roe@optusnet.com.au>
References: <20231024005110.19686-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove nfq_nfnlh() and nfq_open_nfnl() from public access.

As outlined near the foot of
https://www.spinics.net/lists/netfilter-devel/msg82762.html,
nfq_open_nfnl() and nfq_nfnlh() are "problematic" to move to libmnl.

These functions are only of use to users writing libnfnetlink programs,
and libnfnetlink is going away.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 .gitignore                                      | 1 +
 include/libnetfilter_queue/libnetfilter_queue.h | 2 --
 src/libnetfilter_queue.c                        | 5 +++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index ae3e740..b64534a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -19,6 +19,7 @@ Makefile.in
 /libnetfilter_queue.pc
 
 /examples/nf-queue
+/examples/nfq6
 /doxygen/doxyfile.stamp
 /doxygen/html/
 /doxygen/man/
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index ec727fc..c5d4cc7 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -28,7 +28,6 @@ struct nfq_data;
 
 extern int nfq_errno;
 
-extern struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h);
 extern int nfq_fd(struct nfq_handle *h);
 
 typedef int  nfq_callback(struct nfq_q_handle *gh, struct nfgenmsg *nfmsg,
@@ -36,7 +35,6 @@ typedef int  nfq_callback(struct nfq_q_handle *gh, struct nfgenmsg *nfmsg,
 
 
 extern struct nfq_handle *nfq_open(void);
-extern struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
 extern int nfq_close(struct nfq_handle *h);
 
 extern int nfq_bind_pf(struct nfq_handle *h, uint16_t pf);
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..e8de90a 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -237,9 +237,11 @@ static int __nfq_rcv_pkt(struct nlmsghdr *nlh, struct nfattr *nfa[],
 	return qh->cb(qh, nfmsg, &nfqa, qh->data);
 }
 
+static struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh);
+static struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h);
+
 /* public interface */
 
-EXPORT_SYMBOL
 struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 {
 	return h->nfnlh;
@@ -413,7 +415,6 @@ struct nfq_handle *nfq_open(void)
  *
  * \return a pointer to a new queue handle or NULL on failure.
  */
-EXPORT_SYMBOL
 struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
 {
 	struct nfnl_callback pkt_cb = {
-- 
2.35.8

