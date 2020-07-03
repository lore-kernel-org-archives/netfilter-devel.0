Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949CBC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE9E206A1
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="dZh9boHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCNhB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCNhA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 09:37:00 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B41C08C5C1
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 06:36:59 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z2so23889690qts.5
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jul 2020 06:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=bJmqwWFrAIe8ZK9B67ZPHMKhCaBXUrrmbgzZcvhmbT0=;
        b=dZh9boHdF4CV11P788Y8JP2c5xURiKXVazqK2lO7mdweMMZcXJjOk2sIaHbw3jbsNZ
         5G5RcdqN/K5QpZOgOxWucXb7xtSwDMekIdxRGTlYxnnRpYH2PAviNTD+ro/SXcHBirTg
         AHsotLs4MhCqLG/4jqKNxeMoMmuob+Sq7ApapzRNxSAvSF1Gsyzy/kGN38ql6Qy2PzoD
         LVz/gfjwRhT4w01ZaQSiaYeSiSum/dl5v9f9vJAGcVRPKeyvuJGCxeXwWwK8jdyPm3jT
         uOWB2H+EnuKEAo9qq++2iCCH1TKtYc50mHx5IbG9LosAHBlyVcSq4GXb7X+LyVDmQHZM
         bKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=bJmqwWFrAIe8ZK9B67ZPHMKhCaBXUrrmbgzZcvhmbT0=;
        b=WsRNc8Pp9TlprQLtY0cGof1jfz937/8sIy5iRRzVpfO/jYps2baJH9C5elCudGXAyH
         2HHs2pixTXQn+D4caEXpGlwrEt9+BINtmd1wNQT5MJDOry3qojoOW2lR3XefLa4rAyUQ
         /Pw+DaduNY4++ml4HcEj71shv8cz1oM9r6V2RvGJ01/NrZlUUST80z8fExbglsBxdS3H
         HtEKlcNh8uZ2omeSKUQpyUAiAHFjWohI7LhGJPTDHxLhOgIGtI0jyzN8k4bYd1URmnUV
         /uKmhhGztJ9M5LVNacTbMzW18VTJGUeez5IHPjlc8hRgq6mDk8rnYO6DIszUItg+EpHq
         EBOw==
X-Gm-Message-State: AOAM533cQqwTduQuZCGJlgl8x2N882zpzAVENHeOtvrfEZ40SlQToltl
        EfHyqG+rwY4lHvhT3VPj6I43
X-Google-Smtp-Source: ABdhPJweXHQZCIZ09TB4Ia4NsEfzcvCSUK/hSin/naGrWBqifP4aa9aCMw3X9VjaQpv/M+00tWAIMA==
X-Received: by 2002:ac8:5484:: with SMTP id h4mr35754240qtq.322.1593783418831;
        Fri, 03 Jul 2020 06:36:58 -0700 (PDT)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id z68sm10734785qke.113.2020.07.03.06.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 06:36:58 -0700 (PDT)
Subject: [PATCH] audit: use the proper gfp flags in the audit_log_nfcfg()
 calls
From:   Paul Moore <paul@paul-moore.com>
To:     linux-audit@redhat.com
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Jones Desougi <jones.desougi+netfilter@gmail.com>,
        netfilter-devel@vger.kernel.org
Date:   Fri, 03 Jul 2020 09:36:56 -0400
Message-ID: <159378341669.5956.13490174029711421419.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
incorrectly passed gfp flags to audit_log_nfcfg() which were not
consistent with the calling function, this commit fixes that.

Fixes: 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
Reported-by: Jones Desougi <jones.desougi+netfilter@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 net/netfilter/nf_tables_api.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f7ff91479647..886e64291f41 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5953,7 +5953,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 
 			if (reset) {
-				char *buf = kasprintf(GFP_KERNEL,
+				char *buf = kasprintf(GFP_ATOMIC,
 						      "%s:%llu;?:0",
 						      table->name,
 						      table->handle);
@@ -5962,7 +5962,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						family,
 						obj->handle,
 						AUDIT_NFT_OP_OBJ_RESET,
-						GFP_KERNEL);
+						GFP_ATOMIC);
 				kfree(buf);
 			}
 
@@ -6084,7 +6084,7 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 				family,
 				obj->handle,
 				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 		kfree(buf);
 	}
 
@@ -6172,7 +6172,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 			event == NFT_MSG_NEWOBJ ?
 				AUDIT_NFT_OP_OBJ_REGISTER :
 				AUDIT_NFT_OP_OBJ_UNREGISTER,
-			GFP_KERNEL);
+			gfp);
 	kfree(buf);
 
 	if (!report &&

