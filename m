Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C182C10F00
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 211D92075C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714505;
	bh=hwIQkumsm02l7ELcMhM1NzD2TMtFFki900g1Q9UTozQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MBcP3ZWxLS2+lzG6f7VA4MZY4HGcwc4WsnfWFWwjuiSDdalIo68g6suhWis1zrArw
	 /129ZP01HFHRNFQO04Ti9LryG1+ZdcPg0T0C9D64wR5IkjfBOIUiQCoDETr6Z8uKhI
	 GjnbTZMMMI6HCegPmxG3ramEk+MrFpAYK+67ifXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388016AbfC0SGs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388012AbfC0SGq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 14:06:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1242184D;
        Wed, 27 Mar 2019 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710005;
        bh=hwIQkumsm02l7ELcMhM1NzD2TMtFFki900g1Q9UTozQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMM36WseWTH7oxAwi+pWLKdH9O2VJELKjeB18BR6ojeifylnW3NmkYzEovWCupB5M
         y/ugfAm62rVaQjDSr0YNjaqV7Fvwxr8Loo91PNNCQ3cjAvOws5xSoI1lg0f0HYBDgb
         St/DM7//MGyIoAvhHLzY3MYO1F+z+PKz2oXRoCwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chieh-Min Wang <chiehminw@synology.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 153/262] netfilter: conntrack: fix cloned unconfirmed skb->_nfct race in __nf_conntrack_confirm
Date:   Wed, 27 Mar 2019 14:00:08 -0400
Message-Id: <20190327180158.10245-153-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Chieh-Min Wang <chiehminw@synology.com>

[ Upstream commit 13f5251fd17088170c18844534682d9cab5ff5aa ]

For bridge(br_flood) or broadcast/multicast packets, they could clone
skb with unconfirmed conntrack which break the rule that unconfirmed
skb->_nfct is never shared.  With nfqueue running on my system, the race
can be easily reproduced with following warning calltrace:

[13257.707525] CPU: 0 PID: 12132 Comm: main Tainted: P        W       4.4.60 #7744
[13257.707568] Hardware name: Qualcomm (Flattened Device Tree)
[13257.714700] [<c021f6dc>] (unwind_backtrace) from [<c021bce8>] (show_stack+0x10/0x14)
[13257.720253] [<c021bce8>] (show_stack) from [<c0449e10>] (dump_stack+0x94/0xa8)
[13257.728240] [<c0449e10>] (dump_stack) from [<c022a7e0>] (warn_slowpath_common+0x94/0xb0)
[13257.735268] [<c022a7e0>] (warn_slowpath_common) from [<c022a898>] (warn_slowpath_null+0x1c/0x24)
[13257.743519] [<c022a898>] (warn_slowpath_null) from [<c06ee450>] (__nf_conntrack_confirm+0xa8/0x618)
[13257.752284] [<c06ee450>] (__nf_conntrack_confirm) from [<c0772670>] (ipv4_confirm+0xb8/0xfc)
[13257.761049] [<c0772670>] (ipv4_confirm) from [<c06e7a60>] (nf_iterate+0x48/0xa8)
[13257.769725] [<c06e7a60>] (nf_iterate) from [<c06e7af0>] (nf_hook_slow+0x30/0xb0)
[13257.777108] [<c06e7af0>] (nf_hook_slow) from [<c07f20b4>] (br_nf_post_routing+0x274/0x31c)
[13257.784486] [<c07f20b4>] (br_nf_post_routing) from [<c06e7a60>] (nf_iterate+0x48/0xa8)
[13257.792556] [<c06e7a60>] (nf_iterate) from [<c06e7af0>] (nf_hook_slow+0x30/0xb0)
[13257.800458] [<c06e7af0>] (nf_hook_slow) from [<c07e5580>] (br_forward_finish+0x94/0xa4)
[13257.808010] [<c07e5580>] (br_forward_finish) from [<c07f22ac>] (br_nf_forward_finish+0x150/0x1ac)
[13257.815736] [<c07f22ac>] (br_nf_forward_finish) from [<c06e8df0>] (nf_reinject+0x108/0x170)
[13257.824762] [<c06e8df0>] (nf_reinject) from [<c06ea854>] (nfqnl_recv_verdict+0x3d8/0x420)
[13257.832924] [<c06ea854>] (nfqnl_recv_verdict) from [<c06e940c>] (nfnetlink_rcv_msg+0x158/0x248)
[13257.841256] [<c06e940c>] (nfnetlink_rcv_msg) from [<c06e5564>] (netlink_rcv_skb+0x54/0xb0)
[13257.849762] [<c06e5564>] (netlink_rcv_skb) from [<c06e4ec8>] (netlink_unicast+0x148/0x23c)
[13257.858093] [<c06e4ec8>] (netlink_unicast) from [<c06e5364>] (netlink_sendmsg+0x2ec/0x368)
[13257.866348] [<c06e5364>] (netlink_sendmsg) from [<c069fb8c>] (sock_sendmsg+0x34/0x44)
[13257.874590] [<c069fb8c>] (sock_sendmsg) from [<c06a03dc>] (___sys_sendmsg+0x1ec/0x200)
[13257.882489] [<c06a03dc>] (___sys_sendmsg) from [<c06a11c8>] (__sys_sendmsg+0x3c/0x64)
[13257.890300] [<c06a11c8>] (__sys_sendmsg) from [<c0209b40>] (ret_fast_syscall+0x0/0x34)

The original code just triggered the warning but do nothing. It will
caused the shared conntrack moves to the dying list and the packet be
droppped (nf_ct_resolve_clash returns NF_DROP for dying conntrack).

- Reproduce steps:

+----------------------------+
|          br0(bridge)       |
|                            |
+-+---------+---------+------+
  | eth0|   | eth1|   | eth2|
  |     |   |     |   |     |
  +--+--+   +--+--+   +---+-+
     |         |          |
     |         |          |
  +--+-+     +-+--+    +--+-+
  | PC1|     | PC2|    | PC3|
  +----+     +----+    +----+

iptables -A FORWARD -m mark --mark 0x1000000/0x1000000 -j NFQUEUE --queue-num 100 --queue-bypass

ps: Our nfq userspace program will set mark on packets whose connection
has already been processed.

PC1 sends broadcast packets simulated by hping3:

hping3 --rand-source --udp 192.168.1.255 -i u100

- Broadcast racing flow chart is as follow:

br_handle_frame
  BR_HOOK(NFPROTO_BRIDGE, NF_BR_PRE_ROUTING, br_handle_frame_finish)
  // skb->_nfct (unconfirmed conntrack) is constructed at PRE_ROUTING stage
  br_handle_frame_finish
    // check if this packet is broadcast
    br_flood_forward
      br_flood
        list_for_each_entry_rcu(p, &br->port_list, list) // iterate through each port
          maybe_deliver
            deliver_clone
              skb = skb_clone(skb)
              __br_forward
                BR_HOOK(NFPROTO_BRIDGE, NF_BR_FORWARD,...)
                // queue in our nfq and received by our userspace program
                // goto __nf_conntrack_confirm with process context on CPU 1
    br_pass_frame_up
      BR_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_IN,...)
      // goto __nf_conntrack_confirm with softirq context on CPU 0

Because conntrack confirm can happen at both INPUT and POSTROUTING
stage.  So with NFQUEUE running, skb->_nfct with the same unconfirmed
conntrack could race on different core.

This patch fixes a repeating kernel splat, now it is only displayed
once.

Signed-off-by: Chieh-Min Wang <chiehminw@synology.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index db4d46332e86..9dd4c2048a2b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -901,10 +901,18 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * REJECT will give spurious warnings here.
 	 */
 
-	/* No external references means no one else could have
-	 * confirmed us.
+	/* Another skb with the same unconfirmed conntrack may
+	 * win the race. This may happen for bridge(br_flood)
+	 * or broadcast/multicast packets do skb_clone with
+	 * unconfirmed conntrack.
 	 */
-	WARN_ON(nf_ct_is_confirmed(ct));
+	if (unlikely(nf_ct_is_confirmed(ct))) {
+		WARN_ON_ONCE(1);
+		nf_conntrack_double_unlock(hash, reply_hash);
+		local_bh_enable();
+		return NF_DROP;
+	}
+
 	pr_debug("Confirming conntrack %p\n", ct);
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
-- 
2.19.1

