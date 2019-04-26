Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB719C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E49E206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:53:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jgSnmK0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDZQxv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:53:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34511 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZQxv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:53:51 -0400
Received: by mail-pl1-f194.google.com with SMTP id d5so1263517plr.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 09:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1Pph3H5cDDa0k+Utt4numULTBeuI16GoSZ0rXiaKs/0=;
        b=jgSnmK0nq2x8bI0jKfI2ftdnBpmQtT3IkAb5uN/jvHU+79r1ylrbSEb2KV7MHtwQuL
         UBjzNQEusge4Zw0dcuzFZtzPUhuX4O2gnRtxSu2Jr0Yt7bdKP+5C4LKUvIS5nyGRN1rI
         xiok1ZgqrB4v9mQ7PneGQzry4N6lsodyl5ZSvsepGnGIfixwBtZWZm42/hdOYoQL0pAQ
         MSzsNWH3cBOBIjZEVniYYh1gq5hI6ru70SeAY6dYcPU3qKv8eiCFGhv8eatQyiXn+9li
         omVhz40fXFoftVHc/7yHSsENMmvczfevBjaSoGIwbAJFYAHHX+CPdyygyghR5xrJ5lWA
         mozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Pph3H5cDDa0k+Utt4numULTBeuI16GoSZ0rXiaKs/0=;
        b=PEZ5gmRutw9gg6uHcRaRZ+nCpXiuJoaOpDMr93MnG8iKnCIHaG5em5EuPgb5a/fZkF
         O/PtF2PSfLFm79PoilS78wTThkvxyLGR3P+iteYI1+xDHQ8CJsOK/+kmx6rpaaNS9vy1
         g3f/vHZxdkhfxHnsMC1HtPTstr1Ha8N+M1eAlTiRb5OEEMIo1S+o1ZHydQ31U+sCMqlN
         5tflQ+VgsHuUdH4B9CthEjSNwG3v9pduzNyck0oVPH2pjU5KXnfDmnuvVnYRzXsJB5xA
         BW7Z3WsSwZicepgf9CYIvi/WDANWnuiJzmCdMxOa7QKbIWB4bMLKV7YOZiBBWQRrrYln
         ZuzQ==
X-Gm-Message-State: APjAAAUW3bJeyQpTiWvVUboEBvq4wuG7LoaV4XpoqRX5+atUklaqesfX
        Pv0kobaQLlUXhXaK6fRwKKg8vHar
X-Google-Smtp-Source: APXvYqwqcueDmqaiOXa/g7HRxTBH8pzks+WhsV3/MDMIUHFEedaH9kZJMxBjxGtvOhRz/eUGotYP9g==
X-Received: by 2002:a17:902:23:: with SMTP id 32mr32061920pla.116.1556297630320;
        Fri, 26 Apr 2019 09:53:50 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id 13sm38504564pfi.172.2019.04.26.09.53.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:53:49 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf 2/4] netfilter: nft_flow_offload: do not make un-established tcp flow_offload session.
Date:   Sat, 27 Apr 2019 01:53:27 +0900
Message-Id: <20190426165327.3533-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft_flow_offload_eval() makes flow_offload session but it doesn't check
tcp state.
So, it can make un-ESTABLISHED tcp flow offload session such as SYN-RECV.
But, this is not a normal case.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index ff50bc1b144f..8538ddf9c6bf 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -84,6 +84,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
+		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
+			goto out;
+		break;
 	case IPPROTO_UDP:
 		break;
 	default:
-- 
2.17.1

