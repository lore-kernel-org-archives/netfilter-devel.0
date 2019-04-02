Return-Path: <SRS0=UyK1=SE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB397C10F00
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 12:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8013720883
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 12:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLlcVD0t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbfDBM45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 08:56:57 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:53908 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbfDBM44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 08:56:56 -0400
Received: by mail-it1-f196.google.com with SMTP id y204so4848309itf.3;
        Tue, 02 Apr 2019 05:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UXcY3+LQuritg/1xQjWkFlbv9Xw0iZ9vOAGOhx2mF2c=;
        b=QLlcVD0tgGVoQTJwlyV4nMg3eG6Kn57gTZrRNhMPh8H1StL69Toc9DvkleKV9pUFts
         XfPV+hR8onhDGzMAxrhpm+9YfZHHa3BiJDxSt+w8zv/2VVqF4N668XYTmp25VLw63IBj
         tqeyYMCswQeIROwJtVjIExeEQG/M6dSAkJqVpEKUz8AgfQsutMkE2Qw0Y6XksSmmfPjx
         NJGdZ4sz/ZexQdikNhS31LXWu+cs3qBhiSNUpJoHUlY9sE6doDnJvckbv95ep4ZmOrVH
         T+3Jknpn64bjSmVPSNYnS9yXxGcBoQFBE6TqY3MjDKDmJfnmeb893PVDOUYdI1Bq3o1o
         hEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UXcY3+LQuritg/1xQjWkFlbv9Xw0iZ9vOAGOhx2mF2c=;
        b=YCJjCNjC7KQNDpI2NGkztRZc2j1669UCJkfsErDB/wUoPQ+9qU7Cya5LjjgE9hxcDY
         vDg34E3trAO0bsxEAnq/VI3IOpj9LU9uTXdw1F2Jj+i2a1efTVRp11cjyu57qlUAiYtX
         lfU8fZXZDV76veA04KPGGdGaT3HA6mgTb3XnEZbV3Om5m0gvdeSVuKkvIln91JWCzo7Y
         x+gwZ6aDU8hy4iOjPDTee0ujr4kAuiO/aqOXxPsK5J1Bku/KdwQFVZQ4nLF4YM8ictAQ
         wKjKfeO1EenXdnv5fN6V/BX+HcYKztb/xdr7jRNji5xvXCOySo4y/QpfvLtfuhux0FjA
         ctbw==
X-Gm-Message-State: APjAAAWFF+r+Q/R6Ec3luIxvxzc9aLtrufOk/vDD7fby9yTUs3fOIHHR
        7qoqmooH+m1Vn2CfWOFELw==
X-Google-Smtp-Source: APXvYqzjsQD9eQEAgsVD0F9wwBU0pOOGihJo/94I6vN4xMPDGsfMVuTpLhhKI986D+lFJpxKwMW/iw==
X-Received: by 2002:a24:59c1:: with SMTP id p184mr20168itb.158.1554209815462;
        Tue, 02 Apr 2019 05:56:55 -0700 (PDT)
Received: from ip-172-31-35-247.us-east-2.compute.internal (ec2-52-15-165-154.us-east-2.compute.amazonaws.com. [52.15.165.154])
        by smtp.gmail.com with ESMTPSA id x25sm5744948ioh.63.2019.04.02.05.56.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 05:56:54 -0700 (PDT)
From:   Rundong Ge <rdong.ge@gmail.com>
To:     pablo@netfilter.org
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdong.ge@gmail.com
Subject: [PATCH] netfilter:bridge: Hold bridge dev for fake_rtable to avoid  the dangling pointer
Date:   Tue,  2 Apr 2019 12:56:09 +0000
Message-Id: <20190402125609.30313-1-rdong.ge@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Problem:
When bridge-nf-call-iptables is enabled, skb_dst(skb) of packets that
in the nfqueue may be a dangling pointer if user delete the bridge.
Because packets go through the br_nf_pre_routing_finish will set the dst
pointer to the br->fake_rtable. But the br struct will be freed
without the reference check for these skbs.

User impact:
Kernel panic may happen when user delete the bridge if there are
continuous traffics go through the nfqueue.
Here is a panic in my device which using kernel v3.10.

general protection fault: 0000 1 SMP
task: ffff880158418000 ti: ffff88011aeec000 task.ti: ffff88011aeec000
RIP: 0010:[<ffffffff8133a83f>] [<ffffffff8133a83f>]
 __percpu_counter_add+0xf/0x70
RSP: 0000:ffff88017fc83e20 EFLAGS: 00010206
RAX: ffff88011aeeffd8 RBX: ff0b900200000080 RCX: ffff88017fc901a0
RDX: 0000000000000020 RSI: ffffffffffffffff RDI: ff0b900200000080
RBP: ffff88017fc83e38 R08: ffff88015b5b1100 R09: ffff88017fc901a0
R10: 0000000000000000 R11: ffff88017fc83da0 R12: 0000000bfd80400a
R13: ffffffffffffffff R14: 0000000000000000 R15: ffff88017fc901c0
FS: 00007fcfe17d2700(0000) GS:ffff88017fc80000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa3fbdf0ec0 CR3: 0000000159eba000 CR4: 00000000003407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
ffff88015b5b1100 0000000bfd80400a ff0b900200000000 ffff88017fc83e60
ffffffff8157be3a ffffffff81a3a580 000000000000000a 0000000000000000
ffff88017fc83e70 ffffffff8157c0be ffff88017fc83ed0 ffffffff8113977d
Call Trace:
<IRQ>
[<ffffffff8157be3a>] dst_destroy+0xfa/0x120
[<ffffffff8157c0be>] dst_destroy_rcu+0xe/0x20
[<ffffffff8113977d>] rcu_process_callbacks+0x1dd/0x550
[<ffffffff8108f2cf>] __do_softirq+0xef/0x280
[<ffffffff816b1adc>] call_softirq+0x1c/0x30
[<ffffffff8102d365>] do_softirq+0x65/0xa0
[<ffffffff8108f665>] irq_exit+0x115/0x120
[<ffffffff816b2755>] smp_apic_timer_interrupt+0x45/0x60
[<ffffffff816b0c9d>] apic_timer_interrupt+0x6d/0x80
<EOI>
[<ffffffff816b016b>] ? sysret_audit+0x17/0x21
RIP [<ffffffff8133a83f>] __percpu_counter_add+0xf/0x70
RSP <ffff88017fc83e20>

Solution:
Hold the bridge dev until there is no dst reference.

Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
---
 net/bridge/br_if.c              |  3 +++
 net/bridge/br_netfilter_hooks.c |  3 ++-
 net/bridge/br_netfilter_ipv6.c  |  3 ++-
 net/bridge/br_nf_core.c         |  1 +
 net/core/dst.c                  | 13 ++++++++++++-
 5 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 41f0a69..21948bd 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -384,6 +384,9 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 	cancel_delayed_work_sync(&br->gc_work);
 
 	br_sysfs_delbr(br->dev);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dst_release(&br->fake_rtable.dst);
+#endif
 	unregister_netdevice_queue(br->dev, head);
 }
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 22afa56..3683f0f 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -401,7 +401,8 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set(skb, &rt->dst);
+		dst_hold(&rt->dst);
 	}
 
 	skb->dev = nf_bridge->physindev;
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e88d664..425b11a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -201,7 +201,8 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
-		skb_dst_set_noref(skb, &rt->dst);
+		skb_dst_set(skb, &rt->dst);
+		dst_hold(&rt->dst);
 	}
 
 	skb->dev = nf_bridge->physindev;
diff --git a/net/bridge/br_nf_core.c b/net/bridge/br_nf_core.c
index 8e2d7cf..6543c3c 100644
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -81,6 +81,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
 	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
 	rt->dst.flags	= DST_NOXFRM | DST_FAKE_RTABLE;
 	rt->dst.ops = &fake_dst_ops;
+	dev_hold(br->dev);
 }
 
 int __init br_nf_core_init(void)
diff --git a/net/core/dst.c b/net/core/dst.c
index a263309..0e6f2a2 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -186,13 +186,24 @@ void dst_release(struct dst_entry *dst)
 {
 	if (dst) {
 		int newrefcnt;
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+		unsigned short fakertable = dst->flags & DST_FAKE_RTABLE;
+#endif
 
 		newrefcnt = atomic_dec_return(&dst->__refcnt);
 		if (unlikely(newrefcnt < 0))
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
-		if (!newrefcnt)
+		if (!newrefcnt) {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+			if (fakertable) {
+				if (dst->dev)
+					dev_put(dst->dev);
+				return;
+			}
+#endif
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+		}
 	}
 }
 EXPORT_SYMBOL(dst_release);
-- 
1.8.3.1

