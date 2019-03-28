Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F25C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 09:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E55722082F
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 09:47:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlAdO3Te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfC1Jr0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 05:47:26 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:33713 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfC1Jr0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 05:47:26 -0400
Received: by mail-yw1-f74.google.com with SMTP id p73so27796432ywp.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2019 02:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PrdnojL0zNQoe9yv6bzdApgTnVotyfhuA2MDCedM0dE=;
        b=hlAdO3TeMVPxzooaKuKsEVekuaCXHhfyyvGuIHlz2B/6YtkMEiLRfPye7rw9OqTFja
         soZOuzB4bgcYAQ/SfMjQORNcyATifHJ9/OANyUHstvFyc3cV1bltrVsSZRjkkJ9NaDn+
         QrZ12BjE7eLKbStjDw9A6rWz9YUMDB7qtNSZF4HAo2bBHMzEGSDWGZunL3jU4y3CJUAx
         UCnzvJtyIzphyNyrzo1SH7a7XfC5H7q4ktXtY0Q+AjHbvSvyyjneeJMP4m84Lc1Ae7xo
         AXjO6m5EK3dgNgDUr/61pugG98l6V3FDgrLh94rXHEjr6UZlFVjSWnvM4du6FZcNDz8b
         q1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PrdnojL0zNQoe9yv6bzdApgTnVotyfhuA2MDCedM0dE=;
        b=HH3YVn46IZZay+enw7cugPIErZ9f80MJ3R8vJsohNWASWfteO3z/X109woLCK6xxlt
         knf+wSOywa53wFSPJu18EdPdMfRc1MzpC2fJY7yfq+C/Tob+cloe6p2AIGuC1Ws/CtJG
         fc4B23saHn15GBaqboKZjOE/MHHZo4koIJzUjLX1IhRwm9IlGcjS+fNrr84hLrZF9Re+
         X5oBw8594PTOuFJPJ3nrq9Ed0DXxMtiiht4nF8wczPdT83sp/wYpJ8uC4WNsVE9RHHwH
         rmeELMTbghbXCp7xHL37vpFzyWEPVB4d43BKO97bKvX9uYYliM0euAukgKTj7QaCJ9B6
         TmKQ==
X-Gm-Message-State: APjAAAVmuAUJwEC8kccqf+9eBcvlzreJauubyCCAW3+EF79HEcN37JK6
        +shVMQ1fc9g+tR4CpunzewDYYITNUYI=
X-Google-Smtp-Source: APXvYqxsQ7En9OXB3LyGsmsuM8MZOWYtY2ZpjwLWX9XrpjsRZ/wdxttwh3R/gIsWXzHUaRf2l2sLb87EAaA=
X-Received: by 2002:a0d:cd81:: with SMTP id p123mr2208089ywd.13.1553766445230;
 Thu, 28 Mar 2019 02:47:25 -0700 (PDT)
Date:   Thu, 28 Mar 2019 10:47:20 +0100
Message-Id: <20190328094720.25399-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
Subject: [PATCH] netfilter: conntrack: initialize ct->timeout
From:   Alexander Potapenko <glider@google.com>
To:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, dvyukov@google.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

KMSAN started reporting an error when accessing ct->timeout for the
first time without initialization:

 BUG: KMSAN: uninit-value in __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
 ...
 dump_stack+0x173/0x1d0 lib/dump_stack.c:113
 kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:624
 __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
 __nf_ct_refresh_acct+0x1ae/0x470 net/netfilter/nf_conntrack_core.c:1765
 nf_ct_refresh_acct ./include/net/netfilter/nf_conntrack.h:201
 nf_conntrack_udp_packet+0xb44/0x1040 net/netfilter/nf_conntrack_proto_udp.c:122
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1605
 nf_conntrack_in+0x1250/0x26c9 net/netfilter/nf_conntrack_core.c:1696
 ...
 Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:205
 kmsan_internal_poison_shadow+0x92/0x150 mm/kmsan/kmsan.c:159
 kmsan_kmalloc+0xa9/0x130 mm/kmsan/kmsan_hooks.c:173
 kmem_cache_alloc+0x554/0xb10 mm/slub.c:2789
 __nf_conntrack_alloc+0x16f/0x690 net/netfilter/nf_conntrack_core.c:1342
 init_conntrack+0x6cb/0x2490 net/netfilter/nf_conntrack_core.c:1421

Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: cc16921351d8ba1 ("netfilter: conntrack: avoid same-timeout update")
Cc: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 82bfbeef46af..a137d4e7f218 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1350,6 +1350,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* save hash for reusing when confirming */
 	*(unsigned long *)(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode.pprev) = hash;
 	ct->status = 0;
+	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
 	memset(&ct->__nfct_init_offset[0], 0,
 	       offsetof(struct nf_conn, proto) -
-- 
2.21.0.392.gf8f6787159e-goog

