Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5A8C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 16:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966702084F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 16:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jB2UkAAD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfCKQSw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 12:18:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35978 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfCKQSv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 12:18:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id j125so4935592wmj.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 09:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l8CFE7I7U3ylhXAuZk5H3zaljuSQPrY0TuBPgXuwitk=;
        b=jB2UkAADMkKuJDH6SYZe6ktHTchm7NnH6AtGcvzYZa2bbqImKDAweHqKjTaalhF+6B
         E3xUe86RuGDDncyu6KmPQG5BISJm8FN4le3SH8ol1o5BM8hQvppa5d2mc4zwl4O410B3
         0n5xfE9NVHetoiDncgImcbJXC5G6ngu4JRlJ4DBWIxgPwykjqAZcDdFeciHEci30qXjn
         7hFuy1qGq0jmAaynNKK2KqhVvVn4HdvvfDDBn2bHU3ZRQ3VVv+jGyRyv9eCOMuem8vIj
         JYLNvkK7zSyabiS2y3kM4gKz8+dgvoSHNx41ARYSy07HYHUaAyRt60jk1JwxlDQCbKqp
         6ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l8CFE7I7U3ylhXAuZk5H3zaljuSQPrY0TuBPgXuwitk=;
        b=NmLuNvxHF5CRQOSmr5pxE9HuShPKOXBPEFuOOcMitZPjhVK7Y5kk0/pCzv7OZKIWB4
         9jCSWxa23JOCZ6q3eVyJNR/1gOgFIhTHpcIZk/17V6oBPJgleDqNTbIuod37arQA+PcQ
         3hxhohJ/H42pqk9QvZomiKkGEVQbDGkv9uUIe8dAyUbPeVCTtscMgGx1vikeW3urotWU
         SDS5Epyb9C5+a7WtSQnwD5iAh3x+07V1zh9Tasc3kkSNvpd5g/HO8dtPzGtgs00ojC+g
         65ojzQw3g1lLtHYghfVgOUjvBac21LfkffCCmo/1n0elG2GmtZBwkoDwbQXHrNOqEBlC
         g8EA==
X-Gm-Message-State: APjAAAUH0BXg/wrILAym/7LEsQa44v3iFpZK0sNXaVLXl69q/hSW1GK1
        nOA3FIdBAs9hjLESIdFGoQJZEy1P
X-Google-Smtp-Source: APXvYqyKsUtloddxfy5u7WSc0Nmy4YGfLQ1EeKJ5jnUu5c/HPbqqW4UIt8U8PwnPML++v5E0TaHWdQ==
X-Received: by 2002:a1c:230e:: with SMTP id j14mr347633wmj.9.1552321129086;
        Mon, 11 Mar 2019 09:18:49 -0700 (PDT)
Received: from cplx1037.edegem.eu.thmulti.com ([2001:4158:f012:230:2a10:7bff:fec5:6f08])
        by smtp.gmail.com with ESMTPSA id l130sm18923274wmf.13.2019.03.11.09.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Mar 2019 09:18:48 -0700 (PDT)
From:   Alin Nastac <alin.nastac@gmail.com>
X-Google-Original-From: Alin Nastac <alin.nastac@technicolor.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_sip: remove direct dependency on IPv6
Date:   Mon, 11 Mar 2019 17:18:42 +0100
Message-Id: <1552321122-23626-1-git-send-email-alin.nastac@technicolor.com>
X-Mailer: git-send-email 2.7.4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

Previous implementation was not usable with CONFIG_IPV6=m.

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f067c6b..39fcc1e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -20,9 +20,9 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
 
-#include <net/route.h>
-#include <net/ip6_route.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -871,38 +871,33 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
 		struct net *net = dev_net(dev);
-		struct rtable *rt;
-		struct flowi4 fl4 = {};
-#if IS_ENABLED(CONFIG_IPV6)
-		struct flowi6 fl6 = {};
-#endif
+		struct flowi fl;
 		struct dst_entry *dst = NULL;
 
+		memset(&fl, 0, sizeof(fl));
+
 		switch (nf_ct_l3num(ct)) {
 			case NFPROTO_IPV4:
-				fl4.daddr = daddr->ip;
-				rt = ip_route_output_key(net, &fl4);
-				if (!IS_ERR(rt))
-					dst = &rt->dst;
+				fl.u.ip4.daddr = daddr->ip;
+				nf_ip_route(net, &dst, &fl, false);
 				break;
 
-#if IS_ENABLED(CONFIG_IPV6)
 			case NFPROTO_IPV6:
-				fl6.daddr = daddr->in6;
-				dst = ip6_route_output(net, NULL, &fl6);
-				if (dst->error) {
-					dst_release(dst);
-					dst = NULL;
-				}
+				fl.u.ip6.daddr = daddr->in6;
+				nf_ip6_route(net, &dst, &fl, false);
 				break;
-#endif
 		}
 
 		/* Don't predict any conntracks when media endpoint is reachable
 		 * through the same interface as the signalling peer.
 		 */
-		if (dst && dst->dev == dev)
-			return NF_ACCEPT;
+		if (dst) {
+			bool external_media = (dst->dev == dev);
+
+			dst_release(dst);
+			if (external_media)
+				return NF_ACCEPT;
+		}
 	}
 
 	/* We need to check whether the registration exists before attempting
-- 
2.7.4

