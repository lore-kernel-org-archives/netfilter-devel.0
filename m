Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB09C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Nov 2023 03:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjKADUs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjKADUr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2023 23:20:47 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377BA4
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 20:20:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6b44befac59so352174b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Oct 2023 20:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698808843; x=1699413643; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcdDbtlbXB6216+moCOwlGvzn7F11JkxFNJvPwuo4w8=;
        b=DjWSP2Kea9xubRZa4wvH8HBiN33L3kBny90ohULsaG4gKN+Brw8wJM180XzKniCJd2
         i/Og55657C8xtHZcMLt3piZTQX7wKU8G1y5wCHNq5083kqFh2i5kYtp1+xWIm3QhwOqN
         QNx5LYUddAB1LJhmoWXVQwz0y+KdpdHrnBV9etc1rvzhhkpieAB4D3qgfrn2CIf+Gpre
         kU4fps3XpING9MoTfsVljs7LHteY99QryYG1Sw90FtJW5zwr1tfkXIgIZvKOS8CU3el7
         ew04SbLJeb3Bg4+NS5OnlSgVrCNw+vCXeV5gbwmYjH9XOwPMGcfT0NxZaPFfQp7TMEqZ
         nhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698808843; x=1699413643;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcdDbtlbXB6216+moCOwlGvzn7F11JkxFNJvPwuo4w8=;
        b=Q4v97Zx45DgGs77pu+zpepTLQRW74u5kCh0q75/ksrDl3ldKLGASNJe3XkQiZzEcH7
         wkRh7j6Ld8w61f7ONeik1H6nM718yLXcIv64bZer3CQh0Qr/gCOCdhScD+TqskLftEKU
         gJqkMq/s0HQw8gxSB/h3oAw6ePkL1mtoslEVqHy2PWeTSVpA39JkqRQ2a7yMqdTXHi2I
         5jygsXonRn70bE3ezl03U8jxAGEFN/jgGi/houel4jKcA5jnfgmSZ1hwfMTQQUcjbG96
         eP61fNKeXV6PONdkgvH2+IVZOiIYd4kxxFGI2x4uVmtBgGaxJBokYOvhe3mKQDew31nb
         M8LQ==
X-Gm-Message-State: AOJu0YwLSiI5+8pGHw0+RfSPbZJ7DgLR9aht68NZuh4DZYJoXbLB0RhX
        QQ5isuNqyrqAQpGAuli4CtY=
X-Google-Smtp-Source: AGHT+IEcxjCYx3zE/a+I+lo8dPF3/hlDBAUFVYOswrZ8CVWMbS4vViBVHrhde9grYxpa3VfhjLUERg==
X-Received: by 2002:a05:6a20:734f:b0:155:1710:664a with SMTP id v15-20020a056a20734f00b001551710664amr6171634pzc.18.1698808843501;
        Tue, 31 Oct 2023 20:20:43 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id b13-20020a056a000ccd00b006c2fd6a7fe3sm144303pfv.22.2023.10.31.20.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 20:20:43 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
X-Google-Original-From: xiaolinkui <xiaolinkui@kylinos.cn>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, razor@blackwall.org, edumazet@google.com
Cc:     netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH] netfilter: bridge: initialize err to 0
Date:   Wed,  1 Nov 2023 11:20:18 +0800
Message-Id: <20231101032018.10616-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

K2CI reported a problem:

	consume_skb(skb);
	return err;
[nf_br_ip_fragment() error]  uninitialized symbol 'err'.

err is not initialized, because returning 0 is expected, initialize err
to 0.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 71056ee84773..0fcf357ea7ad 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -37,7 +37,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	struct iphdr *iph;
-	int err;
+	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-- 
2.17.1

