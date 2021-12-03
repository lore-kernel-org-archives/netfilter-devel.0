Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EBFC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Dec 2021 09:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhLCJb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 04:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbhLCJb5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 04:31:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BD6C06173E
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Dec 2021 01:28:33 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 200so2488354pga.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Dec 2021 01:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RrjRmgt5na89c2+EyJI2+/ANNxyF860Eq49/iXGbZ5Q=;
        b=Eq4vdj328Ppypw0aSzfDjW9CexBZ22s54zs2xm+ey15zU131lU8yDBWhAxWOgbG6Li
         MyXg0jnFd3IIU1XUZSzN1hdclYv0yGZiXHaiKvVDxZPDulNZjo0/G9pdGppQD0RDUQCE
         Iudspvq04Z1djOExqnA4NC2gkMWQ2iCvRfACs5C8rBlE0pmcBMy5rduljcTjo9J4jDbu
         m97TCperNEBHP1HcqMxHyH5mGkR4RjHli9AKx7JWMKz73IB53maRO+l8RU/YBw2OC14y
         QXarMz+uJeIUM7LzFA6LTejUcHk7ANVgV3E4aofO5KgKJFx6KfmhzeN7nQ73evXK+N50
         bP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RrjRmgt5na89c2+EyJI2+/ANNxyF860Eq49/iXGbZ5Q=;
        b=wclPUHN6nTvxfSxaUndz2mTLbTetbbRASamY6DljJ8lqAnWLaT3Tj02HzZregeZmrm
         jKNC2FEpQIEGNyRZwrL8nZSDi5Fy0evRSIqXM66K8BvfWqn7KwhJ1ssYzW4yxQ30D90w
         4A2PnEO2EI6VExonMfD8+GyAb7PGq4z7bdLdEF/plUAZuRxZ1fBlb8PB1xLLrVxYYslm
         JwgYlx2+Fy6D4RAjVjW/MTcU4p+w5wu/67lfUiPf4ke3+ksw8EgI9Ll1SgPaXXx9rtzW
         hkW1FY65GcF3EaUdaAK4cdNvViNtKOzq3pmqcU7LmIptHqARUAKM4blvErfsYwI155u5
         UjzA==
X-Gm-Message-State: AOAM531L9P9PnJMoEvv+PUyRu/0G995qo+HMJa9RD0fsp9q7uZJUf4ch
        KVq+XFIUWFq6kXWLNzv0k/E=
X-Google-Smtp-Source: ABdhPJyVBe0ZOgUGP6M/Id9q2iFDqkNFT2W/AhT2MYCQa3UAk/ZV5P1bO7YWUZ1uH5QhZ+Bw/iFj5w==
X-Received: by 2002:a05:6a00:1a04:b0:4a0:6e3:27b3 with SMTP id g4-20020a056a001a0400b004a006e327b3mr18056517pfv.24.1638523713367;
        Fri, 03 Dec 2021 01:28:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f21sm2928342pfc.85.2021.12.03.01.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 01:28:33 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     xu.xin16@zte.com.cn, pablo@netfilter.org,
        herbert@gondor.apana.org.au, horms@verge.net.au,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        alex.aring@gmail.com
Subject: [RFC PATCH v2] net: Enable some sysctls for the userns root
Date:   Fri,  3 Dec 2021 09:28:28 +0000
Message-Id: <3048f2216253fd6eafcf2e9f46d464d65d1c87bb.1638521705.git.xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

Enabled sysctls include the following changes:
1. net/ipv4/neigh/<if>/*
2. net/ipv6/neigh/<if>/*
3. net/ieee802154/6lowpan/*
4. net/ipv6/route/*
6. net/ipv4/vs/*
7. net/unix/*
8. net/core/xfrm_*

In some scenarios, some userns root have needs to adjust these sysctls
such as sysctls of neighbor in their own netns, but limited just because
they are not init user_ns.

The newly created user namespace OWNS the net namespace, So the root
user inside the user namespace should have rights to access these net
namespace resources.

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 net/core/neighbour.c                | 4 ----
 net/ieee802154/6lowpan/reassembly.c | 4 ----
 net/ipv6/route.c                    | 4 ----
 net/netfilter/ipvs/ip_vs_ctl.c      | 4 ----
 net/netfilter/ipvs/ip_vs_lblc.c     | 4 ----
 net/netfilter/ipvs/ip_vs_lblcr.c    | 3 ---
 net/unix/sysctl_net_unix.c          | 4 ----
 net/xfrm/xfrm_sysctl.c              | 4 ----
 8 files changed, 31 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 0cdd4d9ad942..44d90cc341ea 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3771,10 +3771,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 			neigh_proc_base_reachable_time;
 	}
 
-	/* Don't export sysctls to unprivileged users */
-	if (neigh_parms_net(p)->user_ns != &init_user_ns)
-		t->neigh_vars[0].procname = NULL;
-
 	switch (neigh_parms_family(p)) {
 	case AF_INET:
 	      p_name = "ipv4";
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index be6f06adefe0..89cbad6d8368 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -366,10 +366,6 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 				GFP_KERNEL);
 		if (table == NULL)
 			goto err_alloc;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			table[0].procname = NULL;
 	}
 
 	table[0].data	= &ieee802154_lowpan->fqdir->high_thresh;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f0d29fcb2094..6a0b15d6500e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6409,10 +6409,6 @@ struct ctl_table * __net_init ipv6_route_sysctl_init(struct net *net)
 		table[8].data = &net->ipv6.sysctl.ip6_rt_min_advmss;
 		table[9].data = &net->ipv6.sysctl.ip6_rt_gc_min_interval;
 		table[10].data = &net->ipv6.sysctl.skip_notify_on_dev_down;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			table[1].procname = NULL;
 	}
 
 	return table;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7f645328b47f..a77c8abf2fc7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4040,10 +4040,6 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 		tbl = kmemdup(vs_vars, sizeof(vs_vars), GFP_KERNEL);
 		if (tbl == NULL)
 			return -ENOMEM;
-
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			tbl[0].procname = NULL;
 	} else
 		tbl = vs_vars;
 	/* Initialize sysctl defaults */
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 7ac7473e3804..567ba33fa5b4 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -561,10 +561,6 @@ static int __net_init __ip_vs_lblc_init(struct net *net)
 		if (ipvs->lblc_ctl_table == NULL)
 			return -ENOMEM;
 
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			ipvs->lblc_ctl_table[0].procname = NULL;
-
 	} else
 		ipvs->lblc_ctl_table = vs_vars_table;
 	ipvs->sysctl_lblc_expiration = DEFAULT_EXPIRATION;
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 77c323c36a88..a58440a7bf9e 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -747,9 +747,6 @@ static int __net_init __ip_vs_lblcr_init(struct net *net)
 		if (ipvs->lblcr_ctl_table == NULL)
 			return -ENOMEM;
 
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			ipvs->lblcr_ctl_table[0].procname = NULL;
 	} else
 		ipvs->lblcr_ctl_table = vs_vars_table;
 	ipvs->sysctl_lblcr_expiration = DEFAULT_EXPIRATION;
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index c09bea89151b..01d44e2598e2 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -30,10 +30,6 @@ int __net_init unix_sysctl_register(struct net *net)
 	if (table == NULL)
 		goto err_alloc;
 
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
 	table[0].data = &net->unx.sysctl_max_dgram_qlen;
 	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
 	if (net->unx.ctl == NULL)
diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
index 0c6c5ef65f9d..a9b7723eb88f 100644
--- a/net/xfrm/xfrm_sysctl.c
+++ b/net/xfrm/xfrm_sysctl.c
@@ -55,10 +55,6 @@ int __net_init xfrm_sysctl_init(struct net *net)
 	table[2].data = &net->xfrm.sysctl_larval_drop;
 	table[3].data = &net->xfrm.sysctl_acq_expires;
 
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns != &init_user_ns)
-		table[0].procname = NULL;
-
 	net->xfrm.sysctl_hdr = register_net_sysctl(net, "net/core", table);
 	if (!net->xfrm.sysctl_hdr)
 		goto out_register;
-- 
2.25.1

