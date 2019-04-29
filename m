Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6575AC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 304462087B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DTTLvQy4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfD2QzR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 12:55:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41574 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QzQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 12:55:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id f6so5426304pgs.8
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 09:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qGHtjoUB4ODg3zFQkQLMD6KRyn8WhTqtpKB5nsE8D7M=;
        b=DTTLvQy4oziAJ6dv2ofONm3pnxT7Rt4xGq++iolwWrCeYgU8U/8DFxPRlkDGfX/WF3
         7iKlMWma57D2wutQ8tesB5ZSpHmKusVQPqkX+GgE9lHPeSo543AR1i0rub28X6A7SpJk
         DpFDoj0IFmWlLgqlRvZJbrWZ33GN+YW2XoYAAlEtXsKGdPeQoB0Un830mFIY3qExZ6KZ
         rOe24SnL6WL59zx8+EsXnRHW0NxwpRMBnO9BQ0svgz06t4su3RnlhnOtHnC4zji1CEUA
         /AhfO5FnJ5pv+EMJjn6Hbd9cUf0ofk8A6pT3/srpzgU9/LAP82RisvxgWUhLoXutW6Ib
         RJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qGHtjoUB4ODg3zFQkQLMD6KRyn8WhTqtpKB5nsE8D7M=;
        b=IMz0I/MkWtR2eDHcz7Fz/sNZCingmPHCEMBTxO5oUhh5+vzm87s2diBYhSKiBSVMc0
         LM+PF+1dRP+TPQRuWXtDjhNDX88R7+Nvlxhuv03p1PTm0bjViKDqLypwJe31aeaCIAYy
         MWZ6DASYt1yMQ4lt1P2C38CEsa2yPA5sQjx6JmbkcWX0HLU1vkY81KL4NKeN1wtIyq97
         M5qMFFBkcIxu9hxDNkdqrxFX6tnCsikv5chWwWicq/zSR2v9CSr/VnZbG5bZtwTGJWu/
         qushK5kfPTTxie+fNeOZyuJtOKKxrJD1nKpIV7UcnvQQxX9HXhMNMgfPYhMTd1izz1Go
         Hxzw==
X-Gm-Message-State: APjAAAWGZnz6JF2NfBs5UxTMuGFzC+N6cxUpmJIMIpWMe23WmkHJW7QW
        pRvPDQ/foBzWcJf99SJ9hb0=
X-Google-Smtp-Source: APXvYqwSFxINHTYj2sZG/YCNUitjGoTiF//mxRoNeNbOV41rF7G7bJmJMPPgMtxf06ShaU+hbXxFRw==
X-Received: by 2002:a63:fe0a:: with SMTP id p10mr58995898pgh.86.1556556915706;
        Mon, 29 Apr 2019 09:55:15 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id a10sm44006990pfc.21.2019.04.29.09.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 09:55:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf v2 0/3] netfilter: nf_flow_table: fix several flowtable bugs
Date:   Tue, 30 Apr 2019 01:55:06 +0900
Message-Id: <20190429165506.1202-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch set fixes several bugs in the flowtable modules.

First patch fixes netdev refcnt leak bug.
The flow offload routine allocates a dst_entry and that has 1 refcnt.
So the dst_release() should be called.
This patch just adds missing dst_release() in the end of
nft_flow_offload_eval().

Second patch adds ttl value check routine.
Flow offload data-path routine decreases ttl value. but it doesn't check
ttl value.
This patch just adds ttl value check routine.
If ttl value is under 1, the packet will be passed up to the L3.

Third patch adds CT condition check routine into flow offload routines.
a flow offloaded CT can be deleted by masquerade notifier. if so,
the flow offload shouldn't be used in flow offload data-path and
the GC should delete that.

v1 -> v2 :
 - Drop Second patch.
 - use IPS_DYING_BIT instead of ct refcnt at Third patch.

Taehee Yoo (3):
  netfilter: nf_flow_table: fix netdev refcnt leak
  netfilter: nf_flow_table: check ttl value in flow offload data path
  netfilter: nf_flow_table: do not use deleted CT's flow offload

 net/netfilter/nf_flow_table_core.c | 10 +++++++++-
 net/netfilter/nf_flow_table_ip.c   |  6 ++++++
 net/netfilter/nft_flow_offload.c   |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

-- 
2.17.1

