Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC315ECAAD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 05:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiHaFgi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 01:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaFgi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 01:36:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0083EA7237
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 22:36:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so1432388ybu.10
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 22:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=GgibhT2dRRWNW575v6h8h+/D9+WbqjmVF1FVldDjews=;
        b=OoWB/bhxMqSlKH9hS3a3TY1Lyt2CAX+qsZQkDDdxGp0B+fe+BbNkEtb4o55luQrY22
         rOtMoONrr3HPeIjQA5AQ+gO1c8FDX9WpCNVMYllXqlhHNTW9SmGJmtI+YHeLpZkHhpZw
         hVHJxTK79fy5GjIkpsWC7wuZrfz6rTAHPq3Ih1IeS91WZnNUfrGtbTG/uQpDqfUmobNf
         9Pf1jZT2YmNyExprRgyjHCeXTASGbLThCOinErtrEijSZUmrDKTWsx7aVq7bjZFZpXMH
         ADM1xgTku1x+U6ihGNd1PqOVNrdZkg2fh+jF1g37WA2iijPixPejDj18vRpH2WT30iOC
         SZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=GgibhT2dRRWNW575v6h8h+/D9+WbqjmVF1FVldDjews=;
        b=5ahWCFfDNtkgEhIq68CQVdrBfElY9iwYPWpnniiERw2xeAZ1RExQ+kPxoxX6rkeANh
         m0cYLDfeHzXnOGkq9Uu7SsgWujKuOfHQVpOjqEVlRqIaq140k1ChjgKQgx8kCuCsx2Fi
         WlCpOCEtzQMGiV0J3/6YF684w8zzUNDbYDJOmtNGyz9BuFGvnhVfaQIRzpq1ZxByHqU0
         pm1cPSTu2DocI4rGjpeb9jjBN9zZQ3P4l81+JxRnH/xUZdXGvJryIaBKoXltPNw0fT+Z
         6x6u6bGAsbjMszLkUPrTk3QZjDZL0amuta7GkVt4Yz8woQI6/bXHKfIvYZ7KL5mjgId7
         fe3g==
X-Gm-Message-State: ACgBeo07tFmXHXzUflVmVEXSG9+w5kgQotk56tTcJiGJnKNIt/joHY6I
        w2DtGc26bNhzXMpdymw1J4nRLB8AK9ERk+x/R2TtBmFaXwo8OGhbNfNhRqJRv8TE3sNf53XWs4g
        YqXIu5kFuWYe5XCCFZaB7Xu7Io3I6CWa6rRX1cBzPxACjIvVFeARUx6MrsKYsqBn4mnKjxxukws
        RGr3FFeQ==
X-Google-Smtp-Source: AA6agR6kGzdCnjGx4SIJDb4tpzXVAs/vqzaI4KeJLyYKWPlff+qByzelVOP1mDMTzVN1a3FqGzF/zIi80WmZsmg=
X-Received: from dolcetriade.mtv.corp.google.com ([2620:15c:124:202:d923:f530:815d:a2d5])
 (user=harshmodi job=sendgmr) by 2002:a0d:d952:0:b0:33d:c71e:c78d with SMTP id
 b79-20020a0dd952000000b0033dc71ec78dmr16685652ywe.269.1661924196187; Tue, 30
 Aug 2022 22:36:36 -0700 (PDT)
Date:   Tue, 30 Aug 2022 22:36:03 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831053603.4168395-1-harshmodi@google.com>
Subject: [PATCH bridge, v3] br_netfilter: Drop dst references before setting.
From:   Harsh Modi <harshmodi@google.com>
To:     netfilter-devel@vger.kernel.org
Cc:     harshmodi@google.com, sdf@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The IPv6 path already drops dst in the daddr changed case, but the IPv4
path does not. This change makes the two code paths consistent.

Further, it is possible that there is already a metadata_dst allocated from
ingress that might already be attached to skbuff->dst while following
the bridge path. If it is not released before setting a new
metadata_dst, it will be leaked. This is similar to what is done in
bpf_set_tunnel_key() or ip6_route_input().

It is important to note that the memory being leaked is not the dst
being set in the bridge code, but rather memory allocated from some
other code path that is not being freed correctly before the skb dst is
overwritten.

An example of the leakage fixed by this commit found using kmemleak:

unreferenced object 0xffff888010112b00 (size 256):
  comm "softirq", pid 0, jiffies 4294762496 (age 32.012s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 16 f1 83 ff ff ff ff  ................
    e1 4e f6 82 ff ff ff ff 00 00 00 00 00 00 00 00  .N..............
  backtrace:
    [<00000000d79567ea>] metadata_dst_alloc+0x1b/0xe0
    [<00000000be113e13>] udp_tun_rx_dst+0x174/0x1f0
    [<00000000a36848f4>] geneve_udp_encap_recv+0x350/0x7b0
    [<00000000d4afb476>] udp_queue_rcv_one_skb+0x380/0x560
    [<00000000ac064aea>] udp_unicast_rcv_skb+0x75/0x90
    [<000000009a8ee8c5>] ip_protocol_deliver_rcu+0xd8/0x230
    [<00000000ef4980bb>] ip_local_deliver_finish+0x7a/0xa0
    [<00000000d7533c8c>] __netif_receive_skb_one_core+0x89/0xa0
    [<00000000a879497d>] process_backlog+0x93/0x190
    [<00000000e41ade9f>] __napi_poll+0x28/0x170
    [<00000000b4c0906b>] net_rx_action+0x14f/0x2a0
    [<00000000b20dd5d4>] __do_softirq+0xf4/0x305
    [<000000003a7d7e15>] __irq_exit_rcu+0xc3/0x140
    [<00000000968d39a2>] sysvec_apic_timer_interrupt+0x9e/0xc0
    [<000000009e920794>] asm_sysvec_apic_timer_interrupt+0x16/0x20
    [<000000008942add0>] native_safe_halt+0x13/0x20

Signed-off-by: Harsh Modi <harshmodi@google.com>
---
 net/bridge/br_netfilter_hooks.c | 2 ++
 net/bridge/br_netfilter_ipv6.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index ff4779036649..f20f4373ff40 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -384,6 +384,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -413,6 +414,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e4e0c836c3f5..6b07f30675bb 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -197,6 +197,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
-- 
2.37.2.672.g94769d06f0-goog

