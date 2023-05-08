Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33B2C77B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 03:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjEHDPA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 May 2023 23:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjEHDO7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2023 23:14:59 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441277EF5
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 20:14:58 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2ac785015d6so43926011fa.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 May 2023 20:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683515696; x=1686107696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbJduYgF7YJEuUTzpAoy9Z4HUMvLrdUs98l6wH9u04g=;
        b=kED1UqgMXPiE3l9s3YfbB5mrIB5UKn7CgIG17BBoWwu2uwt7hL+6hG+fW9rkvCmRB7
         kf2WHN4mxU56jsMp9oJhhILqpTThRovmIYOPGlKOZVxVfU5UONVQBf7bZCedgfLmlwzq
         EEQ8jfxV8/bKJ0TxQm2symqesxoDRKbY2MNfFiyqkc4u1Yn5T6aL4mzhXRcPDNd9oQ+l
         GnHAwf+i+IbcpIgcxuH4kpFfiGbaTfmTeQjR4KkTDfsMS7bNJl6x8IeKgNY/WHB1ORuA
         84ptNugzkAggHD7Fsm2TFUIBKF81sJAdmxoZSOIhzqjveGuMUi/n4GK8UfXsuY+GkyKY
         jYrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683515696; x=1686107696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbJduYgF7YJEuUTzpAoy9Z4HUMvLrdUs98l6wH9u04g=;
        b=XkomQ+dLIyiJZV13QDPHE99ECfDci7IJkeIH3Xh22egH+F3qz+dEHOkUtYoqIW+N9g
         zSj+4jNo7YbDUATtHowh9SkkC7galgNGNOqD1Jgjg0HwmeE0lBHiUXlDbfq8NaZ4lZJ4
         oASufTapmOZQpdKT7PQn/PT64WxUD+ZY4hMEltXmDU9a6NDmAzuf61pTo3hID17TwZ/q
         aeyTV3p1IfQGvNDJMZbIf++xdec6SnCETbdV+w1ehoUGJnItPPM4vbqUx5r8KuiwbfgO
         rsFMWUrXnU9D74HYRO4dqni5zQYD67TaxnhptZvH9F3NierBynD5pK8hcGOVGzkLWL+o
         Z3mg==
X-Gm-Message-State: AC+VfDwZj7NHp2MSQUlNiuDsr/1YFPRzhzCAT6+aTDICr60Eu1DhkdD0
        3TKxdzTSiDiiTZQUXXx7tEhq41BFOA==
X-Google-Smtp-Source: ACHHUZ6Gg3OzdDlDaZUvQfZIWjk1IXKNISxNB9ZBsa6DiYcDZKxD4i4MNk2ISrCrRixhNANjNLLGbw==
X-Received: by 2002:a2e:b6c6:0:b0:2ab:4399:708b with SMTP id m6-20020a2eb6c6000000b002ab4399708bmr2342967ljo.40.1683515696413;
        Sun, 07 May 2023 20:14:56 -0700 (PDT)
Received: from localhost.localdomain (77-254-67-144.adsl.inetia.pl. [77.254.67.144])
        by smtp.gmail.com with ESMTPSA id j14-20020a2eb70e000000b002a8a77f4d03sm1018850ljo.59.2023.05.07.20.14.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 May 2023 20:14:55 -0700 (PDT)
From:   Patryk Sondej <patryk.sondej@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     eric_sage@apple.com, Patryk Sondej <patryk.sondej@gmail.com>
Subject: [PATCH 1/2] netfilter: nfnetlink_log: enable cgroup id socket info retrieval
Date:   Mon,  8 May 2023 05:14:24 +0200
Message-Id: <20230508031424.55383-2-patryk.sondej@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230508031424.55383-1-patryk.sondej@gmail.com>
References: <20230508031424.55383-1-patryk.sondej@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This enables associating a socket with a v2 cgroup. Useful processing
packets in userspace.

Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
---
 include/uapi/linux/netfilter/nfnetlink_log.h |  2 ++
 net/netfilter/nfnetlink_log.c                | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 0af9c113d665..5f4500e1c28c 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -65,6 +65,8 @@ enum nfulnl_attr_type {
 	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
 	NFULA_VLAN,			/* nested attribute: packet vlan info */
 	NFULA_L2HDR,			/* full L2 header */
+	NFULA_CGROUP_ID,		/* __u64 cgroup2 id of socket */
+	NFULA_PAD,			/* 64bit padding */
 
 	__NFULA_MAX
 };
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e57eb168ee13..5d11d070ad24 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/cgroup.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_log.h>
 #include <net/netns/generic.h>
@@ -628,6 +629,15 @@ __build_packet_message(struct nfnl_log_net *log,
 			read_unlock_bh(&sk->sk_callback_lock);
 	}
 
+#if IS_ENABLED(CONFIG_SOCK_CGROUP_DATA)
+	/* cgroup2 */
+	if (sk && sk_fullsock(sk)) {
+		struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+		if(cgrp && nla_put_be64(inst->skb, NFULA_CGROUP_ID, cpu_to_be64(cgroup_id(cgrp)), NFULA_PAD))
+			goto nla_put_failure;
+	}
+#endif
+
 	/* local sequence number */
 	if ((inst->flags & NFULNL_CFG_F_SEQ) &&
 	    nla_put_be32(inst->skb, NFULA_SEQ, htonl(inst->seq++)))
@@ -729,6 +739,9 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(u_int32_t))	/* mark */
 		+ nla_total_size(sizeof(u_int32_t))	/* uid */
 		+ nla_total_size(sizeof(u_int32_t))	/* gid */
+#if IS_ENABLED(CONFIG_SOCK_CGROUP_DATA)
+		+ nla_total_size(sizeof(u_int64_t))	/* cgroup2 id */
+#endif
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
-- 
2.37.1 (Apple Git-137.1)

