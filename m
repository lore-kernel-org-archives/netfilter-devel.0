Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDF6C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E4C420835
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 16:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHGAxWDZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbfDQQts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:49:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44619 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfDQQts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 12:49:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id g12so12271623pll.11;
        Wed, 17 Apr 2019 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pe3igutK4LaSTsAdFLptNovb66N+ypNP5LkQ446Wvss=;
        b=YHGAxWDZn1lltJ2+hIIbaT/PdIvJZ32gMokmhHd41lHpHuGO6JgX+H3RahG5bD0W0O
         zhbnnWOcBYYG1nj9dAlWKyGtMdawzyMCPfcJGqdZJAfAFL5EJYrBsp6QXIHmXYQkq4kB
         yS7lx/j8iMe3FMJd92ZXpqJYDWt/mQklr0D3hrhA3zrtVKuoXUGf/RAigb4icpIIo3fa
         BTqlo/i7BlW7xGHGoxOh/XbTWHavnWL9bzNHiL2RT+t8msmwr0JHT+/MOu0xb7ZreM4J
         XiKvZqpqZlCK6twIuQ5VmG8aAIE3RyitPVCVWBIOMCw/no/bdeTJ8dvQHkmn8SXwwV9k
         z7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pe3igutK4LaSTsAdFLptNovb66N+ypNP5LkQ446Wvss=;
        b=D8/f3xaEpqE++Cwsu+XBi3LUicFWd6zOJBlE/Fsdnm8czXhrWWFRYFrOeuIWI9bvhh
         aHX6K9a7a8+LscgERHnbNbN3Uz0Ef7LHOjQ1S3Lp8ttQ6tEboO0DbjEz7J78/aXIfhJC
         Cc02m7rTQYMDNZ1N3930TejGAhupQehCoUPnVKNug7lxKCLjuACKr97d3fQ4LuRU8flY
         zSSBOrn76wgRJzwgseKrWaShGfirde5wVNNGnKuowPjscbHJ3kqBqB87uXTQL8vFevbQ
         zBO/DlcZHRnOIos4hYB7cLkZ0/9vD0GtOsryAscGQkg/sUJBHdvvyIZ1foPgIdDnTE/W
         Jyng==
X-Gm-Message-State: APjAAAUgiTaESNZ6A067Y+HIUkqkpu18NS3U1Esd0XS70K4SONotClsw
        cGk3zysLv4ZoU1A2iZysJfY=
X-Google-Smtp-Source: APXvYqy072rsZGzErl2LHybNnktLFchHRzwTiIZkxOKyx8PZZk5Cc8s5U7EaFi0SI1dMyCK4Yh10rg==
X-Received: by 2002:a17:902:2b87:: with SMTP id l7mr9992505plb.130.1555519786756;
        Wed, 17 Apr 2019 09:49:46 -0700 (PDT)
Received: from localhost.localdomain ([2620:0:1008:fd00:ed8e:8493:d2b7:8f54])
        by smtp.gmail.com with ESMTPSA id s20sm75149565pgs.39.2019.04.17.09.49.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 09:49:46 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Andrei Vagin <avagin@gmail.com>
Subject: [PATCH] netfilter: fix nf_l4proto_log_invalid to log invalid packets
Date:   Wed, 17 Apr 2019 09:49:44 -0700
Message-Id: <20190417164944.1462-1-avagin@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It doesn't log a packet if sysctl_log_invalid isn't equal to protonum
OR sysctl_log_invalid isn't equal to IPPROTO_RAW. This sentence is
always true. I believe we need to replace OR to AND.

Cc: Florian Westphal <fw@strlen.de>
Fixes: c4f3db1595827 ("netfilter: conntrack: add and use nf_l4proto_log_invalid")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---
 net/netfilter/nf_conntrack_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index b9403a266a2e..37bb530d848f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -55,7 +55,7 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 	struct va_format vaf;
 	va_list args;
 
-	if (net->ct.sysctl_log_invalid != protonum ||
+	if (net->ct.sysctl_log_invalid != protonum &&
 	    net->ct.sysctl_log_invalid != IPPROTO_RAW)
 		return;
 
-- 
2.20.1

