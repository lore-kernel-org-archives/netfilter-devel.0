Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175AAC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA2B206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvVhLH50"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfDZQy0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:54:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32919 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZQy0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:54:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id h5so2026308pfo.0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 09:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=N3QWncicWEyla2xGy7gOu964ZKLsMstNFxMAu578khQ=;
        b=GvVhLH50mWhNQgvWlHFvmBum+BuTM9y8MrVXND1FUFh1cNjaHpmgC9CMBjCuKlqETL
         1YB3MwXBkoqrHv4beXkIo3PHh6GJFQWAx1u5qDWJp/ye04xvIBUlwIMQEqwIB2RSFOVN
         pItJhvKttMMP3tUHInskz5acZ/xxuUEK8ixAdB0QWRxKuPAl26/hKZbxbInnFUSGG69Q
         EbUdY5ZY3X1m5PKUc7C5dxKbyUBBN7bE9+SJnY3X8a3t0v2Myf4cpnHkcN3eZDffNZOa
         EbepzQMjlODC4NVvH56hN51drDzdWAkYjJ5mmCjZcFKU5T9+5Za1E1Yo8X6vvsXnbRNB
         LxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N3QWncicWEyla2xGy7gOu964ZKLsMstNFxMAu578khQ=;
        b=h6kOAjHpabtRr/mdHZZIAKB46Za0EIXESo0DqaYPkqbY9YtF0gsgp+R/P8S67BZukx
         2BdQv6+Jv5L8wU8gdHSZrJbZ3ZyCEYOWiaHg2ed0+GfOHE7nQPzjGifDaAfQ7iRYQ3DR
         pJu83gxvYa2O/X5flg8nJ37VwJ2PHIMFWQ7Q7BbMVwmguiWZuThfoJES8yxSTNK5j2xJ
         r7wRrot2IeAXAY8V7EPgJ3VuXSWRXifCxRqMXyKvWs2Si77dmfYUEO7aVh5Rvll3fs/+
         JQND6s6vYwulhDYM5ojTtt+rBRjTr7jEevXLPjUiGMxEBsyHbkA7OJeOqp6UfLlnbqaG
         5ODA==
X-Gm-Message-State: APjAAAWWjSKX0mwKaKljWMZvRbcS+h4AXdH8jKfGCN5s3J0fBtbqT9jC
        cnkA76qD3EvNIkmTqSeJW5c=
X-Google-Smtp-Source: APXvYqygEi1NjzG6PFdfYySW1lfSOvRd3jEaARdHRD943HGJnGf6Wx4W0I02hFN0QyADEJE33PJAtw==
X-Received: by 2002:a63:e22:: with SMTP id d34mr39562799pgl.251.1556297666002;
        Fri, 26 Apr 2019 09:54:26 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id j5sm7829721pfg.186.2019.04.26.09.54.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:54:25 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf 3/4] netfilter: nf_flow_table: check ttl value in flow offload data path
Date:   Sat, 27 Apr 2019 01:54:16 +0900
Message-Id: <20190426165416.3741-1-ap420073@gmail.com>
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

