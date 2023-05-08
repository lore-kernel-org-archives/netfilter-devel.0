Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECB2C77B75
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 03:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjEHDPD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 May 2023 23:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjEHDPB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2023 23:15:01 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73377EE3
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 20:14:59 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2ac8c0fbb16so29819571fa.2
        for <netfilter-devel@vger.kernel.org>; Sun, 07 May 2023 20:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683515698; x=1686107698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HgADu5aECiZ7xPmm6/GH32z65pbt6re30In465DSTfo=;
        b=YtbUWLcNs61WpUC5uUVBFEWZc5rRZZhqz5WwyW+tF3Y457rhyK2YNEUo/plJkIwwi1
         Gv59vzCq5Pe5vDMcBPBK3r/Iah32hhgC7JfFyJcvt96Zm+swnYcFyG6fo+ltrgG2gCBk
         3B8Fb493qbGz69/dn9azOP1oNeLQQ5o+nshVPpX5VqR1DMe4zdImp6dolq3BxPAZ8GqC
         3bIDk5atMKdbExHnd8rBzQ7oV7WjzdVYKy2bnlNjNMNZQ/YvV5XrtxOqe+VyFVaMJPoS
         olFdGaOU0t+iOzkR2mLFH9sCHEbnTIrSEhfW6N3WetGtuC2Mt9rc9dMvSoV8U6VyPAEz
         LA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683515698; x=1686107698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HgADu5aECiZ7xPmm6/GH32z65pbt6re30In465DSTfo=;
        b=LS47+4Pgf6lUBYzV3kpRM5NuGZTA2bjLaR62I/HZhNbuDcA3BemmEG9PkXXbSJTTSb
         fHxhOphW54eq3K4JbmAkk3w/FNojlLuhUqYEvnHYIEZAr+TNqXedgJCniO8W8brNCrKw
         n+aXpIHPcolMhLu0IRB2K/3YKwcuJEZy8N9EYBcU7ukywnDfbIqVjMLJH9LFILUB4V84
         kyKgv8LJJTKPI3E82j/IyWd+WRkrgqcSUxbM3I12MqcQAGPgcmDdawCa3KA3S3nc+M0L
         7AQWZpbEK1bPdHjXDH/53DO0XDts4Bz8Ni8623OxGgmYQJonaXUB5xsSgludNoUPzYU8
         LaZA==
X-Gm-Message-State: AC+VfDwHwR7SuFtX+b6xaObzey5pkJDTpSEPYIZvSre6AvXKP6todz9e
        TvKkdmB0CWXxu6WthRepJ4e12Vyksw==
X-Google-Smtp-Source: ACHHUZ5+kKIAppvg10khshK/L7XHyeh8usmjH8AVRNDleDX1BQF/2tedLNs7jjIuak0oK+kqukzMXQ==
X-Received: by 2002:a2e:82c3:0:b0:2ac:8000:1ea0 with SMTP id n3-20020a2e82c3000000b002ac80001ea0mr2693286ljh.26.1683515698195;
        Sun, 07 May 2023 20:14:58 -0700 (PDT)
Received: from localhost.localdomain (77-254-67-144.adsl.inetia.pl. [77.254.67.144])
        by smtp.gmail.com with ESMTPSA id j14-20020a2eb70e000000b002a8a77f4d03sm1018850ljo.59.2023.05.07.20.14.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 May 2023 20:14:57 -0700 (PDT)
From:   Patryk Sondej <patryk.sondej@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     eric_sage@apple.com, Patryk Sondej <patryk.sondej@gmail.com>
Subject: [PATCH 2/2] netfilter: nfnetlink_queue: enable cgroup id socket info retrieval
Date:   Mon,  8 May 2023 05:14:25 +0200
Message-Id: <20230508031424.55383-3-patryk.sondej@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230508031424.55383-1-patryk.sondej@gmail.com>
References: <20230508031424.55383-1-patryk.sondej@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables associating a socket with a v2 cgroup. Useful for
applying a per-cgroup policy when processing packets in userspace.

Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
---
 .../uapi/linux/netfilter/nfnetlink_queue.h    |  2 ++
 net/netfilter/nfnetlink_queue.c               | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index efcb7c044a74..681c02290d39 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -63,6 +63,8 @@ enum nfqnl_attr_type {
 	NFQA_L2HDR,			/* full L2 header */
 	NFQA_PRIORITY,			/* skb->priority */
 	NFQA_CGROUP_CLASSID,		/* __u32 cgroup classid */
+	NFQA_CGROUP_ID,			/* __u64 cgroup2 id of socket */
+	NFQA_PAD,			/* 64bit padding */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e311462f6d98..c9c473d523c5 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -30,6 +30,7 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
 #include <linux/cgroup-defs.h>
+#include <linux/cgroup.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
@@ -302,6 +303,18 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
+static int nfqnl_put_sk_cgroupid(struct sk_buff *skb, struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_SOCK_CGROUP_DATA)
+	if (sk && sk_fullsock(sk)) {
+		struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+		if (cgrp && nla_put_be64(inst->skb, NFQA_CGROUP_ID, cpu_to_be64(cgroup_id(cgrp)), NFQA_PAD))
+			return -1;
+	}
+#endif
+	return 0;
+}
+
 static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
@@ -420,6 +433,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
+#if IS_ENABLED(CONFIG_SOCK_CGROUP_DATA)
+		+ nla_total_size(sizeof(u_int64_t))	/* cgroup2 id */
+#endif
 #if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
 		+ nla_total_size(sizeof(u_int32_t))	/* classid */
 #endif
@@ -616,6 +632,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (nfqnl_put_sk_cgroupid(skb, entskb->sk) < 0)
+		goto nla_put_failure;
+
 	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-- 
2.37.1 (Apple Git-137.1)

