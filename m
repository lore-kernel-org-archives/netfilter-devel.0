Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E6BECE58C
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 16:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 084AD2067B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 16:19:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EUnGVRCq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfJIQTT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:19:19 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:50589 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbfJIQTT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 12:19:19 -0400
Received: by mail-pl1-f202.google.com with SMTP id y13so1785676plr.17
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2019 09:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FFXVGfca53SiSL7HqaRqfk9Hg68uxc6K6z/nepNQII8=;
        b=EUnGVRCqYymy2Sq/LMdSpcx2rxJHRSnPqmH66R3NvRjfhqeNWd/S3XXFRMMlN+cqu6
         uA29QA1U+xgIRZuJUKxptgvtaMI6bHHD1hya6aoUJmLqMLBETjuOaTaHj5yD3RMiq9HF
         NIzyJR25Jc1ld2cM6+aAV6z8WCQy0aVRr/lI/XIY7LqQ19rcGel9CCKSUXCHY+ln2r3Z
         C0sUp9KwNN7AT7KyyMyqn0nTIkHKrEzMlM/eKLaMwvRWP/xDr1CVpR7wy30vKuaP0968
         Wy+Cv41M5KDhd7uZYs1qVfTqtYkfoaBv6wEKidX1kHVey6FoXvaxFbok1w93KNYiMYP8
         MpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FFXVGfca53SiSL7HqaRqfk9Hg68uxc6K6z/nepNQII8=;
        b=KPju8bb/FUq1sdJHOwK9gNVukzvgbRdl+fa+/qlV/+dvXrwW2Cxt19P9MC+XLQYeuZ
         B+CBduPUBK/1mF7VrS/1MKdZnzPVLZ+Kl/2pMABDsTl0qzJxc5Q4htDLzNS5pk1t0Hc+
         ttEPIGadJYYxGP0psREdiHXkNqOfZEm+pjnKwMNRZAifbfmuZ9dg8E4lcV6eGS6FgpNU
         1C6+hqDAbVxtxT281trmNLYd86Kmvo4T9y5oPAzOxKp0/s7Nt5sz7etW7o/HErJwYYj4
         4xVIO+4rnlgmZTstBx4m2PGP3F4b7ad8t3N4X59/uQ7uMR16C+e3EmtEWZHodAHf2z/H
         vSHQ==
X-Gm-Message-State: APjAAAXtW8xGobWRKlddKShqOLWrLHX5DhaKBz554q1bIcJTlSuKbbbj
        SoIllDA8l4GKKA2vfFuXnmRFrybjMtUUzg==
X-Google-Smtp-Source: APXvYqwmU1FFrtv+wXrGnf2TMoVSzSEk1J5FQ8b5ObV2cM7Fn1mzSuNLKCS5Hik7xTV07sHREOLf9tgFXkN9BQ==
X-Received: by 2002:a63:ff1c:: with SMTP id k28mr5277749pgi.281.1570637956834;
 Wed, 09 Oct 2019 09:19:16 -0700 (PDT)
Date:   Wed,  9 Oct 2019 09:19:13 -0700
Message-Id: <20191009161913.18600-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] netfilter: conntrack: avoid possible false sharing
From:   Eric Dumazet <edumazet@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As hinted by KCSAN, we need at least one READ_ONCE()
to prevent a compiler optimization.

More details on :
https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance

sysbot report :
BUG: KCSAN: data-race in __nf_ct_refresh_acct / __nf_ct_refresh_acct

read to 0xffff888123eb4f08 of 4 bytes by interrupt on cpu 0:
 __nf_ct_refresh_acct+0xd4/0x1b0 net/netfilter/nf_conntrack_core.c:1796
 nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
 nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
 nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
 ipv4_conntrack_in+0x27/0x40 net/netfilter/nf_conntrack_proto.c:178
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 ip_rcv+0x12f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
 napi_skb_finish net/core/dev.c:5671 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x436/0x7d0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6352 [inline]
 net_rx_action+0x3ae/0xa50 net/core/dev.c:6418
 __do_softirq+0x115/0x33f kernel/softirq.c:292

write to 0xffff888123eb4f08 of 4 bytes by task 7191 on cpu 1:
 __nf_ct_refresh_acct+0xfb/0x1b0 net/netfilter/nf_conntrack_core.c:1797
 nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
 nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
 nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
 nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
 ipv4_conntrack_local+0xbe/0x130 net/netfilter/nf_conntrack_proto.c:200
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 __ip_local_out+0x1f7/0x2b0 net/ipv4/ip_output.c:114
 ip_local_out+0x31/0x90 net/ipv4/ip_output.c:123
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:236
 __tcp_transmit_skb+0xdeb/0x1cd0 net/ipv4/tcp_output.c:1158
 __tcp_send_ack+0x246/0x300 net/ipv4/tcp_output.c:3685
 tcp_send_ack+0x34/0x40 net/ipv4/tcp_output.c:3691
 tcp_cleanup_rbuf+0x130/0x360 net/ipv4/tcp.c:1575

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7191 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120b2db2e1ea9983a6b1ce8d2aefebc29501..5cd610b547e0d1e3463a65ba3627f265c836bdc5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1792,8 +1792,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		extra_jiffies += nfct_time_stamp;
 
-	if (ct->timeout != extra_jiffies)
-		ct->timeout = extra_jiffies;
+	if (READ_ONCE(ct->timeout) != extra_jiffies)
+		WRITE_ONCE(ct->timeout, extra_jiffies);
 acct:
 	if (do_acct)
 		nf_ct_acct_update(ct, ctinfo, skb->len);
-- 
2.23.0.581.g78d2f28ef7-goog

