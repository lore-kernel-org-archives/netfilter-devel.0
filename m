Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D95C43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CBF02087B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uTKrw08L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfD2Q4B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 12:56:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43508 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2Q4B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 12:56:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id t22so2420747pgi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N3QWncicWEyla2xGy7gOu964ZKLsMstNFxMAu578khQ=;
        b=uTKrw08LKQ3h2Z/2IWTfhqz04yfjPpdZR0T6oDHUSprwsAjx8oyQIzSFLRkrDRRwvd
         DgolB1WUlGkDmx1cEc6Om1Ta8hPAbFTNiirDw0DdXcQcQ/Z9AF4Z/m71YgzNr9EoT6S4
         qQ5ruWjHYQqysHIRuamGPxJvfL/V6bCfulPzfPmF9QK2or6L4+vrn6FwYxu9e97CpGd0
         VzJDOgUz48UZK63EnEUa7cdqUjDty3jj/vZgR49Rk0DWWk8D4FjqpO2ovm80GB65jMZq
         InJUUweCh+6gs8SHaAVqPjRiOleyBaf7yDRSyG1CFChP3eBiL32srWxM81fWq2RT/V8R
         eCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N3QWncicWEyla2xGy7gOu964ZKLsMstNFxMAu578khQ=;
        b=j0VjBr7rT5mitjv+XJtMc0GVuxMGQQrnwKKCDzZWi4baPyRdMBBsBDGVo6eEwF27Ir
         TcMOOdoPqyZvl3rfnBhozS4o3bpuOR06NB7oiVEGBYzMNQc/j14i2WBSkEHEzKOksjxw
         G7TZNbuStucEBRIl787P/yG9f7qzr9nObv2WESw29cEPIGK/9PWbv5+QSsSbT+Slewuu
         ZwlryZ1Cbr+3XrHfTZJIITL1ufy4k6eJzqHwNGYVGTj44XtAXF+BDBfF169P3FSm9N+U
         /3FUjJb/VpVSnMYE5UdobYPVdNTVxg7Ojk8S5e0LRTEGhvo4nXYgXBr48sw0m75wAjuT
         miaw==
X-Gm-Message-State: APjAAAU5M6m0+fPrgukDAu5OIfpiug8Z1X2gYbORUgfOVpcwtUUeL3sF
        47v9wcRAW8R4vOv9QoFtZBo=
X-Google-Smtp-Source: APXvYqyeeN1lbV2uEXRMAsXBPIYwQ9giQoT8XnKOQ3h38TK8MDOiD/Kx+MbbKyhO7aCvGJMLNPCOGg==
X-Received: by 2002:a63:6983:: with SMTP id e125mr56279925pgc.370.1556556960923;
        Mon, 29 Apr 2019 09:56:00 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id f14sm10055877pgj.24.2019.04.29.09.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 09:56:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf v2 2/3] netfilter: nf_flow_table: check ttl value in flow offload data path
Date:   Tue, 30 Apr 2019 01:55:54 +0900
Message-Id: <20190429165554.1424-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_flow_offload_ip_hook() and nf_flow_offload_ipv6_hook() do not check
ttl value.
So, ttl value overflow can occur.

Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1d291a51cd45..46022a2867d7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -181,6 +181,9 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	    iph->protocol != IPPROTO_UDP)
 		return -1;
 
+	if (iph->ttl <= 1)
+		return -1;
+
 	thoff = iph->ihl * 4;
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
@@ -411,6 +414,9 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	    ip6h->nexthdr != IPPROTO_UDP)
 		return -1;
 
+	if (ip6h->hop_limit <= 1)
+		return -1;
+
 	thoff = sizeof(*ip6h);
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
-- 
2.17.1

