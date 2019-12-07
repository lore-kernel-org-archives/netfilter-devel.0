Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A6FC3F68F
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 22:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC8E24677
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 22:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k+RiGDbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLGWnn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 17:43:43 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:55564 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfLGWnn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 17:43:43 -0500
Received: by mail-pg1-f201.google.com with SMTP id v30so6009603pga.22
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Dec 2019 14:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0JnHAKjpCnoBkVKM1WOylaTi0fyRoTvLK1Dji++R99g=;
        b=k+RiGDbripln+WNqXmqY3WYOI6HID+a9h+lOakjUivuYxvklPpQVsgtKdvqKH5uI1g
         hgbEf99gTYKMVPBIn7fL8gacHUaMRNaH2PftIrF6meE7i7ICuU4QKuagMNnNqNbBOooZ
         QymJWu5su9wn35fGbMAdKLQqc+pGqR4Vq8JphuRXhBkfIcYbjdMDI0quqVTsFrt6eX+3
         hTEX2t333M5seEgX0G/Ow+lbbmwL+GUkAo8Odc28Pbo5/j80cXMaXlfqi5mftwh6uAfd
         njPpH8MCOHA03trSBytWQGoDo7rF+arLdIPA8ArJOnMySHK8wS41XodAovBsOGHydBcb
         emLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0JnHAKjpCnoBkVKM1WOylaTi0fyRoTvLK1Dji++R99g=;
        b=BP7XyXqJsvjuFkxL6mfhw+BmAGoS9TAomaPTgCVntt0cO3xDZkn6zriEtTpnQ/DEmu
         YOGmc4wTSgzOGjzq1WHSPXrDbCujgTBROv1T39XxkDDJJGE66lF/7s/ZcCgfUjADYI8y
         PpOEaIDwSsVqHQkTHp9B5wS4jY3t15GuhBGvCkMdusbAhj5Y4OK6ZPsftd19+nLPL2ae
         PV2LiNQKHbo75ma4zmNMI9Bf4J3+V35wKeWTswA6jW7rA922u+0TWBIi0jNQAPSHav1J
         sfJ/4VrsQ1hT9aa9ue5dBEuDJwfnpy/FQt3GgkmITOsbjbca/l6UHamWh2ouKS4cEHKD
         PKPA==
X-Gm-Message-State: APjAAAUKxCZfIAC2kCSC27jx9fhOOXTIvggcO65rAccaxbkzU0wyIeZ2
        fLMrVr6v7/maF9J235GnR/sTW3xTIgZM7g==
X-Google-Smtp-Source: APXvYqzFEIBSKcSIa97bFhAZq7gBMS5/UqabrLI5F6MLCSgOPu1drXOTrOHJ1SvnoBkgSeU2CItrxUIlVPcjGw==
X-Received: by 2002:a63:215d:: with SMTP id s29mr10197277pgm.200.1575758622354;
 Sat, 07 Dec 2019 14:43:42 -0800 (PST)
Date:   Sat,  7 Dec 2019 14:43:39 -0800
Message-Id: <20191207224339.91704-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH netfilter] netfilter: bridge: make sure to pull arp header in br_nf_forward_arp()
From:   Eric Dumazet <edumazet@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot is kind enough to remind us we need to call skb_may_pull()

BUG: KMSAN: uninit-value in br_nf_forward_arp+0xe61/0x1230 net/bridge/br_netfilter_hooks.c:665
CPU: 1 PID: 11631 Comm: syz-executor.1 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
 __msan_warning+0x64/0xc0 mm/kmsan/kmsan_instr.c:245
 br_nf_forward_arp+0xe61/0x1230 net/bridge/br_netfilter_hooks.c:665
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x18b/0x3f0 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:260 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 __br_forward+0x78f/0xe30 net/bridge/br_forward.c:109
 br_flood+0xef0/0xfe0 net/bridge/br_forward.c:234
 br_handle_frame_finish+0x1a77/0x1c20 net/bridge/br_input.c:162
 nf_hook_bridge_pre net/bridge/br_input.c:245 [inline]
 br_handle_frame+0xfb6/0x1eb0 net/bridge/br_input.c:348
 __netif_receive_skb_core+0x20b9/0x51a0 net/core/dev.c:4830
 __netif_receive_skb_one_core net/core/dev.c:4927 [inline]
 __netif_receive_skb net/core/dev.c:5043 [inline]
 process_backlog+0x610/0x13c0 net/core/dev.c:5874
 napi_poll net/core/dev.c:6311 [inline]
 net_rx_action+0x7a6/0x1aa0 net/core/dev.c:6379
 __do_softirq+0x4a1/0x83a kernel/softirq.c:293
 do_softirq_own_stack+0x49/0x80 arch/x86/entry/entry_64.S:1091
 </IRQ>
 do_softirq kernel/softirq.c:338 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:190
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
 __dev_queue_xmit+0x38e8/0x4200 net/core/dev.c:3819
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:3825
 packet_snd net/packet/af_packet.c:2959 [inline]
 packet_sendmsg+0x8234/0x9100 net/packet/af_packet.c:2984
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 __sys_sendto+0xc44/0xc70 net/socket.c:1952
 __do_sys_sendto net/socket.c:1964 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1960
 __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0a3c9e5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 000000000045a679
RDX: 000000000000000e RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 00000000200000c0 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0a3c9e66d4
R13: 00000000004c8ec1 R14: 00000000004dfe28 R15: 00000000ffffffff

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:149 [inline]
 kmsan_internal_poison_shadow+0x5c/0x110 mm/kmsan/kmsan.c:132
 kmsan_slab_alloc+0x97/0x100 mm/kmsan/kmsan_hooks.c:86
 slab_alloc_node mm/slub.c:2773 [inline]
 __kmalloc_node_track_caller+0xe27/0x11a0 mm/slub.c:4381
 __kmalloc_reserve net/core/skbuff.c:141 [inline]
 __alloc_skb+0x306/0xa10 net/core/skbuff.c:209
 alloc_skb include/linux/skbuff.h:1049 [inline]
 alloc_skb_with_frags+0x18c/0xa80 net/core/skbuff.c:5662
 sock_alloc_send_pskb+0xafd/0x10a0 net/core/sock.c:2244
 packet_alloc_skb net/packet/af_packet.c:2807 [inline]
 packet_snd net/packet/af_packet.c:2902 [inline]
 packet_sendmsg+0x63a6/0x9100 net/packet/af_packet.c:2984
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg net/socket.c:657 [inline]
 __sys_sendto+0xc44/0xc70 net/socket.c:1952
 __do_sys_sendto net/socket.c:1964 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:1960
 __x64_sys_sendto+0x6e/0x90 net/socket.c:1960
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c4e70a87d975 ("netfilter: bridge: rename br_netfilter.c to br_netfilter_hooks.c")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---

Note: Fixes: tag does not point to real bug origin, but is old enough
     to cover all stable versions.

 net/bridge/br_netfilter_hooks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index af7800103e51e5aee724ff314697d17ec583aeba..59980ecfc9623fd0edcd8f3c4375dc5b68cb704b 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -662,6 +662,9 @@ static unsigned int br_nf_forward_arp(void *priv,
 		nf_bridge_pull_encap_header(skb);
 	}
 
+	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
+		return NF_DROP;
+
 	if (arp_hdr(skb)->ar_pln != 4) {
 		if (is_vlan_arp(skb, state->net))
 			nf_bridge_push_encap_header(skb);
-- 
2.24.0.393.g34dc348eaf-goog

