Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DBAC04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C88F20818
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:02:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V4zI/F0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfEOTCm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:02:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34804 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfEOTCl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:02:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so252286pgt.1
        for <netfilter-devel@vger.kernel.org>; Wed, 15 May 2019 12:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IcxGW+AhXXPlWfcujEEyhhe86DICV1jA/wJu18DGnyA=;
        b=V4zI/F0QwNUMHjr5O57FEmJGjCgC/2uJpnBFjeTIYQyt8ehfs02AcagxwOoK5H6OwK
         XZeSX3AfIKcy78dS7ZN+Ty0szydpl0z+/3Tfaa+oXu8IrUG+wJE+PFvQCVI/Q/VnW9oE
         y+LFMyRYjqrMSOig4Gj3RnhAr6xlCKh1HzDtTdv22F7gijBohy5MctIgp0GuzN/gWblW
         iRa7bIRXg8hvcYyc6kU8+rDz1Yugoy+4dMU7K+crg6QaqJz2j3QLtGsbh80ui+jlZj8k
         qSPfC5zKBncTAnoe5VS0P04/hioYdnG3wwfVHpYE9zPThmGiJMBKY67NHsHkAGhcd3FI
         SB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IcxGW+AhXXPlWfcujEEyhhe86DICV1jA/wJu18DGnyA=;
        b=Xb6HJMqMkNfEBWA6IsWFQmiSHbfyF7DJlD1fO8cCPsmCDBw2+WzMV2wEaoiIKNoxUs
         ckrEBM43+h4bHoxnjVhwW4nMSPUk5W4uDKXcL6/zLlNUZoFv50ZnMGXrQwXKiVH5qf1k
         UIhskSABpyzxVQ7Z6kii7FHuAPy4s3GB2JquwrYUqjH9nkmzCgzjNgVolwcABI0MhLzI
         85aOWVlRYIgt8prvvzb0svcgriG7iv1YXFKMP+ndpk+3Ki3mWAX8B7+OxIKdA9gB/6QT
         TF4Sqbujp+5gBZssz6DURzY9YcM55kc8bNiPPTIldwGrWMo7EBEMvZrs8EdyI071b3To
         5RGQ==
X-Gm-Message-State: APjAAAX9y+y+9Zt/kyQmtLDrM953kVID1KbTfeyCoT5H7wpqZeDWUrBK
        qSEeYCwqnsPvJzs1bmT4HN6+1u+X
X-Google-Smtp-Source: APXvYqwxQUkS0DetWj90nDOtTykEOfpA+UoglfyvMzsw3lJFSX/lxJnqqKXyIaAr2lyeIY/MfL03Mg==
X-Received: by 2002:a65:6688:: with SMTP id b8mr45189398pgw.81.1557946960899;
        Wed, 15 May 2019 12:02:40 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id y10sm5163346pff.4.2019.05.15.12.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:02:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf-next] netfilter: nf_flow_table: remove unnecessary variable in flow_offload_tuple
Date:   Thu, 16 May 2019 04:02:31 +0900
Message-Id: <20190515190231.28110-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The oifidx in the struct flow_offload_tuple is not used anymore.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nf_flow_table.h | 2 --
 net/netfilter/nf_flow_table_core.c    | 1 -
 2 files changed, 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 3e370cb36263..d8c187936bec 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -53,8 +53,6 @@ struct flow_offload_tuple {
 	u8				l4proto;
 	u8				dir;
 
-	int				oifidx;
-
 	u16				mtu;
 
 	struct dst_entry		*dst_cache;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50..1bb41abcb91d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -52,7 +52,6 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 	ft->dst_port = ctt->dst.u.tcp.port;
 
 	ft->iifidx = other_dst->dev->ifindex;
-	ft->oifidx = dst->dev->ifindex;
 	ft->dst_cache = dst;
 }
 
-- 
2.17.1

